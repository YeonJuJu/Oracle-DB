CREATE TABLE B40 (M1 VARCHAR2(1), M2 DATE, M3 DATE);

INSERT INTO B40 VALUES ('A', TO_DATE ('2020-06-30', 'YYYY-MM-DD'), TO_DATE ('2020-06-10', 'YYYY-MM-DD'));
INSERT INTO B40 VALUES ('B', TO_DATE ('2020-05-31', 'YYYY-MM-DD'), TO_DATE ('2020-05-21', 'YYYY-MM-DD'));
INSERT INTO B40 VALUES ('C', TO_DATE ('2020-05-01', 'YYYY-MM-DD'), TO_DATE ('2020-05-11', 'YYYY-MM-DD'));
INSERT INTO B40 VALUES ('D', TO_DATE ('2020-04-20', 'YYYY-MM-DD'), TO_DATE ('2020-04-15', 'YYYY-MM-DD'));

COMMIT;

/*
    A	2020/06/30 00:00:00	2020/06/10 00:00:00
    B	2020/05/31 00:00:00	2020/05/21 00:00:00
    C	2020/05/01 00:00:00	2020/05/11 00:00:00
    D	2020/04/20 00:00:00	2020/04/15 00:00:00
*/

SELECT * FROM B40;

/*
    C	-10
*/

SELECT M1, RESULT
FROM (SELECT M1, M2 - M3 AS RESULT
           FROM B40
           ORDER BY M2-M3)
WHERE ROWNUM <= 1;

-----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE B41 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B42 (M1 NUMBER, M2 VARCHAR2(1));

INSERT INTO B41 (M1, M2) VALUES (1, 'A');
INSERT INTO B41 (M1, M2) VALUES (2, 'B');
INSERT INTO B41 (M1, M2) VALUES (3, 'C');
INSERT INTO B41 (M1, M2) VALUES (4, 'D');

INSERT INTO B42 (M1, M2) VALUES (2, 'B');
INSERT INTO B42 (M1, M2) VALUES (2, 'B');
INSERT INTO B42 (M1, M2) VALUES (3, 'C');
INSERT INTO B42 (M1, M2) VALUES (5, 'C');

COMMIT;

/*
    1	A
    2	B
    3	C
    4	D
*/

SELECT * FROM B41;

/*
    2	B
    2	B
    3	C
    5	C
*/

SELECT * FROM B42;

/*
    CROSS JOIN
    -> 조건이 없음. 조건 없이 다 합쳐짐
*/

/*
    4	16
*/

SELECT COUNT (DISTINCT A.M1) AS CNB41, COUNT (B.M2) AS CNB42 
FROM B41 A CROSS JOIN B42 B;

SELECT *
FROM B41 A CROSS JOIN B42 B;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B43 PURGE;

CREATE TABLE B43 (M1 NUMBER, M2 NUMBER);

INSERT INTO B43 VALUES (1, 1);
INSERT INTO B43 VALUES (2, 2);

COMMIT;

/*
    1	1
    2	2
*/

SELECT * FROM B43;

-----------------------------------------------------------------------------------------------------------------------------

/*
    7566	    JONES	    7839
    7839	    KING	
*/

SELECT EMPNO, ENAME, MGR
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY EMPNO = PRIOR MGR;

-----------------------------------------------------------------------------------------------------------------------------

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		    20
    7499	ALLEN	SALESMAN	1902	1981/02/20 00:00:00	1700	300	30
    7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		    20
    7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
    7698	BLAKE	MANAGER	7839	1981/05/01 00:00:00	2850		    30
    7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		    10
    7839	KING	    PRESIDENT		    1981/11/17 00:00:00	5000		    10
    7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	  0	    30
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		    30
    7902	FORD	    ANALYST	7566	1981/12/03 00:00:00	3000		    20
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		    10
*/

SELECT * FROM EMP;

/*
    1981			            950	    5700
    1982	       1300			
*/

