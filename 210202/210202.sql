DESC EMP;
SELECT * FROM EMP;

SELECT EMPNO, ENAME, JOB, MGR FROM EMP;


-- CONNECT BY MGR = PRIOR EMPNO
  SELECT COUNT (*)
   FROM EMP
  START WITH ENAME = 'JONES'
CONNECT BY PRIOR EMPNO =  MGR
       AND JOB <> 'ANALYST';
       
----------------------------------------------------------      
SELECT EMPNO, ENAME, JOB, MGR
  FROM EMP
 START WITH ENAME = 'JONES'
CONNECT BY PRIOR EMPNO = MGR; 

WITH W1 (EMPNO, ENAME, MGR, LV) AS (
SELECT EMPNO, ENAME, MGR, 1 AS LV
  FROM EMP
 WHERE ENAME = 'JONES'
UNION ALL
SELECT C.EMPNO, C.ENAME, C.MGR, P.LV + 1 AS LV
  FROM W1 P, EMP C
 WHERE C.MGR = P.EMPNO)
SELECT EMPNO, ENAME, MGR, LV
  FROM W1;

/*
     EMPNO ENAME                       MGR         LV
---------- -------------------- ---------- ----------
      7566 JONES                      7839          1
      7902 FORD                       7566          2
      7369 SMITH                      7902          3
      7499 ALLEN                      7902          3
*/

---------------------------------------------------------- 

SELECT JOB, DEPTNO, SAL
FROM EMP;
/*
JOB                    DEPTNO        SAL
------------------ ---------- ----------
CLERK                      20        800
SALESMAN                   30       1700
SALESMAN                   30       1250
MANAGER                    20       2975
SALESMAN                   30       1250
MANAGER                    30       2850
MANAGER                    10       2450
PRESIDENT                  10       5000
SALESMAN                   30       1500
CLERK                      30        950
ANALYST                    20       3000
CLERK                      10       1300
*/

SELECT *
  FROM (SELECT JOB, DEPTNO, SAL FROM EMP WHERE DEPTNO IN (10, 20))
 PIVOT (SUM (SAL) FOR DEPTNO IN (10, 20))
 ORDER BY JOB;

/*
JOB                        10         20
------------------ ---------- ----------
ANALYST                             3000
CLERK                    1300        800
MANAGER                  2450       2975
PRESIDENT                5000    
*/
SELECT DEPTNO, JOB, SAL
  FROM EMP
 WHERE DEPTNO IN (10, 20)
 ORDER BY DEPTNO;

---------------------------------------------------------- 

-- PIVOT 절에 열이름이 부여되는 방법

/*
                     10               10 AS D10
SUM(SAL)             10               D10     
SUM(SAL) AS SAL      10_SAL           D10_SAL
*/

--   PIVOT : ROW > COLUMN: PIVOT된 값이 들어갈 컬럼을 지정
--     FOR : PIVOT된 값을 설명할 값이 들어갈 컬럼을 지정
--      IN : PIVOT할 컬럼과 설명할 값의 LITERAL 값(실제 DATA)을 지정 

SELECT *
  FROM (SELECT JOB, DEPTNO, SAL FROM EMP)
 PIVOT (SUM (SAL) AS SAL FOR DEPTNO IN (10 AS D10))
 ORDER BY JOB;

/*
JOB                  [ D10_SAL]
------------------ ----------
ANALYST
CLERK                    1300
MANAGER                  2450
PRESIDENT                5000
SALESMAN            

*/

---------------------------------------------------------- 
DROP TABLE TEST1 PURGE;
CREATE TABLE TEST1(
  N1  NUMBER,
  N2  NUMBER(3),
  N3  NUMBER(5,2),
  N4  NUMBER(6,1),
  N11 NUMBER(6,-1),
  N5  NUMBER(6,-2),
  N6  NUMBER(4,5),
  N7  NUMBER(4,5),
  N8  NUMBER(4,5),
  N9  NUMBER(2,7),
  N10  NUMBER(2,7)
);
INSERT INTO TEST1 VALUES(123.89,123.89,123.89,123.89,123.89,123.89,0.01234,0.00012,0.000127,0.0000012,0.00000123);

