# scripts/xlsx_to_postgres.py
import os
import sys
import pandas as pd
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv

# load backend .env automatically
env_path = os.path.join(os.path.dirname(__file__), '..', 'backend', '.env')
if os.path.exists(env_path):
    load_dotenv(env_path)

DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')
DB_NAME = os.getenv('DB_NAME', 'skills_inventory')
DB_USER = os.getenv('DB_USER', 'sim_user')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'SimP@ssw0rd')

XLSX_PATH = sys.argv[1] if len(sys.argv) > 1 else 'data/seed.xlsx'

# mapping: sheet_name -> table_name (adjust if your sheets differ)
SHEET_TABLE_MAP = {
    'Organizations': 'organization',
    'People': 'person',
    'Skills': 'skill',
    'Projects': 'project',
    'ProjectSkillRequired': 'project_skill_required',
    'PersonSkill': 'person_skill',
    'PersonProjectAssignment': 'person_project_assignment'
}

def normalize_columns(df):
    """Normalize column names: lowercase, remove spaces/hyphens, convert to snake_case"""
    df.columns = (df.columns
                  .str.strip()
                  .str.lower()
                  .str.replace(r'[\s\-]+', '_', regex=True)
                  .str.replace('_id_', '_id', regex=False))
    return df

def df_to_csvbuffer(df, cols):
    # return CSV text for COPY with header matching cols
    return df[cols].to_csv(index=False, header=False).encode('utf-8')