SELECT * 
FROM (SELECT TO_CHAR (HIREDATE, 'YYYY') AS YYYY, DEPTNO, JOB, SAL
           FROM EMP
           WHERE DEPTNO IN (10, 30))
PIVOT (SUM(SAL) AS SAL
           FOR (DEPTNO, JOB) IN ((10, 'CLERK') AS D10C
                                          , (10, 'SALESMAN') AS D10S
                                          , (30, 'CLERK') AS D30C
                                          , (30, 'SALESMAN') AS D30S))
ORDER BY YYYY;

-----------------------------------------------------------------------------------------------------------------------------

-- SYSTEM 계정으로 작업 -> 오른쪽 위에 SYSTEM 으로 변경

/*
    CREATE USER user IDENTIFIED BY password;
*/

DROP USER USER1 CASCADE;
DROP USER USER2 CASCADE;
DROP USER USER3 CASCADE;

CREATE USER USER1 IDENTIFIED BY USER1
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CREATE SESSION, CREATE TABLE TO USER1;
GRANT CREATE SESSION, CREATE TABLE TO USER2;
GRANT CREATE SESSION, CREATE TABLE TO USER3;

CREATE USER USER2 IDENTIFIED BY USER2;
CREATE USER USER3 IDENTIFIED BY USER3;

GRANT CREATE SESSION TO USER1, USER2, USER3;

GRANT CONNECT, RESOURCE, DBA TO USER1;
GRANT CONNECT, RESOURCE, DBA TO USER2;
GRANT CONNECT, RESOURCE, DBA TO USER3;

ALTER USER USER2 ACCOUNT UNLOCK;

ALTER TABLE USER2.B42 ADD M2 NUMBER;

-- USER1 에서 USER2 의 B42 테이블을 변경할 수 있는 권한을 USER1, USER3 에게 부여
-- 이 작업을 하려면 USER1 이 USER2 계정에 로그인해서 USER3에게 권한을 부여해야 함
-- GRANT ALTER ON USER2.B42 TO USER1;
-- ㄴ 이 권한 만으로는 USER1이 USER2 계정에 로그인 할 수 없음
-- GRANT ALTER ON B42 TO USER1 WITH GRANT OPTION;
-- ㄴ USER2 계정에 로그인해서 WITH GRANT OPTION 옵션을 주어야
-- USER1이 USER2 계정에 로그인해서 USER2 소유의 B42 테이블을 
-- 변경할 수 있는 권한을 USER3에게 부여 가능

GRANT ALTER ON USER2.B42 TO USER3;
GRANT ALTER ON USER2.B42 TO USER1;

-----------------------------------------------------------------------------------------------------------------------------

-- SYSTEM 계정
DROP USER USER1 CASCADE;
DROP USER USER2 CASCADE;
DROP USER USER3 CASCADE;

CREATE USER USER1 IDENTIFIED BY USER1
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

CREATE USER USER2 IDENTIFIED BY USER2
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

CREATE USER USER3 IDENTIFIED BY USER3
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

-- USER1, USER3 가 계정에 접속하고 테이블을 만들 수 있도록 권한을 부여해야 함
GRANT CREATE SESSION, CREATE TABLE TO USER1, USER3;

-- USER2에게  CONNECT, RESOURCE, DBA 권한 부여
GRANT CONNECT, RESOURCE, DBA TO USER2;



-- USER2 계정
-- B42 테이블 생성
DROP TABLE B42 PURGE;
CREATE TABLE B42(
  M1 NUMBER
);

-- USER2 가 USER1에게 USER2 소유인 B42 테이블을 변경할 권한을 부여함
GRANT ALTER ON USER2.B42 TO USER1;

-- GRANT ALTER ON B42 TO USER1 WITH GRANT OPTION;


