/* ======================================
    DISTINCT 는 SELECT 하는 전체 행의 중복을 제거하여 출력
====================================== */

DROP TABLE TB14 PURGE;

CREATE TABLE TB14(
    M1 VARCHAR2(1),
    M2 VARCHAR2(1)
);

INSERT INTO TB14 VALUES('A', 'B');
INSERT INTO TB14 VALUES('A', 'D');
INSERT INTO TB14 VALUES('B', 'D');
INSERT INTO TB14 VALUES('B', 'D');
INSERT INTO TB14 VALUES('B', 'E');

COMMIT;

SELECT DISTINCT M1 FROM TB14;           --> A, B 

SELECT M2 FROM TB14;                          --> B, D, D, D, E

SELECT DISTINCT M1, M2 FROM TB14;     --> (A,B) (A,D) (B,D) (B,E) 

-------------------------------------------------------------------------------------------------------------------------------

/* ==================================================================
    CONCATE(STR1, STR2) : STR1STR2
    
    SUBSTR(STR, start, num) : STR의 start번째 문자부터 num 개 리턴
    
    || : + 같은 의미
    
    UPPER(STR) : 모두 대문자로 변경
    
    REPLACE(STR, 변경할str, 변경하고싶은str) : STR에서 변경할 str 찾아 변경하고싶은 str 으로 바꿈.
                                                              만약 변경하고싶은 str이 비어있을 경우 그냥 삭제
================================================================== */

-- 'ORacle'

SELECT CONCAT('OR', 'acle') AS RESULT FROM DUAL;                -->ORacle

SELECT SUBSTR('ORacle Corp.', 1, 6) AS RESULT FROM DUAL;      -->ORacle

SELECT 'OR' || UPPER('aCLe') AS RESULT FROM DUAL;                -->ORACLE

SELECT REPLACE('ORacle Corp.', 'Corp.') AS RESULT FROM DUAL;  -->ORacle

-------------------------------------------------------------------------------------------------------------------------------

/* ==================================================================
    EXTRACT(want FROM COLUMN) : 빼내는 함수
================================================================== */

DROP TABLE TB15 PURGE;

CREATE TABLE TB15(
    M1 DATE
);

INSERT INTO TB15 VALUES(TO_DATE('2020-06-30', 'YYYY-MM-DD HH24:MI:SS'));

SELECT EXTRACT (YEAR FROM M1) || '-' || TO_CHAR (M1, 'MM') AS R1 
FROM TB15;  --> 2020-06

SELECT TO_CHAR(M1, 'YYYY') || '-' || TO_CHAR(M1, 'MM') AS R1 
FROM TB15;  --> 2020-06

SELECT SUBSTR (TO_CHAR (M1, 'YYYY-MM-DD'), 1, 7) AS R1 
FROM TB15;  --> 2020-06

SELECT EXTRACT (YEAR FROM M1) || '-' || EXTRACT (MONTH FROM M1) AS R1 
FROM TB15;  --> 2020-6

-------------------------------------------------------------------------------------------------------------------------------

/* ==================================================================
    LIKE

    _ : 한 개 이상
    %: 없거나 한 개 이상
================================================================== */

CREATE TABLE B16 (M1 VARCHAR2(10));

INSERT INTO B16 (M1) VALUES ('ABCD');
INSERT INTO B16 (M1) VALUES ('A_C%');
INSERT INTO B16 (M1) VALUES ('ABC');
INSERT INTO B16 (M1) VALUES ('ABBCD');

COMMIT;

SELECT SUM (LENGTH (M1) ) AS R1 FROM B16 WHERE M1 LIKE 'A_C%' ;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B17 (M1 NUMBER(2, 1));

INSERT INTO B17 (M1) VALUES (3.5);
INSERT INTO B17 (M1) VALUES (4.0);
INSERT INTO B17 (M1) VALUES (5.5);
INSERT INTO B17 (M1) VALUES (6.0);

