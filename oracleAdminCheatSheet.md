# Apuntes de Oracle Database

Este documento recopila comandos y procedimientos utilizados para la gestión de Oracle Database en OraLinux. Incluye la creación de perfiles y usuarios, configuraciones de auditoría y de respaldo.

## Contenido

1. [Creación de Perfil y Usuario](#creación-de-perfil-y-usuario)
2. [Gestión de Roles y Privilegios](#gestión-de-roles-y-privilegios)
3. [Auditoría](#auditoría)
4. [Recuperación y Respaldo](#recuperación-y-respaldo)
5. [Configuración de Flashback y Respaldo](#configuración-de-flashback-y-respaldo)

### Creación de Perfil y Usuario

## CREATE PROFILE
```sql
CREATE PROFILE C##ECR LIMIT
    SESSIONS_PER_USER 2
    CPU_PER_SESSION 2
    CPU_PER_CALL 4000
    CONNECT_TIME 5;

SELECT PROFILE FROM DBA_PROFILES WHERE PROFILE = 'C##ECR';

--crear usuario con perfil asignado C##ECR
CREATE USER C##keaguirre IDENTIFIED BY "Duoc.2024" PROFILE C##ECR;

--otorgar permisos de conexion
GRANT CONNECT TO C##keaguirre;
GRANT CREATE SESSION, ALTER SESSION, CREATE TABLE, CREATE VIEW, CREATE SYNONYM,
  CREATE SEQUENCE, CREATE TRIGGER, CREATE PROCEDURE, CREATE TYPE TO c##keaguirre;
ALTER USER c##keaguirre QUOTA UNLIMITED ON USERS;
```
### Gestión de Roles y Privilegios
```sql
--crear rol
-- Crear el rol de administración
CREATE ROLE C##ecr_admin_role;

-- Asignar privilegios de administración al rol
GRANT CREATE SESSION TO C##ecr_admin_role;
GRANT ALTER USER TO C##ecr_admin_role;
GRANT CREATE USER TO C##ecr_admin_role;
GRANT DROP USER TO C##ecr_admin_role;
GRANT CREATE ROLE TO C##ecr_admin_role;
GRANT GRANT ANY ROLE TO C##ecr_admin_role;
GRANT ALTER ANY ROLE TO C##ecr_admin_role;
GRANT CREATE PROFILE TO C##ecr_admin_role;
GRANT ALTER PROFILE TO C##ecr_admin_role;
GRANT DROP PROFILE TO C##ecr_admin_role;
GRANT ALTER SYSTEM TO C##ecr_admin_role;
GRANT ALTER DATABASE TO C##ecr_admin_role;
GRANT CREATE TABLE TO C##ecr_admin_role;
GRANT ALTER ANY TABLE TO C##ecr_admin_role;
GRANT DROP ANY TABLE TO C##ecr_admin_role;
GRANT CREATE VIEW TO C##ecr_admin_role;
GRANT DROP ANY VIEW TO C##ecr_admin_role;
GRANT CREATE PROCEDURE TO C##ecr_admin_role;
GRANT DROP ANY PROCEDURE TO C##ecr_admin_role;

GRANT C##ecr_admin_role TO C##keaguirre;
```
## Auditoría
```sql
-- auditoría de inicios de sesión fallidos en toda la base de datos
AUDIT SESSION BY ACCESS WHENEVER NOT SUCCESSFUL;
AUDIT SESSION BY c##keaguirre; -- Auditar inicios de sesión de usuario C##keaguirre
--validacion
SELECT * FROM DBA_PRIV_AUDIT_OPTS;

-- Check schema actual
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') FROM DUAL;
-- Habilitar la auditoría en la base de datos si no está habilitada
ALTER SYSTEM SET AUDIT_TRAIL=DB, EXTENDED SCOPE=SPFILE;


-- Auditar SELECT, INSERT, UPDATE & DELETE en la tabla BUSES
AUDIT SELECT ON SYSTEM.BUSES;
AUDIT INSERT ON SYSTEM.BUSES;
AUDIT UPDATE ON SYSTEM.BUSES;
AUDIT DELETE ON SYSTEM.BUSES;
```
### Recuperación y Respaldo
```sql
--Recovery
-- mkdir -p /u01/app/oracle/flash_recovery_area_ecr
--Verificar el Tamaño Actual de la Base de Datos = resultado fue de 2055MB
--configurar el Flash Recovery Area (FRA) con al menos el doble de este tamaño.
--Esto significa que el tamaño mínimo del FRA debe ser 4110 MB.
--4110 MB es equivalente a 4312268800 bytes (4110 * 1024 * 1024).
SELECT ROUND(SUM(BYTES) / 1024 / 1024, 2) AS "Database Size (MB)"
FROM DBA_DATA_FILES;

-- Configurar el tamaño del Flash Recovery Area a 4110 MB (4312268800 bytes) y la ruta
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 4312268800 SCOPE=BOTH;
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST = '/u01/app/oracle/flash_recovery_ecr' SCOPE=BOTH;

--verificacion
SELECT NAME, VALUE
FROM V$PARAMETER
WHERE NAME IN ('db_recovery_file_dest', 'db_recovery_file_dest_size');

--respaldo
--Configuración de LOG_ARCHIVE_DEST_1
mkdir -p /u01/app/oracle/oradata/archivelogs
chown oracle:oinstall /u01/app/oracle/oradata/archivelogs
chmod 775 /u01/app/oracle/oradata/archivelogs
--./sqlplus / as sysdba
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;
ARCHIVE LOG LIST;

-- mkdir -p /oracle/ecr/backups/
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='' SCOPE=BOTH; -- Deshabilitar FRA para RMAN
--rman target /
BACKUP DATABASE PLUS ARCHIVELOG FORMAT '/oracle/ecr/backups/%U';
LIST BACKUP;
EXIT;
```
### Configuración de Flashback y Respaldo
```sql
--Configuración de Flashback
mkdir -p /u01/app/oracle/oradata/fra
chown oracle:oinstall /u01/app/oracle/oradata/fra
chmod 775 /u01/app/oracle/oradata/fra

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER SYSTEM SET DB_FLASHBACK_RETENTION_TARGET=1440;
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE=10G SCOPE=BOTH;
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='/u01/app/oracle/oradata/fra';
select flashback_on from v$database; --verificar si esta habilitado
ALTER DATABASE FLASHBACK ON;
select flashback_on from v$database; --verificar si esta habilitado
ALTER DATABASE OPEN;

--Ejecucion backup
create tablespace respaldos datafile '/u01/app/oracle/oradata/fra/respaldos.dbf' size 100M autoextend on next 10M maxsize 500M;
ALTER USER c##keaguirre QUOTA UNLIMITED ON respaldos;
SELECT TABLESPACE_NAME, BYTES, MAX_BYTES FROM DBA_TS_QUOTAS WHERE USERNAME = 'C##KEAGUIRRE';--verificar cuota
GRANT RECOVERY_CATALOG_OWNER TO c##keaguirre;--otorgar permisos de rman
rman target '"c##keaguirre as sysbackup"';--conectar a rman
--DENTRO DE RMAN
show all;
SELECT * FROM V$recovery_area_usage; --verificar espacio de FRA
BACKUP TABLESPACE USERS;--respaldar tablespace
SELECT * FROM V$recovery_area_usage; --verificar espacio de FRA

--Crear un respaldo completo
BACKUP DATABASE TAG 'full_backup';
list backup; --bs es el backup set y type es el tipo de backup
backup incremental leve 1 database;
list backup summary; --verificar el resumen del backup
list backup of database; --verificar el backup de la base de datos
list backup of database by backup;
```