-- USER1 계정에서 USER2 소유인 B42 테이블을 변경할 수 있는 권한을 USER3에게 부여함
-- 이 작업을 하려면 USER1가 USER2 계정에 로그인해서 USER3에게 권한을 부여해야 함
-- GRANT ALTER ON USER2.B42 TO USER1;
--  ㄴ 이 권한만으로는 USER1이 USER2계정에 접속(로그인)할 수 없음
-- GRANT ALTER ON B42 TO USER1 WITH GRANT OPTION;
--  ㄴ USER2 계정에 로그인해서 WITH GRANT OPTION 옵션을 주어야
--     USER1이 USER2계정에 접속(로그인)해서 
--     USER2 소유인 B42 테이블을 변경할 수 있는 권한을 USER3에게 부여할 수 있음
GRANT ALTER ON USER2.B42 TO USER3;

-- USER1 계정에 접속해서 함
GRANT ALTER ON USER2.B42 TO USER3;

-----------------------------------------------------------------------------------------------------------------------------

CREATE TABLE 계약(
    계약번호 NUMBER(2),
    계약금    NUMBER(5),
    중도금    NUMBER(5),
    잔금       NUMBER(5)
);

INSERT INTO 계약 VALUES (1, 50, 100, 150);
INSERT INTO 계약 VALUES (2, 100, 100, 100);
INSERT INTO 계약 VALUES (3, 100, 0, 200);

SELECT * FROM 계약;

SELECT MAX(계약금) AS 최고계약금, ROUND(AVG(중도금), 2) AS 평균중도금
FROM 계약;

-- 아래 4개의 SQL 문을 실행할 결과의 데이터 유형이 다른 것은?

-- 1987/10/16
SELECT TO_DATE('1987-10-06', 'YYYY-MM-DD') AS R1 FROM DUAL;

-- 1987/10/16 : date type
SELECT TO_DATE('1987-10-06', 'YYYY-MM-DD') + 10 AS R1 FROM DUAL;

-- 5 : number typr
SELECT TO_DATE('1987-10-06', 'YYYY-MM-DD') -   TO_DATE('1987-10-01', 'YYYY-MM-DD') AS R1 FROM DUAL;

-- 1/24/60/60 : 1초
SELECT TO_DATE('1987-10-06', 'YYYY-MM-DD') - 1/24/60/60 AS R1 FROM DUAL;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE COMMISSION PURGE;

CREATE TABLE COMMISSION (EMPNO NUMBER(4), COMM NUMBER);

INSERT INTO COMMISSION (EMPNO, COMM) VALUES (1, 1000);
INSERT INTO COMMISSION (EMPNO, COMM) VALUES (2, NULL);
INSERT INTO COMMISSION (EMPNO, COMM) VALUES (3, 2000);

COMMIT;

/*
    ORA-01722: invalid number
    01722. 00000 -  "invalid number"
    *Cause:    The specified number was invalid.
    *Action:   Specify a valid number.
*/
SELECT NVL(COMM, '없음') AS RESULT
FROM COMMISSION;

/*
    1	1000
    2	없음
    3	2000
*/
SELECT EMPNO, (NVL(TO_CHAR(COMM), '없음')) AS RESULT
FROM COMMISSION;

/* ========================================================
    NVL 함수가 동작할 때 묵시적으로 형변환이 일어남 (자동형변환)
    
    1) NVL 함수의 첫 번째 인자값의 DATA TYPE 이 문자형이면, 
        첫 번째 인자값을 NULL 과 비교하기 전에 
        두 번째 인자값을 첫 번째 인자값의 DATA TYPE으로 변환하여
        VARCHAR2 TYPE 으로 변환함
    2) NVL 함수의 첫 번째 인자 값의 DATA TYPE 이 숫자형이면
        두 번째 인자값을 첫 번째 인자값의 DATA TYPE으로 변환하며 NUMBER TYPE 으로 변환
    3) 자동 형변환을 할 수 없는 경우 에러 발생
======================================================== */

-----------------------------------------------------------------------------------------------------------------------------

/* ========================================================
    @@ AND 연산 후 OR 연산 수행 @@
======================================================== */

