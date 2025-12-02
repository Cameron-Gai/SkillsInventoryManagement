CREATE TYPE skill_status_enum AS ENUM ('Approved', 'Canceled');
CREATE TYPE skill_type_enum AS ENUM ('Knowledge', 'Experience', 'Technology', 'Other');
CREATE TYPE person_skill_status_enum AS ENUM ('Pending', 'Approved', 'Canceled');
CREATE TYPE project_status_enum AS ENUM ('Approved', 'Canceled');
CREATE TYPE project_skill_required_status_enum AS ENUM ('Approved', 'Canceled');
CREATE TYPE person_project_assignment_status_enum AS ENUM ('Requested', 'Approved', 'Canceled');
CREATE TYPE skill_request_status_enum AS ENUM ('Requested', 'Approved', 'Rejected');

CREATE TABLE person (
    person_id SERIAL PRIMARY KEY,
    person_name VARCHAR(255) NOT NULL,
    manager_person_id INT,
    member_of_organization_id INT,
    is_admin BOOLEAN DEFAULT FALSE
);

CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    organization_name VARCHAR(255) NOT NULL,
    organization_manager_person_id INT
);

ALTER TABLE person
ADD CONSTRAINT fk_person_org FOREIGN KEY (member_of_organization_id)
REFERENCES organization(organization_id)
ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE person
ADD CONSTRAINT fk_person_manager FOREIGN KEY (manager_person_id)
REFERENCES person(person_id)
ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE organization
ADD CONSTRAINT fk_org_manager FOREIGN KEY (organization_manager_person_id)
REFERENCES person(person_id)
ON UPDATE CASCADE ON DELETE SET NULL;

CREATE TABLE skill (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(255) NOT NULL,
    status skill_status_enum NOT NULL,
    skill_type skill_type_enum NOT NULL
);

CREATE TABLE skill_request (
    request_id SERIAL PRIMARY KEY,
    requested_by INT NOT NULL REFERENCES person(person_id) ON DELETE CASCADE,
    skill_name VARCHAR(255) NOT NULL,
    skill_type skill_type_enum NOT NULL,
    justification TEXT DEFAULT '',
    status skill_request_status_enum NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMPTZ,
    resolved_by INT REFERENCES person(person_id),
    resolution_notes TEXT,
    created_skill_id INT REFERENCES skill(skill_id)
);

CREATE TABLE person_skill (
    person_id INT NOT NULL,
    skill_id INT NOT NULL,
    status person_skill_status_enum NOT NULL,
    requested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (person_id, skill_id),
    FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(255) NOT NULL,
    status project_status_enum NOT NULL,
    project_owning_organization_id INT NOT NULL,
    project_start_date DATE,
    project_end_date DATE,
    FOREIGN KEY (project_owning_organization_id) REFERENCES organization(organization_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE project_skill_required (
    project_id INT NOT NULL,
    skill_id INT NOT NULL,
    status project_skill_required_status_enum NOT NULL,
    PRIMARY KEY (project_id, skill_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill(skill_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE person_project_assignment (
    person_id INT NOT NULL,
    project_id INT NOT NULL,
    status person_project_assignment_status_enum NOT NULL,
    PRIMARY KEY (person_id, project_id),
    FOREIGN KEY (person_id) REFERENCES person(person_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES project(project_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
