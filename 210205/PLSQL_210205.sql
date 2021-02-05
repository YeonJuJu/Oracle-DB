-- PL/SQL --

--> SQL을 확장한 절차적 언어

/*
    PROCEDURAL LANGUAGE / STRUCTURED QUERY LANGUAGE
    
    오라클 데이터베이스 환경에서 실행되는 절차적인 데이터베이스 프로그래밍 언어
    
    프로그램 단위를 BLOCK 이라 하며, 여기서 APPLICATION LOGIC 을 작성
    
    업무 규칙이나 복잡한 로직들을 캡슐화(ENCAPSULATION) 할 수 있고,
    모듈화(MODULARITY), 추상화(ABSTRACTION)가 가능함
    
    데이터베이스 트리거를 사용해서 데이터베이스 무결성 제약조건과 변경 내역 등 데이터를 복사함
    
    PL/SQL 에서 제공하는 명령문
    --> SQL 문
    --> 변수, 상수 등의 선언문
    --> 대입문 (할당 연산자 사용)
    --> 조건문, 반복문 등 제어문
    
    PL/SQL 문의 기본 구조
    -> DECLARE 변수, 상수, 프로시저, 함수, 서브프로그램, 커서 등을 선언함
    
        선언문...
        
    BEGIN       처리할 명령문들을 절차적으로 기술함
    
        실행문(STATEMENT)      SQL문,   대입문,    조건문,    반복문    등의 제어문,    커서 처리문
        
    EXCEPTION       오류 처리에 대한 예외처리 명령문을 기술함
    
        예외처리문
        
    END;
    /   (마지막에 '/' 를 기술함)
    
*/

/*
    PRINTF 역할 => DBMS_OUTPUT.PUT_LINE();
*/

SET SERVEROUTPUT ON;

DECLARE
    VNO     NUMBER(4);
    VNAME VARCHAR2(10);
BEGIN
    SELECT EMPNO, ENAME INTO VNO, VNAME
    FROM EMP
    WHERE EMPNO = 7782;
    
    DBMS_OUTPUT.PUT_LINE(VNO || ' ' || VNAME);
END;
/

/*
    DECLARE 절에서 변수 타입을 직접 정해주지 않고 자동으로 정해주는 법
    
    => table.column%TYPE
*/

DECLARE
    VNO    EMP.EMPNO%TYPE;
    VSAL    EMP.SAL%TYPE;
BEGIN
    SELECT EMPNO, SAL INTO VNO, VSAL
    FROM EMP
    WHERE EMPNO = 7782;
    
    DBMS_OUTPUT.PUT_LINE(VNO||' == '||VSAL);   
END;
/

------------------------------------------------------------------------------------------------------------------------

/*
    DECLARE 절은 생략 가능

    DECLARE 변수이름 데이터타입;
	ex) DECLARE NAME VARCHAR2(10);

    DECLARE 변수이름 데이터타입 :=값;
	ex) DECLARE NAME VARCHAR2(10) := '갓댐';

    DECLARE 변수이름 데이터타입 DEFAULT 기본값;
	ex) DECLARE NAME VARCHAR2(10) DEFAULT '갓대미';
*/

-- 테이블 생성
CREATE TABLE PLTEST1(
    NO  NUMBER,
    NAME    VARCHAR2(10)
);

-- 시퀀스 생성
CREATE SEQUENCE PLTEST_SEQ;

-- PL/SQL 문 실행 : 테이블에 데이터를 삽입
BEGIN 
    INSERT INTO PLTEST1
    VALUES(PLTEST_SEQ.NEXTVAL, 'PAUL');
END;
/

-- 테이블 조회
SELECT * FROM PLTEST1;

COMMIT;

------------------------------------------------------------------------------------------------------------------------

/*
    데이터 입력 받기 : 변수 선언 후 " := '&name' " 입력
*/

-- 테이블 생성
CREATE TABLE PLTEST2(
    NO     NUMBER,
    NAME VARCHAR2(10),
    ADDR  VARCHAR2(20)
);