SELECT * FROM EMP
WHERE JOB IN ('CLERK', 'MANAGER')
            AND DEPTNO = 20
            AND SAL BETWEEN 1000 AND 3000;

-- 위와 같은 결과를 출력하는 쿼리문을 고르시오

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		30
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		10
*/

SELECT * FROM EMP
WHERE JOB = 'CLERK' OR JOB = 'MANAGER'
            AND DEPTNO = 20
            AND SAL BETWEEN 1000 AND 3000;
            
/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		30
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		10
*/

SELECT * FROM EMP
WHERE JOB IN ('CLERK') OR  JOB IN ('MANAGER')
            AND DEPTNO = 20
            AND SAL >= 1000 AND SAL <= 3000;

/*
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
*/

SELECT * FROM EMP
WHERE (JOB = 'CLERK' OR JOB = 'MANAGER')
            AND DEPTNO = 20
            AND SAL BETWEEN 1000 AND 3000;

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		30
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		10
*/
SELECT * FROM EMP
WHERE JOB IN ('CLERK') OR  JOB IN ('MANAGER')
            AND DEPTNO = 20
            AND (SAL >= 1000 AND SAL <= 3000);

-----------------------------------------------------------------------------------------------------------------------------

SELECT * FROM EMP
WHERE NOT (DEPTNO = 10 AND COMM IS NULL);

-- 위와 같은 결과를 출력하는 쿼리문을 고르시오

/*
    7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		10
    7839	KING    	PRESIDENT		    1981/11/17 00:00:00	5000		10
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		10
*/

SELECT * FROM EMP
WHERE DEPTNO = 10 AND COMM IS NULL;

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
    7698	BLAKE	MANAGER	7839	1981/05/01 00:00:00	2850		30
    7782	CLARK	MANAGER	7839	1981/06/09 00:00:00	2450		10
    7839	KING	    PRESIDENT		    1981/11/17 00:00:00	5000		10
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		30
    7902	FORD	    ANALYST	7566	1981/12/03 00:00:00	3000		20
    7934	MILLER	CLERK	    7782	1982/01/23 00:00:00	1300		10
*/

SELECT * FROM EMP
WHERE DEPTNO = 10 OR COMM IS NULL;

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		    20
    7499	ALLEN	SALESMAN	1902	1981/02/20 00:00:00	1700	300	30
    7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		    20
    7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
    7698	BLAKE	MANAGER	7839	1981/05/01 00:00:00	2850		    30
    7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	    0	30
    7900	JAMES	CLERK	    7698	1981/12/03 00:00:00	950		    30
    7902	FORD	    ANALYST	7566	1981/12/03 00:00:00	3000		    20
*/

SELECT * FROM EMP
WHERE DEPTNO != 10 OR COMM IS NOT NULL;

/*
    7499	ALLEN	SALESMAN	1902	1981/02/20 00:00:00	1700	300	30
    7521	WARD	SALESMAN	7698	1981/02/22 00:00:00	1250	500	30
    7654	MARTIN	SALESMAN	7698	1981/09/28 00:00:00	1250	1400	30
    7844	TURNER	SALESMAN	7698	1981/09/08 00:00:00	1500	    0	30
*/

SELECT * FROM EMP
WHERE DEPTNO != 10 AND COMM IS NOT NULL;

-----------------------------------------------------------------------------------------------------------------------------

/* ========================================================
    @@ AVG 함수는 NULL 을 제외하고 계산 @@
======================================================== */

DROP TABLE B43 PURGE;

CREATE TABLE B43 (M1 NUMBER);

INSERT INTO B43 (M1) VALUES ( 100);
INSERT INTO B43 (M1) VALUES (NULL);
INSERT INTO B43 (M1) VALUES (NULL);
INSERT INTO B43 (M1) VALUES ( 200);
INSERT INTO B43 (M1) VALUES ( 300);

COMMIT;

