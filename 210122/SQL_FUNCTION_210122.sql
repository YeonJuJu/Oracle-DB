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
-- MOD(A, B) : A MOD B 나머지 연산자
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

/*
    교수 테이블에서 101 번 학과 교수의 일급을 계산하여 (월 근무 일수를 22일로 함)
    소수점 첫 째자리와 셋 째자리에서 절삭한 결과와
    소수점 왼쪽 첫 째자리에서 절삭한 값을 출력 = 정수 출력
*/

SELECT TRUNC(SAL/22, 1), TRUNC(SAL/22, 3), TRUNC(SAL/22, -1) 
FROM PROFESSOR
WHERE DEPTNO=101;

/*
    교수 테이블에서 101 번 학과 교수의 급여를 보직수당으로 나눈 나머지를 출력
*/

SELECT NAME, SAL, COMM, MOD(SAL,COMM) AS MOD
FROM PROFESSOR
WHERE DEPTNO = 101;

/*
SELECT NAME, SAL, COMM, MOD(SAL,NVL(COMM, 0)) AS MOD
FROM PROFESSOR
WHERE DEPTNO = 101;
*/

-- ==== 날짜 함수 ==== --

/*
    교수 번호가 9908 인 교수의 입사일을 기준으로 입사 30일 후와 60일 후의 날짜를 출력
*/

SELECT PROFNO, NAME , HIREDATE, HIREDATE+30 AS AFTER30 , HIREDATE+60 AS AFTER60
FROM PROFESSOR
WHERE PROFNO = 9908;

-- SYSDATE --

/*
    시스템의 현재 날짜 출력
*/

SELECT SYSDATE FROM DUAL;

/*
    TO_CHAR(날짜, 'YYYY/MM/DD')
    TO_CHAR(날짜, 'YY/MM/DD HH24:MI:SS')
*/

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24:MI:SS') FROM DUAL;

/*
    MONTHS_BETWEEN(DATE1, DATE2)
    ADD_MONTHS(DATE, 개월 수)
*/

/*
    입사한지 360 개월 미만인 교수의 교수번호, 입사일, 입사일로부터 현재까지의 개월 수,
    입사일에서 6개월 후의 날짜를 출력하세요.
*/

SELECT PROFNO, HIREDATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE), 2), ADD_MONTHS(HIREDATE, 6)
FROM PROFESSOR
WHERE MONTHS_BETWEEN(HIREDATE, SYSDATE) < 360;

/*
    LAST_DAY(DATE) : DATE 날짜가 속한 달의 마지막 날짜
    NEXT_DAY(DATE, 'DAY') : DATE 날짜 이후 첫 번째 DAY 요일 계산
*/

SELECT SYSDATE, LAST_DAY(SYSDATE), NEXT_DAY(SYSDATE, '토')
FROM DUAL;

/*
    ROUND(), TRUNC()
*/

SELECT TO_CHAR(SYSDATE, 'YY/MM/DD HH24:MI:SS') AS PRE,
        TO_CHAR(ROUND(SYSDATE),  'YY/MM/DD HH24:MI:SS') AS ROUND,
        TO_CHAR(TRUNC(SYSDATE),  'YY/MM/DD HH24:MI:SS') AS TRUNC
FROM DUAL;

/*
    101 번 학과 교수들의 입사일을 일, 월, 년을 기준으로 반올림해서 출력
*/

SELECT NAME, HIREDATE
            , ROUND (TO_DATE (HIREDATE),'YEAR') AS YEAR_ROUND
            , ROUND (TO_DATE (HIREDATE),'MONTH') AS MONTH_ROUND
            , ROUND (TO_DATE (HIREDATE),'DAY') AS DAY_ROUND
FROM PROFESSOR
WHERE DEPTNO=101;

SELECT NAME, HIREDATE
            , ROUND (HIREDATE,'YEAR') AS YEAR_ROUND
            , ROUND (HIREDATE,'MONTH') AS MONTH_ROUND
            , ROUND (HIREDATE,'DAY') AS DAY_ROUND
FROM PROFESSOR
WHERE DEPTNO=101;

-- ==== DATA TYPE 변한 ==== --

/*
    묵시적 데이터 타입 변환
*/

DESC STUDENT;

-- STUDNO 은 NUMBER TYPE

SELECT STUDNO, NAME
FROM STUDENT
WHERE STUDNO = '10102';

SELECT STUDNO, NAME
FROM STUDENT
WHERE STUDNO = '0102';

-- GRADE 는 VARCHAR TYPE

SELECT STUDNO, NAME, GRADE
FROM STUDENT
WHERE GRADE = '4';

SELECT STUDNO, NAME, GRADE
FROM STUDENT
WHERE TO_NUMBER(GRADE) = 4;

-- 명시적 데이터 타입 변환 
-- TO_CHAR() TO_NUMBER() TO_DATE()

-- 날짜 표현 형식 --

/*
    현재 날짜에 대해 세기, 연도, 요일 출력
                            CC    YYYY DAY
*/

SELECT SYSDATE, TO_CHAR(SYSDATE, 'CC') AS 세기, TO_CHAR(SYSDATE, 'YYYY') AS 연도, TO_CHAR(SYSDATE, 'DAY') AS 요일
FROM DUAL;

/*
    학생 테이블에서 천인하 학생의 학번과 생년월일 중에서 년월만 출력하세요
*/

SELECT STUDNO, NAME, TO_CHAR(BIRTHDATE, 'YYYY-MM') AS BIRTH
FROM STUDENT
WHERE NAME='전인하';

/*
    학생 테이블에서 102 번 학생의 이름, 학년, 생년월일 출력
    생년월일 -> 요일, 날, 월, 년도 로 출력
*/

