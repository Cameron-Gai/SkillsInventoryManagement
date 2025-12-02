import argparse
import os
import random
from datetime import datetime, timezone

import psycopg2
from dotenv import load_dotenv


DEFAULT_NOTES = [
    'Requested by leadership for the next release.',
    'Helps unblock the roadmap this half.',
    'Pairs well with current project objectives.',
    'Managers expect measurable progress this quarter.',
    'Key dependency for migration work.',
]

PRIORITY_BUCKETS = [
    ('High', 0.55),
    ('Medium', 0.3),
    ('Low', 0.15),
]


def load_env():
    env_path = os.path.join(os.path.dirname(__file__), '..', 'backend', '.env')
    if os.path.exists(env_path):
        load_dotenv(env_path)


def get_connection():
    load_env()
    return psycopg2.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', 5432),
        dbname=os.getenv('DB_NAME', 'skills_inventory'),
        user=os.getenv('DB_USER', 'sim_user'),
        password=os.getenv('DB_PASSWORD', 'SimP@ssw0rd'),
    )


def ensure_high_value_table(cur):
    cur.execute(
        """
        CREATE TABLE IF NOT EXISTS team_high_value_skills (
            id SERIAL PRIMARY KEY,
            team_id INTEGER NOT NULL,
            skill_id INTEGER NOT NULL,
            priority VARCHAR(20) DEFAULT 'High',
            notes TEXT,
            created_at TIMESTAMPTZ DEFAULT NOW(),
            assigned_by INTEGER
        );
        """
    )
    cur.execute(
        """
        CREATE UNIQUE INDEX IF NOT EXISTS team_high_value_skills_team_skill_idx
        ON team_high_value_skills(team_id, skill_id);
        """
    )


def fetch_managers(cur):
    cur.execute(
        """
        SELECT DISTINCT mgr.person_id
        FROM person mgr
        WHERE EXISTS (
            SELECT 1 FROM person p WHERE p.manager_person_id = mgr.person_id
        )
        ORDER BY mgr.person_id;
        """
    )
    return [row[0] for row in cur.fetchall()]


def fetch_skill_catalog(cur):
    cur.execute("SELECT skill_id FROM skill WHERE status = 'Approved' ORDER BY skill_id")
    return [row[0] for row in cur.fetchall()]


def pick_priority():
    roll = random.random()
    threshold = 0
    for label, weight in PRIORITY_BUCKETS:
        threshold += weight
        if roll <= threshold:
            return label
    return PRIORITY_BUCKETS[-1][0]


def upsert_team_focus(cur, assignments):
    insert_sql = (
        """
        INSERT INTO team_high_value_skills (team_id, skill_id, priority, notes, assigned_by, created_at)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON CONFLICT (team_id, skill_id)
        DO UPDATE SET
            priority = EXCLUDED.priority,
            notes = EXCLUDED.notes,
            assigned_by = EXCLUDED.assigned_by,
            created_at = EXCLUDED.created_at;
        """
    )
    cur.executemany(insert_sql, assignments)


def seed_team_focus(per_team_min, per_team_max, truncate=False):
    if per_team_min <= 0 or per_team_max < per_team_min:
        raise ValueError('Invalid per-team bounds supplied.')

    with get_connection() as conn:
        with conn.cursor() as cur:
            ensure_high_value_table(cur)

            managers = fetch_managers(cur)
            skill_catalog = fetch_skill_catalog(cur)
            if not managers:
                raise RuntimeError('No managers with direct reports found. Seed people table first.')
            if len(skill_catalog) < per_team_min:
                raise RuntimeError('Not enough approved skills to assign high-value sets.')

            if truncate:
                cur.execute('TRUNCATE TABLE team_high_value_skills RESTART IDENTITY;')

            assignments = []
            now = datetime.now(timezone.utc)
            for manager_id in managers:
                selection_count = random.randint(per_team_min, per_team_max)
                chosen_skills = random.sample(skill_catalog, selection_count)
                for skill_id in chosen_skills:
                    note = random.choice(DEFAULT_NOTES) if random.random() > 0.35 else ''
                    assignments.append(
                        (
                            manager_id,
                            skill_id,
                            pick_priority(),
                            note,
                            manager_id,
                            now,
                        )
                    )

            upsert_team_focus(cur, assignments)
            conn.commit()

            print(f'Assigned {len(assignments)} high-value skill rows across {len(managers)} managers.')


def parse_args():
    parser = argparse.ArgumentParser(description='Randomize team_high_value_skills entries for every manager.')
    parser.add_argument('--min-per-team', type=int, default=2, help='Minimum skills to assign per manager (default: 2)')
    parser.add_argument('--max-per-team', type=int, default=4, help='Maximum skills to assign per manager (default: 4)')
    parser.add_argument('--truncate', action='store_true', help='Clear existing high-value rows before seeding')
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    seed_team_focus(args.min_per_team, args.max_per_team, truncate=args.truncate)