ROLLBACK;

SELECT * FROM TEST1;

/*
        123.89
        123.89
        123.89
        123.89
        123.89
        123.89
        0.01234
        0.00012
        0.000127
        0.0000012
        0.00000123
        
        123.89
        124
        123.89
        123.9
        120
        100	
        0.01234	
        0.00012	
        0.00013	
        0.0000012	
        0.0000012

*/


CREATE TABLE TABLE1(
  JOB     VARCHAR2(10),
  D10_SAL NUMBER,
  D20_SAL NUMBER,
  D30_SAL NUMBER,
  D10_CNT NUMBER,
  D20_CNT NUMBER,
  D30_CNT NUMBER
);

INSERT INTO TABLE1 VALUES ('ANALYST'  , NULL, 6000, NULL, 0, 2, 0);
INSERT INTO TABLE1 VALUES ('CLERK'    , 1300, 1900,  950, 1, 2, 1);
INSERT INTO TABLE1 VALUES ('MANAGER'  , 2450, 2975, 2850, 1, 1, 1);
INSERT INTO TABLE1 VALUES ('PRESIDENT', 5000, NULL, NULL, 1, 0, 0);
INSERT INTO TABLE1 VALUES ('SALESMAN' , NULL, NULL, 5600, 0, 0, 4);
COMMIT;

SELECT * FROM TABLE1;

/*
        JOB        D10_SAL  D20_SAL  D30_SAL  D10_CNT  D20_CNT  D30_CNT
        ANALYST		        6000		        0	    2	    0
        CLERK	    1300	1900	 950	    1	    2	    1
        MANAGER	    2450	2975	 2850	    1	    1	    1
        PRESIDENT	5000			            1	    0	    0
        SALESMAN			         5600	    0	    0	    4
*/
 SELECT   JOB, DEPTNO, SAL
   FROM TABLE1
UNPIVOT (SAL FOR DEPTNO IN (D10_SAL, D20_SAL, D30_SAL))
  WHERE JOB = 'CLERK'
  ORDER BY JOB, DEPTNO;
-- UNPIVOT : COLUMN > ROW : UNPIVOT된 값이 들어갈 컬럼을 지정
--     FOR : UNPIVOT된 값을 설명할 값이 들어갈 컬럼을 지정
--      IN : UNPIVOT할 컬럼과 설명할 값의 LITERAL 값(실제 DATA)을 지정  
/*
        JOB                  DEPTNO                SAL
        -------------------- -------------- ----------
        CLERK                D10_SAL              1300
        CLERK                                     1900
        CLERK                D30_SAL               950
*/
  


---------------------------------------------------------- 

CREATE TABLE TABLE1(
  JOB     VARCHAR2(10),
  D10_SAL NUMBER,
  D20_SAL NUMBER,
  D30_SAL NUMBER,
  D10_CNT NUMBER,
  D20_CNT NUMBER,
  D30_CNT NUMBER
);

INSERT INTO TABLE1 VALUES ('ANALYST'  , NULL, 6000, NULL, 0, 2, 0);
INSERT INTO TABLE1 VALUES ('CLERK'    , 1300, 1900,  950, 1, 2, 1);
INSERT INTO TABLE1 VALUES ('MANAGER'  , 2450, 2975, 2850, 1, 1, 1);
INSERT INTO TABLE1 VALUES ('PRESIDENT', 5000, NULL, NULL, 1, 0, 0);
INSERT INTO TABLE1 VALUES ('SALESMAN' , NULL, NULL, 5600, 0, 0, 4);
COMMIT;

SELECT * FROM TABLE1;

