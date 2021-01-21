-- 20210121

-- 부서 테이블에서 부서 이름 컬럼의 별명은 dept_dame 으로 하고
-- 부서 번호 컬럼의 별명은 DN 으로 해서 출력하세요 (SELECT)
-- SELECT 부서 이름, 부서 번호 부서 테이블에서

-- 컬럼 명 확인
DESC DEPARTMENT;

SELECT DNAME, DEPTNO FROM DEPARTMENT;
SELECT DNAME AS DEPT_NAME, DEPTNO AS DN FROM DEPARTMENT;
SELECT DNAME, DEPT_NAME, DEPTNO DN FROM DEPARTMENT;

-- 부서 테이블에서 부서 이름 컬럼의 별명은 DEPT NAME 으로 하고,
-- 부서 번호 컬럼의 별명은 DEPT NUMBER 로 해서 출력
-- 공백이 있는 별명은 "" 으로 묶어준다

SELECT DNAME AS "DEPT NAME", DEPTNO AS "DEPT NUM" 
FROM DEPARTMENT;

-- 부서 테이블에서 부서 이름 컬럼의 별명은 DEPARTMENT NAME 으로 하고,
-- 부서 번호 컬럼의 별명은 부서 번호# 으로 해서 출력

SELECT DNAME AS "DEPARTMENT NAME", DEPTNO AS "부서 번호#"
FROM DEPARTMENT;

-- 학생 테이블에서학번 컬럼과 이름 컬럼을 연결해서 
-- "Student" 라는 별명으로 하나의 컬럼 처럼 연결하여 출력 -> || 사용

SELECT STUDNO || NAME
FROM STUDENT;

SELECT STUDNO || ' ' || NAME
FROM STUDENT;

-- 교수 테이블에서 교수 이름과 직급 컬럼 사이에 ' 의 직급은 ' 이라는 
-- 문자열을 추가하고 칼럼 별명을 Title of Professor 라고 하여 출력하세요

DESC PROFESSOR;

SELECT NAME || ' 의 직급은 ' || POSITION AS "Title of Professor"
FROM PROFESSOR;

-- 학생 테이블에서 ' 이순신의 키는 190, 몸무게는 80' 과 같은 형태로 출력하되
-- 컬럼 이름은 학생의 키와 몸무게 정보 라고 하여 출력

DESC STUDENT;

SELECT NAME ||  '의 키는 ' || HEIGHT || ', 몸무게는 ' || WEIGHT AS "학생의 키, 무게 정보"
FROM STUDENT;

-- 학생의 몸무게를 POUND 로 확산하고
-- 컬럼 이름은 WEIGHT_POUND 라는 별명으로 출력하세요
-- 1kg = 2.2 pound

SELECT NAME, WEIGHT*2.2 AS "WEIGHT_POUND"
FROM STUDENT;

-- 교수 테이블에서 교수 이름, 급여, 보너스를 포함한 연봉을 출력하세요
-- 보너스를 포함한 연봉은 급여 * 12 + 100 으로 계산하세요
DESC PROFESSOR;

SELECT NAME, SAL*12+100 AS "연봉"
FROM PROFESSOR;

-- 학생들의 비만지수를 출력하기
-- 학생 테이블에서 학생 이름과 몸무게, 키, 비만 지수를 출력하세요
-- 비만지수( BMI ) : 몸무게 / ( 키/100 ^2 )

SELECT NAME, WEIGHT, HEIGHT,  WEIGHT/((HEIGHT/100)*(HEIGHT/100)) AS "BMI"
FROM STUDENT;

-- 소수점 이하 자리 수 지정하기 -> ROUND( COLUMN, 자리수)

SELECT NAME, WEIGHT, HEIGHT,  ROUND( WEIGHT / ((HEIGHT/100) * (HEIGHT/100)), 2) AS "BMI"
FROM STUDENT;

-- 전인하 학생의 키는 176cm 이고, 몸무게는 72 kg 입니다. 형식으로 학생 테이블 출력

SELECT NAME || ' 학생의 키는  ' || HEIGHT || 'cm 이고, 몸무게는 ' || WEIGHT || 'kg 입니다.' AS "INFO"
FROM STUDENT;

-- 학생 테이블의 rowid, stdno 를 출력
SELECT ROWID, STUDNO
FROM STUDENT;

-- TIMESTAMP 타입을 포함한 테이블을 생성하고 데이터를 입력
CREATE TABLE TIME1 (
    TID NUMBER(6),
    BASICTIME TIMESTAMP,
    STANDARDTIME TIMESTAMP WITH TIME ZONE,  -- 뒤에 대륙/지역 나옴
    LOCALTIME TIMESTAMP WITH TIME ZONE
);

