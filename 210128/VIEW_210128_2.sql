SELECT * FROM TAB;

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

/*
    SCOTT 사용자의 EMP 테이블에 있는 7499 번 사원의 MGR 은 7902로,
    SAL 은 1700 으로 수정
*/

UPDATE SCOTT.EMP 
SET MGR = 1902, SAL = 1700
WHERE EMPNO = 7499;

SELECT * FROM EMP;