 /*
    MERGE
    
    구조가 같은 두 개의 테이블을 비교하여 하나의 테이블로 합침
 */
 
 /*
    PROFESSOR 테이블과 PROFESSOR_TMP 테이블을 비교해
    PROFESSOR 테이블에 있는 기존 데이터는 PROFESSOR_TMP 테이블의 
    데이터에 의해 수정하고 PROFESSOR 테이블에 없는 데이터는 새로 입력
 
    PROFESSOR 테이블에서 직급이 교수인 교수들만으로 구성된 PROFESSOR_TMP 생성
 */
 
 -- AS 키워드를 이용해 쿼리의 결과로 테이블 생성 --
 
 CREATE TABLE PROFESSOR_TMP 
 AS
 SELECT * 
 FROM PROFESSOR
 WHERE POSITION = '교수';
 
 SELECT * FROM PROFESSOR_TMP;
 
 /*
    PROFESSOR_TMP 테이블의 교수 직급을 명예 교수로 변경
 */
 
 UPDATE PROFESSOR_TMP
 SET POSITION = '명예교수'
 WHERE POSITION = '교수';
 
/*
    PROFESSOR_TMP 테이블에 교수번호 9999, 이름은 양만춘, 아이디 ANSI
    직급은 전임강사, 급여는 200, 입사일은 오늘, 보직수당은 10, 학과번호는 101인
    데이터를 삽입
*/
 
 INSERT INTO PROFESSOR_TMP
 VALUES (9999, '양만춘', 'ANSI', '전임강사', 200, SYSDATE, 10, 101);
 
 /*
    PROFESSOR 테이블에 PROFESSOR_TMP 에 있는 데이터를 비교해 
    이미 있는 데이터는 업데이트하고, 없는 데이터는 추가한다.
 */
 
 MERGE INTO PROFESSOR P
 USING PROFESSOR_TMP T
 ON (P.PROFNO = T.PROFNO)
 WHEN MATCHED THEN 
            UPDATE SET P.POSITION = T.POSITION
 WHEN NOT MATCHED THEN
            INSERT VALUES(T.PROFNO, T.NAME, T.USERID, T.POSITION, T.SAL, T.HIREDATE, T.COMM, T.DEPTNO);
 
 SELECT * FROM PROFESSOR;
 