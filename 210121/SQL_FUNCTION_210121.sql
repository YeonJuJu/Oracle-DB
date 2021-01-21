-- SQL FUNCTION --

-- 문자 함수 --

-- ==== INITCAP() UPPER() LOWER() ==== --
-- INITCAP() : 첫 문자만 대문자로 출력
-- UPPER() : 대문자로 출력
-- LOWER() : 소문자로 출력

/* 
    학생 테이블에서 김진영 학생의 이름과 사용자 아이디를 출력하세요
    사용자 아이디를 첫 문자만 대문자로 출력하세요
    사용자 아이디를 대문자로 출력하세요
    사용자 아이디를 소문자로 출력하세요
*/

SELECT NAME, USERID, INITCAP(USERID), UPPER(USERID), LOWER(USERID)
FROM STUDENT
WHERE NAME = '김진영';

/*
    학번이 20101 인 학생의 사용자 아이디를 소문자와 대문자로 변환해서 출력하세요
*/

SELECT STUDNO, NAME, USERID, LOWER(USERID), UPPER(USERID)
FROM STUDENT
WHERE STUDNO = 20101;

-- ==== LENGTH() LENGTHB() ==== --
-- LENGTH() : 문자열 길이
-- LENGTHB() : 문자열의 바이트 수

SELECT LENGTH('이순신') FROM DUAL;
SELECT LENGTHB('이순신') FROM DUAL;

/*
    부서 테이블에서 부서 이름의 길이를 문자 수와 바이트 수로 각각 출력
*/

SELECT DNAME, LENGTH(DNAME), LENGTHB(DNAME)
FROM DEPARTMENT;

DROP TABLE DEPARTMENT PURGE;

CREATE TABLE DEPARTMENT
        (DEPTNO NUMBER(4)
                CONSTRAINT dept_no_pk PRIMARY KEY,
         DNAME VARCHAR2(30)
                CONSTRAINT dept_name_nn NOT NULL,
         COLLEGE NUMBER(4),
         LOC VARCHAR2(10));

INSERT INTO DEPARTMENT VALUES
        (101, '컴퓨터공학과', 100, '1호관');

INSERT INTO DEPARTMENT VALUES
        (102, '멀티미디어학과', 100, '2호관');

INSERT INTO DEPARTMENT VALUES
        (201, '전자공학과', 200, '3호관');

INSERT INTO DEPARTMENT VALUES
        (202, '기계공학과', 200, '4호관');

INSERT INTO DEPARTMENT VALUES
        (100, '정보미디어학부', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (200, '메카트로닉스학부', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (10, '공과대학', NULL, NULL);
        
-- ==== STRING MANIPULATION FUNCTION : 문자 조작 함수 ==== --
-- CONCAT(A,B) : 문자열 A 와 B 연결해 출력
-- SUBSTR(STR, a, b) : STR 의 INDEX a 부터 b 개 출력 (SQL 은 1부터 인덱스 시작)
-- INSTR(STR, TOKEN) : STR 안에 TOKEN 의 INDEX 리턴
-- LPAD(STR, NUM, TOKEN) : 왼쪽 정렬. STR이 NUM보다 짧은 경우 남은 자리는 TOKEN 으로 채움
-- RPAD(STR, NUM, TOKEN) : 오른쪽 정렬. STR이 NUM보다 짧은 경우 남은 자리는 TOKEN 으로 채움
-- LTRIM('*STR', '*') : 왼쪽에 STR 전 TOKEN 제거
-- RTRIM('*STR', '*') : 오른쪽에 STR 전 TOKEN 제거

SELECT CONCAT('HELLO', 'ORACLE'), SUBSTR('SQL * PLUS', 5, 4), INSTR( 'SQL * PLUS', '*')
FROM DUAL;

SELECT LPAD('SQL', 5, '*'), RPAD('SQL', 5, '*')
FROM DUAL;

SELECT LTRIM('*SQL', '*'), RTRIM('SQL*', '*')
FROM DUAL;

/*
    학생 테이블에서 1학년 학생의 주민등록번호에서 태어난 년도와 태어난 날을 추출하여
    등록번호, 생년월일, 태어난 달을 출력
*/

DESC STUDENT;

SELECT 19 || SUBSTR(IDNUM, 1, 2) AS "BIRTHYEAR", SUBSTR(IDNUM, 3, 2) AS "BIRTHMONTH", SUBSTR(IDNUM, 5, 2) AS "BIRTHDAY"
FROM STUDENT
WHERE GRADE = 1;

/*
    부서 테이블의 부서 이름 컬럼에서 '과' 글자의 위치를 출력하세요
*/

SELECT DNAME, INSTR(DNAME, '과')
FROM DEPARTMENT;

/*
    학생 테이블의 전화번호 컬럼에서 지역번호를 출력
*/

SELECT NAME, SUBSTR(TEL, 1, INSTR(TEL, ')')-1) AS "지역번호"
FROM STUDENT;

/*
    교수 테이블에서 직급 컬럼의 왼쪽에 '*' 문자를 삽입하여 10BYTES로 출력하고
    교수 아이디 컬럼은 오른쪽에 '+' 문자를 삽입하여 12BYTES로 출력
*/

SELECT NAME, LPAD(POSITION, 10, '*') AS LPAD_POSITION, RPAD(USERID, 12, '+') AS RPAD_POSITION 
FROM PROFESSOR;

/*
    부서 테이블에서 부서 이름의 마지막 글자인 '과'를 삭제해서 출력하세요
*/

SELECT RTRIM(DNAME, '과') AS  부서이름
FROM DEPARTMENT;

-- ==== 숫자 처리 함수 ==== --
-- ROUND(숫자 자릿수) : 자릿수+1 에서 반올림
-- TRUNC(숫자, 자릿수) : 자릿수까지 표현
-- MOD(A, B) : A MOD B
-- CEIL() : 올림
-- FLOOR() : 내림

/*
    교수 테이블에서 101 번 학과 교수의 일급을 계산하여 (월 근무 일수를 22일로 함)
    소수점 첫 째자리와 셋 째자리에서 반올림한 결과
    소수점 왼쪽 첫 째자리에서 반올림한 값을 출력 = 정수 출력
*/

SELECT ROUND(SAL/22, 1), ROUND(SAL/22, 3), ROUND(SAL/22, -1) 
FROM PROFESSOR
WHERE DEPTNO=101;