def main():
    if not os.path.exists(XLSX_PATH):
        print("XLSX not found:", XLSX_PATH)
        sys.exit(2)

    wb = pd.ExcelFile(XLSX_PATH)
    print("Sheets in workbook:", wb.sheet_names)

    conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
    conn.autocommit = False
    cur = conn.cursor()

    try:
        # Disable FK constraints temporarily
        cur.execute("ALTER TABLE person DISABLE TRIGGER ALL;")
        cur.execute("ALTER TABLE organization DISABLE TRIGGER ALL;")
        cur.execute("ALTER TABLE project DISABLE TRIGGER ALL;")
        
        # load people first
        person_sheet = next((s for s in wb.sheet_names if 'person' in s.lower()), 'Person DATA')
        if person_sheet in wb.sheet_names:
            df_person = pd.read_excel(wb, person_sheet)
            df_person = normalize_columns(df_person)
            
            # Replace 0 with NULL for foreign key columns
            if 'manager_person_id' in df_person.columns:
                df_person['manager_person_id'] = df_person['manager_person_id'].replace(0, pd.NA)
            if 'member_of_organization_id' in df_person.columns:
                df_person['member_of_organization_id'] = df_person['member_of_organization_id'].replace(0, pd.NA)
            
            # Ensure is_admin is boolean (convert 1/0 to True/False)
            if 'is_admin' in df_person.columns:
                df_person['is_admin'] = df_person['is_admin'].fillna(0).astype(int).astype(bool)
            elif 'isadmin' in df_person.columns:
                df_person['is_admin'] = df_person['isadmin'].fillna(0).astype(int).astype(bool)
                df_person = df_person.drop(columns=['isadmin'])
            
            # Set role based on is_admin
            if 'is_admin' in df_person.columns:
                df_person['role'] = df_person['is_admin'].apply(lambda x: 'admin' if x else 'employee')
            
            # Generate username from person_name
            if 'person_name' in df_person.columns:
                df_person['username'] = df_person['person_name'].str.lower().str.replace(' ', '.', regex=False)
            
            cols = [c for c in ['person_id','person_name','manager_person_id','member_of_organization_id','is_admin','role','username'] if c in df_person.columns]
            if not df_person.empty and cols:
                print(f"Inserting people ({person_sheet}):", len(df_person))
                print(f"  Columns: {cols}")
                # Print admin count for verification
                if 'is_admin' in df_person.columns:
                    admin_count = df_person['is_admin'].sum()
                    print(f"  Admins found: {admin_count}")
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_person, cols)), 'person', sep=',', columns=cols, null='')
        
        # load organizations
        org_sheet = next((s for s in wb.sheet_names if 'organization' in s.lower()), 'Organization DATA')
        if org_sheet in wb.sheet_names:
            df_org = pd.read_excel(wb, org_sheet)
            df_org = normalize_columns(df_org)
            cols = [c for c in ['organization_id','organization_name','organization_manager_person_id'] if c in df_org.columns]
            if not df_org.empty and cols:
                print(f"Inserting organizations ({org_sheet}):", len(df_org))
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_org, cols)), 'organization', sep=',', columns=cols)
        
        # skills
        skill_sheet = next((s for s in wb.sheet_names if 'skill' in s.lower()), 'Skill DATA')
        if skill_sheet in wb.sheet_names:
            df_skill = pd.read_excel(wb, skill_sheet)
            df_skill = normalize_columns(df_skill)
            cols = [c for c in ['skill_id','skill_name','status','skilltype'] if c in df_skill.columns]
            if not df_skill.empty and cols:
                print(f"Inserting skills ({skill_sheet}):", len(df_skill))
                # Rename skilltype back to skill_type for the database
                df_skill_copy = df_skill[cols].copy()
                if 'skilltype' in df_skill_copy.columns:
                    df_skill_copy = df_skill_copy.rename(columns={'skilltype': 'skill_type'})
                cur.copy_from(pd.io.common.BytesIO(df_skill_copy.to_csv(index=False, header=False).encode('utf-8')), 'skill', sep=',', columns=['skill_id','skill_name','status','skill_type'])

        # projects
        project_sheet = next((s for s in wb.sheet_names if 'project' in s.lower() and 'skill' not in s.lower()), 'Project DATA')
        if project_sheet in wb.sheet_names:
            df_proj = pd.read_excel(wb, project_sheet)
            df_proj = normalize_columns(df_proj)
            cols = [c for c in ['project_id','project_name','status','project_owning_organization_id','project_start_date','project_end_date'] if c in df_proj.columns]
            if not df_proj.empty and cols:
                print(f"Inserting projects ({project_sheet}):", len(df_proj))
                # ensure date columns are in ISO format
                for dcol in ['project_start_date','project_end_date']:
                    if dcol in df_proj.columns:
                        df_proj[dcol] = pd.to_datetime(df_proj[dcol]).dt.date
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_proj, cols)), 'project', sep=',', columns=cols)

        # project_skill_required
        psr_sheet = next((s for s in wb.sheet_names if 'project' in s.lower() and 'skill' in s.lower()), 'Project Skill Required DATA')
        if psr_sheet in wb.sheet_names:
            df_psr = pd.read_excel(wb, psr_sheet)
            df_psr = normalize_columns(df_psr)
            cols = [c for c in ['project_id','skill_id','status'] if c in df_psr.columns]
            if not df_psr.empty and cols:
                print(f"Inserting project_skill_required ({psr_sheet}):", len(df_psr))
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_psr, cols)), 'project_skill_required', sep=',', columns=cols)

        # person_skill
        ps_sheet = next((s for s in wb.sheet_names if 'person' in s.lower() and 'skill' in s.lower()), None)
        if ps_sheet and ps_sheet in wb.sheet_names:
            df_ps = pd.read_excel(wb, ps_sheet)
            df_ps = normalize_columns(df_ps)
            cols = [c for c in ['person_id','skill_id','status'] if c in df_ps.columns]
            if not df_ps.empty and cols:
                print(f"Inserting person_skill ({ps_sheet}):", len(df_ps))
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_ps, cols)), 'person_skill', sep=',', columns=cols)

        # person_project_assignment
        ppa_sheet = next((s for s in wb.sheet_names if 'assignment' in s.lower() or 'person' in s.lower() and 'project' in s.lower()), None)
        if ppa_sheet and ppa_sheet in wb.sheet_names:
            df_ppa = pd.read_excel(wb, ppa_sheet)
            df_ppa = normalize_columns(df_ppa)
            cols = [c for c in ['person_id','project_id','status'] if c in df_ppa.columns]
            if not df_ppa.empty and cols:
                print(f"Inserting person_project_assignment ({ppa_sheet}):", len(df_ppa))
                cur.copy_from(pd.io.common.BytesIO(df_to_csvbuffer(df_ppa, cols)), 'person_project_assignment', sep=',', columns=cols)
        
        # Re-enable FK constraints
        cur.execute("ALTER TABLE person ENABLE TRIGGER ALL;")
        cur.execute("ALTER TABLE organization ENABLE TRIGGER ALL;")
        cur.execute("ALTER TABLE project ENABLE TRIGGER ALL;")
        
        # Update roles: managers are those who have direct reports
        print("Updating manager roles...")
        cur.execute("""
            UPDATE person
            SET role = 'manager'
            WHERE role = 'employee' 
            AND EXISTS (SELECT 1 FROM person p2 WHERE p2.manager_person_id = person.person_id)
        """)
        managers_updated = cur.rowcount
        print(f"  Updated {managers_updated} employees to managers")

        conn.commit()
        print("All done. Committed.")
    except Exception as e:
        conn.rollback()
        print("ERROR: rolled back. Exception:", e)
        raise
    finally:
        cur.close()
        conn.close()

if __name__ == '__main__':
    main()