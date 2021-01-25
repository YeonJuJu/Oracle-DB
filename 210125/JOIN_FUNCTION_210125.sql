SELECT * FROM TABS;

DESC EMP;
DESC DEPT;
DESC BONUS;
DESC SALGRADE;

-- OUTER JOIN --

/*
    사원 번호, 사원 이름, 업무, 부서 번호, 부서 이름, 부서 위치 출력
*/

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;

-- LEFT OUTER JOIN  ~ ON --

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E LEFT OUTER JOIN  DEPT D
                           ON E.DEPTNO = D.DEPTNO;

-- 다음과 같다

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);

-- RIGHT OUTER JOIN ~ ON --

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E RIGHT OUTER JOIN  DEPT D
                           ON E.DEPTNO = D.DEPTNO;

-- 다음과 같다

SELECT E.EMPNO, E.ENAME, E.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E, DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;

/* ================================================ */

/*
    JOIN
*/

/*
    EQUI JOIN
*/

/*
    학번이 10101 인 학생의 이름, 소속 학과 이름을 출력
*/

SELECT STUDNO, NAME, DEPTNO
FROM STUDENT
WHERE STUDNO = 10101;

SELECT DNAME
FROM DEPARTMENT
WHERE DEPTNO = 101;

SELECT ST.STUDNO, ST.NAME, ST.DEPTNO, DP.DNAME
FROM STUDENT ST , DEPARTMENT DP
WHERE ST.DEPTNO = DP.DEPTNO;

/*
    전인하 학생의 학번, 이름, 학과이름, 학과 위치 출력
*/

SELECT S.STUDNO, S.NAME, D.DNAME, D.LOC
FROM STUDENT S, DEPARTMENT D
WHERE S.DEPTNO = D.DEPTNO AND S.NAME = '전인하';

/*
    몸무게가 80KG 이상인 학생의 학번, 이름, 몸무게, 학과 이름, 학과 위치를 출력
*/

SELECT S.STUDNO, S.NAME, S.WEIGHT, D.DNAME, D.LOC
FROM STUDENT S, DEPARTMENT D
WHERE S.DEPTNO = D.DEPTNO AND S.WEIGHT >= 80;

/*==================================================*/

/*
    CARTESIAN PRODUCT 
*/

/*
    학생 테이블과 부서 테이블을 카티션 곱으로 조회한 결과 출력
*/

SELECT NAME, D.DEPTNO, DNAME, LOC
FROM STUDENT S, DEPARTMENT D;

SELECT NAME, D.DEPTNO, DNAME, LOC
FROM STUDENT S CROSS JOIN DEPARTMENT D;

/*
    NATURAL JOIN
    ㄴ> 별명을 사용하지 않는다. 
*/

SELECT STUDNO, NAME, DEPTNO, DNAME
FROM STUDENT NATURAL JOIN DEPARTMENT;

/*
    NATURAL JOIN 을 이용해 4학년 학생의 이름, 학과번호, 학과 이름 출력
*/

SELECT GRADE, NAME, DEPTNO, DNAME
FROM STUDENT NATURAL JOIN DEPARTMENT
WHERE GRADE = 4;

/*==================================================*/

/*
    JOIN ~ USING ( -> EQUI JOIN)
    ㄴ> 별명을 사용하지 않는다.
*/

/*
    JOIN ~ USING 을 이용해 4학년 학생의 이름, 학과번호, 학과 이름 출력
*/

SELECT STUDNO, NAME, DEPTNO, DNAME, LOC
FROM STUDENT JOIN DEPARTMENT USING (DEPTNO)
WHERE GRADE = 4;

/*
    EQUI JOIN : WHERE
    NATURAL JOIN : FROM
    JOIN ~ USING : FROM
*/

/*
    위의 세가지 방법을 이용해 성이 김씨인 학생들을 출력
*/

-- EQUI JOIN
SELECT ST.NAME, ST.STUDNO, DP.DNAME, DP.LOC
FROM STUDENT ST, DEPARTMENT DP
WHERE ST.DEPTNO = DP.DEPTNO AND ST.NAME LIKE '김%';

