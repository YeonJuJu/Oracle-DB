/*
    PROCEDURE (프로시저)
    
    -> 프로시저는 지정된 특정 처리를 실행하는 서브 프로그램의 한 유형
        단독으로 실행되거나 다른 프로시저나 다른 둘, 다른 환경 등에서 호출되어 실행됨
        
    생성 : CREATE [OR REPLACE] PROCEDURE
    수정 : ALTER PROCEDURE
    삭제 : DROP PROCEDURE
    OR REPLACE : 이미 같은 프로시저가 있는 경우, 기존의 내용을 수정함
                        프로시저 이름은 한 계정 (SCHEMA) 안에서 유일해야 함
*/

/*
    PARAMETER 
    -> 선언하는 경우, DATA TYPE 은 기술하고 크기는 기술하지 않음
    
    형식 파라미터 ( FORMAL PARAMETER )
    -> 선언부에 선언된 파라미터
    
    실행 파라미터 ( ACTUAL PARAMETER )
    -> 실행시에 값이 할당되는 파라미터
    
    파라미터를 선언할 때, DEFAULT 키워드를 사용해서 기본값을 지정할 수 있음
    
    MODE
    1) IN : 사용자로부터 값을 입력받아 프로시저로 전달해 주는 역할을 하는 모드
             기본값, 생략 가능
    2) OUT : 호출환경 (SQL PLUS 등) 으로 값을 전달하는 역할을 하는 모드
                OUT 모드로 설정된 파라미터는 값을 지정하기만 하는 지역변수처럼 사용됨
    3) IN OUT : 설정된 파라미터는 호출환경과 프로시저 간에 값을 주고받는 지역변수로 사용됨
                    읽기, 쓰기가 모두 가능함
*/

SELECT EMPNO, SAL
FROM EMP
WHERE EMPNO = 7369; 

CREATE OR REPLACE PROCEDURE UP_SAL
    (VEMPNO EMP.EMPNO%TYPE)
IS
BEGIN
    UPDATE EMP 
    SET SAL = 1000
    WHERE EMPNO = 7369;
END;
/

EXEC UP_SAL(7369);

--USER_RESOURCE 시스템 테이블
-- PROCEDURE 들의 정보 보관

DESC USER_SOURCE;

SELECT TEXT FROM USER_SOURCE;