SELECT * FROM TIME1;

INSERT INTO TIME1
VALUES(1, SYSDATE, SYSDATE, SYSDATE);

SELECT * FROM TIME1;

-- INTERVAL YEAR TO MONTH 데이터 타입을 포함한 테이블을 생성하고 데이터를 입력

CREATE TABLE TIME2(
    YEAR_INTERVAL INTERVAL YEAR(3) TO MONTH
);

SELECT * FROM TIME2;

INSERT INTO TIME2
VALUES(INTERVAL '180' MONTH(3));    -- +15-00 추가됨

SELECT * FROM TIME2;

SELECT YEAR_INTERVAL, SYSDATE, SYSDATE + YEAR_INTERVAL  -- 15년 차이
FROM TIME2;

-- INTERVAL DAY TO SECOND 데이터 타입을 포함한 테이블을 생성하고 데이터 입력

CREATE TABLE TIME3(
    DAY_INTERVAL INTERVAL DAY(3) TO SECOND
);

INSERT INTO TIME3
VALUES(INTERVAL '180' DAY(3));

SELECT DAY_INTERVAL, SYSDATE, SYSDATE + DAY_INTERVAL
FROM TIME3;

-- 학생 테이블에서 1학년 학생들의 학번, 이름, 학과 번호 출력

DESC STUDENT;

SELECT STUDNO, NAME, DEPTNO, GRADE
FROM STUDENT
WHERE GRADE = 1;

-- 학생 테이블에서 몸무게가 70KG 이하인 학생의 학번, 이름 , 학년, 학과번호, 몸무게 출력

SELECT STUDNO, NAME, GRADE, DEPTNO, WEIGHT
FROM STUDENT
WHERE WEIGHT <= 70;

-- 학생 테이블에서 1학년 학생 중 몸무게가 70 이하인 학생 검색해 위와 같이 출력

SELECT STUDNO, NAME, GRADE, DEPTNO, WEIGHT
FROM STUDENT
WHERE WEIGHT <= 70 AND GRADE = 1;

-- 학생 테이블에서 1학년이거나 학생 중 몸무게가 70 이상인 학생 검색해 위와 같이 출력

SELECT STUDNO, NAME, GRADE, DEPTNO, WEIGHT
FROM STUDENT
WHERE WEIGHT >= 70 OR GRADE = 1;

SELECT * 
FROM STUDENT
WHERE GRADE = 1;

-- 1 학년 학생 중 학과 번호가 102가 아니면서 키가 180 이상, 184 이하인 학생 출력

SELECT NAME, USERID, HEIGHT, DEPTNO, GRADE 
FROM STUDENT
WHERE GRADE = 1 AND DEPTNO != 102 AND HEIGHT >=180 AND HEIGHT <=184;

SELECT NAME, USERID, HEIGHT, DEPTNO, GRADE 
FROM STUDENT
WHERE GRADE = 1 AND NOT DEPTNO = 102 AND HEIGHT >=180 AND HEIGHT <=184;

-- A <= X <= B      => BETWEEN A AND B

SELECT NAME, USERID, HEIGHT, DEPTNO, GRADE 
FROM STUDENT
WHERE GRADE = 1 AND NOT DEPTNO = 102 AND HEIGHT BETWEEN 180 AND 184;

SELECT NAME, USERID, WEIGHT, DEPTNO, GRADE 
FROM STUDENT
WHERE WEIGHT BETWEEN 50 AND 70;

-- A, B, C, D 中 1     => IN(A, B, C, D)

SELECT NAME, DEPTNO, GRADE 
FROM STUDENT
WHERE DEPTNO IN(102, 201);

DESC PROFESSOR;

SELECT * FROM PROFESSOR;

SELECT PROFNO, NAME, POSITION, DEPTNO
FROM PROFESSOR
WHERE POSITION IN('조교수', '전임강사');

-- 문자 패턴과 부분적으로 일치시 참 리턴 => LIKE 
-- % -> 없거나 있음
-- _ -> 있음

SELECT NAME, GRADE, DEPTNO
FROM STUDENT
WHERE NAME LIKE '김%';

SELECT NAME
FROM STUDENT
WHERE NAME LIKE '__';

SELECT NAME 
FROM STUDENT
WHERE NAME LIKE '%진';

-- IS NULL

DESC PROFESSOR;

SELECT NAME, POSITION, COMM 
FROM PROFESSOR
WHERE COMM IS NULL;

-- 교수 테이블에서 보직 수당을 받고있는 교수들의 이름과 급여, 보직 수당을 출력