/*
        JOB        D10_SAL  D20_SAL  D30_SAL  D10_CNT  D20_CNT  D30_CNT
        ANALYST		        6000		        0	    2	    0
        CLERK	    1300	1900	 950	    1	    2	    1
        MANAGER	    2450	2975	 2850	    1	    1	    1
        PRESIDENT	5000			            1	    0	    0
        SALESMAN			         5600	    0	    0	    4
*/

 SELECT JOB, DEPTNO, SAL
   FROM TABLE1
UNPIVOT (SAL FOR DEPTNO IN (D10_SAL, D20_SAL, D30_SAL))
  WHERE JOB = 'CLERK'
  ORDER BY JOB, DEPTNO;

/*
        JOB                  DEPTNO                SAL
        -------------------- -------------- ----------
        CLERK                D10_SAL              1300
        CLERK                D20_SAL              
        CLERK                D30_SAL               950
*/


---------------------------------------------------------- 
-- REGULAR EXPRESSION : 정규식
-- REGEXP_SUBSTR 함수

-- REGEXP_SUBSTR(SOURCE_CHAR, PATTERN[, POSITION[, OCCURANCE[, MATCH_PARAM[, SUBEXPR]]]])
-- SOURCE_CHAR : 검색할 문자열
-- PATTERN     : 검색 패턴
-- POSITION    : 검색시작위치(DEFAULT 1)
-- OCCURANCE   : 패턴일치횟수(DEFAULT 1)
-- MATCH_PARAM : 일치옵션
-- SUBEXPR     : 서브 표현식(0(DEFAULT) 은 전체 패턴, 1 이상은 서브 표현식)

SELECT REGEXP_SUBSTR ('ABC', 'A.+' ) AS C1
     , REGEXP_SUBSTR ('ABC', 'A.+?') AS C2
  FROM DUAL;

-- .(마침표) : 모든 문자
-- +(더하기) : 1회 또는 그 이상의 횟수로 일치함을 의미함

-- C1 열 : REGEXP_SUBSTR ('ABC', 'A.+' ) : .+ - 최대일치 : ABC
-- C2 열 : REGEXP_SUBSTR ('ABC', 'A.+?') : .? - 최소일치 : AB 

/*
        C1     C2
        ------ ----
        ABC    AB
*/


select deptno, job, sal
from emp
where deptno in (10, 20)
order by deptno;

---------------------------------------------------------------------------------------------------------------

/*
    PICOT 절에 열 이름이 부여되는 방법
    
    SUM(SAL)              10           D10
    SUM(SAL) AS SAL   10_SAL     D10_SAL
    
*/

/*
        JOB               D10_SAL

        ANALYST	
        CLERK	        1300
        MANAGER	    2450
        PRESIDENT	    5000
        SALESMAN	
*/

select * 
from (select job, deptno, sal from emp)
pivot (sum (sal) as sal for deptno in (10 as d10) )
order by job; 

---------------------------------------------------------------------------------------------------------------

/*
    NUMBER(정수자릿수, 소수점이하자릿수)
    
    EX) NUMBER(5,  2) -> 00000.00
*/

CREATE TABLE TEST1(
    N1 NUMBER,
    N2 NUMBER(3),
    N3 NUMBER(5, 2),
    N4 NUMBER(6, 1),
    N5 NUMBER(6, -2),
    N6 NUMBER(4, 5),
    N7 NUMBER(4, 5),
    N8 NUMBER(4, 5),
    N9 NUMBER(2, 7),
    N10 NUMBER(2, 7)
);

INSERT INTO TEST1 VALUES(123.89, 123.89, 123.89, 123.89, 123.89, 0.01234, 0.00012, 0.000127, 0.00000012, 0.00000123);



CREATE TABLE TABLE1(
    JOB            VARCHAR2(10),
    D10_SAL      NUMBER,
    D20_SAL      NUMBER,
    D30_SAL      NUMBER,
    D10_CNT      NUMBER,
    D20_CNT      NUMBER,
    D30_CNT      NUMBER
);

