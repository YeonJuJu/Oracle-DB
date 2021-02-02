----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB29(
    M1 NUMBER(2),
    M2 VARCHAR2(2),
    M3 NUMBER(6)
);

INSERT INTO TB29 VALUES(1, 'A', 3000);
INSERT INTO TB29 VALUES(2, 'B', 800);
INSERT INTO TB29 VALUES(3, 'A', NULL);
INSERT INTO TB29 VALUES(4, 'B', 2200);
INSERT INTO TB29 VALUES(5, 'C', 3000);
INSERT INTO TB29 VALUES(6, 'B', 3600);

SELECT M2, AVG(M3) AS RESULT
FROM TB29
WHERE M1 <= 4
GROUP BY M2
HAVING AVG(M3) >= 2000;

-- 다음과 같다

SELECT *
FROM ( SELECT M2, AVG(M3) AS RESULT
            FROM TB29
            WHERE M1 <= 4
            GROUP BY M2)
WHERE RESULT >= 2000;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB30(
    M1 NUMBER(2),
    M2 NUMBER(2)
);

INSERT INTO TB30 VALUES(1, 1);
INSERT INTO TB30 VALUES(2, 2);
INSERT INTO TB30 VALUES(3, 3);
INSERT INTO TB30 VALUES(4, 1);
INSERT INTO TB30 VALUES(5, 2);

SELECT 6 - A.M1 AS M1, CASE WHEN A.M1 >= 4 THEN 'A'
                                            WHEN A.M2 IN (1, 3) THEN 'B'
                                            ELSE 'C'
                                            END AS M2
FROM TB30 A
ORDER BY A.M2 DESC, A.M1 DESC;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE ORG(
    ORG_ID VARCHAR2(10),
    ORG_NAME VARCHAR2(20)
);

CREATE TABLE CUST(
    C_NO NUMBER(2),
    C_CODE VARCHAR2(4),
    ORG_ID VARCHAR2(10)
);

INSERT INTO ORG VALUES('OTJQ', '강남본점');
INSERT INTO ORG VALUES('WZQF', '영등포지점');
INSERT INTO ORG VALUES('MIGK', '신촌지점');
INSERT INTO ORG VALUES('HYAO', '을지로지점');

INSERT INTO CUST VALUES(1, 'A1', 'OTJQ');
INSERT INTO CUST VALUES(1, 'A1', 'OTJQ');
INSERT INTO CUST VALUES(1, 'A1', 'OTJQ');
INSERT INTO CUST VALUES(2, 'A1', 'WZQF');
INSERT INTO CUST VALUES(3, 'A1', 'WZQF');
INSERT INTO CUST VALUES(4, 'B1', 'MIGK');
INSERT INTO CUST VALUES(5, 'B1', NULL);
INSERT INTO CUST VALUES(6, 'A1', NULL);

-- EQUI JOIN : 조인 조건이 모두 등호인 조건

SELECT A.C_NO, A.C_CODE, B.ORG_NAME
FROM CUST A, ORG B
WHERE B.ORG_ID = DECODE(A.C_CODE, 'B1', 'OTJQ', A.ORG_ID)
ORDER BY A.C_NO;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE CUST2(
    C_NO NUMBER(2),
    C_NAME VARCHAR2(20)
);

CREATE TABLE ORDER2(
    ORDER_NUMBER VARCHAR2(6),
    C_NO NUMBER(2),
    ORDER_BILL NUMBER(10)
);

INSERT INTO CUST2 VALUES (1, '이순신');
INSERT INTO CUST2 VALUES (2, '강감찬');
INSERT INTO CUST2 VALUES (3, '대조영');
INSERT INTO CUST2 VALUES (4, '유관순');

INSERT INTO ORDER2 VALUES(2001, 1, 40000);
INSERT INTO ORDER2 VALUES(2002, 2, 15000);
INSERT INTO ORDER2 VALUES(2003, 2, 7000);
INSERT INTO ORDER2 VALUES(2004, 2, 8000);
INSERT INTO ORDER2 VALUES(2005, 2, 20000);
INSERT INTO ORDER2 VALUES(2006, 3, 5000);
INSERT INTO ORDER2 VALUES(2007, 4, 9000);

COMMIT;

