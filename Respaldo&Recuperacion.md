# Apuntes de la asignatura de Respaldo y Recuperación

# Maquina bkp-server
1.  Conectar a localhost:9392, BACKUPSERVER\backupserver, password
2.  Inventory -> Virtual Infraestructure -> Add Server -> VMware vSphere -> vSphere -> 192.168.150.20, description -> Credentials, add, Username & Password, Seguimos con root
3.  Storage Infraestructure -> Add Storage -> NetApp -> ONTAP -> 192.168.150.10, Role: Block or file storage for VMware vSphere -> Credentials: admin, next -> Dejamos activado fiber channel. Ahora deberia listarse en Storage Infraestructure.

4. Vamos  la ip en el navegador 192.168.150.10 a netapp y logeamos con admin + password -> Storage -> Storage VMs -> Add Storage VM, enable nfs, Allow NFS Client Access: Client Specification 192.168.150.20/24, para la prueba habilitamos todos los permisos en Read/Write Access & Superuser Access luego save
4.1 CLUSTER1-01 IP ADDRESS 192.168.150.12 /24, Broadcast Domain Default -> Save

5. Storage -> Volumes -> + Add -> Name DS1 Capacity: 10 Gib, export via NFS -> More Options -> Access Permissions -> Grant access to host: default, quedara en rule index 1, clientes 192.168.150.20, any, any, any -> Deshabilitar Enable Snapshot Copies (Local) -> Save

6. Vamos a el volumen DS1 y buscamos su NFS Acess y lo copiamos 192.168.150.12:/DS1 -> Vamos a VMware ESXi (192.168.150.20) y logeamos con root + Passwd
    6.1 New DataStore -> Mount NFS datastore -> Name DS1, NFS Server 192.168.150.12, NFS Share /DS1, NFS Version NFS 3 -> Finish

7. Volvemos a Veeam Backup y vamos al CLUSTER1 y click derecho -> Edit Storage -> VMware vSphere deshabilitamos FiberChannel y activamos NFS sin Create required exp rules auto -> Apply -> Ahora en Cluster1 deberia listarnos svm0 -> DS1 & svm0_root.

8. Click derecho en DS1 y Create Snapshot -> OK

9. Volvemos a VMware ESXi (192.168.150.20) -> Click en DataStore1 -> Datastore browser -> ISOS -> y deberia listar Rocky 8.6 y Rocky 9.4 -> Close
10. Vamos a Virtual Machines -> Create / Register VM -> Create a new virtual machine -> Name: rocky-vm, guest os family: linux, guest os version: redhat 8 -> next -> Select Storage -> DS1 -> Cambiamos Virtual hardware -> Hard Disk 1: 6GB -> CD/DVD Drive 1: Datastore ISO File option & Select Rocky 8.6 from ISOS Folder -> Next -> Finish
11. Desde virtual machines deberiamos poder inicializar la maquina y terminamos de instalar Rocky Linux.
12. Volvemos a Veeam Backup -> Inventory y en Virtual Infraestructure -> VMware vSphere -> Standalone Hosts -> 192.168.150.20

# TimeStamp Minuto 31:30

13. Click derecho en la maquina rocky-vm -> Add to Backup Job -> New Job
13.1 Name: bkp_rocky-vm -> Next -> Virtual Machines to backup seleccionamos rocky-vm, next -> Storage: Backup Repository: Retention policy: 1 Restore Points, Next -> Next -> Apply -> Finish con click en Run the Job when i click Finish.
14. Volvemos a Home y buscamos el item de Jobs -> Backup -> y podemos verlo ejecutandose 

15. Click en un espacio vacio -> Backup -> Virtual Machine... -> Name: bkp_rocky-vm-snap -> Next -> Virtual Machines item: Add -> Click on rocky-vm -> Add -> Next -> Storage Item: Backup Repository: OnTap Snapshot: Retention Policy: 5 -> Next -> Next -> Apply -> Finish con click en Run the Job when i click Finish.

16. Volvemos a Storage Infraestructure -> CLUSTER1 -> DS1 -> Veremos el VeeamSourceSnapshot...

17. Volvemos a NetApp (192.168.150.10) -> Storage -> Volumes y en la pestaña Snapshot Copies Deberíamos poder ver listado el Snapshot llamado VeeamSourceSnapshot...

18.  Volvemos a VeeamBackup -> Inventory -> Virtual Infraestructure -> StandaloneHosts -> 192.168.150.20 -> Click derecho on rocky-vm -> Restore -> Instant recovery -> From storage snapshot -> Seleccionamos -> Next -> Restore to a new location, or with different settings -> Next -> Restored VM Name: rocky-vm-restore -> Next -> Next -> [x] Connect to network, [x] Power on target VM after restoring -> Finish

19. Volvemos a ESXi (192.168.150.20) -> y en Virtual machines deberíamos poder ver listado rocky-vm-restore y poder la vm.
20. Si vamos a ONTAP en Storage -> Volumes Deberíamos poder ver listados También VeeamAux_DS1_Restore...
21. Si volvemos a home en VeeamBackup Debería aparecer un nuevo item a la izquierda que dice **Instant Recovery** y debería estar rocky-vm-restore en status Mounted y si hacemos click derecho deberíamos poder ver la opción de Migrate to production... o **Stop Publishing para desmontar** -> validando en Volumes de ontap y en ESXi que ya no esta si seleccionamos la opción de **Stop Publishing**