SET VERIFY OFF

-- PL/SQL 문 실행 : 입력받은 값을 테이블에 삽입
DECLARE
    VNO     NUMBER := '&NO';
    VNAME VARCHAR2(10) := '&NAME';
    VADDR  VARCHAR2(20) := '&ADDR';
BEGIN
    INSERT INTO PLTEST2
    VALUES(VNO, VNAME, VADDR);
END;
/

-- 테이블 조회
SELECT * FROM PLTEST2;

COMMIT;

-- 테이블 정보 수정
BEGIN
    UPDATE PLTEST2
    SET NAME = 'TOM'
    WHERE NO = 1;
END;
/

-- 테이블 조회
SELECT * FROM PLTEST2;

-- PL/SQL 문 실행 : 테이블 데이터 삭제
BEGIN
    DELETE FROM PLTEST1
    WHERE NO = 1;
END;
/

-- 테이블 조회
SELECT * FROM PLTEST1;

COMMIT;

------------------------------------------------------------------------------------------------------------------------

/*
    MERGE INTO  maintable
    USING comparetable
    ON (comparetable.column = maintable.column)
    WHEN MATCHED THEN ~
    WHEN NOT MATCHED THEN ~ ;
*/

-- 테이블 생성
CREATE TABLE PLTEST3(
    NO     NUMBER,
    NAME VARCHAR2(10)
);

CREATE TABLE PLTEST4 
AS 
    SELECT * FROM PLTEST3;
    
-- 데이터 삽입    
INSERT INTO PLTEST3 VALUES(1, 'PAUL');
INSERT INTO PLTEST3 VALUES(2, 'JOHN');

INSERT INTO PLTEST4 VALUES(1, 'TOM');
INSERT INTO PLTEST4 VALUES(2, 'JERY');

COMMIT;

-- PL/SQL 문 실행 : 테이블 수정
BEGIN
    MERGE INTO PLTEST4 M2
    USING PLTEST3 M1
    ON (M1.NO = M2.NO)
    WHEN MATCHED THEN UPDATE SET M2.NAME = M1.NAME
    WHEN NOT MATCHED THEN INSERT VALUES (M1.NO, M1.NAME);
END;
/

-- 테이블 조회
SELECT * FROM PLTEST4;

COMMIT;

------------------------------------------------------------------------------------------------------------------------

-- 테이블 생성
CREATE TABLE PLTEST5(
    NO     NUMBER,
    NAME VARCHAR2(10)
);

CREATE TABLE PLTEST6 
AS 
    SELECT * FROM PLTEST5;
    
-- 데이터 삽입    
INSERT INTO PLTEST5 VALUES(1, 'PAUL');
INSERT INTO PLTEST5 VALUES(2, 'JOHN');

INSERT INTO PLTEST6 VALUES(2, 'TOM');
INSERT INTO PLTEST6 VALUES(3, 'JERY');

COMMIT;

-- PL/SQL 문 실행 : 테이블 수정
BEGIN
    MERGE INTO PLTEST6 M2
    USING PLTEST5 M1
    ON (M1.NO = M2.NO)
    WHEN MATCHED THEN UPDATE SET M2.NAME = M1.NAME
    WHEN NOT MATCHED THEN INSERT VALUES (M1.NO, M1.NAME);
END;
/

-- 테이블 조회
SELECT * FROM PLTEST6 ORDER BY NO;

COMMIT;

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : PL/SQL 속 PL/SQL
DECLARE     
    VFIRST VARCHAR2(10) := 'FIRST';
BEGIN
    DECLARE
        VSECOND VARCHAR2(10) := 'SECOND';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('VFIRST : ' || VFIRST);
        DBMS_OUTPUT.PUT_LINE('VSECOND : ' || VSECOND);
    END;
    DBMS_OUTPUT.PUT_LINE('VFIRST : ' || VFIRST);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- 테이블 생성
CREATE TABLE EMP2 AS SELECT EMPNO, ENAME, SAL FROM EMP;