COMMIT;

SELECT SUM(ROUND (M1)) AS R1 FROM B17;          --> 20

SELECT ROUND (SUM (M1)) AS R1 FROM B17;         --> 19

SELECT SUM(CEIL (M1)) AS R1 FROM B17;               --> 20

SELECT ROUND (SUM (M1), -1 ) AS R1 FROM B17;   --> 20

-------------------------------------------------------------------------------------------------------------------------------

SELECT JOB, COUNT(*) AS CNT
FROM EMP
GROUP BY JOB;

SELECT DEPTNO, SUM(SAL) AS SAL
FROM EMP
GROUP BY DEPTNO, JOB;

SELECT TO_CHAR(HIREDATE, 'YYYY') AS HIREYEAR, COUNT(*) AS CNT
FROM EMP
GROUP BY HIREDATE;

-- 다음 쿼리문은 에러가 발생한다.
SELECT HIREDATE, SUM(SAL) AS SAL
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY-MM-DD');

-- 다음과 같이 고치면 에러가 발생하지 않는다.
SELECT TO_CHAR(HIREDATE, 'YYYY-MM-DD') AS HIREDATE, SUM(SAL) AS SAL
FROM EMP
GROUP BY HIREDATE;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B18 (M1 NUMBER, M2 VARCHAR2(4));

INSERT INTO B18 (M1, M2) VALUES (1, 'ZA');
INSERT INTO B18 (M1, M2) VALUES (2, 'BZZ');
INSERT INTO B18 (M1, M2) VALUES (3, 'CZZ');
INSERT INTO B18 (M1, M2) VALUES (4, 'DZZZ');
INSERT INTO B18 (M1, M2) VALUES (5, 'ZZZE');

COMMIT;

/*
    5	ZZZE
    2	BZZ
    1	ZA
    3	CZZ
    4	DZZZ
*/

SELECT M1, M2
FROM B18
ORDER BY CASE WHEN M1 <= 2 THEN 'B'
                        WHEN M1 > 4 THEN 'A'
                        ELSE 'C'
                END
                , RTRIM(M2, 'Z');

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B19 (M1 VARCHAR2(1), M2 NUMBER);

INSERT INTO B19 (M1, M2) VALUES ('A',  900);
INSERT INTO B19 (M1, M2) VALUES ('B', 2000);
INSERT INTO B19 (M1, M2) VALUES ('C', 3000);
INSERT INTO B19 (M1, M2) VALUES ('D', 1700);
INSERT INTO B19 (M1, M2) VALUES ('E', 5000);

COMMIT;

SELECT M1
FROM B19
ORDER BY TO_CHAR(M2) DESC;

SELECT M1, M2, TO_CHAR(M2)
FROM B19
ORDER BY TO_CHAR(M2) DESC;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B20 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B21 (M1 NUMBER, M2 VARCHAR2(1));

INSERT INTO B20 (M1, M2) VALUES (1, 'A');
INSERT INTO B20 (M1, M2) VALUES (2, 'B');
INSERT INTO B20 (M1, M2) VALUES (3, 'C');

INSERT INTO B21 (M1, M2) VALUES (1, 'A');
INSERT INTO B21 (M1, M2) VALUES (1, 'B');
INSERT INTO B21 (M1, M2) VALUES (2, 'B');
INSERT INTO B21 (M1, M2) VALUES (3, 'B');
INSERT INTO B21 (M1, M2) VALUES (3, 'C');

COMMIT;

SELECT SUM(B.M1) AS RESULT
FROM B20 A, B21 B
WHERE B.M2 > A.M2;
--> 12 가 나옴 ㅣ A 의 'A' 보다 큰 것 B 의 'B', 'C'. A 의 'B' 보다 큰 것 B 의 'C' 들의 M1 을 합치면 12 가 나온다 

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE 고객 (
    고객번호 NUMBER PRIMARY KEY
  , 고객명   VARCHAR2(100)
);