-- 다음 쿼리문 중 다른 결과가 나오는 것을 고르시오

SELECT AVG(M1) AS RESULT FROM B43;  --> 200

SELECT AVG(M1) AS RESULT FROM B43 WHERE M1 IS NOT NULL;  --> 200

SELECT AVG(NVL(M1, 0)) AS RESULT FROM B43;  --> 120

SELECT NVL(AVG(M1), 0) AS RESULT FROM B43;  --> 200

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B44 PURGE;

CREATE TABLE B44 (M1 NUMBER, M2 NUMBER);

INSERT INTO B44 (M1, M2) VALUES (1, 9);
INSERT INTO B44 (M1, M2) VALUES (2, 9);
INSERT INTO B44 (M1, M2) VALUES (3, 7);
INSERT INTO B44 (M1, M2) VALUES (4, 7);
INSERT INTO B44 (M1, M2) VALUES (5, 8);

COMMIT;

/*
        1	9
        2	9
        3	7
        4	7
        5	8
*/
SELECT * FROM B44;

/*
        3	3
        4	3
        1	1
        2	1
        5	0
*/

SELECT M1, M2
FROM (SELECT M1, MOD (M2, 4) AS M2
           FROM B44
           ORDER BY M2 DESC, M1);   --> 여기서 M2 는 컬럼 이름이 아닌 별명

/*
        1	9	1
        2	9	1
        5	8	0
        3	7	3
        4	7	3
*/

SELECT M1, M2, MOD (M2, 4) AS M3
           FROM B44
           ORDER BY M2 DESC, M1;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B45 PURGE;
DROP TABLE B46 PURGE;

CREATE TABLE B45 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B46 (M1 NUMBER, M2 VARCHAR2(1));

INSERT INTO B45 (M1, M2) VALUES (1, 'A');
INSERT INTO B45 (M1, M2) VALUES (2, 'B');
INSERT INTO B45 (M1, M2) VALUES (3, 'C');

INSERT INTO B46 (M1, M2) VALUES (1, 'A');
INSERT INTO B46 (M1, M2) VALUES (1, 'B');
INSERT INTO B46 (M1, M2) VALUES (2, 'A');
INSERT INTO B46 (M1, M2) VALUES (3, 'A');
INSERT INTO B46 (M1, M2) VALUES (3, 'C');

COMMIT;

/*
    4
*/

SELECT SUM(A.M1) AS RESULT
FROM B45 A, B46 B
WHERE B.M1 = A.M1
AND B.M2 = A.M2;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B47 PURGE;
DROP TABLE B48 PURGE;

CREATE TABLE B47 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B48 (M1 NUMBER, M2 VARCHAR2(1));

INSERT INTO B47 (M1, M2) VALUES (1, 'A');
INSERT INTO B47 (M1, M2) VALUES (2, 'B');
INSERT INTO B47 (M1, M2) VALUES (3, 'C');
INSERT INTO B47 (M1, M2) VALUES (4, 'D');

INSERT INTO B48 (M1, M2) VALUES (1, 'A');
INSERT INTO B48 (M1, M2) VALUES (1, 'A');
INSERT INTO B48 (M1, M2) VALUES (2, 'B');
INSERT INTO B48 (M1, M2) VALUES (2, 'C');
INSERT INTO B48 (M1, M2) VALUES (3, 'C');
INSERT INTO B48 (M1, M2) VALUES (4, 'C');

COMMIT;

-- OUTER JOIN --

SELECT SUM(A.M1) AS RESULT
FROM B47 A, B48 B
WHERE B.M1(+) = A.M1
    AND B.M2(+) = A.M2;
    
SELECT SUM(A.M1) AS RESULT
FROM B47 A, B48 B
WHERE B.M1(+) = A.M1 AND B.M2(+) = A.M2;

SELECT * FROM B47 A , B48 B
WHERE B.M1(+) = A.M1 AND B.M2(+) = A.M2;
    
