DROP DATABASE IF EXISTS university_web;

CREATE DATABASE university_web;

USE university_web;

DROP TABLE IF EXISTS Department;

CREATE TABLE
    Department (
        Dept_No INT UNSIGNED,
        Dept_Name VARCHAR(255) NOT NULL,
        Dept_Location VARCHAR(5),
        HOD INT UNSIGNED,
        HOD_Start DATE,
        PRIMARY KEY(Dept_No),
        UNIQUE (Dept_Name)
    );

INSERT INTO Department
VALUES (
        010,
        'Department of Computer Science',
        'BB 02',
        111114,
        '2020-08-20'
    );

INSERT INTO Department
VALUES (
        020,
        'Department of Electronics and Electrical Engineering',
        'BB 01',
        111127,
        '2018-08-20'
    );

INSERT INTO Department
VALUES (
        030,
        'Department of Physics',
        'BB 03',
        111128,
        '2017-08-20'
    );


CREATE TABLE Hobby (
    Hobby_ID INT UNSIGNED NOT NULL,
    Hobby_Name VARCHAR(255) NOT NULL,
    Hobby_Description TEXT,
    PRIMARY KEY (Hobby_ID),
    UNIQUE (Hobby_Name)
);


INSERT INTO Hobby (Hobby_ID, Hobby_Name, Hobby_Description)
VALUES 
    (1, 'Reading', 'Enjoying books and literature'),
    (2, 'Swimming', 'Participating in swimming activities'),
    (3, 'Photography', 'Capturing moments with a camera'),
    (4, 'Chess', 'Playing the game of chess'),
    (5, 'Taichi', 'Playing tennis as a sport'),
    (6, 'Rugby', 'Participating in rugby activities'),
    (7, 'Climbing', 'Engaging in rock climbing and mountaineering'),
    (8, 'Rowing', 'Participating in rowing and boating activities'),
    (9, 'Tennis', 'Participating in tennis activities');



CREATE TABLE Student_Hobby (
    Stu_URN INT UNSIGNED NOT NULL,
    Hobby_ID INT UNSIGNED NOT NULL,
    PRIMARY KEY (Stu_URN, Hobby_ID),
    FOREIGN KEY (Stu_URN) REFERENCES Student(URN) ON DELETE CASCADE,
    FOREIGN KEY (Hobby_ID) REFERENCES Hobby(Hobby_ID) ON DELETE CASCADE
);


INSERT INTO Student_Hobby (Stu_URN, Hobby_ID)
VALUES (612345, 1), 
       (612346, 2),
       (612347, 3), 
       (612348, 0),
       (612349, 5),
       (612350, 1), 
       (612351, 8), 
       (612352, 9),
       (612353, 6),
       (612354, 7);

      
CREATE TABLE Club (
    Club_ID INT UNSIGNED NOT NULL,
    Club_Name VARCHAR(255) NOT NULL,
    Club_Description TEXT,
    PRIMARY KEY (Club_ID),
    UNIQUE (Club_Name)
);

INSERT INTO Club (Club_ID, Club_Name, Club_Description)
VALUES
    (1, 'Chess Club', 'Playing and learning chess'),
    (2, 'Photography Club', 'Exploring the art of photography'),
    (3, 'Coding Club', 'Club for coding and programming enthusiasts'),
    (4, 'Comedy Club', 'Enjoying laughs and entertainment'),
    (5, 'Book Club', 'For those who love reading and discussing books'),
    (6, 'Football Club', 'Join us for football matches and training'),
    (7, 'Cricket Club', 'Enjoy playing and watching cricket with us'),
    (8, 'Basketball Club', 'For basketball enthusiasts to play and compete');


DROP TABLE IF EXISTS Course;

CREATE TABLE
    Course (
        Crs_Code INT UNSIGNED NOT NULL,
        Crs_Title VARCHAR(255) NOT NULL,
        Crs_Enrollment INT UNSIGNED,
        Crs_Dept INT UNSIGNED NOT NULL,
        PRIMARY KEY (Crs_code),
        FOREIGN KEY (Crs_Dept) REFERENCES Department (Dept_No) ON DELETE CASCADE,
       
    );

INSERT INTO Course
VALUES (
        100,
        'BSc Computer Science',
        100,
        010,
        111125
    ), (
        101,
        'BSc Computer Information Technology',
        20,
        010,
        111122
    ), (
        200,
        'MSc Data Science',
        100,
        010,
        111113
    ), (
        201,
        'MSc Security',
        50,
        010,
        111112
    ), (
        110,
        'BEng Electronics',
        100,
        020,
        111127
    ), (
        111,
        'BEng Electrical Engineering',
        100,
        020,
        111121
    ), (
        210,
        'MSc Electrical Engineering',
        100,
        020,
        111126
    ), (
        211,
        'MSc Physics',
        100,
        020,
        111128
    );