CREATE TABLE 결제 (
    결제번호     NUMBER PRIMARY KEY
  , 고객번호     NUMBER
  , 결제일시     DATE
  , 결제상품코드 VARCHAR2(4)
);

INSERT INTO 고객 VALUES (1, '빈정욱');
INSERT INTO 고객 VALUES (2, '신재원');
INSERT INTO 고객 VALUES (3, '이수빈');
INSERT INTO 고객 VALUES (4, '김고은');
INSERT INTO 고객 VALUES (5, '정희두');

INSERT INTO 결제 VALUES (2001, 1, TO_DATE ('2020-06-01', 'YYYY-MM-DD'), 'A001');
INSERT INTO 결제 VALUES (2002, 1, TO_DATE ('2020-06-11', 'YYYY-MM-DD'), 'A002');
INSERT INTO 결제 VALUES (2003, 1, TO_DATE ('2020-06-15', 'YYYY-MM-DD'), 'B002');
INSERT INTO 결제 VALUES (2004, 3, TO_DATE ('2020-04-08', 'YYYY-MM-DD'), 'A102');
INSERT INTO 결제 VALUES (2005, 3, TO_DATE ('2020-06-12', 'YYYY-MM-DD'), 'A102');
INSERT INTO 결제 VALUES (2006, 3, TO_DATE ('2020-06-28', 'YYYY-MM-DD'), 'C104');
INSERT INTO 결제 VALUES (2007, 4, TO_DATE ('2020-07-13', 'YYYY-MM-DD'), 'B305');

COMMIT;

SELECT A.고객번호, COUNT (DISTINCT B.결제상품코드) AS 상품종류수
FROM 고객 A INNER JOIN 결제 B
ON B.고객번호 = A.고객번호
GROUP BY A.고객번호;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B22 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B23 (M1 NUMBER, M3 VARCHAR2(1));

INSERT INTO B22 (M1, M2) VALUES (1, 'A');
INSERT INTO B22 (M1, M2) VALUES (2, 'B');
INSERT INTO B22 (M1, M2) VALUES (3, 'C');

INSERT INTO B23 (M1, M3) VALUES (1, 'A');
INSERT INTO B23 (M1, M3) VALUES (1, 'B');
INSERT INTO B23 (M1, M3) VALUES (2, 'B');
INSERT INTO B23 (M1, M3) VALUES (2, 'B');
INSERT INTO B23 (M1, M3) VALUES (3, 'C');

COMMIT;

---------------------------------------------------
SELECT *
FROM B22 A LEFT OUTER JOIN B23 B
ON B.M1 = A.M1 AND B.M3 = 'B'
WHERE A.M2 IN ('B', 'C');
---------------------------------------------------

SELECT * 
FROM B22 A, B23 B
WHERE A.M2 IN ('B', 'C') AND B.M1 = A.M1 AND B.M3 = 'B';

SELECT * 
FROM B22 A, B23 B
WHERE A.M2 IN ('B', 'C') AND B.M1(+) = A.M1 AND B.M3(+) = 'B';

SELECT * 
FROM B22 A, B23 B
WHERE A.M2(+) IN ('B', 'C') AND B.M1 = A.M1(+) AND B.M3 = 'B';

SELECT * 
FROM B22 A, B23 B
WHERE A.M2 IN ('B', 'C') AND B.M1(+) = A.M1 AND B.M3 = 'B';

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B24 (M1 NUMBER);
CREATE TABLE B25 (M1 NUMBER);

INSERT INTO B24 VALUES (1);
INSERT INTO B24 VALUES (2);
INSERT INTO B24 VALUES (3);

INSERT INTO B25 VALUES (1);
INSERT INTO B25 VALUES (NULL);

COMMIT;