SELECT A.C_NO, (SELECT SUM(X.ORDER_BILL)
                        FROM ORDER2 X
                        WHERE X.C_NO = A.C_NO) AS ORDERSUM
FROM CUST2 A
WHERE A.C_NO IN (3,4);

SELECT A.C_NO, SUM(B.ORDER_BILL) AS ORDERSUM
FROM CUST2 A JOIN ORDER2 B ON B.C_NO = A.C_NO
WHERE A.C_NO IN (3, 4)
GROUP BY A.C_NO
ORDER BY A.C_NO;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB31(
    M1 NUMBER(2),
    M2 VARCHAR2(2)
);

CREATE TABLE TB32(
    M1 NUMBER(2),
    M2 VARCHAR2(2),
    M3 NUMBER(4)
);

INSERT INTO TB31 VALUES(1, 'A');
INSERT INTO TB31 VALUES(2, 'B');
INSERT INTO TB31 VALUES(3, 'C');

INSERT INTO TB32 VALUES(1, 'A', 100);
INSERT INTO TB32 VALUES(3, 'A', 200);
INSERT INTO TB32 VALUES(3, 'D', 300);

SELECT * 
FROM TB31 A RIGHT JOIN TB32 B USING (M2)
WHERE B.M3 >= 200;

----------------------------------------------------------------------------------------------------------------

/*
    (+) 을 사용한 OUTER JOIN 시 모든 행 비교문에 (+) 을 사용해야한다
    미사용시 INNER JOIN 으로 인식
*/

SELECT *
  FROM TABLE1 A, TABLE2 B
 WHERE A.M2 IN ('B', 'C')
   AND B.M1(+) = A.M1
   AND B.M2(+) <= 2;

-- 다음 두 쿼리문은 결과가 같다

SELECT *
  FROM TABLE1 A, TABLE2 B
 WHERE A.M2 IN ('B', 'C')
   AND B.M1(+) = A.M1
   AND B.M2 <= 2;

SELECT *
  FROM TABLE1 A INNER JOIN TABLE2 B
    ON B.M1 = A.M1
 WHERE A.M2 IN ('B', 'C')
   AND B.M2 <= 2;
   
----------------------------------------------

SELECT *
  FROM TABLE1 A LEFT OUTER JOIN TABLE2 B
    ON B.M1 = A.M1
   AND B.M2 <= 2
 WHERE A.M2 IN ('B', 'C');
 
SELECT *
  FROM TABLE1 A RIGHT OUTER JOIN TABLE2 B
    ON B.M1 = A.M1
   AND A.M2 IN ('B', 'C')
 WHERE B.M2 <= 2;
 
SELECT *
  FROM TABLE1 A CROSS JOIN TABLE2 B
 WHERE A.M2 IN ('B', 'C')
   AND B.M2 <= 2;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB33(
    M1 NUMBER(1)
);

CREATE TABLE TB34(
    M1 NUMBER(1)
);

INSERT INTO TB33 VALUES(1);
INSERT INTO TB33 VALUES(2);
INSERT INTO TB33 VALUES(3);

INSERT INTO TB34 VALUES(1);
INSERT INTO TB34 VALUES(2);

/*
    상관 서브 쿼리의 컬럼을 테이블 별칭으로 한정하지 않으면 서브쿼리 테이블의 컬럼을 우선적으로 검색
*/

-- EXISTS 는 서브 쿼리가 참이면 동작

SELECT COUNT(*)
FROM TB33 A
WHERE EXISTS (SELECT 1 FROM TB34 B WHERE B.M1 = M1); -- WHERE B.M1 = B.M1

SELECT COUNT(*)
FROM TB33 A
WHERE EXISTS (SELECT 1 FROM TB34 B WHERE B.M1 = A.M1); -- B 테이블과 A 테이블에 동시에 존재하는 값에 대한 것만 출력

----------------------------------------------------------------------------------------------------------------
        
/*
    분석함수
    
    테이블에 있는 데이터를 특정 용도로 분석해 결과 반환
    SELECT 절에서 사용 가능, FROM, WHERE, GROUP BY, ORDER BY 구문에서 사용 가능
*/

/*
    그룹함수
    
    여러 행이나 테이블 전체 행으로부터 그룹별로 집계해 결과 반환
*/

SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, MAX(SAL)
                                        FROM EMP
                                        GROUP BY DEPTNO);
                                        
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM (SELECT A.*, RANK() OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) AS RANKING
           FROM EMP A)
WHERE RANKING = 1;

-- RANK, DENSE_RANK
SELECT ENAME, SAL, RANK() OVER (ORDER BY SAL DESC) RANK, 
                                DENSE_RANK() OVER (ORDER BY SAL DESC) DENSE_RANK
FROM EMP
ORDER BY SAL DESC;

----------------------------------------------------------------------------------------------------------------

SELECT DEPTNO, DNAME FROM DEPT;

SELECT EMPNO, ENAME, SAL, DEPTNO FROM EMP;

SELECT TO_NUMBER(SUBSTR(SAL_ENAME, 1, 4)) AS SAL, SUBSTR(SAL_ENAME, 5) AS ENAME
FROM (SELECT (SELECT MAX(LPAD(SAL, 4, '0') || ENAME) 
                       FROM EMP E
                       WHERE E.DEPTNO = D.DEPTNO) AS SAL_ENAME
          FROM DEPT D
          WHERE D.DEPTNO = 20);
        
----------------------------------------------------------------------------------------------------------------

SELECT D.DEPTNO, D.DNAME, 
            (SELECT MAX(E.SAL) FROM EMP E WHERE E.DEPTNO = D.DEPTNO) AS SAL,
            (SELECT MAX(E.COMM) FROM EMP E WHERE E.DEPTNO = DEPTNO) AS COMM
FROM DEPT D;

-- EMP 테이블의 조회 횟수를 줄이기 위해 인라인 뷰 사용
-- 메인 쿼리를 기준으로 인라인 뷰를 OUTER JOIN 해서 사용

SELECT D.DEPTNO, D.DNAME, M.SAL, M.COMM    
FROM DEPT D, (SELECT DEPTNO, MAX(SAL) AS SAL, MAX(COMM) AS COMM 
                      FROM EMP
                      GROUP BY DEPTNO) M
WHERE M.DEPTNO(+) = D.DEPTNO;

----------------------------------------------------------------------------------------------------------------

CREATE TABLE TB35(
  M1  NUMBER(2)
);
CREATE TABLE TB36(
  M1  NUMBER(2)
);
CREATE TABLE TB37(
  M1  NUMBER(2)
);

INSERT INTO TB35 VALUES(1);
INSERT INTO TB35 VALUES(2);
INSERT INTO TB35 VALUES(3);

INSERT INTO TB36 VALUES(1);
INSERT INTO TB36 VALUES(4);

INSERT INTO TB37 VALUES(2);
INSERT INTO TB37 VALUES(3);

SELECT * FROM TB35;
SELECT * FROM TB36;
SELECT * FROM TB37;

/*
  TB35        TB36        TB37
   M1          M1          M1
   1           1           2
   2           4           3
   3
*/
SELECT COUNT(*) CNT
  FROM (SELECT M1 FROM TB35
        UNION
        SELECT M1 FROM TB36
        UNION
        SELECT M1 FROM TB37); -- 4
SELECT COUNT(*) CNT
  FROM (SELECT M1 FROM TB35
        UNION
        SELECT M1 FROM TB36
        MINUS
        SELECT M1 FROM TB37); -- 2   
        
/*
  UNION ALL    : 위아래 두 집합의 합집합 - 중복허용
  UNION        : 위아래 두 집합의 합집합 - 중복제거
  MINUS        : 위쪽 집합에서 아래쪽 집합을 제외한 차집합
  INTERSECT    : 위쪽과 아래쪽의 교집합
*/
       
        
-----------------------------------------------------------------
        
CREATE TABLE TB38(
  M1  VARCHAR2(2),
  M2  NUMBER(2)
);
DROP TABLE TB39 PURGE;
CREATE TABLE TB39(
  M1  VARCHAR2(2),
  M3  NUMBER(2)
);        
        
INSERT INTO TB38 VALUES('A', 1); 
INSERT INTO TB38 VALUES('A', 1); 
INSERT INTO TB38 VALUES('B', 1); 

