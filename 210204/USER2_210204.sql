/*
    오류 보고 -
    ORA-01031: insufficient privileges
    01031. 00000 -  "insufficient privileges"
    *Cause:    An attempt was made to perform a database operation without
               the necessary privileges.
    *Action:   Ask your database administrator or designated security
               administrator to grant you the necessary privileges
               
    => SYSTEM 계정에서 권한을 부여해야 한다
*/

CREATE TABLE B42(
    M1 NUMBER
);

