/* ================================================

    VIEW 
    
    기존 테이블의 정보로부터 생성되는 가상 테이블
    (디스크 저장 공간이 할당되지 않음)
    
================================================ */

/*
    학생 테이블에서 101 학과 학생들의 뷰 생성
*/

CREATE VIEW V_STUDENT_101 (학번, 이름, 학과번호)
AS SELECT STUDNO, NAME, DEPTNO
     FROM STUDENT
     WHERE DEPTNO = 101;
     
SELECT * FROM V_STUDENT_101;

/*
    학생 테이블과 부서 테이블을 조인해 102 번 학과 학생들의 복합 뷰 생성
*/

CREATE VIEW V_STUDENT_102 (학번, 이름, 학년, 학과이름)
AS SELECT S.STUDNO, S.NAME, S.GRADE, D.DNAME
     FROM STUDENT S, DEPARTMENT D
     WHERE S.DEPTNO = D.DEPTNO
         AND S.DEPTNO = 102;

SELECT * FROM V_STUDENT_102;

/*
    교수 테이블에서 학과별 평균 급여와 총계로 정의되는 뷰 생성
*/

CREATE VIEW V_PROFESSOR_SAL (학과, 평균급여, 총계)
AS SELECT DEPTNO, AVG(SAL), SUM(SAL)
     FROM PROFESSOR
     GROUP BY DEPTNO;

SELECT * FROM V_PROFESSOR_SAL;

/* ================================================
    
    INLINE VIEW
    
    검색할 때 일회용으로 사용하는 테이블, 가상 뷰
    
================================================ */

/*
    인라인 뷰를 사용해 학과별 학생들의 평균 키와 평균 몸무게, 학과 이름을 출력
*/

SELECT DNAME, AVG_HEIGHT, AVG_WEIGHT
FROM (SELECT DEPTNO, AVG(HEIGHT) AS AVG_HEIGHT, AVG(WEIGHT) AS AVG_WEIGHT
           FROM STUDENT
           GROUP BY DEPTNO) S, DEPARTMENT D
WHERE S.DEPTNO = D.DEPTNO;

/* ================================================
    
    RANK() OVER (ORDER BY column) : 출력 결과에 순위를 부여하는 함수
                                                     WHERE 절에서 BETWEEN 을 이용해 범윙 지정 가능
    
================================================ */

/*
    인라인 뷰를 이용해 모든 학생 중 몸무게가 적은 순으로 상위 5명 출력
*/

SELECT STUDNO, NAME, WEIGHT, RANKING
FROM (SELECT STUDNO, NAME, WEIGHT, RANK() OVER (ORDER BY WEIGHT) RANKING
           FROM STUDENT)
WHERE RANKING BETWEEN 1 AND 5;

/* ================================================
    
    USER_VIEWS          (VIEW_NAME, TEXT)
    
    뷰의 정의를 저장한 시스템 테이블 (데이터 딕셔너리에 있다)
    
================================================ */

SELECT VIEW_NAME, TEXT
FROM USER_VIEWS;

/* ================================================
    
    VIEW 변경 : CREATE OR REPLACE 옵션
    
================================================ */

/*
    기존에 있는 V_STUD_101 뷰에 학년 컬럼을 추가해 재정의
*/

CREATE OR REPLACE VIEW V_STUD_101 ( 학번, 이름, 학과번호, 학년)
AS SELECT STUDNO, NAME, DEPTNO, GRADE
     FROM STUDENT
     WHERE DEPTNO = 101;
     
SELECT * FROM V_STUD_101;

/* ================================================
    
    VIEW 삭제 : DROP VIEW view;
    
================================================ */

/*
    학생 테이블과 관련된 모든 뷰 삭제
*/

DROP VIEW V_STUDENT_101;
DROP VIEW V_STUDENT_102;
DROP VIEW V_STUD_101;

SELECT VIEW_NAME, TEXT
FROM USER_VIEWS
WHERE VIEW_NAME LIKE 'V_STUD%';

-- ================================================ --

CREATE TABLE V_TABLE(
    A NUMBER(4),
    B NUMBER(4)
);

CREATE OR REPLACE VIEW V_1
AS SELECT A, B
     FROM V_TABLE;
     
INSERT INTO V_1
VALUES (1, 2);

SELECT * FROM V_1;
SELECT * FROM V_TABLE;

/* ================================================
    
    VIEW 생성 - WITH READ ONLY 옵션
    
    WITH READ ONLY 옵션을 이용해 뷰를 생성할 경우 
    뷰를 이용해 데이터 삽입 삭제가 불가능하며
    데이터를 읽는 것만 가능
================================================ */

