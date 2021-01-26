  /*
    SUB QUERY
    
    하나의 SQL 명령문의 결과를 다른 SQL 명령문에 전달하기 위해 
    두 개 이상의 SQL 명령문을 하나의 SQL 명령문으로 연결하여 처리하는 방법
 */
 
 /*
    -- 다중 행 서브쿼리 --
    
    서브 쿼리의 반환 값이 하나 이상일 경우 사용

    IN : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 하나라도 일치하면 참
    ANY, SOME : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 하나 이상 일치하면 참
    ALL : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 모든 값이 일치하면 참
    EXISTS : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 만족하는 값이 하나라도 존재하면 참
*/

-- IN --

/*
    COLLEGE 가 100 인 학과에 속한 학생들 출력
*/

SELECT * FROM STUDENT;

SELECT NAME, GRADE, DEPTNO
FROM STUDENT
WHERE DEPTNO IN ( SELECT DEPTNO
                             FROM DEPARTMENT
                              WHERE COLLEGE = 100)
ORDER BY DEPTNO ASC;
                              
/*
    정보미디어학부 (부서 번호 : 100) 에 소속된 모든 학생들 출력
*/

SELECT * FROM DEPARTMENT;

SELECT STUDNO, NAME, DEPTNO
FROM STUDENT
WHERE DEPTNO IN ( SELECT DEPTNO
                             FROM DEPARTMENT
                             WHERE COLLEGE = 100 );

/*
    메카트로닉스 학부에 소속된 모든 학생들 출력
*/

SELECT STUDNO, NAME, DEPTNO
FROM STUDENT
WHERE DEPTNO IN ( SELECT DP.DEPTNO
                             FROM DEPARTMENT DP, DEPARTMENT ORG
                             WHERE DP.COLLEGE = ORG.DEPTNO 
                             AND ORG.DNAME = '메카트로닉스학부');

-- ANY --
/*
    > ANY : 서브 쿼리 결과 중 최소값 보다 크다
    < ANY : 서브 쿼리 결과 중 최소값 보다 작다
*/

/*
    4학년 학생 중 키가 제일 작은 학생보다 키가 큰 학생들의 학번 이름 키 출력
*/

SELECT STUDNO, NAME, HEIGHT
FROM STUDENT
WHERE HEIGHT > ANY ( SELECT HEIGHT
                                FROM STUDENT
                                WHERE GRADE = 4);

SELECT STUDNO, NAME, HEIGHT
FROM STUDENT
WHERE HEIGHT < ANY ( SELECT HEIGHT
                                FROM STUDENT
                                WHERE GRADE = 4);

-- ALL --
/*
     > ALL : 서브 쿼리 결과 중 최댓값 보다 크다
     < ALL : 서브 쿼리 결과 중 최소값 보다 작다
*/

/*
    4학년 학생 보다 키가 큰 학생들의 학번 이름 키 출력
*/

SELECT STUDNO, NAME, HEIGHT
FROM STUDENT
WHERE HEIGHT > ALL ( SELECT HEIGHT
                                FROM STUDENT
                                WHERE GRADE = 4);

SELECT STUDNO, NAME, HEIGHT
FROM STUDENT
WHERE HEIGHT < ALL ( SELECT HEIGHT
                                FROM STUDENT
                                WHERE GRADE = 4);

-- EXISTS --

/*
    보직 수당을 받는 교수가 한 명이라도 있으면 교수 번호, 교수 이름, 급여, 보직수당, 급여+보직수당 출력
*/

SELECT PROFNO, NAME, SAL, COMM, SAL + NVL(COMM, 0) AS TOTAL
FROM PROFESSOR
WHERE EXISTS (SELECT PROFNO
                       FROM PROFESSOR
                       WHERE COMM IS NOT NULL);

/*
    학생 중에서 'goodboy' 라는 아이디를 가진 학생이 없으면 1을 출력
*/

SELECT '1'
FROM DUAL
WHERE NOT EXISTS (SELECT * 
                               FROM STUDENT
                               WHERE USERID = 'goodboy');

/*
    -- 다중 컬럼 서브 쿼리 --

    PAIRWISE : 컬럼을 쌍으로 묶어서 동시에 비교하는 방식
    UNPAIRWISE : 컬럼별로 나누어서 비교 후 AND 연산 하는 방식

    -> 메인 쿼리와 서브 쿼리에서 비교하는 컬럼의 수는 반드시 동일해야 함
*/

/*
    PAIRWISE 를 이용해 학년별로 몸무게가 최소인 학생을 출력
*/

SELECT NAME, GRADE, WEIGHT
FROM STUDENT
WHERE (GRADE, WEIGHT) IN ( SELECT GRADE, MIN(WEIGHT)
                                         FROM STUDENT
                                         GROUP BY GRADE );

/*
    UNPAIRWISE 를 이용해 학년별로 몸무게가 최소인 학생을 출력
*/

SELECT NAME, GRADE, WEIGHT
FROM STUDENT
WHERE GRADE IN ( SELECT GRADE
                            FROM STUDENT
                            GROUP BY GRADE )             
    AND WEIGHT IN ( SELECT MIN(WEIGHT)
                            FROM STUDENT
                            GROUP BY GRADE );

/*
    상호 연관 서브 쿼리
    
    메인 쿼리절과 서브 쿼리절 간에 검색 결과를 교환하는 서브쿼리
*/

/*
    각 학과 학생의 평균 키보다 키가 큰 학생 출력
*/

SELECT NAME, DEPTNO, HEIGHT
FROM STUDENT MS
WHERE HEIGHT > ( SELECT AVG(SS.HEIGHT)
                            FROM STUDENT SS
                            WHERE MS.DEPTNO = SS.DEPTNO
                            GROUP BY SS.DEPTNO);

/*
    단일행 서브 쿼리에서 오류가 발생하는 경우
    
    1) 복수행 값을 반환하는 서브 쿼리와 단일행 비교 연산자를 함께 사용하는 경우
    2) 서브쿼리에서 반환되는 컬럼의 수와 메인 쿼리에서 비교되는 컬럼의 수가 일치하지 않는 경우
*/

/*
    학년별로 최소 몸무게를 가진 학생을 출력
*/

SELECT NAME, GRADE, WEIGHT
FROM STUDENT MS
WHERE WEIGHT = (SELECT MIN(WEIGHT)
                            FROM STUDENT SS
                            WHERE MS.GRADE = SS.GRADE
                            GROUP BY GRADE)
ORDER BY GRADE;


/*
    메인 쿼리와 서브 쿼리 컬럼의 수가 일치하지 않는 경우
    101 번 학과 교수 중 최소 급여를 받는 교수 출력
*/

SELECT NAME, POSITION, SAL
FROM PROFESSOR MP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MIN(SAL)
                                      FROM PROFESSOR SP
                                      WHERE DEPTNO = 101 
                                      GROUP BY DEPTNO);

/*
    2002 년도에 입사한 교수의 평균 급여보다 많은 급여를 받는 교수 출력
    (서브 쿼리 결과가 NULL)
*/

SELECT PROFNO, NAME, SAL
FROM PROFESSOR
WHERE SAL > (SELECT AVG(SAL)
                      FROM PROFESSOR
                      WHERE TO_CHAR(HIREDATE, 'YYYY') = '2002');