---------------------------------------------------------------------------------------------------------------
/*

    REGULAR EXPRESSION : 정규식

    REGEXP_SUBSTR 함수

    REGEXP_SUBSTR(SOURCE_CHAR, PATTERN[, POSITION[, OCCURANCE[, MATCH_PARAM[, SUBEXPR]]]])

    SOURCE_CHAR : 검색할 문자열
    PATTERN : 검색 패턴
    POSITION : 검색시작위치(DEFAULT 1)
    OCCURANCE : 패턴일치횟수(DEFAULT 1)
    MATCH_PARAM : 일치 옵션
    SUBEXPR : 서브 표현식(DEFAULT 0 -> 전체 패턴, 1 이상은 서브 표현식) 
  
    . (마침표) : 모든 문자
    +(더하기) : 1회 또는 그 이상의 횟수로 일치함을 의미
    
    EX) REGEXP_SUBSTR ('ABC', 'A.+')  : .? -  최소일치 : AB
         REGEXP_SUBSTR ('ABC', 'A.+?') : .+ - 최대일치 : ABC
*/

SELECT REGEXP_SUBSTR ('ABC', 'A.+') AS C1 , REGEXP_SUBSTR ('ABC', 'A.+?') AS C2
FROM DUAL;

---------------------------------------------------------------------------------------------------------------

/*
    AB | CD : AB 또는 CD 가 일치
    A(B|C)D : A 로 시작하고 D 로 끝나면서 가운데에 B 또는 C가 들어가면 일치
*/

SELECT REGEXP_SUBSTR ('ABC', 'AB|CD') AS C1,
           REGEXP_SUBSTR ('ACD', 'A(B|C)D') AS C2
FROM DUAL;

SELECT REGEXP_SUBSTR ('HTTP://WWW.ABC.COM/EFG', '([^:/]+)', 1, 2) AS C1
FROM DUAL;

/*
    CHARACTER LIST : 문자 리스트
        
    -> 문자를 대괄호로 묶은 표현. 문자 리스트 중 한 문자만 일치하면 패턴이 일치한 것으로 처리
        문자 리스트에서 (-) 하이픈 연산자는 범위 연산자로 실행
        
        [CHAR ... ] : 문자 리스트 중 한 문자와 일치
        [^CHAR ... ] : 문자 리스트에 포함되지 않은 한 문자와 일치
*/

---------------------------------------------------------------------------------------------------------------

CREATE TABLE TB45( C1 NUMBER );
CREATE TABLE TB46( C1 NUMBER );

INSERT INTO TB45 VALUES(1);
INSERT INTO TB45 VALUES(2);
INSERT INTO TB45 VALUES(3);

INSERT INTO TB46 VALUES(1);
INSERT INTO TB46 VALUES(NULL);

COMMIT;

SELECT COUNT(*) AS CNT
FROM TB45
WHERE C1 NOT IN (SELECT C1 FROM TB46);

-->
SELECT COUNT(*) AS CNT
FROM TB45
WHERE NOT (C1 = 1 AND C1 = NULL);
-->
SELECT COUNT(*) AS CNT
FROM TB45
WHERE C1 <> 1 AND C1 <> NULL;
-->
SELECT COUNT(*) AS CNT
FROM TB45
WHERE C1 <> 1 AND NULL;
--=>
SELECT COUNT(*) AS CNT
FROM TB45
WHERE C1 = NULL;

---------------------------------------------------------------------------------------------------------------

CREATE TABLE TB47 (M1 VARCHAR2(1), M2 NUMBER);
CREATE TABLE TB48 (M1 VARCHAR2(1), M2 NUMBER);

-- 다음 세 쿼리는 오류 발생

-- 오류 : UNION 사용시 컬럼 수가 일치해야 함
SELECT M1, M2 FROM TB47 
UNION ALL
SELECT M1 FROM TB48;

