/*  GROUP FUNCTION */

/*
    COUNT FUNCTION
    ㄴ>테이블에서 조건을 만족하는 행의 개수를 반환하는 함수
    
    COUNT(COLUMN, DISTINCT || ALL, EXPERIENCE)
*/

/*
    101 번 학과 교수 중 보직 수당을 받는 교수의 수를 출력
*/

SELECT COUNT(*) AS COMMPROF
FROM PROFESSOR
WHERE DEPTNO = 101 AND COMM IS NOT NULL;

/*==================================================*/

/*
    AVG SUM 
*/

/*
    101 번 학과 학생들의 몸무게 합계와 평균을 출력
*/

SELECT SUM(WEIGHT), AVG(WEIGHT)
FROM STUDENT
WHERE DEPTNO = 101;

/*==================================================*/

/*
    MAX MIN 
*/

/*
    102 번 학과 학생 중 키가 제일 큰 학생과 제일 작은 학생의 키 출력
*/

SELECT MAX(HEIGHT), MIN(HEIGHT)
FROM STUDENT
WHERE DEPTNO = 102;

/*==================================================*/

/*
    STDDEV(COLUMN) : 표준 편차
    VARIANCE(COLUMN) : 분산
*/

SELECT ROUND(STDDEV(SAL), 2), ROUND(VARIANCE(SAL), 2)
FROM PROFESSOR;

/*
    교수 테이블에서 직급이 교수인 사람들의 급여 표준편차와 분산 출력
*/

SELECT ROUND(STDDEV(SAL), 2), ROUND(VARIANCE(SAL), 2)
FROM PROFESSOR
WHERE POSITION = '교수';

/*==================================================*/

/*
    GROUP BY
    ㄴ> DEFAULT : 오름차순
    
    # GROUP BY 를 사용할 때 SELECT 절에서는 GROUP BY 절에서 명시하지 않은 컬럼은 사용할 수 없다
*/

SELECT DEPTNO, AVG(SAL)
FROM PROFESSOR
GROUP BY DEPTNO;

/*
    교수 테이블에서 학과별 교수의 인원수와 보직 수당을 받는 교수의 인원수를 출력
*/

SELECT DEPTNO, COUNT(*) AS NUM, COUNT(COMM) AS COMMNUM
FROM PROFESSOR
GROUP BY DEPTNO;

/*
    학과별 소속 교수들의 보직수당 출력
*/

SELECT DEPTNO, NAME, PROFNO, COMM
FROM PROFESSOR
ORDER BY DEPTNO ASC;

/*
    학과별로 소속 교수들의 평균 급여, 최소 급여, 최대 급여
*/

SELECT DEPTNO, AVG(SAL) AS AVERAGE, MIN(SAL) AS "MIN", MAX(SAL) AS "MAX"
FROM PROFESSOR
GROUP BY DEPTNO;

/*==================================================*/

/*
    다중 그룹화

    전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹화하여
    학과와 학년별 인원수, 평균 몸무게 출력
*/  

SELECT DEPTNO, COUNT(*) AS NUM, ROUND(AVG(WEIGHT), 2) AS AVGWEIGHT
FROM STUDENT
GROUP BY DEPTNO, GRADE;

/*==================================================*/

/*
        HAVING
*/

/*
    학생 수가 4 명 이상인 학년의 학생수, 평균키, 평균몸무게 출력
*/

SELECT GRADE, COUNT(*) AS "학생수", ROUND(AVG(WEIGHT), 2) AS WEIAVG, ROUND(AVG(HEIGHT), 2) AS HEIAVG
FROM STUDENT
GROUP BY GRADE
HAVING COUNT(*) >=4
ORDER BY ROUND(AVG(HEIGHT), 2) DESC;

-- WHERE 절과 HAVING 절의 성능 차이 --

SELECT DEPTNO, ROUND(AVG(SAL), 2) 
FROM PROFESSOR
GROUP BY DEPTNO
HAVING DEPTNO > 102;

SELECT DEPTNO, ROUND(AVG(SAL), 2) 
FROM PROFESSOR
WHERE DEPTNO > 102
GROUP BY DEPTNO;

/*
    학과별 학생의 평균 몸무게 중 최대 평균 몸무게 출력
*/

SELECT MAX(AVG(WEIGHT))
FROM STUDENT
GROUP BY DEPTNO;

/*
    학과별 학생 수가 최대 또는 최소인 학과의 학생 수를 출력
*/

SELECT MAX(COUNT(STUDNO)) AS "최대인원수 학과",  MIN(COUNT(STUDNO)) AS "최소인원수 학과"
FROM STUDENT
GROUP BY DEPTNO;