INSERT INTO TB39 VALUES('B', 1); 
INSERT INTO TB39 VALUES('C', 1); 
INSERT INTO TB39 VALUES('C', 1); 

   TB38        TB39 
   M1  M2      M1  M3
   A    1       B  1
   A    1       C  1
   B    1       C  1 

-- GROUPING x

SELECT M1, M2, M3
  FROM (SELECT M1, M2, NULL AS M3 FROM TB38
         UNION ALL 
        SELECT M1, NULL AS M2, M3 FROM TB39)
ORDER BY M1;



-- GROUP BY M1

SELECT M1, SUM(M2) C2, SUM(M3) C3
  FROM (SELECT M1, M2, NULL AS M3 FROM TB38
         UNION ALL 
        SELECT M1, NULL AS M2, M3 FROM TB39)
GROUP BY M1
ORDER BY M1;

        
----------------------------------------------------------------- 

DROP TABLE TB40 PURGE;
CREATE TABLE TB40(
  M1 NUMBER
);

DROP TABLE TB41 PURGE;
CREATE TABLE TB41(
  M1 NUMBER
);

INSERT INTO TB40 VALUES(1);
INSERT INTO TB40 VALUES(1);
INSERT INTO TB40 VALUES(2);

INSERT INTO TB41 VALUES(1);
INSERT INTO TB41 VALUES(3);

COMMIT;

SELECT * FROM TB40;
SELECT * FROM TB41;


SELECT M1 FROM TB40
MINUS
SELECT M1 FROM TB41;

SELECT DISTINCT
       A.M1
  FROM TB40 A
 WHERE NOT EXISTS(SELECT 1
                    FROM TB41 B
                   WHERE B.M1 = A.M1);  

----------------------------------------------------------------- 

DROP TABLE TB42 PURGE;
CREATE TABLE TB42(
  M1 NUMBER
);

DROP TABLE TB43 PURGE;
CREATE TABLE TB43(
  M1 NUMBER
);

INSERT INTO TB42 VALUES(1);
INSERT INTO TB42 VALUES(2);
INSERT INTO TB42 VALUES(2);

INSERT INTO TB43 VALUES(2);
INSERT INTO TB43 VALUES(3);

COMMIT;

SELECT M1 FROM TB42
INTERSECT
SELECT M1 FROM TB43;

SELECT DISTINCT
       A.M1
  FROM TB42 A
 WHERE EXISTS(SELECT 1
               FROM TB43 B
              WHERE B.M1 = A.M1); 

----------------------------------------------------------------------------------------------------------------

DROP TABLE TB43 PURGE;
DROP TABLE TB42 PURGE;

CREATE TABLE TB42(
    M1 NUMBER(4)
);

CREATE TABLE TB43(
    M1 NUMBER(4)
);

INSERT INTO TB42 VALUES(1);
INSERT INTO TB42 VALUES(2);
INSERT INTO TB42 VALUES(2);

INSERT INTO TB43 VALUES(2);
INSERT INTO TB43 VALUES(3);

COMMIT;

SELECT M1 FROM TB42
INTERSECT
SELECT M1 FROM TB43;

SELECT DISTINCT A.M1
FROM TB42 A
WHERE EXISTS (SELECT 1 FROM TB43 B WHERE B.M1 = A.M1);

----------------------------------------------------------------------------------------------------------------

DROP TABLE TB44 PURGE;

CREATE TABLE TB44(
    M1 VARCHAR2(2),
    M2 DATE,
    M3 NUMBER(2)
);

INSERT INTO TB44 VALUES('A', TO_DATE('2050-0101', 'YYYY-MM-DD'), 1);
INSERT INTO TB44 VALUES('A', TO_DATE('2050-0102', 'YYYY-MM-DD'), 1);
INSERT INTO TB44 VALUES('B', TO_DATE('2050-0101', 'YYYY-MM-DD'), 1);
INSERT INTO TB44 VALUES('B', TO_DATE('2050-0102', 'YYYY-MM-DD'), 1);
INSERT INTO TB44 VALUES('C', TO_DATE('2050-0101', 'YYYY-MM-DD'), 1);
INSERT INTO TB44 VALUES('C', TO_DATE('2050-0102', 'YYYY-MM-DD'), 1);

COMMIT;

/*
    ROLLUP: 지정한 표현식(컬럼)의 소계와 총계를 반환. 컬러를 뒤쪽에서 부터 하나씩 제거하는 방식
    
    ROLLUP(A, B), (A), () 
*/

