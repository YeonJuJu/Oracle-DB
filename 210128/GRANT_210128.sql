/* ====================================================

    권한 부여하기 ( QUERY REWRITE, DBA, CONNECT, RESOURCE )
    
    GRANT option ON .. TO who WITH GRANT OPTION;
    
    권한 철회하기
    
    REVOKE option FROM who [CASCADE CONSTRINTS];
    
    권한 확인하기
    
    SELECT * FROM USER_SYS_PRIVS;
    SELECT * FROM SESSION_PRIVS;

==================================================== */

-- 모든 사용자에게 QUERY REWRITE 권한 부여

GRANT QUERY REWRITE TO PUBLIC;

-- 사용자와 롤에 부여된 시스템 권한을 조회

SELECT * FROM USER_SYS_PRIVS;

-- 현재 세션에서 사용자와 롤에 부여된 시스템 권한을 조회

SELECT * FROM SESSION_PRIVS;

-- 모든 사용자에게 QUERY REWRITE 권한 철회

REVOKE QUERY REWRITE FROM PUBLIC;

/*
    객체 권한
*/

/*
    TJOEUN 사용자에게 SCOTT 소유의 EMP 테이블을 SELECT 할 수 있는 권한 부여
*/

GRANT SELECT ON SCOTT.EMP TO TJOEUN;

/*
    TJOEUN 사용자에게 SCOTT 소유의 EMP 테이블의 키와 몸무게를 수정할 수 있는 권한 부여
*/

GRANT UPDATE(MGR, SAL) ON SCOTT.EMP TO TJOEUN;

/*
    객체 권한 조회
    
    TJOEUN 에게 부여된 사용자 객체, 컬럼에 부여된 객체 권한 조회
*/

-- 티조은 사용자가 다른 사용자에게 부여한 객체 권한 조회
SELECT * FROM USER_TAB_PRIVS_MADE;

-- 티조은 사용자에게 부여된 사용자 객체 권한, 객체 이름 조회
SELECT * FROM USER_TAB_PRIVS_RECD;

-- UPDATE 권한 확인
SELECT * FROM USER_COL_PRIVS_RECD;

-- SELECT 권한 확인
SELECT * FROM USER_TAB_PRIVS_RECD;
