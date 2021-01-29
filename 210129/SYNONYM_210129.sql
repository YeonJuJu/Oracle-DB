-- 210129

/* ========================================================
    
    동의어
    
    => 하나의 객체에 부여하는 다른 이름
    
======================================================== */

-- System 사용자 소유의 PROJECT 테이블에 MY_PROJECT 라는 이름으로 전용 동의어 생성 --

CREATE TABLE PROJECT(
    PROJECT_ID      NUMBER(6) CONSTRAINT PRO_ID_PK PRIMARY KEY , 
    PROJECT_NAME VARCHAR2(100) ,
    STUDNO          NUMBER(6) ,
    PROFNO          NUMBER(6)
);

-- PROJECT 테이블에 데이터 삽입

INSERT INTO PROJECT
VALUES(12345, 'PORTPOLIO', 10101, 9901);

SELECT * FROM PROJECT;

-- SCOTT 사용자에게 PROJECT 테이블에 검색할 수 있는 권한을 부여

GRANT SELECT ON PROJECT TO SCOTT;

-- 공용 동의어 생성하기

CREATE PUBLIC SYNONYM PUB_PROJECT FOR PROJECT;

-- 동의어 조회

SELECT * FROM USER_SYNONYMS;

-- 공용 동의어 조회

SELECT * FROM DBA_SYNONYMS
WHERE TABLE_NAME = 'PROJECT';