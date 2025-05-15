/*
Questão 01. Crie um procedimento chamado student_grade_points segundo os critérios abaixo:

a. Utilize como parâmetro de entrada o conceito. Exemplo: A+, A-, ...

b. Retorne os atributos das tuplas: Nome do estudante, Departamento do estudante, Título do curso, 
Departamento do curso, Semestre do curso, Ano do curso, Pontuação alfanumérica, Pontuação numérica.

c. Filtre as tuplas utilizando o parâmetro de entrada.
*/

CREATE PROCEDURE DBO.STUDENT_GRADE_POINTS @STUDENT_GRADE VARCHAR(2) 
AS 
BEGIN
    SET NOCOUNT ON; 

    SELECT STUDENT.NAME AS "Nome do Estudante", 
           STUDENT.DEPT_NAME AS "Departamento do Estudante", 
           COURSE.TITLE AS "Título do Curso", 
           COURSE.DEPT_NAME AS "Departamento do Curso", 
           SECTION.SEMESTER AS "Semestre do Curso", 
           SECTION.YEAR AS "Ano do Curso", 
           TAKES.GRADE AS "Pontuação Alfanumérica",
           IIF(TAKES.GRADE = 'A+', 4.0,
               IIF(TAKES.GRADE = 'A ', 3.7,
               IIF(TAKES.GRADE = 'A-', 3.3,
               IIF(TAKES.GRADE = 'B+', 3.0,
               IIF(TAKES.GRADE = 'B ', 2.7,
               IIF(TAKES.GRADE = 'B-', 2.3,
               IIF(TAKES.GRADE = 'C+', 2.0,
               IIF(TAKES.GRADE = 'C ', 1.7,
               IIF(TAKES.GRADE = 'C-', 1.3, 0))))))))) AS "Pontuação Numérica"
    FROM STUDENT
    INNER JOIN DEPARTMENT ON STUDENT.DEPT_NAME = DEPARTMENT.DEPT_NAME 
    INNER JOIN COURSE ON DEPARTMENT.DEPT_NAME = COURSE.DEPT_NAME 
    INNER JOIN SECTION ON COURSE.COURSE_ID = SECTION.COURSE_ID 
    INNER JOIN TAKES ON STUDENT.ID = TAKES.ID 
    WHERE TAKES.GRADE = @STUDENT_GRADE
    GROUP BY STUDENT.NAME, STUDENT.DEPT_NAME, COURSE.TITLE, COURSE.DEPT_NAME, SECTION.SEMESTER, SECTION.YEAR, TAKES.GRADE;
END;

EXEC DBO.STUDENT_GRADE_POINTS 'A';

/*
Questão 02.

Crie uma função chamada return_instructor_location segundo os critérios abaixo:

a. Utilize como parâmetro de entrada o nome do instrutor.

b. Retorne os atributos das tuplas: Nome do instrutor, Curso ministrado, 
Semestre do curso, Ano do curso, prédio e número da sala na qual o curso foi ministrado

c. Exemplo: SELECT * FROM dbo.return_instructor_location('Gustafsson');
*/

CREATE FUNCTION return_instructor_location (@nome_instrutor varchar(20))
RETURNS TABLE
AS
RETURN (
    SELECT 
        instructor.name AS "Nome do Instrutor",
        course.title AS "Curso Ministrado",
        section.semester AS "Semestre do Curso",
        section.year AS "Ano do Curso",
        section.building AS "Prédio",
        section.room_number AS "Sala"
    FROM instructor
    JOIN teaches ON instructor.ID = teaches.ID
    JOIN section ON 
        teaches.course_id = section.course_id AND 
        teaches.sec_id = section.sec_id AND 
        teaches.semester = section.semester AND 
        teaches.year = section.year
    JOIN course ON teaches.course_id = course.course_id
    WHERE instructor.name = @nome_instrutor
);

SELECT * FROM dbo.return_instructor_location('Gustafsson');