-- PL/SQL 문 실행 
DECLARE
    VNO     EMP2.EMPNO%TYPE;
    VNAME EMP2.ENAME%TYPE;
    VSAL    EMP2.SAL%TYPE;
BEGIN
    SELECT EMPNO, ENAME, SAL INTO VNO, VNAME, VSAL
    FROM EMP2
    WHERE EMPNO = 7844;
    
    DBMS_OUTPUT.PUT_LINE(VNO || ' - ' || VNAME || ' - ' || VSAL);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : ROWTYPE 변수 활용
DECLARE
    VROW EMP2%ROWTYPE;
BEGIN
    SELECT * INTO VROW
    FROM EMP2
    WHERE EMPNO = 7521;
    
     DBMS_OUTPUT.PUT_LINE(VROW.EMPNO || ' - ' || VROW.ENAME || ' - ' || VROW.SAL);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : 변수를 이용한 계산
DECLARE
    NUM     NUMBER(4);
BEGIN
    NUM := 1238;
    NUM := NUM + 1111;
    
     DBMS_OUTPUT.PUT_LINE('NUM : ' || NUM);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : 인자를 입력받아 계산
DECLARE
    VNUM1     NUMBER := '&NUM1';
    VNUM2     NUMBER := '&NUM2';
    VSUM        NUMBER;
BEGIN
    VSUM := VNUM1 + VNUM2;
    
    DBMS_OUTPUT.PUT_LINE ('VNUM1 + VNUM2 = ' || VNUM1 || ' + ' || VNUM2 || ' = ' || VSUM);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : 타입의 이름을 별칭으로 지정
DECLARE
    TNAME VARCHAR2(20);
    --> 타입의 이름을 별칭으로 지정
    TYPE TBL_EMP_NAME IS TABLE OF EMP.ENAME%TYPE INDEX BY BINARY_INTEGER;
    VNAME TBL_EMP_NAME;
BEGIN
    SELECT ENAME INTO TNAME
    FROM EMP
    WHERE EMPNO = 7654;
    
    VNAME(0) := TNAME;
    
    DBMS_OUTPUT.PUT_LINE (VNAME(0));
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : FOR 반복문 
DECLARE
    TYPE EMP_TBLE_TYPE IS TABLE OF EMP.ENAME%TYPE INDEX BY BINARY_INTEGER;
    TBL_TYPE EMP_TBLE_TYPE;
    K BINARY_INTEGER := 0;
    
BEGIN
    FOR I IN (SELECT ENAME FROM EMP) 
    LOOP
        K := K+1;
        TBL_TYPE(K) := I.ENAME;
    END LOOP;
    
    FOR J IN 1..K
    LOOP
        DBMS_OUTPUT.PUT_LINE(TBL_TYPE(J));
    END LOOP;
END;
/

------------------------------------------------------------------------------------------------------------------------

-- 바인드 변수 ( 비PL/SQL 변수 )

/*
     바인드 변수는 HOST 환경에서 생성되어 DATA를 저장 : HOST 변수라고도 함
    
      VARIABLE 키워드를 사용해서 생성함
      SQL 문과  PL/SQL 블럭에서 사용함
      PL/SQL 블럭이 실행된 이후에도 사용할 수 있음
*/

-- 사용 예
VARIABLE VBIND NUMBER;

BEGIN
  SELECT (SAL * 12) INTO :VBIND
    FROM EMP
   WHERE EMPNO = 7369;
END;
/
PRINT VBIND;

------------------------------------------------------------------------------------------------------------------------

/*
  조건문
  
  IF(조건) THEN
    STATEMENT1;
    STATEMENT1;
    STATEMENT1;
    STATEMENT1;
    ............
  END IF;  
    
*/

/*
 EMP 테이블에서 EMPNO 가 7844인 사원의 
 EMPNO, ENAME, DEPTNO, DNAME 을 출력하세요

 (IF)
 DEPTNO 10 -> ACCOUNTING   
 DEPTNO 20 -> RESEARCH                     
 DEPTNO 30 -> SALES                        
 DEPTNO 40 -> OPERATIONS              
*/ 

