 /*
    SEQUENCE
    
    시퀀스를 이용해 기본 키 생성 가능
    
    CREATE SEQUENCE sequence
    
    DROP SEQUENCE sequence
    
    ALTER SEQUENCE sequence
    VALUE = value
 */
 
 /*
    시작번호 1, 증가치 1, 최댓값 2인 NUM_SEQ 이름을 가진 시퀀스 생성
 */
 
 CREATE SEQUENCE NUM_SEQ
 INCREMENT BY 1
 START WITH 1
 MAXVALUE 2;
 
 /*
    데이터 딕셔너리 : 테이블이나 시퀀스 등의 정보를 저장한 테이블
 */
 
 SELECT MIN_VALUE, MAX_VALUE, INCREMENT_BY, LAST_NUMBER
 FROM USER_SEQUENCES
 WHERE SEQUENCE_NAME = 'NUM_SEQ';
 
 /*
    .CURRVAL : 시퀀스에서 생성된 현재 번호 확인 
    .NEXTVALUE : 시퀀스에서 다음 번호 생성
 */
 
  -- NUM_SEQ 의 다음 값 : MAX_VALUE 보다 큰 숫자까지는 갈 수 없다
 SELECT NUM_SEQ.NEXTVAL FROM DUAL;
 
 -- NUM_SEQ 의 현재 값 : NUM_SEQ.NEXTVAL 을 생성 후 조회해야 함
 SELECT NUM_SEQ.CURRVAL FROM DUAL;
 
 -- NUM_SEQ 의 최댓값 변경하기
 ALTER SEQUENCE NUM_SEQ MAXVALUE 100;
 
/*
    학생 테이블에서 시퀀스 값을 이용해 기본키 값을 생성하여 입력
*/

INSERT 
INTO STUDENT(STUDNO, NAME, DEPTNO)
VALUES (NUM_SEQ.NEXTVAL, '강감찬', 102);

SELECT * FROM STUDENT
WHERE NAME = '강감찬';

-- 시퀀스 삭제

DROP SEQUENCE NUM_SEQ;

INSERT 
INTO STUDENT(STUDNO, NAME, DEPTNO)
VALUES (NUM_SEQ.NEXTVAL, '계백', 102);

SELECT * FROM STUDENT
WHERE NAME = '계백';