SELECT COUNT(*) AS CNT
FROM B24 A
WHERE NOT EXISTS (SELECT 1 FROM B25 B WHERE B.M1 = A.M1);

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B26 (M1 NUMBER);
CREATE TABLE B27 (M1 NUMBER);

INSERT INTO B26 VALUES (1);
INSERT INTO B26 VALUES (2);
INSERT INTO B26 VALUES (3);

INSERT INTO B27 VALUES (1);
INSERT INTO B27 VALUES (2);

COMMIT;

SELECT A.DEPTNO, B.DNAME, SUM( A.SAL ) AS SAL
FROM EMP A , DEPT B
WHERE B.DEPTNO = A.DEPTNO
GROUP BY A.DEPTNO, B.DNAME;

-- 밑의 쿼리문이 위 커리문 보다 성능이 좋다 

SELECT A.DEPTNO, B.DNAME, A.SAL
FROM (SELECT DEPTNO, SUM (SAL) AS SAL
          FROM EMP
          GROUP BY DEPTNO) A, DEPT B
WHERE B.DEPTNO = A.DEPTNO;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B28 (M1 NUMBER, M2 NUMBER);

INSERT INTO B28 VALUES (1, 1);
INSERT INTO B28 VALUES (1, 2);
INSERT INTO B28 VALUES (2, 1);
INSERT INTO B28 VALUES (2, 2);

COMMIT;

SELECT * FROM B28 WHERE (M1 = 1 OR M2 = 1);

SELECT * FROM B28 WHERE M1 = 1
UNION
SELECT * FROM B28 WHERE M2 = 1;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B29 (M1 VARCHAR2(1), M2 DATE, M3 NUMBER);

INSERT INTO B29 VALUES ('A', DATE '2050-01-01', 1);
INSERT INTO B29 VALUES ('A', DATE '2050-01-02', 1);
INSERT INTO B29 VALUES ('B', DATE '2050-01-01', 1);
INSERT INTO B29 VALUES ('B', DATE '2050-01-02', 1);
INSERT INTO B29 VALUES ('C', DATE '2050-01-01', 1);
INSERT INTO B29 VALUES ('C', DATE '2050-01-02', 1);

COMMIT;

/*
    A		                            2
    B		                            2
    C		                            2
        2050/01/01 00:00:00	3
        2050/01/02 00:00:00	3
                                        6
*/

SELECT M1, M2, SUM(M3) AS M3
FROM B29
GROUP BY GROUPING SETS(M1, M2, ());

SELECT M1, M2, GROUPING(M2) GROUP1, GROUPING(M1) GROUP2, GROUPING_ID(M2, M1) GROUPID, BIN_TO_NUM(GROUPING(M2), GROUPING(M1)) BIN2NUM
FROM B29
GROUP BY ROLLUP(M1, M2);

/*
        -- BIN_TO_NUM 함수 --
    
        이진수를 십진수로 변환해주는 함수
        
        SELECT BIN_TO_NUM(1, 0, 1, 0) FROM DUAL : 10 출력
        
        GROUPING_ID 는 BIN_TO_NUM 이라고 생각
*/

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B30 (M1 VARCHAR2(1), M2 DATE, M3 NUMBER);

INSERT INTO B30 VALUES ('A', DATE '2050-01-01', 1);
INSERT INTO B30 VALUES ('A', DATE '2050-01-02', 1);
INSERT INTO B30 VALUES ('B', DATE '2050-01-01', 1);
INSERT INTO B30 VALUES ('B', DATE '2050-01-02', 1);
INSERT INTO B30 VALUES ('C', DATE '2050-01-01', 1);
INSERT INTO B30 VALUES ('C', DATE '2050-01-02', 1);

COMMIT;

SELECT M1, M2, SUM(M3) AS M3, GROUPING_ID(M1, M2) AS GROUPINGID
FROM B30
GROUP BY ROLLUP (M1, M2);