DECLARE 
  VEMPNO   EMP.EMPNO%TYPE;
  VNAME    EMP.ENAME%TYPE;
  VDEPTNO  EMP.DEPTNO%TYPE;
  VDNAME   VARCHAR2(20);
BEGIN 
  SELECT EMPNO, ENAME, DEPTNO
    INTO VEMPNO, VNAME, VDEPTNO
    FROM EMP
   WHERE EMPNO = 7844;
   
   IF(VDEPTNO = 10) THEN
     VDNAME := 'ACCOUNTING';
   END IF;
   IF(VDEPTNO = 20) THEN
     VDNAME := 'RESEARCH';
   END IF;
   IF(VDEPTNO = 30) THEN
     VDNAME := 'SALES';
   END IF;
   IF(VDEPTNO = 40) THEN
     VDNAME := 'OPERATIONS';
   END IF;
   DBMS_OUTPUT.PUT_LINE(VEMPNO||' - '||VNAME||' - '||VDEPTNO||' - '||VDNAME);
END;
/

------------------------------------------------------------------------------------------------------------------------

/*
  조건문
  
  IF(조건) THEN
    STATEMENT1;
  ELSIF(조건) THEN
    STATEMENT2;
  END IF;  
    
*/

/*
 EMP 테이블에서 EMPNO 가 7844인 사원의 
 EMPNO, ENAME, DEPTNO, DNAME 을 출력하세요

 (IF)
 DEPTNO 10 -> ACCOUNTING   
 DEPTNO 20 -> RESEARCH                     
 DEPTNO 30 -> SALES                        
 DEPTNO 40 -> OPERATIONS              
*/ 

DECLARE 
  VEMPNO   EMP.EMPNO%TYPE;
  VNAME    EMP.ENAME%TYPE;
  VDEPTNO  EMP.DEPTNO%TYPE;
  VDNAME   VARCHAR2(20);
BEGIN 
  SELECT EMPNO, ENAME, DEPTNO
    INTO VEMPNO, VNAME, VDEPTNO
    FROM EMP
   WHERE EMPNO = 7844;
   
   IF(VDEPTNO = 10) THEN
     VDNAME := 'ACCOUNTING';
   ELSIF(VDEPTNO = 20) THEN
     VDNAME := 'RESEARCH';
   ELSIF(VDEPTNO = 30) THEN
     VDNAME := 'SALES';
   ELSIF(VDEPTNO = 40) THEN
     VDNAME := 'OPERATIONS';
   END IF;
   DBMS_OUTPUT.PUT_LINE(VEMPNO||' - '||VNAME||' - '||VDEPTNO||' - '||VDNAME);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 문 실행 : IF 조건문
DECLARE
    VEMPNO EMP.EMPNO%TYPE;
    VENAME  EMP.ENAME%TYPE;
    VSAL       EMP.SAL%TYPE;
    VCOMM  EMP.COMM%TYPE;
    VTOTAL   NUMBER;