SELECT M1, M2, SUM(M3) AS M3
FROM TB44
GROUP BY ROLLUP (M2, M1), (M1);

SELECT M1, M2, SUM(M3) AS M3
FROM TB44
GROUP BY ROLLUP (M1, M2), M1;

----------------------------------------------------------------------------------------------------------------

SELECT * FROM EMP;

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

-- ROLLUP을 사용하면 소계 및 총계 출력

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO);

SELECT DEPTNO, JOB, SUM(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);

-- DNAME 을 기준으로 소계와 합계 출력

SELECT B.DNAME, A.JOB, SUM(A.SAL) SAL, COUNT(A.EMPNO) EMP_COUNT
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
GROUP BY ROLLUP(B.DNAME, A.JOB)
ORDER BY DNAME;

-- CUBE 를 이용하면 DNAME 과 JOB 모두 기준으로 소계와 합계 출력

SELECT B.DNAME, A.JOB, SUM(A.SAL) SAL, COUNT(A.EMPNO) EMP_COUNT
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO
GROUP BY CUBE(B.DNAME, A.JOB)
ORDER BY DNAME;

----------------------------------------------------------------------------------------------------------------

-- GROUPING SETS : UNION ALL

SELECT JOB, DEPTNO, COUNT(*) AS CNT
FROM EMP
GROUP BY GROUPING SETS(JOB, DEPTNO);

-- 괄호를 두번 감싸주면 다음과 같이 출력

SELECT JOB, DEPTNO, COUNT(*) AS CNT
FROM EMP
GROUP BY GROUPING SETS((JOB, DEPTNO));

SELECT JOB, MGR, DEPTNO, COUNT(*) AS CNT
FROM EMP
GROUP BY GROUPING SETS((JOB, MGR), (JOB, DEPTNO), ());

-- GROUPING 함수는 NULL일 경우 1 반환 

SELECT DECODE(GROUPING(JOB), 1, 'TOTAL', JOB) JOB, DEPTNO, COUNT(*) AS CNT
FROM EMP
GROUP BY GROUPING SETS((JOB, DEPTNO), ());

SELECT DECODE(GROUPING(JOB), 1, 'TOTAL', JOB) JOB, 
           DECODE(GROUPING_ID(JOB, DEPTNO), 1, 'SUM', DEPTNO) DEPTNO,  COUNT(*) AS CNT
FROM EMP
GROUP BY GROUPING SETS((JOB, DEPTNO), ());

----------------------------------------------------------------------------------------------------------------

SELECT EMPNO, ENAME, SAL, RANK() OVER (ORDER BY SAL) AS M1
FROM EMP
WHERE DEPTNO = 30;

/*
    RANGE BETWEEN 50 PRECENDING AND 100 FOLLOWING
    각 행의 SAL 값에서 50 을 빼고 100 을 더한 값 사이의 범위
*/

SELECT EMPNO, ENAME, SAL, COUNT(*) OVER (ORDER BY SAL RANGE BETWEEN 50 PRECEDING AND 100 FOLLOWING) AS M1
FROM EMP
WHERE DEPTNO = 20;

/*
        7369	SMITH	800	800     ( 800-50 ~ 800+100 )
        7566	JONES	2975	5975   ( 2925 ~ 3075 )
        7902	FORD 	3000	5975   ( 2950 ~ 3100 )
*/

----------------------------------------------------------------------------------------------------------------

/*
    SELECT 문의 처리 순서
    FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY
*/

SELECT EMPNO, ENAME, MGR
FROM EMP;

SELECT B.EMPNO, B.ENAME
FROM EMP A, EMP B
WHERE A.ENAME = 'JONES'
    AND B.MGR = A.EMPNO;

/*

   계층 쿼리
   
-- START WITH 절과 CONNECT BY 절로 구성
-- WHERE 절 다음에 기술하지만 실행 순서는 WHERE 절 보다 먼저 실행
-- START WITH 

    PRIOR 연산자 : 직전 상위 노드의 값을 반환

*/

SELECT EMPNO, ENAME, MGR
FROM EMP
START WITH ENAME = 'JONES'
CONNECT BY PRIOR EMPNO = MGR;






