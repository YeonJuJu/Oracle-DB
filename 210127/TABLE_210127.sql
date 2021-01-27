 /*
    테이블 관리와 데이터 딕셔너리
 */
 
/*
    테이블 생성
    
    CREATE TABLE ( );

    -> 서브 쿼리를 이용하려면 뒤에 AS 를 붙인 후 서브 쿼리문 작성
*/
 
 -- 주소록 테이블 생성
 
 CREATE TABLE ADDRESS(
        ID          NUMBER(6),
        NAME    VARCHAR2(50),
        ADDR     VARCHAR2(100),
        PHONE   VARCHAR2(30),
        EMAIL    VARCHAR2(100)
 );
 
 SELECT * FROM TAB;
 
 DESC ADDRESS;
 
 -- ADDRESS 테이블에 데이터 삽입
 
 INSERT INTO ADDRESS
 VALUES(1, '김남준', '일산', '010-1234-5678', 'namjun@gmail.com');
 
 COMMIT;
 
 SELECT * FROM ADDRESS;
 
 /*
    서브 쿼리절을 사용해 주소록 테이블의 구조와 데이터를 복사해 ADDR_2 생성
 */
 
 -- 테이블 서브쿼리의 전체 내용을 가져올 때는 다음과 같이 컬럼명 생략
 
 CREATE TABLE ADDRESS_2 AS SELECT * FROM ADDRESS;
 
 DESC ADDRESS_2;
 
 SELECT * FROM ADDRESS_2;
 
 CREATE TABLE ADDRESS_4 AS SELECT ID FROM ADDRESS;
 
 SELECT * FROM ADDRESS_4;

 -- 테이블 서브쿼리의 일부의 내용을 가져올 때는 다음과 같이 컬럼명 명시
 
 CREATE TABLE ADDRESS_3 (ID, NAME, ADDR, PHONE, EMAIL)
                                                                                AS SELECT * FROM ADDRESS;
 
 SELECT * FROM ADDRESS_3;
 
 /*
        -- 기존 테이블의 구조만 복사하기 --
        
        WHERE 절을 사용해 항상 거짓이 되는 조건식 설정
 */
 
 /*
    주소록 테이블에서 ID, NAME 컬럼만 복사해 ADDR_S 를 생성
    단, 데이터는 복사하지 않는다
 */
 
 CREATE TABLE ADDRESS_5
 AS SELECT ID, NAME FROM ADDRESS
 WHERE 1 = 2;
 
 SELECT * FROM ADDRESS_5;
 
 /*
        테이블 수정
        
        ALTER TABLE 
        
        1) 테이블 컬럼 추가 : ALTER TABLE ~ ADD
        2) 테이블 컬럼 수정 : ALTER TABLE ~ MODIFY
        3) 테이블 컬럼 삭제 : ALTER TABLE ~ DROP COLUMN
 */
 
 -- 테이블 컬럼 추가
 
 /*
    주소록 테이블에 BIRTHDATE 컬럼 추가
 */
 
 ALTER TABLE ADDRESS
 ADD (BIRTHDATE DATE);
 
 DESC ADDRESS;
 SELECT * FROM ADDRESS;
 
 /*
    주소록 테이블에 VARCHAR2 타입의 COMMENTS 컬럼 추가
    기본값은 NO COMMENT
 */
 
 ALTER TABLE ADDRESS
 ADD (COMMENTS VARCHAR(100) DEFAULT 'NO COMMENT');
 
 DESC ADDRESS;
 SELECT * FROM ADDRESS;
 
 -- 테이블 컬럼 삭제
 
 /*
    주소록 테이블에서 COMMENTS 컬럼을 삭제하세요
 */
 
 ALTER TABLE ADDRESS
 DROP COLUMN COMMENTS;
 
 -- 테이블 컬럼 수정
 
 /*
    주소록 테이블에서 PHONE 컬럼의 데이터 타입의 크기를 50으로 증가
 */
 
 ALTER TABLE ADDRESS
 MODIFY PHONE VARCHAR(50);
 
 DESC ADDRESS;
 
 /*
        테이블 이름 변경 (뷰, 시퀀스, 동의어 다 가능)
        
        RENAME table_name TO new_name;
 */
 
 /*
    ADDRESS_2 테이블의 이름을 ADDRESS_CLIENT 로 변경
 */
 
 RENAME ADDRESS_2 TO ADDRESS_CLIENT;
 
 SELECT * FROM TAB;
 
 /*
        테이블 삭제
        
        DROP TABLE table CASCADE OR RESTRICT
 */
 
 /*
    ADDRESS_3 테이블을 삭제
 */
 
 DROP TABLE ADDRESS_3;
 
 /*
        휴지통 보기 -> 휴지통에 있는 정보는 다시 복구 가능
        
        SHOW RECYCLEBIN; : 휴지통 보기
        FLASHBACK TABLE table TO BEFORE DROP; : 복구
        PURGE RECYCLEBIN table : 휴지통 비우기
 */
 
 SHOW RECYCLEBIN;
 
 FLASHBACK TABLE ADDRESS_3 TO BEFORE DROP;

 PURGE RECYCLEBIN;
 
 /*
    TAB 은 TABLE 정보를 모아둔 DICTIONARY
 */
 
 SELECT *
 FROM TAB
 WHERE TNAME = 'ADDRESS_3';
 
  /*
        TRUNCATE
        
        테이블 구조는 그대로 유지하고, 테이블의 데이터와 할당된 공간만 삭제
  */

 TRUNCATE TABLE ADDRESS_4;
 
 SELECT * FROM ADDRESS_4;
 
 /*
        테이블에 주석 추가
        
        COMMENT ON TABLE table
        IS 'comments'
        
        컬럼에 주석 추가
        
        COMMENT ON COLUMN table.column
        IS 'comments'
 */
 
 /*
    주소록 테이블에 '고객 주소록을 관리하기 위한 테이블' 이라는 주석 추가
 */
 
 COMMENT ON TABLE ADDRESS
 IS '고객 주소록을 관리하기 위한 테이블';
 
 /*
    주소록 테이블의 NAME 컬럼에 '고객 이름' 이라는 주석 추가 
 */
 
 COMMENT ON COLUMN ADDRESS.NAME
 IS '고객 이름';
 
 /*
    USER_TAB_COMMENTS, USER_COL_COMMENTS 데이터 딕셔너리를 사용해
    ADDRESS 테이블과 ADDRESS 테이블 각 컬럼에 추가된 주석 출력
 */
 
 SELECT *
 FROM USER_TAB_COMMENTS;
 
 SELECT *
 FROM USER_COL_COMMENTS;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 