CREATE VIEW V_2
AS SELECT A, B
     FROM V_1
WITH READ ONLY;

INSERT INTO V_1
VALUES (3, 4);

INSERT INTO V_1
VALUES (5, 6);

INSERT INTO V_1
VALUES (7, 8);

SELECT * FROM V_1;
SELECT * FROM V_TABLE;

/* ================================================
    
    VIEW 생성 - WITH CHECK OPTION
    
    WHERE 로 COLUMN에 조건을 지정할 수 있으며 해당 COLUMN 만 조건 검사
    
================================================ */

DROP VIEW V_3;

CREATE VIEW V_3
AS SELECT A, B
     FROM V_TABLE
     WHERE A = 3
WITH CHECK OPTION;

SELECT * FROM V_3;

-- 다음 코드의 오류 : view WITH CHECK OPTION where-clause violation

UPDATE V_3 
SET A = 7
WHERE B = 4;

SELECT * FROM V_3;
SELECT * FROM V_TABLE;

-- 다음은 오류가 나지 않는다. OPTION 이 A 에 달렸기 때문

UPDATE V_3 
SET B = 44
WHERE A = 3;

/*
    학과 번호가 101 인 교수를 나타내는 PROFESSOR VIEW 생성
*/

DESC PROFESSOR;

SELECT * FROM PROFESSOR;

CREATE VIEW V_PROF_101
AS SELECT PROFNO, NAME, SAL, DEPTNO
     FROM PROFESSOR
     WHERE DEPTNO = 101
WITH CHECK OPTION;

SELECT * FROM V_PROF_101;

-- 다음 문장은 오류를 포함 : view WITH CHECK OPTION where-clause violation

INSERT INTO V_PROF_101
VALUES(9933, '민윤기', 700, 201);

-- 다음은 오류가 나지 않는다. OPTION인 DEPTNO이 101이기 때문

INSERT INTO V_PROF_101
VALUES(9933, '민윤기', 700, 101);

SELECT * FROM V_PROF_101;
SELECT * FROM PROFESSOR;

/*
    VIEW 에서 DATA 삭제
*/

DELETE FROM V_PROF_101
WHERE NAME = '민윤기';

/*
    PROFESSOR 테이블과 DEPARTMENT 테이블을 조회하여 
    교수 이름과 학과 이름을 출력하는 VIEW 생성
*/

CREATE VIEW PROF_DEPT (교수이름, 학과이름)
AS SELECT P.NAME, D.DNAME
     FROM PROFESSOR P, DEPARTMENT D
     WHERE P.DEPTNO = D.DEPTNO;

SELECT * FROM PROF_DEPT;

/*
    INLINE VIEW 를 이용해
    PROFESSOR 테이블과 DEPARTMENT 테이블을 조회하여 
    학과 번호와 학과 이름, 학과별 최대 급여 출력
*/

SELECT P.DEPTNO, D.DNAME, P.SAL_MAX
FROM (SELECT DEPTNO, MAX(SAL) AS SAL_MAX
           FROM PROFESSOR 
           GROUP BY DEPTNO) P, DEPARTMENT D
WHERE P.DEPTNO = D.DEPTNO;

SELECT DEPTNO, PROFNO, NAME
FROM PROFESSOR;

/* ================================================
    LAG(column) OVER (ORDER BY column) : 이전 행 (row) 의 값을 리턴
    
    LAG(EXPRESSTION, OFFSET, DEFAULT) OVER (ORDER BY column)
    
    EXPRESSTION : 컬럼이름이나 그룹함수 (SUM, COUNT, AVG, MIN, MAX)
    OFFSET : 몇 번째 이전의 ROW 값을 가져올지 설정 (DEFAULT : 1)
    DEFAULT : 이전 ROW 값이 없는 경우 반환되는 값 (DEFAULT : NULL)
================================================ */

SELECT DECODE(DEPTNO, NDEPTNO, NULL, DEPTNO) DEPTNO, PROFNO, NAME
FROM (SELECT LAG(DEPTNO) OVER (ORDER BY DEPTNO) NDEPTNO, DEPTNO, PROFNO, NAME
          FROM PROFESSOR);

/*
    교수 테이블과 학과 테이블을 조회하여 교수번호, 이름, 소속학과 이름을 출력하는 뷰 생성
*/

SELECT PROFNO, NAME, DNAME
FROM (SELECT P.PROFNO, P.NAME, D.DNAME
          FROM PROFESSOR P, DEPARTMENT D
          WHERE P.DEPTNO = P.DEPTNO);
          
