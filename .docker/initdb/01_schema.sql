CREATE TABLE department (
    dept_name VARCHAR(50) PRIMARY KEY,
    building VARCHAR(50) NOT NULL,
    budget NUMERIC(12, 2) NOT NULL CHECK (budget >= 0)
);

CREATE TABLE classroom (
    building VARCHAR(50) NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    PRIMARY KEY (building, room_number)
);

CREATE TABLE time_slot (
    time_slot_id VARCHAR(10) NOT NULL,
    day CHAR(1) NOT NULL CHECK (day IN ('M', 'T', 'W', 'R', 'F', 'S')),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    PRIMARY KEY (time_slot_id, day, start_time),
    CHECK (end_time > start_time)
);

CREATE TABLE instructor (
    id VARCHAR(8) PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    dept_name VARCHAR(50),
    salary NUMERIC(10, 2) CHECK (salary IS NULL OR salary >= 0),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE student (
    id VARCHAR(8) PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    dept_name VARCHAR(50),
    total_credits INTEGER NOT NULL DEFAULT 0 CHECK (total_credits >= 0),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE course (
    course_id VARCHAR(8) PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    dept_name VARCHAR(50),
    credits INTEGER NOT NULL CHECK (credits BETWEEN 1 AND 6),
    FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE section (
    course_id VARCHAR(8) NOT NULL,
    sec_id VARCHAR(8) NOT NULL,
    semester VARCHAR(10) NOT NULL CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')),
    year INTEGER NOT NULL CHECK (year BETWEEN 2000 AND 2100),
    building VARCHAR(50),
    room_number VARCHAR(10),
    time_slot_id VARCHAR(10),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (building, room_number) REFERENCES classroom (building, room_number)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE teaches (
    id VARCHAR(8) NOT NULL,
    course_id VARCHAR(8) NOT NULL,
    sec_id VARCHAR(8) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    year INTEGER NOT NULL,
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES instructor (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE takes (
    id VARCHAR(8) NOT NULL,
    course_id VARCHAR(8) NOT NULL,
    sec_id VARCHAR(8) NOT NULL,
    semester VARCHAR(10) NOT NULL,
    year INTEGER NOT NULL,
    grade VARCHAR(2) CHECK (grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F') OR grade IS NULL),
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (id) REFERENCES student (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE advisor (
    student_id VARCHAR(8) PRIMARY KEY,
    instructor_id VARCHAR(8),
    FOREIGN KEY (student_id) REFERENCES student (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructor (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE prereq (
    course_id VARCHAR(8) NOT NULL,
    prereq_id VARCHAR(8) NOT NULL,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES course (course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CHECK (course_id <> prereq_id)
);