-- 오류 : UNION 사용시 컬럼 타입이 일치해야 함
SELECT M1, M2 FROM TB47 
UNION ALL
SELECT M2, M1 FROM TB48;

-- 오류: ORDER BY 는 한쪽에만 사용해야 함
SELECT M1, M2 FROM TB47 ORDER BY M1
UNION ALL
SELECT M1, M2 FROM TB48 ORDER BY M1;

-- 다음은 오류가 발생하지 않는다 

(SELECT M1, M2 FROM TB47) 
UNION ALL
(SELECT M1, M2 FROM TB48);

----------------------------------------------------------------------------------------------------------------

/*
    <> == !=
*/

CREATE TABLE TB49 (M1 NUMBER NOT NULL, M2 NUMBER);

INSERT INTO TB49 VALUES (1, 1);
INSERT INTO TB49 VALUES (1, 2);
INSERT INTO TB49 VALUES (2, 1);
INSERT INTO TB49 VALUES (2, 1);

COMMIT;

SELECT * FROM TB49 WHERE (M1 = 1 OR M2 = 1);

SELECT * FROM TB49 WHERE M1 =1
UNION ALL
SELECT * FROM TB49 WHERE M2 = 1 AND M1 <> 1;

SELECT * FROM TB49 WHERE M1 =1
UNION
SELECT * FROM TB49 WHERE M2 = 1 AND M1 <> 1;

----------------------------------------------------------------------------------------------------------------

DROP TABLE TB50 PURGE;

CREATE TABLE TB50 (M1 VARCHAR2(1), M2 DATE, M3 NUMBER);

INSERT INTO TB50 VALUES ('A', DATE '2050-01-01', 1);
INSERT INTO TB50 VALUES ('A', DATE '2050-01-02', 1);
INSERT INTO TB50 VALUES ('B', DATE '2050-01-01', 1);
INSERT INTO TB50 VALUES ('B', DATE '2050-01-02', 1);
INSERT INTO TB50 VALUES ('C', DATE '2050-01-01', 1);
INSERT INTO TB50 VALUES ('C', DATE '2050-01-02', 1);

COMMIT;

SELECT * FROM TB50;

SELECT M1, M2, SUM(M3) AS M3
FROM TB50
GROUP BY M1, ROLLUP((M1, M2));

/*
    GROUPING (EXPRESSION)
    
    GROUPING (컬럼) : 컬럼에 값이 있으면 0 , 없으면 1 반환
*/

SELECT M1, M2, SUM(M3) AS M3, GROUPING(M2) AS GP
FROM TB50
GROUP BY ROLLUP (M1, M2);

----------------------------------------------------------------------------------------------------------------

/*
    FIRST_VALUE 함수 : 각 컬럼의 첫번째 행 반환
    IGNORE NULLS 를 사용할 경우 NULL 을 제외한 각 컬럼의 첫 행 반환
*/

SELECT EMPNO, ENAME, SAL, COMM,
                    FIRST_VALUE (COMM) OVER (ORDER BY SAL) AS M1,
                    FIRST_VALUE (COMM IGNORE NULLS) OVER (ORDER BY SAL) AS M2
FROM EMP
WHERE DEPTNO = 30;

SELECT ENAME, JOB, SAL, FIRST_VALUE(SAL) OVER() AS SAL_FIRST
                                   , LAST_VALUE(SAL) OVER() AS SAL_LAST
FROM EMP
WHERE JOB IN ('MANAGER', 'ANALYST');

SELECT ENAME, HIREDATE, JOB, SAL, FIRST_VALUE(SAL) OVER() AS SAL_FIRST
FROM EMP
WHERE JOB IN ('MANAGER', 'ANALYST');

SELECT ENAME, HIREDATE, JOB, SAL, FIRST_VALUE(SAL) OVER(PARTITION BY JOB ORDER BY HIREDATE) AS SAL_FIRST
FROM EMP
WHERE JOB IN ('MANAGER', 'ANALYST');