SELECT M1, M2, SUM(M3) AS M3, GROUPING (M2) AS GROUP1, GROUPING (M2) AS GROUP2, 
                                        GROUPING_ID (M2, M1) AS GROUPINGID,
                                        BIN_TO_NUM(GROUPING (M2), GROUPING (M1)) AS BIN2NUM
FROM B30
GROUP BY ROLLUP(M1, M2);

-------------------------------------------------------------------------------------------------------------------------------

SELECT JOB, MIN(SAL) OVER(PARTITION BY JOB) FROM EMP WHERE DEPTNO = 20;

SELECT EMPNO, ENAME, JOB, SAL, MAX(SAL) OVER() - MIN(SAL) OVER(PARTITION BY JOB) AS M1
FROM EMP
WHERE DEPTNO IN (20, 30);

--ANALYST	    3000
--CLERK	        800
--MANAGER	2975

--7902	FORD	    ANALYST	3000	    0
--7369	SMITH	CLERK	    800	    2200
--7566	JONES	MANAGER	2975	    25

-- MAX(SAL) : DEPTNO = 20 에서 최댓값, MIN(SAL) OVER(PARTITION BY JOB) : 그 중 JOB 별로 최소값

-------------------------------------------------------------------------------------------------------------------------------

SELECT EMPNO, ENAME, SAL, LEAD(SAL, 2, 0) OVER (ORDER BY SAL) AS C1
FROM EMP
WHERE DEPTNO = 20;

-------------------------------------------------------------------------------------------------------------------------------

/*
    CONNECT_BY_ISLEAF
    
    계층형 쿼리에서 해당하는 로우가 자식노드가 있는지 없는지 여부를 체크
    자식노드가 있을 경우 0 , 자식노드가 없을 경우 1
*/

SELECT EMPNO, ENAME, MGR
FROM EMP;

-- 조상을 찾는거인데..?

SELECT COUNT(*) AS CNT
FROM EMP
WHERE CONNECT_BY_ISLEAF = 1
START WITH ENAME = 'JONES'
CONNECT BY MGR = PRIOR EMPNO;
/*
    7369	SMITH	CLERK	7902	1980/12/17 00:00:00	800		20
*/
-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B31 (
    JOB     VARCHAR2(10)
  , D10_SAL NUMBER, D20_SAL NUMBER, D30_SAL NUMBER
  , D10_CNT NUMBER, D20_CNT NUMBER, D30_CNT NUMBER);

INSERT INTO B31 VALUES ('ANALYST'     , NULL, 6000, NULL, 0, 2, 0);
INSERT INTO B31 VALUES ('CLERK'         , 1300 , 1900,  950, 1, 2, 1);
INSERT INTO B31 VALUES ('MANAGER'   , 2450 , 2975, 2850, 1, 1, 1);
INSERT INTO B31 VALUES ('PRESIDENT'  , 5000 , NULL, NULL, 1, 0, 0);
INSERT INTO B31 VALUES ('SALESMAN'  , NULL, NULL, 5600, 0, 0, 4);

COMMIT;


/*
        JOB      D10_SAL    D20_SAL       D30_SAL   D10_CNT    D20_CNT    D30_CNT
    
    ANALYST		                6000		                       0	            2	            0   
    CLERK	        1300	        1900	         950	           1	            2	            1
    MANAGER	    2450	        2975	        2850	           1	            1	            1
    PRESIDENT	    5000			                                   1	            0	            0
    SALESMAN		                                5600	           0	            0	            4
*/

SELECT * FROM B31;


/*
        UNPIVOT (column1, column2)
            FOR(출력할컬럼명1, 출력할컬럼명2) IN (column1data, column2data) 
                                                            AS (해당출력컬럼명1에 데이터, 해당출력컬럼명2에 데이터)
*/

/*
          JOB    DEPTNO      DNAME               SAL       CNT
-------------------------------------------------------------------------------
        CLERK	  10	      ACCOUNTING	      1300	     1
        CLERK	  20	      DALLAS	              1900	     2
        CLERK	  30	      CHICAGO	              950	         1
*/