/*
    INLINE VIEW 를 이용해 STUDENT 테이블과 DEPARTMENT 테이블에서 
    학과별 학생들의 최대 키와 몸무게, 학과 이름을 출력
*/

SELECT D.DNAME, P.MAX_WEI, P.MAX_HEI
FROM (SELECT DEPTNO, MAX(WEIGHT) AS MAX_WEI, MAX(HEIGHT) AS MAX_HEI
           FROM STUDENT
           GROUP BY DEPTNO) P, DEPARTMENT D
WHERE P.DEPTNO = D.DEPTNO;

/*
    STUDENT 테이블과 DEPARTMENT 테이블을 이용해 학과 이름, 학과별 최대 키,
    학과별 키가 제일 큰 학생의 이름과 키를 INLINE VIEW 를 이용해 출력
*/
SELECT PD.DNAME, PD.MAX_HEI, SS.NAME, SS.HEIGHT
FROM (SELECT D.DNAME AS DNAME, P.MAX_HEI AS MAX_HEI
          FROM (SELECT DEPTNO, MAX(HEIGHT) AS MAX_HEI
                     FROM STUDENT
                     GROUP BY DEPTNO) P , DEPARTMENT D
          WHERE P.DEPTNO = D.DEPTNO) PD, STUDENT SS
WHERE PD.MAX_HEI = SS.HEIGHT;

-- 다음과 같이 하는게 더 깔끔

SELECT D.DNAME, G.MAX_HEI, S.NAME, S.HEIGHT
FROM (SELECT DEPTNO, MAX(HEIGHT) AS MAX_HEI
           FROM STUDENT
           GROUP BY DEPTNO) G, STUDENT S, DEPARTMENT D
WHERE G.DEPTNO = D.DEPTNO
    AND G.MAX_HEI = S.HEIGHT;

/*
    INLINE VIEW 를 이용해 STUDENT 테이블에서 같은 학년의 평균 키보다 큰 학생들의
    이름과 키, 해당 학년의 평균 키를 오름차순으로  출력
*/

SELECT S.GRADE, S.NAME, S.HEIGHT, A.AVG_HEIGHT
FROM (SELECT GRADE, AVG(HEIGHT) AS AVG_HEIGHT
          FROM STUDENT
          GROUP BY GRADE) A, STUDENT S
WHERE A.GRADE = S.GRADE
AND S.HEIGHT > A.AVG_HEIGHT
ORDER BY S.GRADE ASC;

/*
    PROFESSOR 테이블에서 급여 순위와 교수 이름, 급여 출력
    급여가 많은 사람부터 1~5 위까지 출력
*/

SELECT ROWNUM AS RANKING, NAME, SAL
FROM (SELECT NAME, SAL
           FROM PROFESSOR
           ORDER BY SAL DESC)
WHERE ROWNUM BETWEEN 1 AND 5;

/* ================================================

    인덱스 실행 계획
    
 ================================================ */
 
 /*
    학과 테이블에서 학과 이름이 '정보미디어학부' 인 학과의 학과 번호와 이름 출력
 */
 
 SELECT DEPTNO, DNAME
 FROM DEPARTMENT
 WHERE DNAME = '정보미디어학부';
 
 SELECT TABLE_NAME, INDEX_NAME, UNIQUENESS
 FROM USER_INDEXES 
 WHERE TABLE_NAME = 'DEPARTMENT';
 
ALTER INDEX IDX_DEPT_NAME MONITORING USAGE;
 
 SELECT INDEX_NAME, USED
 FROM V$OBJECT_USAGE
 WHERE INDEX_NAME = 'IDX_DEPT_NAME';
 
-- CREATE OR REPLACE VIEW V_ALL_INDEX_USAGE
-- (INDEX_NAME, TABLE_NAME, OWNER_NAME, MONITORING, USED, START_MONITORING, END_MONITORING)
-- AS SELECT A.NAME, B.NAME, E.NAME,
--                  DECODE(BITAND (C.FLAGS, 65536), 0, 'NO', 'YES'),
--                  DECODE(BITAND (D.FLAGS, 1), 0, 'NO', 'YES'),
--                  D.START_MONITORING, D.END_MONITORING
--      FROM SYS.OBJ$ A, SYS.OBJ$ B, SYS.IND$ C, SYS.USER$ E, SYS.OBJECT_USAGE D
--      WHERE C.OBJ# = D.OBJ#
--          AND A.OBJ# = D.OBJ#
--          AND B.OBJ# = C.OBJ#
--          AND E.USER# = A.OWNER#;
 
 /* ================================================
 
    INDEX REBUILD 하기
    
 ================================================ */
 