SELECT ENAME, JOB, COMM, FIRST_VALUE(COMM IGNORE NULLS) OVER() AS COMM_FIRST
FROM EMP
WHERE JOB IN ('MANAGER', 'ANALYST');

----------------------------------------------------------------------------------------------------------------

/*
   LAG 함수 : 현재 행에서 OFFSET 이전 행의 컬럼 값을 반환
   
   OFFSET :  기준, 기본값은 1
   이전 행이 없는 경우 반환할 값을 DEFAULT 로 지정
   
   LAG(VALUE[, OFFSET[, DEFAULT]])  [IGNORE NULLS]
   OVER ([QUERY_PARTITION_CLUASE] ORDER_BY_CLAUSE)
   
   VALUE_EXPR : 대상 컬럼 이름
   OFFSET : 값을 가져올 행의 위치 기본값 1, 생략 가능
   DEFAULT : 이전 행이 없는 경우 값이 없을 경우 지정
   PARTITION_BY_CLAUSE : 그룹 컬럼 (생략 가능)
   ORDER_BY_CLAUSE : 정렬 기준 컬럼 (필수)
   
   
   LEAD 함수 : 현재 행에서 OFFSET 다음 행의 컬럼 값을 반환
   
   
*/

SELECT EMPNO, ENAME, JOB, SAL
                    , LAG(EMPNO) OVER (ORDER BY EMPNO) AS EMPNO_PREV
                    , LEAD(EMPNO) OVER (ORDER BY EMPNO) AS EMPNO_NEXT
FROM EMP
WHERE JOB IN ('MANAGER', 'ANALYST', 'SALESMAN');

SELECT EMPNO, ENAME, SAL
                    , LAG(SAL, 2, 0) OVER (ORDER BY SAL) AS M1
FROM EMP
WHERE DEPTNO = 20;

----------------------------------------------------------------------------------------------------------------

/*
    PIVOT -> ROW 를 COLUMN 으로 바꿔서 표현
    
    PIVOT pivot FOR column IN (values..)
    
    일단 values 에 따른 컬럼이 생김
    column의 값이 values 일때 pivot 값으로 들어감
*/

SELECT JOB, HIREDATE, DEPTNO, SAL 
FROM EMP;

SELECT *
FROM (SELECT JOB, TO_CHAR(HIREDATE, 'YYYY') AS YYYY, DEPTNO, SAL
           FROM EMP
           WHERE DEPTNO IN (10, 30) )
PIVOT (SUM (SAL) FOR DEPTNO IN (10, 30))
ORDER BY JOB, YYYY;

SELECT  JOB, TO_CHAR(HIREDATE, 'YYYY') AS YYYY, DEPTNO, SAL 
FROM EMP 
WHERE DEPTNO IN (10, 30)
ORDER BY JOB, YYYY;

----------------------------------------------------------------------------------------------------------------

/*
    PIVOT -> COLUMN 을 ROW 로 바꿔서 표현
    
    PIVOT pivot FOR column IN (values..)
    
    일단 values 에 따른 컬럼이 생김
    column의 값이 values 일때 pivot 값으로 들어감
*/

DROP TABLE TB51 PURGE;

CREATE TABLE TB51 (
    JOB     VARCHAR2(10)
  , D10_SAL NUMBER, D20_SAL NUMBER, D30_SAL NUMBER
  , D10_CNT NUMBER, D20_CNT NUMBER, D30_CNT NUMBER);

INSERT INTO TB51 VALUES ('ANALYST'  , NULL, 6000, NULL, 0, 2, 0);
INSERT INTO TB51 VALUES ('CLERK'    , 1300, 1900,  950, 1, 2, 1);
INSERT INTO TB51 VALUES ('MANAGER'  , 2450, 2975, 2850, 1, 1, 1);
INSERT INTO TB51 VALUES ('PRESIDENT', 5000, NULL, NULL, 1, 0, 0);
INSERT INTO TB51 VALUES ('SALESMAN' , NULL, NULL, 5600, 0, 0, 4);