-- NATURAL JOIN
SELECT NAME, STUDNO, DNAME, LOC
FROM STUDENT NATURAL JOIN DEPARTMENT
WHERE NAME LIKE '김%';

-- JOIN ~ USING
SELECT NAME, STUDNO, DNAME, LOC
FROM STUDENT JOIN DEPARTMENT USING(DEPTNO)
WHERE NAME LIKE '김%';

/*
    NON EQUI JOIN
    테이블의 어떤 컬럼도 JOIN 할 테이블의 컬럼과 일치하지 않는 경우에 사용
    EQUAL 연산자 (=) 를 사용하지 않고 < , > , BETWEEN A AND B, IS NOT NULL 과 같은 연산자를 사용함

    특정 범위와 등급을 지정해 해당 범위에 있는 경우, 등급으로 데이터 표현하기 위해 사용
*/

-- 교수 테이블과 급여 테이블을 NON EQUI-JOIN 해서 교수별 급여 등급 출력하기

SELECT PROFNO, NAME, SAL, GRADE
FROM PROFESSOR P, SALGRADE S
WHERE P.SAL BETWEEN S.LOSAL AND S.HISAL;

SELECT NAME, SAL
FROM PROFESSOR;


SELECT PROFNO, NAME, SAL, GRADE
FROM PROFESSOR P JOIN SALGRADE S
WHERE P.SAL BETWEEN S.LOSAL AND S.HISAL;

SELECT * FROM SALGRADE;

-- 101 번 학과 교수의 교수번호, 이름, 급여, 급여등급을 출력하세요

SELECT PROFNO, NAME, SAL, GRADE
FROM PROFESSOR P, SALGRADE S
WHERE P.SAL BETWEEN S.LOSAL AND S.HISAL;

/*
    SELF JOIN
    
    하나의 테이블 내에 있는 컬럼끼리 연결하는 JOIN 의 경우에 사용
    JOIN 대상 테이블이 자기 자신 테이블이라는 것 이외에는 EQUI - JOIN 과 같음
*/

/*
    부서 테이블에서 SELF JOIN 을 이용하여 부서 이름과 상위 부서 이름을 출력
*/

-- WHERE 절을 이용한 SELF JOIN --

SELECT DEPT.DNAME AS 부서, ORG.DNAME AS 상위부서
FROM DEPARTMENT DEPT, DEPARTMENT ORG
WHERE DEPT.COLLEGE = ORG.DEPTNO;

SELECT PROFNO, NAME, SAL, GRADE
FROM PROFESSOR P, SALGRADE S
WHERE P.SAL BETWEEN S.LOSAL AND S.HISAL;

/*
    101 번 학과 교수의 교수번호, 이름, 급여, 급여 등급을 출력
*/

SELECT PROFNO, NAME, SAL, GRADE
FROM PROFESSOR P, SALGRADE S
WHERE P.SAL BETWEEN S.LOSAL AND S.HISAL;

/*
    OUTER JOIN
    ㄴ>NULL 이 존재하는 컬럼을 가진 테이블에 (+) 기호를 사용. 
    (+) 를 붙인 테이블에서 널 값이 나올 수 있음 헷갈 ㄴㄴ~~ 메인이 아닌 서브에 (+) 붙이기
    
    => EQUI JOIN 에서 양 테이블의 컬럼 중 하나가 NULL 인 경우에도 JOIN 결과로 출력하고자 하는 경우에 사용
*/

/*
    학생 테이블과 교수 테이블을 조인해서 학생이름, 학년, 지도교수이름, 지도교수직급을 출력
    지도교수가 배정되지 않은 학생이름도 출력
*/

SELECT S.NAME AS SNAME, S.GRADE, P.NAME AS PNAME, P.POSITION
FROM STUDENT S, PROFESSOR P
WHERE S.DEPTNO(+) = P.DEPTNO;