BEGIN    
    SELECT EMPNO, ENAME, SAL, COMM, SAL*COMM
    INTO VEMPNO, VENAME, VSAL, VCOMM, VTOTAL
    FROM EMP
    WHERE EMPNO = &EMPNO;
    
    IF(VCOMM > 0) THEN
        DBMS_OUTPUT.PUT_LINE(VENAME || ' 사원의 보너스는 ' || VTOTAL || '입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE(VENAME || ' 사원의 보너스는 없습니다.');
    END IF;
END;
/

------------------------------------------------------------------------------------------------------------------------

/*
  CASE [조건]
        WHEN 조건1 THEN 결과1
        WHEN 조건2 THEN 결과2
        WHEN 조건3 THEN 결과3
        ....
        WHEN 조건N THEN 결과N
        [ELSE DEFAULT 값]
    END;
*/

-- PL/SQL 문 실행 : CASE 조건문
DECLARE
    POINT NUMBER := 80;
BEGIN    
    CASE
        WHEN POINT >= 90 THEN DBMS_OUTPUT.PUT_LINE('당신의 학점은 A 입니다');
        WHEN POINT >= 80 THEN DBMS_OUTPUT.PUT_LINE('당신의 학점은 B 입니다');
        ELSE DBMS_OUTPUT.PUT_LINE('당신의 학점은 C 입니다');
    END CASE;
END;
/


DECLARE 
  VEMPNO   EMP.EMPNO%TYPE;
  VNAME    EMP.ENAME%TYPE;
  VDEPTNO  EMP.DEPTNO%TYPE;
  VDNAME   VARCHAR2(20);
BEGIN 
  SELECT EMPNO, ENAME, DEPTNO
    INTO VEMPNO, VNAME, VDEPTNO
    FROM EMP
   WHERE EMPNO = 7844;
   
   CASE
        WHEN(VDEPTNO = 10) THEN VDNAME := 'ACCOUNTING';
        WHEN(VDEPTNO = 20) THEN VDNAME := 'RESEARCH';
        WHEN(VDEPTNO = 30) THEN VDNAME := 'SALES';
        WHEN(VDEPTNO = 40) THEN VDNAME := 'OPERATIONS';
   END CASE;
   
   DBMS_OUTPUT.PUT_LINE(VEMPNO||' - '||VNAME||' - '||VDEPTNO||' - '||VDNAME);
END;
/

------------------------------------------------------------------------------------------------------------------------

-- PL/SQL 에서 IF 문을 사용하여 EMP 테이블에서 연봉을,
--COMM 이 NULL 이면 SAL * 12, NULL 이 아니면 SAL * 12 + COMM 으로 하여
--ENAME 이 SCOTT 인 사원의 이름과 연봉을 출력

DECLARE

    --> VEMP EMP%ROWTYPE 하고 나서 밑에 SELECT * INTO VEMP FROM EMP 하고 VEMP.COLUMN명 해서 사용해도 됨

    VNAME EMP.ENAME%TYPE;
    VSAL EMP.SAL%TYPE;
    VCOMM EMP.COMM%TYPE;
    VMONEY NUMBER(20);
BEGIN
    SELECT ENAME, SAL, COMM INTO VNAME, VSAL, VCOMM
    FROM EMP
    WHERE ENAME='ALLEN';
    
    CASE 
        WHEN (VCOMM IS NULL) THEN VMONEY := VSAL*12;
        WHEN (VCOMM IS NOT NULL) THEN VMONEY := VSAL*12+VCOMM;
    END CASE;
    
    DBMS_OUTPUT.PUT_LINE(VNAME || ' : ' || VMONEY);

END;
/

------------------------------------------------------------------------------------------------------------------------

-- 반복문 --

/*
    기본 형식
    
    LOOP
        STATEMENT1;
        STATEMENT2;
        ...
        STATEMENTN;
        
        EXIT [조건];
    END LOOP;
*/

DECLARE 
    NUM NUMBER := 1;
BEGIN
    LOOP
            DBMS_OUTPUT.PUT_LINE(NUM);
            NUM := NUM+1;
            EXIT WHEN NUM >5;
    END LOOP;
END;
/

DECLARE 
    NUM NUMBER := 1;
BEGIN
    LOOP
        IF (NUM >5) THEN EXIT; END IF;
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM+1;
    END LOOP;
END;
/

DECLARE 
    NUM NUMBER := 1;
    STAR VARCHAR2(10) := NULL;
BEGIN
    LOOP
        NUM := NUM+1;
        STAR := STAR || '*';
        DBMS_OUTPUT.PUT_LINE(STAR);
        EXIT WHEN NUM >5;
    END LOOP;
END;
/

------------------------------------------------------------------------------------------------------------------------

DECLARE 
    NUM NUMBER := 1;
BEGIN
    WHILE NUM < 6 LOOP
         DBMS_OUTPUT.PUT_LINE(NUM);
         NUM := NUM+1;
    END LOOP;
END;
/

DECLARE 
    NUM NUMBER := 1;
    STAR VARCHAR2(10) := NULL;
BEGIN
    WHILE NUM<6 LOOP
        STAR := STAR || '*';
        DBMS_OUTPUT.PUT_LINE(STAR);
        NUM := NUM+1;
    END LOOP;
END;
/

------------------------------------------------------------------------------------------------------------------------

-- FOR LOOP
BEGIN
    FOR NUM IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/

-- FOR REVERSE LOOP
BEGIN
    FOR NUM IN REVERSE 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
    END LOOP;
END;
/

DECLARE
    VDEPT DEPT%ROWTYPE;
BEGIN
    FOR NUM IN 1..4 LOOP
        SELECT * INTO VDEPT FROM DEPT
        WHERE DEPTNO = 10 * NUM;
        
        DBMS_OUTPUT.PUT_LINE('부서번호 : ' || VDEPT.DEPTNO);        
        DBMS_OUTPUT.PUT_LINE('부서이름 : ' || VDEPT.DNAME);        
        DBMS_OUTPUT.PUT_LINE('위      치 : ' || VDEPT.LOC);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');

    END LOOP;
END;
/

------------------------------------------------------------------------------------------------------------------------

-- 커서 --

/*
    커서 (CURSOR)
    
    SELECT 문을 통한 결과값이 저장되는 메모리 공간
    
    -- 종류 --
    
    . 묵시적 커서 (IMPLICIT CURSOR)
            오라클에서 자동으로 선언해주는 SQL커서 (사용자가 임의로 사용할 수 없음)
            1 개의 결과를 반환하는 경우 자동으로 저장
    . 명시적 커서 (EXPLICIT CURSOR)
            여러 개의 결과를 반환하는 경우 직접 선언해서 사용함
    
    -- 속성  --
    
        . %FOUND : 가져올 RECORD 가 있는 경우 TRUE
        . %ISOPEN :  CURSOR가 OPEN 상태인 경우 TRUE
        . %NOTFOUND : 더 이상 참조할 RECORD 가 없는 경우 TRUE
        . %ROWCOUNT : OPEN 시에는 0. FETCH 가 발생할마다 1씩 증가함
                                  (FETCH : CURSOR에서 결과값을 가져오는 작업)
        
    -- 처리 단계 --
    
        커서 선언 : CURSOR 커서이름 IS 
                            SELECT 컬럼(속성) FROM 테이블
                            
        커서 열기 : OPEN 커서이름 IS
        
        데이터 추출 : FETCH 커서이름 INTO 변수이름
                            
        커서 종료 : CLOSE 커서이름 
        
*/

DECLARE
    VENAME  EMP.ENAME%TYPE;
    VDEPTNO EMP.DEPTNO%TYPE;
    
    CURSOR CS IS
        SELECT ENAME, DEPTNO
        FROM EMP
        WHERE DEPTNO = 20;
BEGIN
    OPEN CS;
    LOOP
        FETCH CS INTO VENAME, VDEPTNO;
        EXIT WHEN CS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VENAME||' - ' || VDEPTNO);
    END LOOP;
    CLOSE CS;
