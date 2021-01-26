/*
    트랜잭션 관리
    
    관계형 데이터베이스에서 실행되는 여러 개의 SQL 명령문을 
    하나의 논리적인 단위로 묶은 것
    
    COMMIT : 트랜잭션 정상 종료
    ROLLBACK : 트랜잭션 전체 취소 ( 가장 최근 COMMIT 선언한 부분까지 )
*/
ROLLBACK;
COMMIT;

DELETE 
FROM DEPARTMENT
WHERE DEPTNO IN (300, 301);

SELECT * FROM DEPARTMENT;

ROLLBACK;

SELECT * 
FROM DEPARTMENT
WHERE DEPTNO = 102;

UPDATE DEPARTMENT
SET DNAME = '인터넷정보학과'
WHERE DEPTNO = 102;

ROLLBACK;
