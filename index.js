const express = require('express');
const mysql = require('mysql');
const util = require('util');
const ejs = require('ejs');
const bodyParser = require('body-parser');

const PORT = 8000;
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASSWORD = '';
const DB_NAME = 'university_web';
const DB_PORT = 3306;

var connection = mysql.createConnection({
	host: DB_HOST,
	user: DB_USER,
	password: DB_PASSWORD,
	database: DB_NAME,
	port: DB_PORT
});

connection.query = util.promisify(connection.query).bind(connection);

connection.connect((err) => {
	if (err) {
		console.error(`could not connect to database
		    ${err}
		`);
		return;
	}


	console.log('boom, you are connected');
})


const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', async (req, res) => {
    const studentCount = await connection.query('SELECT COUNT(*) as count FROM Student');
    
    const departmentCount = await connection.query('SELECT COUNT(*) as count FROM Department');
    const courseCount = await connection.query('SELECT COUNT(*) as count FROM Course');
    const hobbyCount = await connection.query('SELECT COUNT(*) as count FROM Hobby');
    const clubsCount = await connection.query('SELECT COUNT(*) as count FROM Club'); // Add this line

    res.render('index', {
        studentCount: studentCount[0].count,
        departmentCount: departmentCount[0].count,
        courseCount: courseCount[0].count,
        hobbyCount: hobbyCount[0].count,
        clubsCount: clubsCount[0].count // Include clubsCount in the render options
    });
});

app.get('/clubs', async (req, res) => {
    const clubs = await connection.query('SELECT * FROM Club');
    res.render('clubs', { clubs: clubs });
});


app.get('/departments', async (req, res) => {
    const departments = await connection.query('SELECT * FROM Department');
    res.render('departments', { departments: departments });
	console.log(departments);
});



app.get('/students', async (req, res) => {
    let students;
    const searchTerm = req.query.search;

    if (searchTerm) {
        students = await connection.query(`
            SELECT
                Student.*,
                Course.Crs_Title,
                (
                    SELECT GROUP_CONCAT(Hobby.Hobby_Name)
                    FROM Hobby
                    INNER JOIN Student_Hobby ON Hobby.Hobby_ID = Student_Hobby.Hobby_ID
                    WHERE Student_Hobby.Stu_URN = Student.URN
                ) AS Hobbies,
                Club.Club_Name AS Club_Name
            FROM
                Student
            INNER JOIN Course ON student.Stu_Course = course.Crs_Code
            LEFT JOIN Club ON Student.Club_ID = Club.Club_ID
            WHERE
            Student.Stu_FName LIKE ?
        `, [`%${searchTerm}%`]);
    } else {
        students = await connection.query(`
            SELECT
                Student.*,
                Course.Crs_Title,
                (
                    SELECT GROUP_CONCAT(Hobby.Hobby_Name)
                    FROM Hobby
                    INNER JOIN Student_Hobby ON Hobby.Hobby_ID = Student_Hobby.Hobby_ID
                    WHERE Student_Hobby.Stu_URN = Student.URN
                ) AS Hobbies,
                Club.Club_Name AS Club_Name
            FROM
                Student
            INNER JOIN Course ON student.Stu_Course = course.Crs_Code
            LEFT JOIN Club ON Student.Club_ID = Club.Club_ID
        `);
    }

    res.render('students', { students: students, searchTerm: searchTerm });
});





app.get('/students/edit/:id', async (req, res) => {

	const courses = await connection.query('SELECT Crs_Code, Crs_Title FROM Course');

	const student = await connection.query('SELECT * from Student INNER JOIN Course on student.Stu_Course = course.Crs_Code WHERE URN = ?',
		[req.params.id]);

	res.render('student_edit', { student: student[0], courses: courses, message: '' });
});

app.post('/students/edit/:id', async (req, res) => {

	const updatedStudent = req.body;


	if (isNaN(updatedStudent.Stu_Phone || updatedStudent.Stu_Phone.length != 11)) {
		const courses = await connection.query('SELECT Crs_Code, Crs_Title FROM Course');

		const student = await connection.query('SELECT * from Student INNER JOIN Course on student.Stu_Course = course.Crs_Code WHERE URN = ?',
			[req.params.id]);

		res.render('student_edit', { student: student[0], courses: courses, message: 'student not updated, invalid number' });
		return;
	}

	await connection.query('UPDATE STUDENT SET ? WHERE URN = ?', [updatedStudent, req.params.id]);
	const courses = await connection.query('SELECT Crs_Code, Crs_Title FROM Course');
	const student = await connection.query('SELECT * from Student INNER JOIN Course on student.Stu_Course = course.Crs_Code WHERE URN = ?',
		[req.params.id]);

	res.render('student_edit', { student: student[0], courses: courses, message: 'student updated' });



})

app.get('/students/view/:id', async (req, res) => {
    const student = await connection.query('SELECT * FROM Student INNER JOIN Course on student.Stu_Course = course.Crs_Code WHERE URN = ?', [req.params.id]);

    // Assuming there's a department code in the Course table related to the student's course
    const courseDepartment = await connection.query('SELECT * FROM Department WHERE Dept_No = ?', [student[0].Crs_Dept]);

    res.render('student_view', { student: student[0], department: courseDepartment[0] });
});

app.get('/hobbies', async (req, res) => {
    const hobbies = await connection.query('SELECT * FROM Hobby');
    res.render('hobbies', { hobbies: hobbies });
});




app.listen(PORT, () => {
	console.log(`
    application listening on http://localhost:${PORT}
 `);
});