DROP TABLE IF EXISTS Student;

CREATE TABLE
    Student (
        URN INT UNSIGNED NOT NULL,
        Stu_FName VARCHAR(255) NOT NULL,
        Stu_LName VARCHAR(255) NOT NULL,
        Stu_DOB DATE,
        Stu_Gender ENUM('M', 'F'),
        Stu_Phone VARCHAR(12),
        Stu_Course INT UNSIGNED NOT NULL,
        Stu_Type ENUM('UG', 'PG'),
        Club_ID INT UNSIGNED,
        PRIMARY KEY (URN),
        FOREIGN KEY (Stu_Course) REFERENCES Course (Crs_Code) ON DELETE RESTRICT
            FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID)  -- New foreign key

    );

INSERT INTO Student
VALUES (
        612345,
        'John',
        'Smith',
        '2002-06-20',
        'M',
        '01483112233',
        100,
        'UG'
    ), (
        612346,
        'Pierre',
        'Gervais',
        '2002-03-12',
        'M',
        '01483223344',
        100,
        'UG'
    ), (
        612347,
        'Patrick',
        'O-Hara',
        '2001-05-03',
        'M',
        '01483334455',
        100,
        'UG'
    ), (
        612348,
        'Iyabo',
        'Ogunsola',
        '2002-04-21',
        'F',
        '01483445566',
        100,
        'UG'
    ), (
        612349,
        'Omar',
        'Sharif',
        '2001-12-29',
        'M',
        '01483778899',
        100,
        'UG'
    ), (
        612350,
        'Yunli',
        'Guo',
        '2002-06-07',
        'F',
        '01483123456',
        100,
        'UG'
    ), (
        612351,
        'Costas',
        'Spiliotis',
        '2002-07-02',
        'M',
        '01483234567',
        100,
        'UG'
    ), (
        612352,
        'Tom',
        'Jones',
        '2001-10-24',
        'M',
        '01483456789',
        101,
        'UG'
    ), (
        612353,
        'Simon',
        'Larson',
        '2002-08-23',
        'M',
        '01483998877',
        101,
        'UG'
    ), (
        612354,
        'Sue',
        'Smith',
        '2002-05-16',
        'F',
        '01483776655',
        101,
        'UG'
    );

DROP TABLE IF EXISTS Undergraduate;

CREATE TABLE
    Undergraduate (
        UG_URN INT UNSIGNED NOT NULL,
        UG_Credits INT UNSIGNED NOT NULL,
        CHECK (60 <= UG_Credits <= 150),
        PRIMARY KEY (UG_URN),
        FOREIGN KEY (UG_URN) REFERENCES Student(URN) ON DELETE CASCADE
    );

INSERT INTO Undergraduate
VALUES (612345, 120), (612346, 90), (612347, 150), (612348, 120), (612349, 120), (612350, 60), (612351, 60), (612352, 90), (612353, 120), (612354, 90);

DROP TABLE IF EXISTS Postgraduate;

CREATE TABLE
    Postgraduate (
        PG_URN INT UNSIGNED NOT NULL,
        Thesis VARCHAR(512) NOT NULL,
        PRIMARY KEY (PG_URN),
        FOREIGN KEY (PG_URN) REFERENCES Student(URN) ON DELETE CASCADE
    );


ALTER TABLE Student_Hobby
ADD CONSTRAINT FK_Student_Hobby_Student
FOREIGN KEY (Stu_URN) REFERENCES Student(URN) ON DELETE CASCADE,
ADD CONSTRAINT FK_Student_Hobby_Hobby
FOREIGN KEY (Hobby_ID) REFERENCES Hobby(Hobby_ID) ON DELETE CASCADE;


ALTER TABLE Course
ADD CONSTRAINT FK_Course_Department
FOREIGN KEY (Crs_Dept) REFERENCES Department (Dept_No) ON DELETE CASCADE;


ALTER TABLE Undergraduate
ADD CONSTRAINT FK_Undergraduate_Student
FOREIGN KEY (UG_URN) REFERENCES Student(URN) ON DELETE CASCADE;


ALTER TABLE Postgraduate
ADD CONSTRAINT FK_Postgraduate_Student
FOREIGN KEY (PG_URN) REFERENCES Student(URN) ON DELETE CASCADE;


