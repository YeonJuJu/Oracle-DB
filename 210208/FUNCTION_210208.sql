/*
    -- FUNCTION --
    
    -- 내장 함수와 프로시저는 문법이나 특징이 거의 비슷함
    -- 함수 : 정해진 작업을 수행한 수 결과를 리턴
    -- 프로시저 : 정해진 작업을 수행한 후 결과를 리턴할 수도 있고, 반환하지 않고 그냥 종료할 수도 있음
    
    -- 생성 : CREATE FUNCTION
    -- 수정 : ALTER FUNCTION
    -- 삭제 : DROP FUNCTION
    
    에러가 발생한 경우, SHOW ERROR 명령으로 확인할 수 있음
    
    함수 이름은 같은 계정 안에서 유일해야 함
    파라미터 부분은 프로시저와 같다
    모드도 같다
    
    MODE
    1) IN : 사용자로부터 값을 입력받아 프로시저로 전달해 주는 역할을 하는 모드
             기본값, 생략 가능
    2) OUT : 호출환경 (SQL PLUS 등) 으로 값을 전달하는 역할을 하는 모드
                OUT 모드로 설정된 파라미터는 값을 지정하기만 하는 지역변수처럼 사용됨
    3) IN OUT : 설정된 파라미터는 호출환경과 프로시저 간에 값을 주고받는 지역변수로 사용됨
                    읽기, 쓰기가 모두 가능함
    
    RETURN TYPE
    -> RETURN 하는 DATA의 TYPE을 명시하는 부분
    
    함수를 사용할 수 있는 부분
    -> SELECT 절
    -> START WITH, CONNECT BY
    -> ORDER BY, GROUP BY
    -> INSERT 문의 VALUES 절
    -> UPDATE 문의 SET 절
*/

CREATE OR REPLACE FUNCTION MAX_SAL(FDEPTNO EMP.DEPTNO%TYPE)
    RETURN NUMBER
IS
    MAX_SAL EMP.SAL%TYPE;
BEGIN
     SELECT MAX(SAL) INTO MAX_SAL
     FROM EMP
     WHERE DEPTNO = FDEPTNO;
     RETURN MAX_SAL;
END;
/

SELECT MAX_SAL(20) FROM DUAL;

CREATE OR REPLACE FUNCTION UPDATE_SAL(VEMPNO IN NUMBER)
    RETURN NUMBER
IS
    VSAL EMP.SAL%TYPE;
BEGIN
    UPDATE EMP
    SET SAL = SAL * 1.1
    WHERE EMPNO = VEMPNO;
    
    COMMIT;
    
    SELECT SAL INTO VSAL
    FROM EMP
    WHERE EMPNO = VEMPNO;
    
    RETURN VSAL;
END;
/

VAR SALARY NUMBER; 
EXECUTE : SALARY := UPDATE_SAL(7900);

SELECT EMPNO, SAL
FROM EMP
WHERE EMPNO = 7900;