COMMIT;

SELECT COUNT (*) AS CNT
FROM TB51
UNPIVOT INCLUDE NULLS (SAL FOR DEPTNO IN (D10_SAL AS 10, D20_SAL AS 20, D30_SAL AS 30))
WHERE JOB = 'ANALYST';

SELECT DEPTNO, SAL
FROM TB51
UNPIVOT INCLUDE NULLS (SAL FOR DEPTNO IN (D10_SAL AS 10, D20_SAL AS 20, D30_SAL AS 30))
WHERE JOB = 'ANALYST';

----------------------------------------------------------------------------------------------------------------

DROP TABLE TB52 PURGE;

CREATE TABLE TB52 (M1 NUMBER, M2 NUMBER, M3 NUMBER DEFAULT 3);

INSERT INTO TB52(M2) VALUES (1);

COMMIT;

SELECT * FROM TB52;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB53 (M1 NUMBER, M2 NUMBER, M3 NUMBER);
CREATE TABLE TB54 (M1 NUMBER, M2 NUMBER, M3 NUMBER);

INSERT INTO TB53 VALUES (1,1,1);
INSERT INTO TB54 VALUES (2,3,4);

COMMIT;

UPDATE TB53 A
SET (A.M2, A.M3) = (SELECT B.M2, B.M3 FROM TB54 B WHERE B.M1 = A.M1);

-- 위의 커리문은 널값이 들어갈 수 있기 때문에 아래와 같이 하는 것이 안전

UPDATE TB53 A
SET (A.M2, A.M3) = (SELECT B.M2, B.M3 FROM TB54 B WHERE B.M1 = A.M1)
WHERE EXISTS (SELECT 1 FROM TB54 X WHERE X.M1 = A.M1);

SELECT * FROM TB53;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB55 (M1 NUMBER, M2 NUMBER);
CREATE TABLE TB56 (M1 NUMBER, M2 NUMBER);

INSERT INTO TB55 VALUES (1, 1);
INSERT INTO TB55 VALUES (2, 1);
INSERT INTO TB55 VALUES (3, 1);
INSERT INTO TB56 VALUES (1, 1);
INSERT INTO TB56 VALUES (2, NULL);

COMMIT;

SELECT * FROM TB55;
SELECT * FROM TB56;

/*
    WHERE 조건 절에서 NOT IN 을 사용하면 일치하는 데이터가 하나도 없는지를 확인하게 됨
    NOT IN 연산자 안에서 사용하는 컬럼에 NULL 이 있으면 MAIN 쿼리와 일치하는 데이터가 
    하나도 없는지 참, 거짓을 확인할 수 없다
    -> WHERE 조건절에서 참, 거짓을 확인할 수 없으므로 TB55 테이블의 ROW(RECODE)는 하나도 삭제되지 않음
*/

DELETE FROM TB55 WHERE M1 NOT IN (SELECT M2 FROM TB56);

MERGE
INTO TB55 T
USING TB56 S
ON (T.M1 = S.M1)
WHEN MATCHED THEN UPDATE SET T.M2 = S.M2, T.M3 = S.M3;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB57(
    M1 NUMBER
);

INSERT INTO TB57 VALUES(1);
INSERT INTO TB57 VALUES(2);

ALTER TABLE TB57 ADD M2 NUMBER; -- TB57 테이블 생성 후 컬럼 추가

INSERT INTO TB57 VALUES(3, 5);

/*
    ROLLBACK 은 DML 에서 사용.
    DDL 사용시 자동 COMMIT
*/

ROLLBACK;

SELECT * FROM TB57;

----------------------------------------------------------------------------------------------------------------

/*
    테이블 이름 맨 앞에 숫자는 불가능
    특수문자는 #, $, _ 만 사용 가능
*/


