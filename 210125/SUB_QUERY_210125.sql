 /*
    SUB QUERY
    
    하나의 SQL 명령문의 결과를 다른 SQL 명령문에 전달하기 위해 
    두 개 이상의 SQL 명령문을 하나의 SQL 명령문으로 연결하여 처리하는 방법
 */
 
 /*
    교수 테이블에서 전은지 교수님과 같은 직급을 가진 교수들을 출력
 */
 
 SELECT PROFNO, NAME, POSITION
 FROM PROFESSOR
 WHERE POSITION = (SELECT POSITION
                               FROM PROFESSOR
                               WHERE NAME = '전은지');
                               
/*
    사용자 아이디가 JUN123 인 학생과 같은 학년을 출력
*/

SELECT DEPTNO, NAME, GRADE
FROM STUDENT
WHERE GRADE = (SELECT GRADE
                          FROM STUDENT
                          WHERE USERID = 'jun123');

/*
    101 번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생들을 출력
*/

SELECT NAME, DEPTNO, WEIGHT
FROM STUDENT
WHERE WEIGHT < (SELECT AVG(WEIGHT)
                            FROM STUDENT
                            WHERE DEPTNO = 101)
ORDER BY DEPTNO ASC;                            

/*
    20101 번 학생과 학년이 같고 키는 20101 번 학생보다 큰 학생을 출력
*/

SELECT NAME, GRADE, HEIGHT
FROM STUDENT
WHERE GRADE =   (SELECT GRADE
                            FROM STUDENT
                            WHERE STUDNO = 20101)
          AND
          HEIGHT > (SELECT HEIGHT
                            FROM STUDENT
                            WHERE STUDNO = 20101);


/*
    -- 다중 행 서브쿼리 --
    
    서브 쿼리의 반환 값이 하나 이상일 경우 사용

    IN : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 하나라도 일치하면 참
    ANY, SOME : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 하나 이상 일치하면 참
    ALL : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 모든 값이 일치하면 참
    EXISTS : 메인 쿼리의 비교 조건이 서브 쿼리의 결과 중 만족하는 값이 하나라도 존재하면 참
*/

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











