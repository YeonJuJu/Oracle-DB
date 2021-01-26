/*
    데이터 수정
    
    UPDATE SET [WHERE]
*/

/*
    10108 번 학생의 생년월일을 '89/11/23'으로 수정하고 주민등록번호를 8911231659874 로 수정
*/

SELECT STUDNO, NAME, BIRTHDATE, IDNUM
FROM STUDENT
WHERE STUDNO = 10108;

UPDATE STUDENT
SET BIRTHDATE = TO_DATE('89/11/23', 'YY/MM/DD'), IDNUM = '8911231659874'
WHERE STUDNO = 10108;

-- 서브 쿼리를 이용한 데이터 수정 --

/*
    서브 쿼리를 이용해 성연희 교수의 급여와 보직수당을 권혁일 교수의 급여와 보직수당과 같게 수정
*/

UPDATE PROFESSOR
SET (SAL, COMM) = (SELECT SAL, COMM
                            FROM PROFESSOR
                            WHERE NAME = '권혁일')
WHERE NAME = '성연희';

ROLLBACK;

SELECT * FROM PROFESSOR;

/*
    서브쿼리를 이용해 기계공학과에 속한 학생의 지도교수 번호를 남은혁 교수의 교수번호로 수정
*/

UPDATE STUDENT
SET PROFNO = (SELECT PROFNO
                       FROM PROFESSOR
                       WHERE NAME = '남은혁')
WHERE DEPTNO = (SELECT DEPTNO
                            FROM DEPARTMENT
                            WHERE DNAME = '기계공학과');