CREATE TABLE B2(
    M1 NUMBER(2)
);

INSERT INTO B2 VALUES(1);
COMMIT;

SELECT * FROM B2;

/*
    테이블 변경시 데이터 타입은 늘리는 것만 가능
*/
ALTER TABLE B2 MODIFY M1 NUMBER(3);

CREATE TABLE B3 (M1 NUMBER, CONSTRAINT B3_PK PRIMARY KEY (M1));
CREATE TABLE B4 (M1 NUMBER, CONSTRAINT B3_FK FOREIGN KEY (M1) REFERENCES B3 (M1));

ALTER TABLE B3 RENAME COLUMN M1 TO M2;
ALTER TABLE B4 RENAME COLUMN M1 TO M2;

/*
    다른 테이블이 참조하고 있는 테이블은 삭제시 오류 발생
*/

DROP TABLE B3;
DROP TABLE B4;

CREATE TABLE B5 (M1 NUMBER);
CREATE TABLE B6 (M1 NUMBER);

ALTER TABLE B5 ADD CONSTRAINT B5_PK PRIMARY KEY (M1);
ALTER TABLE B6 ADD CONSTRAINT B6_U1 UNIQUE (M1);

INSERT INTO B5 VALUES (1);
INSERT INTO B5 VALUES (1);          --> UNIQUE 제약조건 위반
INSERT INTO B5 VALUES (NULL);    --> NOT NULL 제약조건 위반
INSERT INTO B5 VALUES (NULL);

INSERT INTO B6 VALUES (1);
INSERT INTO B6 VALUES (1);          --> UNIQUE 제약조건 위반
INSERT INTO B6 VALUES (NULL);    --> ORACLE 에서는 UNIQUE 제약조건에서 NULL을 INSERT 할 수 있고 NULL 값은 중복되어 삽입 가능
INSERT INTO B6 VALUES (NULL);

COMMIT;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE B7 (M1 NUMBER, M2 NUMBER, CONSTRAINT B7_PK PRIMARY KEY (M1));
CREATE TABLE B8 (M1 NUMBER, M2 NUMBER, CONSTRAINT B8_PK PRIMARY KEY (M1));

INSERT INTO B7 VALUES (1, 1);
INSERT INTO B8 VALUES (1, 1);
INSERT INTO B8 VALUES (2, 1);
INSERT INTO B8 VALUES (3, 1);
INSERT INTO B8 VALUES (4, 1);

COMMIT;

INSERT INTO B7
SELECT A.M1, A.M2
FROM B8 A
WHERE NOT EXISTS (SELECT 1 FROM B7 X WHERE X.M1 = A.M1);

SELECT * FROM B7;

----------------------------------------------------------------------------------------------------------------

DROP TABLE B9 PURGE;
DROP TABLE B10 PURGE;

CREATE TABLE B9 (M1 NUMBER(1));
CREATE TABLE B10 (M1 NUMBER);

INSERT INTO B10 VALUES ( 8);
INSERT INTO B10 VALUES ( 9);
INSERT INTO B10 VALUES (10);

COMMIT;

INSERT INTO B9 VALUES(7);

-- 다음 문장은 오류 발생 : 데이터의 타입 범위가 맞지 않는다.
INSERT INTO B9 SELECT * FROM B10;

DELETE FROM B9 WHERE M1 = 9;

SELECT MAX(M1) AS M1
FROM B9;

----------------------------------------------------------------------------------------------------------------

DROP TABLE B13 PURGE;
CREATE TABLE B13 (M1 CHAR(2), M2 VARCHAR2(2));

INSERT INTO B13 VALUES ('A' , 'A' );
INSERT INTO B13 VALUES ('B' , 'B ');
INSERT INTO B13 VALUES ('C ', 'C' );
INSERT INTO B13 VALUES ('D ', 'D ');

COMMIT;

SELECT * FROM B13;

SELECT * FROM B13 WHERE M1 = M2;