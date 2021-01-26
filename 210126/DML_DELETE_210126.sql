 /*
    데이터 삭제
    
    DELETE FROM [WHERE]
*/

/*
    10110 번 학생의 데이터를 삭제
*/

DELETE 
FROM STUDENT
WHERE STUDNO = 10110;

-- 서브 쿼리를 이용한 데이터 삭제 --

/*
    교수 테이블에서 기계공학과에 소속된 모든 교수의 정보를 삭제
*/

SELECT * FROM PROFESSOR;

DELETE
FROM PROFESSOR
WHERE DEPTNO = (SELECT DEPTNO
                            FROM DEPARTMENT
                            WHERE DNAME = '기계공학과');
                            
ROLLBACK;                                                   