END;
/

-- 20 부서에 근무하는 사원의 이름과 부서번호 출력

DECLARE
    CURSOR CS IS
            SELECT ENAME, JOB, DEPTNO
            FROM EMP
            WHERE DEPTNO = 20;
BEGIN
    FOR ROW IN CS LOOP
        DBMS_OUTPUT.PUT_LINE(ROW.ENAME || ' - ' || ROW.JOB || ' - ' || ROW.DEPTNO);
    END LOOP;
END;
/

BEGIN
    FOR ROW IN (SELECT ENAME, JOB, DEPTNO
                        FROM EMP
                        WHERE DEPTNO = 20) LOOP
        DBMS_OUTPUT.PUT_LINE(ROW.ENAME || ' - ' || ROW.JOB || ' - ' || ROW.DEPTNO);
    END LOOP;
END;
/

DECLARE 
    VEMPNO EMP.EMPNO%TYPE;
    VENAME EMP.ENAME%TYPE;
    CURSOR CS IS
        SELECT EMPNO, ENAME
        FROM EMP
        WHERE DEPTNO = 30;
BEGIN
    OPEN CS;
    LOOP
            FETCH CS INTO VEMPNO, VENAME;
            EXIT WHEN CS%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(VEMPNO || ' - ' || VENAME);
    END LOOP;
    CLOSE CS;