-----------------------------------------------------------------------------------------------------------------------------
    
DROP TABLE B49 PURGE;
DROP TABLE B50 PURGE;

CREATE TABLE B49 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B50 (M1 NUMBER, C3 VARCHAR2(1));

INSERT INTO B49 (M1, M2) VALUES (1, 'A');
INSERT INTO B49 (M1, M2) VALUES (2, 'B');
INSERT INTO B49 (M1, M2) VALUES (3, 'C');

INSERT INTO B50 (M1, C3) VALUES (1, 'A');
INSERT INTO B50 (M1, C3) VALUES (1, 'B');
INSERT INTO B50 (M1, C3) VALUES (2, 'B');
INSERT INTO B50 (M1, C3) VALUES (3, 'C');
INSERT INTO B50 (M1, C3) VALUES (3, 'A');
INSERT INTO B50 (M1, C3) VALUES (4, 'B');

COMMIT;

ALTER TABLE B50 RENAME COLUMN C3 TO M2;

SELECT SUM (A.M1) AS RESULT
FROM B49 A JOIN B50 B
ON B.M1 = A.M1;

SELECT SUM (A.M1) AS RESULT
FROM B49 A LEFT JOIN B50 B
ON B.M1 = A.M1;

SELECT SUM (M1) AS RESULT
FROM B49 NATURAL JOIN B50;

SELECT SUM (M1) AS RESULT
FROM B49 A LEFT JOIN B50 B USING (M1);

/*
    1	A	1	A
    1	A	1	B
    2	B	2	B
    3	C	3	C
    3	C	3	A
*/

SELECT *
FROM B49 A JOIN B50 B
ON B.M1 = A.M1;

SELECT *
FROM B49 A LEFT JOIN B50 B
ON B.M1 = A.M1;

SELECT *
FROM B49 A LEFT JOIN B50 B USING (M1);

/*
        1	A
        2	B
        3	C
*/

/*
    NATURAL JOIN
    
    양쪽 테이블에서 이름이 같은 컬럼을 기준으로 EQUI JOIN
*/

SELECT *
FROM B49 NATURAL JOIN B50;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B51 PURGE;
DROP TABLE B52 PURGE;

CREATE TABLE B51 (M1 NUMBER, M2 VARCHAR2(1));
CREATE TABLE B52 (M1 NUMBER, M2 VARCHAR2(1));

INSERT INTO B51 (M1, M2) VALUES (1, 'A');
INSERT INTO B51 (M1, M2) VALUES (2, 'B');
INSERT INTO B51 (M1, M2) VALUES (3, 'C');
INSERT INTO B51 (M1, M2) VALUES (4, 'D');

INSERT INTO B52 (M1, M2) VALUES (2, 'B');
INSERT INTO B52 (M1, M2) VALUES (2, 'B');
INSERT INTO B52 (M1, M2) VALUES (3, 'C');
INSERT INTO B52 (M1, M2) VALUES (5, 'C');

COMMIT;

SELECT COUNT (A.M1) + COUNT (B.M1) AS RESULT
FROM B51 A FULL OUTER JOIN B52 B
ON B.M1 = A.M1;

SELECT *
FROM B51 A FULL OUTER JOIN B52 B
ON B.M1 = A.M1;

-----------------------------------------------------------------------------------------------------------------------------

SELECT * 
FROM DEPT
WHERE DEPTNO IN (SELECT DEPTNO FROM EMP);

SELECT A.* 
FROM DEPT A
WHERE EXISTS ( SELECT 1 FROM EMP E WHERE W.DEPTNO = A.DEPTNO);

SELECT B.* 
FROM (SELECT DISTINCT DEPTNO FROM EMP) A, DEPT B
WHERE B.DEPTNO = A.DEPTNO;

SELECT DISTINCT A.*
FROM DEPT A, EMP B
WHERE B.DEPTNO(+) = A.DEPTNO;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B53 PURGE;
DROP TABLE B54 PURGE;