SELECT NAME, GRADE, TO_CHAR(BIRTHDATE, 'DAY, DD, MONTH, YYYY') AS BIRTH
FROM STUDENT
WHERE DEPTNO = 102;

-- 시간 표현 형식 --

/*
    교수 테이블에서 101 번 학과 교수의 이름과 입사일을 출력
    입사일 -> 달 날짜, 년도, 시간(24):분:초 (오전/오후)
*/

SELECT NAME, HIREDATE, TO_CHAR(HIREDATE, 'MM DD YYYY HH24:MI:SS PM') AS HIREDATE2
FROM PROFESSOR
WHERE DEPTNO = 101;

-- 그 외 날짜 표현 형식 --

/*
    교수 테이블에서 101 번 학과 교수의 이름과 직급, 입사일을 출력
    입사일 -> 월(앞에 세 글자) THE 날짜(서수) OF 년도
*/

SELECT NAME, POSITION, TO_CHAR(HIREDATE, 'MON "THE" DDTH "OF" YYYY') AS HIREDATE
FROM PROFESSOR
WHERE DEPTNO = 101;

/*
    보직 수당을 받는 교수들의 이름, 급여, 보직수당,
    급여와 보직수당을 더한 값에 12 곱한 결과를 연봉으로 출력
*/

SELECT NAME, SAL, COMM, (SAL+COMM)*12 AS 연봉
FROM PROFESSOR
WHERE COMM IS NOT NULL;

-- N,NNN

SELECT NAME, SAL, COMM, TO_CHAR((SAL+COMM)*12, '9,999') AS 연봉
FROM PROFESSOR
WHERE COMM IS NOT NULL;

-- TO_DATE() --

/*
    교수 테이블에서 입사일이 'JUNE 01, 01'인 교수의 이름과 입사일을 출력
*/

SELECT NAME, HIREDATE
FROM PROFESSOR
WHERE HIREDATE = TO_DATE('6월 01, 01', 'MONTH DD, YY');

-- 중첩함수

/*
    주민등록번호에서 생년월일을 추출해서 'YY/MM/DD' 형식으로 출력
*/

SELECT NAME, TO_CHAR(TO_DATE(SUBSTR(IDNUM, 1, 6), 'YYMMDD'), 'YY/MM/DD') AS BIRTHDATE
FROM STUDENT;

-- NVL(COLUMN, NULL대체값) => 해당 컬럼의 NULL 값을 대체값으로 변환하여 출력
-- NVL2(COLUMN, NULL아닐때반환값, NULL일때대체값)

/*
    201 번 학과 교수의 이름, 직급, 급여, 보직수당, 보직수당+급여 출력
    급여 = 기본급여 + 보직수당
    보직수당이 null 인 경우 0으로 계산
*/

SELECT NAME, POSITION, SAL+NVL(COMM, 0) AS 급여
FROM PROFESSOR
WHERE DEPTNO=201;

SELECT NAME, POSITION, NVL(COMM+SAL, SAL) AS 급여
FROM PROFESSOR
WHERE DEPTNO=201;

/*
    102 번 학과 교수 중 보직수당을 받는 사람은 급여와 보직수당을 더한 값을 급여 충액으로 출력
    단, 보직 수당을 받지 않는 교수는 급여만 급여 총액으로 출력
*/

SELECT NAME, POSITION, SAL, COMM, NVL2(COMM, SAL+COMM, SAL) AS 급여총액
FROM PROFESSOR
WHERE DEPTNO = 102;

-- NULLIF(EXPRESSION1, EXPRESSION2) 
-- 두개 값이 동일하면 NULL 리턴, 다르면 EXPRESSION1 리턴

/*
    교수 테이블에서 이름의 바이트 수와 사용자 아이디의 바이트 수가
    일치하면 NULL 출력, 일치하지 않으면 이름의 바이트 수 출력
*/

SELECT NAME, USERID, NULLIF(LENGTHB(NAME), LENGTHB(USERID)) AS BYTE
FROM PROFESSOR;

-- COALESCE() : 인수 중 NULL이 아닌 첫 번째 인수를 반환하는 함수 (NVL 확장 함수)--

/*
    교수 테이블에서 보직수당이 NULL 이 아니면 보직수당을 출력하고
    보직수당이 NULL 이고 급여가 NULL 이 아니면 급여를 출력,
    보직수당과 급여가 NULL 이면 0을 출력
*/

SELECT NAME, COMM, SAL, COALESCE(COMM, SAL, 0) AS ISNULL
FROM PROFESSOR;

/*
    DECODE(EXPRESSION OR COLUMN | SEARCH1, RESULT1, ..., DEFUALT) : 
    첫 번째 인자가 SEARCH1과 일치하면 RESULT1을 반환 
    일치하는 값이 없거나 NULL 인 경우에는 디폴트 값 반환
    디폴트 값이 없는 경우 NULL 반환
*/

/*
    교수 테이블에서 교수의 소속 학과번호를 학과 이름으로 변환하여 출력
*/

SELECT NAME, DECODE(DEPTNO, 101, '컴퓨터공학과', 102, '멀티미디어학과', 201, '전자공학과', '기계공학과') AS DEPTNAME
FROM PROFESSOR;

/*
    102 번 학과 학생들 중에서 주민등록번호 7번째 숫자가 1인 경우에는 '남자',
    2인 경우에는 '여자' 로 출력
*/

SELECT NAME, STUDNO, IDNUM, DECODE(SUBSTR(IDNUM, 7, 1), 1, '남자', 2, '여자', '외계인') AS 성별
FROM STUDENT
WHERE DEPTNO = 102;





