SELECT NAME, SAL, COMM
FROM PROFESSOR
WHERE COMM IS NOT NULL AND COMM !=0;

-- 교수 테이블에서 급여에 보직수당을 더한 값을 sal_comm 이라는 별명으로 출력

SELECT NAME, SAL, COMM, SAL+COMM AS SAL_COMM
FROM PROFESSOR;

SELECT NAME, SAL, COMM, SAL+COMM AS SAL_COMM
FROM PROFESSOR
WHERE COMM IS NOT NULL;

-- NULL 값을 처리하고 싶은 값으로 세팅 => NVL ( COLUMN , VALUE )

SELECT NAME, SAL, COMM, SAL+NVL(COMM, 0) AS SAL_COMM
FROM PROFESSOR;

-- 102 번 학과 학생 중 1학년 또는 4학년 학생의 이름과 학년과 학과번호

SELECT NAME, GRADE, DEPTNO
FROM STUDENT
WHERE GRADE IN(1,4) AND DEPTNO = 102;

-- 102 학과 학생 중 4학년 학생과 학과 상관 없이 1학년 학생 출력

SELECT NAME, GRADE, DEPTNO
FROM STUDENT
WHERE (GRADE =4 AND DEPTNO = 102) OR GRADE = 1;

--UNION (합집합, 중복 제거)
--UNION ALL (합집합, 중복 포함)
-- 조건 : 칼럼 수가 같고 대응되는 데이터 타입이 같아야 함

-- 몸무게 70 이상이고 1학년 학생들을 STUDENT_HEAVY 테이블을 만들어 추가

CREATE TABLE STUDENT_HEAVY
AS SELECT * FROM STUDENT
WHERE WEIGHT >= 70 AND GRADE = 1;

SELECT * FROM STUDENT_HEAVY;

-- 몸무게 70 이상이고 1학년 학생들을 출력

SELECT * FROM STUDENT
WHERE WEIGHT >= 70 AND GRADE = 1;

-- 학과가 101 이고 1학년인 학생을 STUDENT_101 테이블을 만들어 삽입

CREATE TABLE STUDENT_101
AS SELECT * FROM STUDENT
WHERE DEPTNO = 101 AND GRADE = 1;

SELECT * FROM STUDENT_101;

-- A : 박동진, 서재진
SELECT NAME, DEPTNO FROM STUDENT_HEAVY;

-- A : 박미경, 서재진
SELECT NAME, DEPTNO FROM STUDENT_101;

-- STUDENT_HEAVY U STUDENT_101

SELECT NAME, DEPTNO FROM STUDENT_HEAVY
UNION
SELECT NAME, DEPTNO FROM STUDENT_101;

SELECT NAME, DEPTNO FROM STUDENT_HEAVY
UNION ALL
SELECT NAME, DEPTNO FROM STUDENT_101;

-- INTERSECT (교집합) ∩

SELECT NAME, DEPTNO FROM STUDENT_HEAVY
INTERSECT
SELECT NAME, DEPTNO FROM STUDENT_101;

-- MINUS (차집합) -

SELECT NAME, STUDNO FROM STUDENT_HEAVY
MINUS
SELECT NAME, STUDNO FROM STUDENT_101;

-- SORTING => ORDER BY COLUMN [DESC || ASC]; => 기본값은 ASC

-- 학생 테이블에서 이름을 가나다 순으로 정렬

SELECT NAME, GRADE, TEL
FROM STUDENT
ORDER BY NAME ASC;

-- 학생 테이블에서 101 학과 중 생년월일 빠른 순으로 정렬

SELECT NAME, GRADE, DEPTNO, BIRTHDATE
FROM STUDENT
WHERE DEPTNO = 101
ORDER BY BIRTHDATE;

-- 교수 테이블에서 보직 수당이 적은순으로 출력
-- DESC : NULL 값이 가장 위에 출력
-- ASC : NULL 값이 가장 밑에 출력

SELECT NAME, SAL, COMM
FROM PROFESSOR
ORDER BY COMM;

-- 학과 번호 오름차순. 같은 학과는 학년으로 오름차순 하여 정렬

SELECT * FROM STUDENT;

SELECT NAME, STUDNO, USERID, DEPTNO, GRADE
FROM STUDENT
ORDER BY DEPTNO ASC, GRADE ASC;

-- 테이블 내에서의 컬럼의 위치를 이용해서 정렬

DESC STUDENT;

SELECT NAME, USERID, GRADE
FROM STUDENT
ORDER BY 3; -- 3번째 컬럼 정렬하겠다는 의미