CREATE TABLE B53 (M1 NUMBER);
CREATE TABLE B54 (M1 NUMBER);

INSERT INTO B53 VALUES (1);
INSERT INTO B53 VALUES (2);
INSERT INTO B53 VALUES (3);
INSERT INTO B53 VALUES (4);

INSERT INTO B54 VALUES (1);
INSERT INTO B54 VALUES (2);
INSERT INTO B54 VALUES (2);

COMMIT;

SELECT COUNT(*) AS CNT
FROM B53 A
WHERE EXISTS (SELECT COUNT (*)
                        FROM B51 B
                        WHERE B.M1 = A.M1);

SELECT *
FROM B53 A
WHERE EXISTS (SELECT COUNT (*)
                        FROM B51 B
                        WHERE B.M1 = A.M1);
 
-----------------------------------------------------------------------------------------------------------------------------

-- UNION ALL, UNION, MINUS, INTERSECT 중 SORT 가 발생하지 않는 연산은?

--> UNION ALL

DROP TABLE B55 PURGE;

CREATE TABLE B55 (M1 VARCHAR2(1), M2 DATE, M3 NUMBER);

INSERT INTO B55 VALUES ('A', DATE '2050-01-01', 1);
INSERT INTO B55 VALUES ('A', DATE '2050-01-02', 1);
INSERT INTO B55 VALUES ('B', DATE '2050-01-01', 1);
INSERT INTO B55 VALUES ('B', DATE '2050-01-02', 1);
INSERT INTO B55 VALUES ('C', DATE '2050-01-01', 1);
INSERT INTO B55 VALUES ('C', DATE '2050-01-02', 1);

COMMIT;


SELECT M1, M2, SUM(M3) AS M3
FROM B55
GROUP BY ROLLUP (M1, M2);

-- 다음과 같은 결과를 출력한다

SELECT M1, M2, SUM(M3) AS M3
FROM B55
GROUP BY GROUPING SETS ((M1, M2), M1, ());

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B56 PURGE;

CREATE TABLE B56 (M1 VARCHAR2(1), M2 DATE, M3 NUMBER);

INSERT INTO B56 VALUES ('A', DATE '2050-01-01', 1);
INSERT INTO B56 VALUES ('A', DATE '2050-01-02', 1);
INSERT INTO B56 VALUES ('B', DATE '2050-01-01', 1);
INSERT INTO B56 VALUES ('B', DATE '2050-01-02', 1);
INSERT INTO B56 VALUES ('C', DATE '2050-01-01', 1);
INSERT INTO B56 VALUES ('C', DATE '2050-01-02', 1);

COMMIT;

SELECT M1, M2, SUM(M3) AS M3
FROM B56
GROUP BY ROLLUP((M1, M2));

SELECT M1, M2, SUM(M3) AS M3
FROM B56
GROUP BY GROUPING SETS ((M1,M2), ());

-----------------------------------------------------------------------------------------------------------------------------

/*
        7900	JAMES	950	1
        7521	WARD	1250	2
        7654	MARTIN	1250	2
        7844	TURNER	1500	3
        7499	ALLEN	1700	4
        7698	BLAKE	2850	5
*/

SELECT EMPNO, ENAME, SAL, DENSE_RANK () OVER (ORDER BY SAL) AS C1
FROM EMP
WHERE DEPTNO = 30;

-----------------------------------------------------------------------------------------------------------------------------
/*
    ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    --> 현재 행을 기준으로 전후 한 행씩을 포함함 : 현재 행 + 전 행 + 다음 행
*/

/*
    7369	SMITH	800	1887.5  (= (800 + 2975)/2 )
    7566	JONES	2975	2258.33 (= (800 + 2975 + 3000)/3 )
    7902	FORD	    3000	2987.5 (= (2975 + 3000)/2 )
*/

