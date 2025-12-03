-- Add requested_at to person_skill for age-bucket calculations
ALTER TABLE person_skill
    ADD COLUMN IF NOT EXISTS requested_at TIMESTAMP NULL;

-- Optionally initialize requested_at for current Requested records
UPDATE person_skill
SET requested_at = NOW()
WHERE status = 'Requested' AND requested_at IS NULL;
-- Add requested_at column to person_skill for age buckets
ALTER TABLE person_skill
    ADD COLUMN IF NOT EXISTS requested_at TIMESTAMP NULL;

-- Backfill requested_at for currently Requested entries if missing
UPDATE person_skill
SET requested_at = COALESCE(requested_at, NOW())
WHERE status = 'Requested' AND requested_at IS NULL;

-- Optional: index to speed up admin requests filtering by status and requested_at
CREATE INDEX IF NOT EXISTS idx_person_skill_status_requested_at
    ON person_skill (status, requested_at);

--Run every block one by one
-- Person table
--{ 1) run these first
ALTER TABLE person DROP CONSTRAINT fk_person_org;
ALTER TABLE person DROP CONSTRAINT fk_person_manager;

-- Organization table
ALTER TABLE organization DROP CONSTRAINT fk_org_manager;
--} 1) till here


--2) Do this after (CHANGE CSV FILE PATH IMPORTANTTTT)
--insert all tables with \copy command manually on command prompt. You can do it in sql directly too with import
--\copy organization(organization_id, organization_name, organization_manager_person_id) FROM 'path/to/Organization_data.csv' DELIMITER ',' CSV HEADER;
--\copy person(person_id, person_name, manager_person_id, member_of_organization_id, is_admin) FROM 'path/to/Person_data.csv' DELIMITER ',' CSV HEADER;
--\copy skill(skill_id, skill_name, status, skill_type) FROM 'path/to/Skill_data.csv' DELIMITER ',' CSV HEADER;
--\copy project_skill_required(project_id, skill_id, status) FROM 'path/to/Project_Skill_Required_data.csv' DELIMITER ',' CSV HEADER;
-- Insert data into project table


--3) this after
INSERT INTO project (
    project_id, 
    project_name, 
    status, 
    project_owning_organization_id, 
    project_start_date, 
    project_end_date
) VALUES
(1, 'Order Management', 'Approved', 1, TO_DATE('1/1/2025','MM/DD/YYYY'), TO_DATE('12/31/2025','MM/DD/YYYY')),
(2, 'Offer Management', 'Approved', 1, TO_DATE('4/15/2025','MM/DD/YYYY'), TO_DATE('6/30/2025','MM/DD/YYYY')),
(3, 'Customer A1', 'Approved', 2, TO_DATE('6/22/2025','MM/DD/YYYY'), TO_DATE('6/21/2026','MM/DD/YYYY')),
(4, 'New Low Cost Carrier CD', 'Approved', 2, TO_DATE('10/10/2025','MM/DD/YYYY'), TO_DATE('4/30/2026','MM/DD/YYYY'));


--{ 4) Do this next
UPDATE person
SET manager_person_id = NULL
WHERE manager_person_id = 0;

-- Person table
ALTER TABLE person
ADD CONSTRAINT fk_person_org FOREIGN KEY (member_of_organization_id)
REFERENCES organization(organization_id)
ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE person
ADD CONSTRAINT fk_person_manager FOREIGN KEY (manager_person_id)
REFERENCES person(person_id)
ON UPDATE CASCADE ON DELETE SET NULL;

-- Organization table
ALTER TABLE organization
ADD CONSTRAINT fk_org_manager FOREIGN KEY (organization_manager_person_id)
REFERENCES person(person_id)
ON UPDATE CASCADE ON DELETE SET NULL;


ALTER TABLE person
ADD COLUMN role VARCHAR(20);

UPDATE person
SET role = CASE
    WHEN is_admin THEN 'admin'
    WHEN EXISTS (SELECT 1 FROM person p2 WHERE p2.manager_person_id = person.person_id) THEN 'manager'
    ELSE 'employee'
END;
--} 4) UNTIL HEREEE


--5) Can run everything else below this together
ALTER TABLE person
ADD COLUMN password TEXT;

ALTER TABLE person
ADD COLUMN username VARCHAR(50) UNIQUE;

UPDATE person
SET username = LOWER(REPLACE(person_name, ' ', '.'));


ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS level VARCHAR(50);
ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS years INT;
ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS frequency VARCHAR(50);
ALTER TABLE person_skill ADD COLUMN IF NOT EXISTS notes TEXT;