SELECT * FROM B31
UNPIVOT ((SAL, CNT) FOR (DEPTNO, DNAME) 
                        IN ((D10_SAL, D10_CNT) AS (10, 'ACCOUNTING'), 
                             (D20_SAL, D20_CNT) AS (20, 'DALLAS'), 
                             (D30_SAL, D30_CNT) AS (30, 'CHICAGO')))
WHERE JOB = 'CLERK'
ORDER BY JOB, DEPTNO;

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B32 (M1 NUMBER, M2 NUMBER);
CREATE TABLE B33 (M1 NUMBER, M2 NUMBER);

INSERT INTO B32 VALUES (1, 1);
INSERT INTO B33 VALUES (1, 2);

COMMIT;

-- 다음 쿼리문은 오류가 발생한다.
UPDATE (SELECT A.M2 AS AM2, B.M2 AS BM2 
             FROM B32 A, B33 B
             WHERE B.M1 = A.M1)
SET AM2 = BM2;

-- 테이블을 다음 중 한 문장과 같이 수정한 후 위의 커리문을 실행하면 오류가 나지 않는다.
ALTER TABLE B32 MODIFY M2 NOT NULL;

ALTER TABLE B33 MODIFY M2 NOT NULL;

ALTER TABLE B32 ADD CONSTRAINT M1_PK PRIMARY KEY (M1);

--> 다음 문장을 실행하면 위의 커리문에서 오류가 발생하지 않는다.
ALTER TABLE B33 ADD CONSTRAINT M2_PK PRIMARY KEY (M1);      

-- 위 커리문의 오류는 다음과 같다

--SQL 오류: ORA-01779: cannot modify a column which maps to a non key-preserved table
--01779. 00000 -  "cannot modify a column which maps to a non key-preserved table"
--*Cause:    An attempt was made to insert or update columns of a join view which map to a non-key-preserved table.
--*Action:   Modify the underlying base tables directly.

/*
    변경할 테이블 : B32
    변경데이터를 제공하는 테이블 : B33
    
    조인 할 때 변경 데이터를 제공하는 테이블에서 일관성을 유지할 수 없기 때문에 오류 발생
    UNIQUE 조건이 필요하다. 따라서 PRIMARY KEY 를 세팅해줌으로써 UNIQUE 조건 추가해줌
*/

-------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B34 (M1 NUMBER, M2 NUMBER);
CREATE TABLE B35 (M1 NUMBER, M2 NUMBER);

INSERT INTO B34 VALUES (1, 1);
INSERT INTO B34 VALUES (2, 1);
INSERT INTO B34 VALUES (3, 1);

INSERT INTO B35 VALUES (2, 2);
INSERT INTO B35 VALUES (3, 3);

COMMIT;

/*
    MERGE UPDATE : ON 절의 조건이 만족하는 경우 수행되는 구문 (WHEN MATCHED THEN UPDATE)
    MERGE INSERT : ON 절의 조건이 만족하는 경우 수행되는 구문 (WHEN MATCHED THEN INSERT)
    
    INTO :  갱신이나 삽입할 타깃 테이블
    USING : 갱신이나 삽입에 사용할 소스 테이블
    ON : 갱신이나 삽입의 대상을 결정하는 조건
*/

MERGE
INTO B34 T USING B35 S
ON (T.M1 = S.M1(+))
WHEN MATCHED THEN UPDATE SET T.M2 = S.M2;

SELECT * FROM B34;

-------------------------------------------------------------------------------------------------------------------------------

/*
        SAVEPOINT P1; --> SAVEPOINT 설정

        ROLLBACK TO SAVEPOINT P1; --> SAVEPOINT P1 으로 ROLLBACK
        
*/

CREATE TABLE B36 (M1 NUMBER);

