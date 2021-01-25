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

/*
    CASE 함수
    CASE WHEN 조건 THEN 출력
            ELSE 출력
    END AS 어쩌구
*/
