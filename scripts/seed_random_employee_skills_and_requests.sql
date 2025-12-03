-- Randomize only employee skills and catalog requests
-- Idempotent-ish: wipes person_skill and skill_request, then reseeds

BEGIN;

-- 1) Wipe existing employee skills and catalog requests
DELETE FROM person_skill;
DELETE FROM skill_request;

-- 2) Ensure skill_id sequence is aligned (in case catalog existed)
SELECT setval('public.skill_skill_id_seq', COALESCE((SELECT MAX(skill_id) FROM public.skill), 0));

-- 3) Randomly assign 4–8 skills per employee
WITH emp AS (
  SELECT person_id
  FROM person
),
sk AS (
  SELECT skill_id FROM skill
),
pairs AS (
  SELECT e.person_id,
         s.skill_id,
         ROW_NUMBER() OVER (PARTITION BY e.person_id ORDER BY random()) AS rn
  FROM emp e
  CROSS JOIN sk s
),
chosen AS (
  SELECT person_id, skill_id
  FROM pairs
  WHERE rn <= (4 + floor(random() * 5))  -- 4..8
),
payload AS (
  SELECT
    c.person_id,
    c.skill_id,
    CASE WHEN random() < 0.6 THEN 'Approved'::public.person_skill_status_enum ELSE 'Requested'::public.person_skill_status_enum END AS status,
    CASE WHEN random() < 0.6 THEN (ARRAY['Beginner','Intermediate','Advanced','Expert'])[1 + floor(random()*4)] ELSE NULL END AS level,
    CASE WHEN random() < 0.6 THEN floor(random() * 11)::int ELSE NULL END AS years,
    CASE WHEN random() < 0.6 THEN (ARRAY['Daily','Weekly','Monthly','Rarely'])[1 + floor(random()*4)] ELSE NULL END AS frequency,
    CASE WHEN random() < 0.6 THEN 'Seeded assignment' ELSE 'Seeded request' END AS notes,
    CASE
      WHEN random() < 0.6 THEN NULL
      ELSE NOW()
           - (floor(random() * 30))::int * INTERVAL '1 day'
           - (floor(random() * 24))::int * INTERVAL '1 hour'
           - (floor(random() * 60))::int * INTERVAL '1 minute'
    END AS requested_at
  FROM chosen c
)
-- Prevent duplicates: one record per (person_id, skill_id) regardless of status
INSERT INTO person_skill (person_id, skill_id, status, level, years, frequency, notes, requested_at)
SELECT p.person_id, p.skill_id, p.status, p.level, p.years, p.frequency, p.notes, p.requested_at
FROM payload p
WHERE NOT EXISTS (
  SELECT 1 FROM person_skill ps
  WHERE ps.person_id = p.person_id AND ps.skill_id = p.skill_id
);

-- 4) Randomly create catalog requests (20–40), avoiding duplicates and existing skills
WITH emp AS (
  SELECT person_id
  FROM person
  ORDER BY random()
  LIMIT (20 + floor(random() * 21))  -- 20..40
),
candidate_names AS (
  SELECT
    (ARRAY['Knowledge','Experience','Technology','Other'])[1 + floor(random()*4)]::public.skill_type_enum AS skill_type,
    CONCAT(
      (ARRAY['Observability','API Governance','Security Review','Cross-Team Sync','Platform Onboarding','Budget Tracking'])[1 + floor(random()*6)],
      ' ',
      (ARRAY['101','Fundamentals','Pro','Advanced','Essentials'])[1 + floor(random()*5)]
    ) AS skill_name
  FROM generate_series(1, 120)
),
unique_names AS (
  SELECT DISTINCT skill_type, skill_name
  FROM candidate_names
  WHERE NOT EXISTS (
    SELECT 1 FROM skill s WHERE LOWER(s.skill_name) = LOWER(candidate_names.skill_name)
  )
),
picked AS (
  SELECT e.person_id, un.skill_name, un.skill_type
  FROM emp e
  JOIN unique_names un ON TRUE
  ORDER BY random()
  LIMIT (20 + floor(random() * 21))  -- 20..40
)
-- Ensure only one active request per unique skill_name; pick one random requester
INSERT INTO skill_request (requested_by, skill_name, skill_type, justification, status, created_at)
SELECT DISTINCT ON (LOWER(p.skill_name))
  p.person_id,
  p.skill_name,
  p.skill_type,
  CONCAT('Requested for upcoming work: ', p.skill_name),
  'Requested'::public.person_skill_status_enum,
  NOW()
    - (floor(random() * 30))::int * INTERVAL '1 day'
    - (floor(random() * 24))::int * INTERVAL '1 hour'
    - (floor(random() * 60))::int * INTERVAL '1 minute'
FROM picked p
ORDER BY LOWER(p.skill_name), random()
ON CONFLICT DO NOTHING;

-- 5) If timestamp columns exist for approved skills, randomize them too
DO $$
BEGIN
  -- Prefer updating 'updated_at' when present
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'person_skill' AND column_name = 'updated_at'
  ) THEN
    UPDATE public.person_skill ps
    SET updated_at = NOW()
      - (floor(random() * 30))::int * INTERVAL '1 day'
      - (floor(random() * 24))::int * INTERVAL '1 hour'
      - (floor(random() * 60))::int * INTERVAL '1 minute'
    WHERE ps.status = 'Approved';
  END IF;

  -- Alternatively, set 'approved_at' if that column exists
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'person_skill' AND column_name = 'approved_at'
  ) THEN
    UPDATE public.person_skill ps
    SET approved_at = NOW()
      - (floor(random() * 30))::int * INTERVAL '1 day'
      - (floor(random() * 24))::int * INTERVAL '1 hour'
      - (floor(random() * 60))::int * INTERVAL '1 minute'
    WHERE ps.status = 'Approved';
  END IF;
END $$;

COMMIT;