INSERT INTO B36 VALUES (1);
SAVEPOINT P1;
INSERT INTO B36 VALUES (2);
SAVEPOINT P2;
INSERT INTO B36 VALUES (3);
SAVEPOINT P3;
INSERT INTO B36 VALUES (4);
SAVEPOINT P4;

SELECT * FROM B36;

-------------------------------------------------------------------------------------------------------------------------------

-- VARCHAR2 : 가변형

CREATE TABLE B37 (M1 VARCHAR2(2));

INSERT INTO B37 VALUES ('A');

COMMIT;

-- 다음 중 오류가 나는 쿼리문은?

ALTER TABLE B37 MODIFY M1 VARCHAR2(1);

ALTER TABLE B37 MODIFY M1 VARCHAR2(3);

ALTER TABLE B37 MODIFY M1 NULL;                 --> DEFAULT는 널 이기 때문에 NULL -> NULL X, NOT NULL -> NULL O 같은 조건끼리 변경은 X

ALTER TABLE B37 MODIFY M1 NOT NULL;

SELECT * FROM B37;

------------------------------------------------------------------------------------------------------------------------------

/*
    VARCHAR2 : 가변 - BYTE , CHAR 단위 가능 (기본은 BYTE)
    CHAR : 고정, 글자 수 지정
    
    한글은 최소 2 BYTE 
*/

CREATE TABLE B38 (M1 VARCHAR2(1 BYTE), M2 VARCHAR2(1 CHAR));

INSERT INTO B38 (M1) VALUES ('A' );
INSERT INTO B38 (M2) VALUES ('A' );
INSERT INTO B38 (M1) VALUES ('가');  --> 에러 발생 : 한글은 최소 2 BYTE
INSERT INTO B38 (M2) VALUES ('가');

COMMIT;

------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B39 (M1 DATE);

INSERT INTO B39 (M1) VALUES (TO_DATE ('2020-09-05', 'YYYY-MM-DD'));
INSERT INTO B39 (M1) VALUES (TO_DATE ('2020-09-15', 'YYYY-MM-DD'));
INSERT INTO B39 (M1) VALUES (TO_DATE ('2020-09-30', 'YYYY-MM-DD'));

COMMIT;

SELECT * FROM B39;

-- (2020-09-05) + 2 - (2020-09-01) = (2020-09-07) - (2020-09-01) = 6
SELECT M1 + 2 - TO_DATE ('2020-09-01', 'YYYY-MM-DD') AS RESULT FROM B39;

------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE 쿠폰 (쿠폰번호 NUMBER PRIMARY KEY, 할인내용 VARCHAR2(50));

INSERT INTO 쿠폰 (쿠폰번호, 할인내용) VALUES (1000, '10% 할인');
INSERT INTO 쿠폰 (쿠폰번호, 할인내용) VALUES (2000, '10만원 DISCOUNT');
INSERT INTO 쿠폰 (쿠폰번호, 할인내용) VALUES (3000, '15% DISCOUNT');
INSERT INTO 쿠폰 (쿠폰번호, 할인내용) VALUES (4000, '12만원 가격 할인');
INSERT INTO 쿠폰 (쿠폰번호, 할인내용) VALUES (5000, '5% 할인');

COMMIT;

/*
    1000	    10% 할인
    2000	    10만원 DISCOUNT
    3000	    15% DISCOUNT
    4000	    12만원 가격 할인
    5000	    5% 할인
*/
SELECT * FROM 쿠폰;

/*
    LIKE ' ' ESCAPE '어쩌구';
    ㄴ> 어쩌구 문자를 빼고 ~
*/

SELECT 쿠폰번호, 할인내용
FROM 쿠폰
WHERE 할인내용 LIKE '1_\%%' ESCAPE '\';

SELECT 쿠폰번호, 할인내용
FROM 쿠폰
WHERE 할인내용 LIKE '1_/%%' ESCAPE '/';