-- INDEX REBUILD 하기 -- 

-- IDX_TEST 테이블 생성하기
DROP TABLE IDX_TEST PURGE;
CREATE TABLE IDX_TEST(
  NO NUMBER
);

-- PL/SQL 명령문으로 INSERT 하기
BEGIN
  FOR i IN 1..10000 LOOP
    INSERT INTO IDX_TEST VALUES(i);
  END LOOP;
  COMMIT;
END;
/

-- IDX_TEST 테이블 조회하기
SELECT * FROM IDX_TEST;

-- IDX_NO 인덱스 생성하기
CREATE INDEX IDX_NO ON IDX_TEST(NO);

-- IDX_NO 인덱스 상태 분석하기
ANALYZE INDEX IDX_NO VALIDATE STRUCTURE;

-- IDX_NO 인덱스 상태값 : (DEL_LF_ROWS_LEN / LF_ROWS_LEN) * 100  알아보기
SELECT (DEL_LF_ROWS_LEN / LF_ROWS_LEN) * 100 BALANCE
FROM INDEX_STATS
WHERE NAME = 'IDX_NO';  -- 0 : 0 에 가까울 수록 좋은 상태

DESC INDEX_STATS;
SELECT NAME FROM INDEX_STATS;

-- IDX_TABLE 에서 DML 작업하기
 DELETE FROM IDX_TEST
 WHERE NO BETWEEN 1 AND 4000;

-- DML 작업 후 IDX_NO 인덱스 분석 및 상태 확인하기
ANALYZE INDEX IDX_NO VALIDATE STRUCTURE;

SELECT ROUND( (DEL_LF_ROWS_LEN / LF_ROWS_LEN) * 100, 2) BALANCE
FROM INDEX_STATS
WHERE NAME = 'IDX_NO';

-- 흐트러진 밸런싱 REBUILD 하기
ALTER INDEX IDX_NO REBUILD;

-- REBUILD 후 상태 확인하기
ANALYZE INDEX IDX_NO VALIDATE STRUCTURE;

SELECT ROUND( (DEL_LF_ROWS_LEN / LF_ROWS_LEN) * 100, 2) BALANCE
FROM INDEX_STATS
WHERE NAME = 'IDX_NO';
 
  /* ================================================
 
    INDEX 활용하기
    
 ================================================ */
 
 CREATE TABLE EMP (
    ENO NUMBER(4),
    ENAME VARCHAR2(20),
    SAL NUMBER(4)
);

INSERT INTO EMP VALUES(1001, '이순신', 900);
INSERT INTO EMP VALUES(1002, '안중근', 800);
INSERT INTO EMP VALUES(1003, '김유신', 700);
INSERT INTO EMP VALUES(1004, '유관순', 600);
INSERT INTO EMP VALUES(1005, '윤봉길', 500);
INSERT INTO EMP VALUES(1006, '양만춘', 400);
 
 COMMIT;
 
 SELECT * FROM EMP;
 
 /*
    ENAME 컬럼에 INDEX 생성
 */
 
CREATE INDEX IDX_ENAME ON EMP(ENAME);

-- INDEX 를 사용하지 않은 검색
SELECT ENAME FROM EMP;

-- INDEX 를 사용한 검색
SELECT ENAME FROM EMP
WHERE ENAME > '0'; -- INDEX 를 사용하라는 의미
 
 -- MIN() : INDEX의 가장 첫 번째 DATA
 -- MAX() : INDEX의 가장 마지막 DATA
 
 -- INDEX 를 사용하지 않은 검색
 -- 정렬 발생
 SELECT MIN(ENAME)
 FROM EMP;
 
 -- INDEX (ROWNUM) 을 사용한 검색
 -- 정렬 발생하지 않음
 SELECT ENAME FROM EMP
 WHERE ENAME > '0'
 AND ROWNUM = 1;
 
 /*
    힌트?
 */
 SELECT /*+ INDEX_DESC(E INX_ENAME) */ ENAME
 FROM EMP E
 WHERE ENAME > '0'
 AND ROWNUM = 1;
 
 /*
    ROWID
    
    ORACLE 에서 사용하는 DATA 의 주소를 의미   
    
    ROWNUM
    
    행 번호
 */
 
 SELECT ROWID, ENO, ENAME
 FROM EMP
 WHERE ENO = 1004;
