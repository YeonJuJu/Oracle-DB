/*
    INDEX
    
    -> 해당 컬럼에 중복된 값이 있으면 생성 불가능
*/

/*
    부서 테이블에서 NAME 컬럼을 고유 인덱스로 생성
    고유 인덱스의 이름 =  IDX_DEPT_NAME 
*/

CREATE UNIQUE INDEX IDX_DEPT_NAME
ON DEPARTMENT(DNAME);

/*
    NON UNIQUE INDEX
    
    -> 해당 컬럼에 중복되는 값이 있어도 생성 가능
        하나의 인덱스 키는 테이블의 여러 행과 연결 가능
*/

/*
    학생 테이블의 BIRTHDATE 컬럼을 비고유 인덱스로 생성
    비고유 인덱스의 이름 = IDX_STUD_BIRTHDATE
*/

CREATE INDEX ID_STUD_BIRTHDATE
ON STUDENT(BIRTHDATE);

/*
    단일 인덱스
    => 하나의 컬럼으로만 구성된 인덱스
    
    결합 인덱스
    => 두 개 이상의 컬럼을 결합하여 생성하는 인덱스
*/

-- 결합 인덱스 생성

CREATE INDEX IDX_STUD_DNO_GRADE
ON STUDENT(DEPTNO, GRADE);

/*
    인덱스 생성시 오름차순, 내림차순 설정
    => ASC, DESC
*/

CREATE INDEX IDX_STUD_NO_NAME
ON STUDENT(DEPTNO DESC, NAME ASC);

/*
    함수 기반 인덱스 생성
    
    => 함수 기반 인덱스 생성시 QUERY REWRITE 권한이 필요
         SYSTMEM 계정으로 로그인해서 GRANT QUERY REWRITE TO TJOEUN 하쇼
*/

CREATE INDEX FIDX_STANDARD_WEIGHT
ON STUDENT ( (HEIGHT - 100) * 0.9 );


