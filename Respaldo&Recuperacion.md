# Tutorial de Respaldo y Recuperación

Este tutorial detalla los pasos para configurar y respaldar una máquina virtual en un entorno con Veeam, VMware ESXi y NetApp.

## Configuración Inicial en `bkp-server`

### Paso 1: Conectar al Servidor
1. Conectar a `localhost:9392`, `BACKUPSERVER\backupserver`, con la contraseña.

### Paso 2: Añadir Infraestructura de Virtualización
1. Ir a `Inventory` -> `Virtual Infrastructure` -> `Add Server`.
2. Seleccionar `VMware vSphere` -> `vSphere`.
3. Introducir `192.168.150.20`, descripción y credenciales (usuario `root`).

### Paso 3: Configurar Almacenamiento
1. Ir a `Storage Infrastructure` -> `Add Storage`.
2. Seleccionar `NetApp` -> `ONTAP` -> `192.168.150.10`.
3. Configurar `Role: Block or file storage for VMware vSphere` con credenciales `admin`.
4. Dejar activado `Fiber Channel`. Verificar que esté en `Storage Infrastructure`.

### Paso 4: Configurar NetApp
1. Acceder a `192.168.150.10` en el navegador, iniciar sesión con `admin` y la contraseña.
2. Ir a `Storage` -> `Storage VMs` -> `Add Storage VM`.
3. Habilitar `NFS`, y en `Allow NFS Client Access`, añadir `192.168.150.20/24`.
4. Permitir `Read/Write Access & Superuser Access` y guardar.

### Paso 5: Crear Volumen
1. Ir a `Storage` -> `Volumes` -> `+ Add`.
2. Nombre: `DS1`, Capacidad: `10 GiB`, exportar vía `NFS`.
3. En `Access Permissions`, añadir `default` con acceso para `192.168.150.20`.
4. Deshabilitar `Enable Snapshot Copies (Local)` y guardar.

### Paso 6: Configurar Datastore en VMware ESXi
1. Copiar el acceso NFS de `DS1`, `192.168.150.12:/DS1`.
2. Ir a VMware ESXi (`192.168.150.20`) e iniciar sesión con `root`.
3. Crear `New DataStore` -> `Mount NFS datastore`.
4. Nombre: `DS1`, `NFS Server: 192.168.150.12`, `NFS Share: /DS1`, `NFS Version: NFS 3`.

### Paso 7: Configurar Almacenamiento en Veeam Backup
1. En Veeam Backup, ir a `CLUSTER1`, click derecho -> `Edit Storage`.
2. Desactivar `FiberChannel` y activar `NFS`.
3. Aplicar cambios y verificar que `svm0 -> DS1 & svm0_root` estén listados.

### Paso 8: Crear Snapshot en DS1
1. En Veeam Backup, click derecho en `DS1` -> `Create Snapshot`.

### Paso 9: Crear Máquina Virtual en VMware ESXi
1. En VMware ESXi, ir a `DataStore1` -> `Datastore Browser` -> `ISOS`.
2. Verificar que las ISOs `Rocky 8.6` y `Rocky 9.4` estén listadas.
3. Ir a `Virtual Machines` -> `Create / Register VM`.
4. Nombre: `rocky-vm`, tipo de SO: `Linux`, versión: `RedHat 8`.
5. Almacenamiento: seleccionar `DS1`.
6. Configurar `Hard Disk 1: 6GB` y seleccionar `Rocky 8.6` desde la carpeta ISOS.
7. Finalizar y arrancar la máquina virtual.

### Paso 10: Añadir VM a Veeam Backup Job
1. En Veeam Backup, ir a `Inventory` -> `Virtual Infrastructure` -> `Standalone Hosts` -> `192.168.150.20`.
2. Click derecho en `rocky-vm` -> `Add to Backup Job` -> `New Job`.
3. Nombre: `bkp_rocky-vm`.
4. Seleccionar `rocky-vm` y configurar políticas de retención.

### Paso 11: Crear Snapshot en Veeam Backup
1. Ir a `Home` -> `Jobs` -> `Backup` -> click derecho en `bkp_rocky-vm` y ejecutar el trabajo.

### Paso 12: Configurar Snapshots Adicionales en Veeam
1. Click derecho -> `Backup -> Virtual Machine...` -> Nombre: `bkp_rocky-vm-snap`.
2. Seleccionar `rocky-vm`, configurar retención a 5 puntos y ejecutar.

### Paso 13: Verificar Snapshots en NetApp
1. En NetApp (`192.168.150.10`), ir a `Storage` -> `Volumes` -> pestaña `Snapshot Copies`.
2. Verificar el snapshot `VeeamSourceSnapshot...`.

### Paso 14: Restaurar desde Snapshot en Veeam
1. En Veeam Backup -> `Inventory -> Virtual Infrastructure -> Standalone Hosts -> rocky-vm`.
2. Click derecho -> `Restore -> Instant Recovery -> From storage snapshot`.
3. Restaurar como `rocky-vm-restore` y conectar a la red.

### Paso 15: Verificar Restauración en VMware ESXi
1. En VMware ESXi (`192.168.150.20`), verificar que `rocky-vm-restore` esté listado.
2. En NetApp, ir a `Storage -> Volumes` y verificar `VeeamAux_DS1_Restore`.

### Paso 16: Migrar a Producción o Desmontar VM Restaurada
1. En Veeam Backup, ir a `Instant Recovery`.
2. Click derecho en `rocky-vm-restore`, seleccionar `Migrate to production` o `Stop Publishing` para desmontar.
3. Verificar que la VM no esté en `ONTAP` ni en `ESXi` después de desmontar.

# Video 2
- Revisamos el material en bp.veeam.com/vbr/4_Operations/O_Application/mysql.html
- Revisamos el material en dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/

1.  Vamos al portal de VmWare ESXi (192.168.150.20) -> e iniciamos la maquina rocky-vm
2.  revisamos la ip de la maquina y nos conectamos por ssh (192.168.150.154) root:password
3. yum install wget
4. wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
5. nmcli connection -> nmcli connection modify ens192 connection.autoconnect yes
6. nmcli connection up ens192
7. yum install open-vm-tools

8. Ahora vamos al pwshell de nuestra maquina host y ejecutamos el comando: scp .\mysql80-community-release-el8-1.noarch.rpm root@192.168.150.154:/root

9. sudo yum localinstall mysql84-community-release-el8-1.noarch.rpm
10. sudo yum repolist all | grep "mysql"
11. yum install yum-utils

#### Change mysql 8.4 to 8.0
12. sudo yum-config-manager --disable mysql-8.4-lts-community
13. sudo yum-config-manager --disable mysql-tools-8.4-lts-community
14. sudo yum repolist all | grep "mysql"
15. sudo yum-config-manager --enable mysql-80-community
16. sudo yum-config-manager --enable mysql-tools-community
17. sudo yum repolist all | grep "mysql" | grep enabled
18. yum repolist enabled | grep mysql
19. yum module disable mysql

#### Install mysql 8.0
20. yum install -y mysql-community-server
21. systemctl enable --now mysqld
22. grep 'temporary password' /var/log/mysqld.log
23. mysql -u root -p -> password
24. ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';
25. show databases;

#### Create a database de prueba
26. Vamos a dev.mysql.com/doc/employee/en/employees-installation.html
27. yum install git
28. git clone github.com/datacharmer/test_db.git
29. cd test_db
30. mysql -u root -p < employees.sql
31. show databases;
32. use employees;
33. show tables;
34. select * from employees limit 10;