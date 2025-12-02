import argparse
import os
import random
from collections import defaultdict
from datetime import datetime, timedelta, timezone

import psycopg2
from dotenv import load_dotenv


def load_env():
    """Load backend/.env so DB creds stay centralized."""
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


def fetch_people_and_skills(cur):
    cur.execute("SELECT person_id FROM person ORDER BY person_id")
    people = [row[0] for row in cur.fetchall()]

    cur.execute("SELECT skill_id, skill_type FROM skill")
    skills_by_type = defaultdict(list)
    for skill_id, skill_type in cur.fetchall():
        skills_by_type[skill_type].append(skill_id)

    all_skills = [skill_id for skill_ids in skills_by_type.values() for skill_id in skill_ids]
    return people, skills_by_type, all_skills


def choose_status():
    statuses = (
        ('Approved', 0.6),
        ('Pending', 0.3),
        ('Canceled', 0.1),
    )
    roll = random.random()
    threshold = 0
    for status, weight in statuses:
        threshold += weight
        if roll <= threshold:
            return status
    return statuses[-1][0]


def generate_requested_at(status):
    """Return a believable timestamp for when a skill was submitted."""
    now = datetime.now(timezone.utc)

    if status == 'Approved':
        days_ago = random.randint(30, 180)
    elif status == 'Canceled':
        days_ago = random.randint(15, 120)
    else:  # Pending
        days_ago = random.randint(1, 60)

    hours_ago = random.randint(0, 23)
    minutes_ago = random.randint(0, 59)

    return now - timedelta(days=days_ago, hours=hours_ago, minutes=minutes_ago)


def assign_skills_to_person(person_id, skills_by_type, all_skills, min_skills, max_skills):
    target_count = random.randint(min_skills, max_skills)
    assigned = set()

    # Try to ensure each skill type is represented before filling the rest.
    shuffled_types = list(skills_by_type.keys())
    random.shuffle(shuffled_types)
    for skill_type in shuffled_types:
        if len(assigned) >= target_count:
            break
        pool = skills_by_type[skill_type]
        if not pool:
            continue
        skill_choice = random.choice(pool)
        assigned.add(skill_choice)

    # Fill remaining slots with random skills across the catalog.
    remaining_skills = [skill for skill in all_skills if skill not in assigned]
    random.shuffle(remaining_skills)
    for skill in remaining_skills:
        if len(assigned) >= target_count:
            break
        assigned.add(skill)

    freq_options = ['Daily', 'Weekly', 'Monthly', 'Occasionally']
    level_options = ['Beginner', 'Intermediate', 'Advanced', 'Expert']

    assignments = []
    for skill_id in assigned:
        years = random.randint(0, 15)
        frequency = random.choice(freq_options)
        level = random.choice(level_options)
        status = choose_status()
        note = '' if random.random() < 0.7 else random.choice([
            'Used on latest delivery.',
            'Ready for stretch assignments.',
            'Needs refresh this quarter.',
        ])
        requested_at = generate_requested_at(status)
        assignments.append((
            person_id,
            skill_id,
            status,
            years,
            frequency,
            level,
            note,
            requested_at,
        ))

    return assignments


def ensure_metadata_columns(cur):
    column_statements = [
        "ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS experience_years INTEGER DEFAULT 0",
        "ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS usage_frequency TEXT DEFAULT 'Occasionally'",
        "ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS proficiency_level TEXT DEFAULT 'Intermediate'",
        "ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS notes TEXT DEFAULT ''",
        "ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS requested_at TIMESTAMPTZ DEFAULT NOW()",
    ]
    for statement in column_statements:
        cur.execute(statement)


def seed_person_skills(min_skills, max_skills, truncate=False, dry_run=False):
    if min_skills <= 0 or max_skills < min_skills:
        raise ValueError('Invalid min/max skill bounds.')

    with get_connection() as conn:
        with conn.cursor() as cur:
            ensure_metadata_columns(cur)

            people, skills_by_type, all_skills = fetch_people_and_skills(cur)
            if not people or not all_skills:
                raise RuntimeError('People or skills table is empty. Please seed base data first.')

            if truncate and not dry_run:
                cur.execute('TRUNCATE TABLE person_skill RESTART IDENTITY CASCADE;')

            assignments = []
            for person_id in people:
                assignments.extend(
                    assign_skills_to_person(person_id, skills_by_type, all_skills, min_skills, max_skills)
                )

            if dry_run:
                print(f'[dry-run] Would assign {len(assignments)} person/skill pairs across {len(people)} people.')
                return

            insert_sql = (
                'INSERT INTO person_skill (person_id, skill_id, status, experience_years, usage_frequency, proficiency_level, notes, requested_at) '
                'VALUES (%s, %s, %s, %s, %s, %s, %s, %s) '
                'ON CONFLICT (person_id, skill_id) DO UPDATE '
                'SET status = EXCLUDED.status,'
                '    experience_years = EXCLUDED.experience_years,'
                '    usage_frequency = EXCLUDED.usage_frequency,'
                '    proficiency_level = EXCLUDED.proficiency_level,'
                '    notes = EXCLUDED.notes,'
                '    requested_at = EXCLUDED.requested_at'
            )
            cur.executemany(insert_sql, assignments)
            conn.commit()

            print(f'Assigned {len(assignments)} skills across {len(people)} people.')

            status_counts = defaultdict(int)
            for assignment in assignments:
                status_counts[assignment[2]] += 1
            for status, count in status_counts.items():
                print(f'  - {status}: {count}')


def parse_args():
    parser = argparse.ArgumentParser(description='Assign random skills (with varied statuses) to people in the database.')
    parser.add_argument('--min-skills', type=int, default=2, help='Minimum skills per person (default: 2)')
    parser.add_argument('--max-skills', type=int, default=6, help='Maximum skills per person (default: 6)')
    parser.add_argument('--truncate', action='store_true', help='Remove existing person_skill rows before assigning')
    parser.add_argument('--dry-run', action='store_true', help='Preview assignments without writing to the database')
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    seed_person_skills(
        min_skills=args.min_skills,
        max_skills=args.max_skills,
        truncate=args.truncate,
        dry_run=args.dry_run,
    )
