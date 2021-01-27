/*
    DATA DICTIONARY
    
    -> 사용자와 데이터베이스 자원을 효율적으로 관리하기 위해 다양한 정보를 저장하는 테이블 집합
    
    접두어 (권한 표현)
        USER_   : 객체 소유자만 접근 가능
        ALL_     : 자기 소유 또는 권한 부여받은 객체만 접근 가능
        DBA_    : 데이터베이스 관리자만 접근 가능
*/

-- USER_ DATA DIRCITIONARY VIEW

SELECT TABLE_NAME FROM USER_TABLES;

-- ALL_ DATA DICTIONARY VIEW

SELECT OWNER, TABLE_NAME FROM ALL_TABLES;

-- DBA_ DATA DICTIONARY VIEW

SELECT OWNER, TABLE_NAME FROM DBA_TABLES;

/*
        사용자 테이블 정보 조회하기
        
        USER_TABLES
        -> 테이블이 저장된 테이블스페이스 이름, 데이터가 저장된 물리적 공간
        
        USER_OBJECTS
        
        USER_CATALOG
        -> 사용자 소유로 생성된 모든 객체 이름과 종류에 대한 정보를 저장한 시스템 테이블
*/

-- USER_TABLES

/*
    ADDR 로 시작하는 테이블의 이름, 테이블 스페이스 이름, 최소 확장 영역 수와 최대 확장 영역 수 출력
*/

SELECT TABLE_NAME, TABLESPACE_NAME, MIN_EXTENTS, MAX_EXTENTS
FROM USER_TABLES
WHERE TABLE_NAME LIKE 'ADDR%';

-- USER_OBJECTS

/*
    객체의 종류가 테이블이고 이름이 ADDR로 시작하는 객체의 이름, 종류, 생성날짜 출력
*/

SELECT OBJECT_NAME, OBJECT_TYPE, CREATED
FROM USER_OBJECTS
WHERE OBJECT_NAME LIKE 'ADDR%'
AND OBJECT_TYPE = 'TABLE';

-- USER_CATALOG

DESC USER_CATALOG;

SELECT * FROM USER_CATALOG;
