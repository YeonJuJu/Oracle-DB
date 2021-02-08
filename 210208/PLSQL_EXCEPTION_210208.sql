-- RAISE 를 이용한 예외 처리 --

SET SERVEROUTPUT ON;

CREATE TABLE EMP3
AS SELECT EMPNO, ENAME 
     FROM EMP;
     
DESC EMP3;

DECLARE
    NO_EMPNO EXCEPTION;
BEGIN
    DELETE FROM EMP3
    WHERE EMPNO = &NO;
    
    IF SQL %NOTFOUND THEN
        RAISE NO_EMPNO;
    END IF;
EXCEPTION 
    WHEN NO_EMPNO THEN
        DBMS_OUTPUT.PUT_LINE('입력하신 번호는 없는 사원번호입니다.');
END;
/

/*
    -- RAISE_APPLICATION_ERROR 프로시저 사용하기

    -- 사용자가 예외를 정의하고 예외처리부 없이 실행부에서 즉시 예외를 처리하는 방법
    -- 사용자가 지정 가능한 예외(에러) 번호 범위 : 20000 ~ 20999
*/

BEGIN
    DELETE FROM EMP3
    WHERE EMPNO = &NO;
    
    IF SQL %NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20100, '입력하신 번호는 없는 사원번호입니다');
    END IF;
END;
/

DECLARE 
    p_num NUMBER;
BEGIN
    p_num := &NUM;
    
    IF p_num <= 0 THEN
        RAISE INVALID_NUMBER;
    END IF;

    DBMS_OUTPUT.PUT_LINE(p_num);
    
EXCEPTION
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE 
    p_num NUMBER;
BEGIN
    p_num := &NUM;
    
    IF p_num <= 0 THEN
        RAISE_APPLICATION_ERROR(-20000, '양수만 입력받을 수 있습니다.');
    END IF;

    DBMS_OUTPUT.PUT_LINE(p_num);
    
EXCEPTION
    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다.');
    WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE(SQLCODE);
         DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