END;
/

------------------------------------------------------------------------------------------------------------------------

/*
    PARAMETER EXPLICIT CURSOR
    
    명시적으로 커서를 선언한 후 OPEN 할 때 값을 바꿔서 수행해야 하는 경우
    커서를 OPEN 할 때 필요한 값만 PARAMETER 로 전달해 반복 수행할 수 있음
*/

DECLARE
    VEMPNO EMP.EMPNO%TYPE;
    VENAME EMP.ENAME%TYPE;
    VSAL EMP.SAL%TYPE;
    CURSOR EMP_CS (VDEPTNO EMP.DEPTNO%TYPE) IS
        SELECT EMPNO, ENAME, SAL
        FROM EMP
        WHERE DEPTNO = VDEPTNO;
BEGIN
    OPEN EMP_CS(20);
    LOOP
        FETCH EMP_CS INTO VEMPNO, VENAME, VSAL;
        EXIT WHEN EMP_CS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(VEMPNO || ' - ' || VENAME || ' - ' || VSAL);
    END LOOP;
    CLOSE EMP_CS;
END;
/

------------------------------------------------------------------------------------------------------------------------

-- ORACLE EXCEPTION HANDLING : 예외처리 --

/*
    형식
    
    EXCEPTION
        WHEN EXCEPTION1 [OR EXCEPTION2...] THEN
            STATEMENT1;
            STATEMENT2;
            ...........
        WHEN EXCEPTION3 [OR EXCEPTION4...] THEN
            STATEMENT3;
            STATEMENT4;
            ...........
        WHEN EXCEPTION5 [OR EXCEPTION6...] THEN
            STATEMENT5;
            STATEMENT6;
            ...........
        [WHEN OTHERS THEN 
                   STATEMENT....;
                   .....
        ]
*/

DECLARE
    VENAME EMP.ENAME%TYPE;
BEGIN
    SELECT ENAME INTO VENAME
    FROM EMP
    WHERE ENAME LIKE 'M%';
    
    DBMS_OUTPUT.PUT_LINE('사원 이름은 ' || VENAME || ' 입니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' 없는 사원 이름입니다.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE(' 사원이 두 명 이상이어서 명시적 커서를 사용해야 합니다.');
END;
/

------------------------------------------------------------------------------------------------------------------------

-- 사용자가 예외를 직접 지정하는 방법 --

/*
    PRAGMA EXCEPTION_INIT 함수를 사용함
    ㄴ > COMPILER 에게 예외 이름을 ORACLE 오류번호와 연관시키도록 지시함
           모든 예외를 이름으로 참조하고 이 예외에 대한 특정 처리기를 작성할 수 있음
           PRAGMA(의사 명령어)는 명령문이 COMPILER 지시어임을 의미하는 키워드
           PL/SQL 블록 실행시 처리되지 않음
           블록 내의 모든 예외 이름을 연관된 ORACLE 서버 오류번호로 해석하도록 
           PL/SQL COMPILER에 지시하는 역할을 함
*/

CREATE TABLE T_PRAGMA(
    NO      NUMBER PRIMARY KEY,
    NAME  VARCHAR2(10)    
);

INSERT INTO T_PRAGMA VALUES(1, 'JOHN');
INSERT INTO T_PRAGMA VALUES(2, 'JERRY');

COMMIT;

DECLARE
    NEW_MESSAGE EXCEPTION;
    PRAGMA EXCEPTION_INIT(NEW_MESSAGE, -1);
BEGIN
    INSERT INTO T_PRAGMA VALUES(1, 'PAUL');
EXCEPTION
    WHEN NEW_MESSAGE THEN
        DBMS_OUTPUT.PUT_LINE('이미 존재하는 번호입니다');
END;
/