SELECT EMPNO, ENAME, SAL, ROUND(AVG (SAL) OVER (ORDER BY SAL 
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS C1
FROM EMP
WHERE DEPTNO = 20;

/*
        7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
        7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
        7902	FORD    	ANALYST	7566	1981/12/03 00:00:00	3000		20
*/

SELECT *
FROM EMP
WHERE DEPTNO = 20;

-----------------------------------------------------------------------------------------------------------------------------

/*
    NTILE 함수
    
    NTILE (EXPR) OVER ([QUERY_PARTITION_CLAUSE] ORDER_BY_CLAUSE)
    
    EXPR : 그룹 수
    
    결과 집합을 ARGUMENT 로 지정한 개수만큼 그룹을 생성하는 경우,
    각 행이 ORDER BY 로 지정한 순서에 따라서 몇 번째 그룹에 속하는 반환함
*/

SELECT C1, COUNT (*) AS C2
FROM (SELECT NTILE (2) OVER (ORDER BY SAL) AS C1
           FROM EMP
           WHERE DEPTNO = 20)
GROUP BY C1;

/*
    7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
    7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
    7902	FORD	    ANALYST	7566	1981/12/03 00:00:00	3000		20
*/
SELECT * FROM EMP WHERE DEPTNO = 20;

/*
        1
        1
        2
*/
SELECT NTILE (2) OVER (ORDER BY SAL) AS C1
FROM EMP
WHERE DEPTNO = 20;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE SCORE_TBL PURGE;
CREATE TABLE SCORE_TBL(NO NUMBER, NAME VARCHAR2(30), SCORE NUMBER);



INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 1,  '이순신', 97 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 2,  '강감찬', 20 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 3,  '안중근', 28 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 4,  '김구', 19 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 5,  '유관순', 29 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 6,  '김유신', 53 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 7,  '계백', 59 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 8,  '고주몽', 97 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 9,  '양만춘', 89 );

INSERT INTO SCORE_TBL(NO, NAME, SCORE) VALUES ( 10, '박제상', 49 );

COMMIT;

SELECT NO, NAME, SCORE, NTILE(3) OVER (ORDER BY SCORE DESC) AS 등급
FROM SCORE_TBL;

-----------------------------------------------------------------------------------------------------------------------------

/*
            7369	SMITH	7902
            7499	ALLEN	1902
            7521	WARD	7698
            7566	JONES	7839
            7654	MARTIN	7698
            7698	BLAKE	7839
            7782	CLARK	7839
            7839	KING	
            7844	TURNER	7698
            7900	JAMES	7698
            7902	FORD	    7566
            7934	MILLER	7782
*/

SELECT EMPNO, ENAME, MGR
FROM EMP;

/*
        3
*/

SELECT MAX(LEVEL) AS C1 --> LEVEL : 현재 노드의 레벨 반환
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY MGR = PRIOR EMPNO;  
--> JONES 의 EMPNO 와 어떤 행의 MGR 이 같은거를 타고타고 올라감

/*
        7566	JONES	MANAGER	7839	1981/04/02 00:00:00	2975		20
        7902	FORD    	ANALYST	7566	1981/12/03 00:00:00	3000		20
        7369	SMITH	CLERK	    7902	1980/12/17 00:00:00	800		20
*/

SELECT *
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY MGR = PRIOR EMPNO;

-----------------------------------------------------------------------------------------------------------------------------

DROP TABLE B57 PURGE;
DROP TABLE B58 PURGE;

CREATE TABLE B57 (M1 NUMBER, M2 NUMBER);
CREATE TABLE B58 (M1 NUMBER, M2 NUMBER);

INSERT INTO B57 VALUES (1, 1);
INSERT INTO B57 VALUES (2, 1);
INSERT INTO B57 VALUES (3, 1);
INSERT INTO B58 VALUES (1, 1);

COMMIT;

DELETE FROM B57 A
WHERE EXISTS (SELECT 1 FROM B58 B WHERE B.M1 = M1);

SELECT COUNT(*) FROM B57;





