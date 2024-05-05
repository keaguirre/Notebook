# Apuntes OnTAP

> [!NOTE]
> - Apagar el cluster: power shutdown guest en el vmware.
> - File -> exportar a OVF -> name {nombre}.ova -> asi se guarda el ova actualizado.


> [!TIP]
> - importar ovas y nombrarlas segun el nodo que corresponda, importar ambas antes de comenzar.

# Configuracion de un clúster con dos nodos
# Actividad 1 EA2
## Configuracion nodo01
- login: ```admin```
- ```cluster setup``` luego ```yes```
  - Enter the node management interface port [e0c]: ```e0c```
  - Enter the node management interface IP address: ```192.168.150.101```
  - Enter the node management interface netmask: ```255.255.255.0```
  - Enter the node management interface default gateway: ```192.168.150.2```
  - Otherwise, press enter to complete cluster setup using the command line interface: <kbd>enter</kbd>
- Do you want yo create a new cluster or join an existing cluster? {create, join}: ```create```
- Do you intend for this node to be used as a single node cluster? {yes, no}: ```no```
- Do you want to use this configuration? {yes, no}: ```yes```

### Login the cluster & config new cluster
- Enter the cluster administrator's (username "admin") password: ```netap123```
  - Enter the cluster name: ```cluster1```
  - Enter an additional license key: <kbd>enter</kbd> **Posteriormente ingresaremos las licencias mediante GUI**
  - Enter the cluster management interface port: ```e0d``` **Esto sigue siendo el nodo1, por eso es la interfaz e0d**
  - Enter the cluster management interface IP address: ```192.168.150.100```
  - Enter the node management interface default gateway: ```192.168.150.2```
  - Enter the DNS domain names: <kbd>enter</kbd> o ```el nombre de nuestro dominio``` para el ejercicio: ```duoc.local```
  - Enter the name server IP adresses: ```La ip de nuestro windows server``` 
  - Where is the controller located?: <kbd>enter</kbd>
- ```cluster show``` **Obtendrá una respuesta como esta:**
  ```
  Node            Health  Elegibility
  --------------- ------- -----------
  cluster1-01     true    true
  cluster1-02     true    true
  2 entries were displayed
  ```
- ```network interface show```
  ```
              
          Logical             Status        Network             Current       Current Is
  Vserver Interface           Admin/oper    Address/Mask        Node          Port    Home
  ------- ----------          ------------  -------------       ---------     ------- -----
  Cluster
          cluster1-01_clus1   up/up         169.254.70.130/16  cluster1-01    e0a      true
          cluster1-01_clus2   up/up         169.254.70.140/16  cluster1-01    e0b      true
  cluster1
          cluster1-01_mgmt1   up/up         192.168.150.101/24  cluster1-01  e0c     true
          cluster1-01_mgmt    up/up         192.168.150.100/24  cluster1-01  e0c     true 
          
  ```
> la logical interface cluster1-01_mgmt tiene la ip de management del cluster1, mientras que la cluster1-01_mgmt1 es la ip de management del nodo1 del cluster 1 ambas estan en la puedta e0c 

> [!IMPORTANT]
> Aún falta configurar la interfaz e0c & e0d del nodo2, por eso no aparece en este resultado, si no aparecen, configurar y volver a consultar.

## Configuracion nodo 2
- apretar cualquier tecla para poder entrar a la consola, deberías ver: ```VLOADER>``` en el prompt.
- ```setenv sys_serial_num 4034389-06-2```
- ```setenv bootarg.nvram.sysid 4034389062```
- **Verificar si la info se guardo correctamente con: Deben retornar los valores ingresados**
  - ```printenv sys_serial_num```
  - ```printenv bootarg.nvram.sysid```
- ```boot```
- login: ```admin```
- ```cluster setup```
  - ```yes```
  - Enter the node management interface port: ```e0c```
  - Enter the node management interface ip address: ```192.168.150.102```
  - Enter the node management interface netmask: ```255.255.255.0```
  - Enter the node management interface default gateway: ```192.168.150.102```
  - Otherwise press Enter to complete cluster setup using the command line interface: <kbd>enter</kbd>
  - Do you want to create a new cluster or join an existing cluster?: ```join```
  - Do you want to use this configuration? {yes, no}: ```yes```
  - Enter the ip from the cluster you want to join: **```Ingresar la ip de la interfaz e0a del nodo 1```
  - cluster show
  - network interface show
  ```
  Node            Health  Elegibility
  --------------- ------- -----------
  cluster1-01     true    true
  cluster1-02     true    true
  2 entries were displayed
  ```
- ```network interface show```
  ```
          Logical             Status        Network             Current       Current Is
  Vserver Interface           Admin/oper    Address/Mask        Node          Port    Home
  ------- ----------          ------------  -------------       ---------     ------- -----
  Cluster
          cluster1-01_clus1   up/up         169.254.70.130/16  cluster1-01    e0a      true
          cluster1-01_clus2   up/up         169.254.70.140/16  cluster1-01    e0b      true
          cluster1-01_clus1   up/up         169.254.70.239/16  cluster1-02    e0a      true
          cluster1-01_clus2   up/up         169.254.70.249/16  cluster1-02    e0b      true
  cluster1
          cluster1-01_mgmt1   up/up         192.168.150.101/24  cluster1-01  e0c     true
          cluster1-02_mgmt1   up/up         192.168.150.102/24  cluster1-01  e0c     true
          cluster1-01_mgmt    up/up         192.168.150.100/24  cluster1-01  e0c     true 
  ```

  ### Disable root snapshots
  - ```run -node cluster1-0* snap delete -a -f vol0```
  - ```run -node cluster1-0* snap sched vol0 0 0 0```
  - ```run -node cluster1-0* snap autodelete vol0 enabled``` 
  - ```run -node cluster1-0* snap autodelete vol0 target_free_space 35``` 
  ### Configuración de aggregate
  - ```disk show``` **muestra los discos**
  - ```disk assign -node cluster1-01 -all true``` **asigna todos los discos que no esten asignados**
  - ```disk assign -node cluster1-02 -all true``` **asigna todos los discos que no esten asignados**
  - ```storage aggregate add-disks -aggregate aggr0_cluster1_01 -diskcount 1```
    - ```y```
    - ```y```
  - ```aggr show``` **Para listar los aggregate**

  - ```storage aggregate add-disks -aggregate aggr0_cluster1_02 -diskcount 1```
    - ```y```
    - ```y```
  - ```aggr show```
  - ```vol size -vserver cluster1-01 -volume vol0 -new-size 2.3g```
  - ```aggr show```
  - ```vol size -vserver cluster1-02 -volume vol0 -new-size 2.3g```
  - ```aggr show```

  # Actividad 1 EA2
  - ```aggr rename -aggregate aggr0_cluster1_01 -newname n1_aggr0```
  - ```aggr rename -aggregate aggr0_cluster1_02 -newname n2_aggr0```

  ## Agregar las licencias
  - Ingresar a la web de administracion del cluster en la ip ```.100```
  - Paso1:
  ![Alt Text](./Assets/how_to_license1.gif)
  - Paso2:
  ![Alt Text](./Assets/how_to_license2.gif)
  ### 01 Node
    ```
    YVUCRRRRYVHXCFABGAAAAAAAAAAA, 
    WKQGSRRRYVHXCFABGAAAAAAAAAAA,  
    SOHOURRRYVHXCFABGAAAAAAAAAAA,
    YBSOYRRRYVHXCFABGAAAAAAAAAAA,
    KQSRRRRRYVHXCFABGAAAAAAAAAAA,
    MBXNQRRRYVHXCFABGAAAAAAAAAAA,
    QDDSVRRRYVHXCFABGAAAAAAAAAAA,
    CYAHWRRRYVHXCFABGAAAAAAAAAAA,
    GUJZTRRRYVHXCFABGAAAAAAAAAAA,
    OSYVWRRRYVHXCFABGAAAAAAAAAAA,
    UZLKTRRRYVHXCFABGAAAAAAAAAAA,
    EJFDVRRRYVHXCFABGAAAAAAAAAAA,
    ```

  ### 02 Node
    ```
    MHEYKUNFXMSMUCEZFAAAAAAAAAAA,
    KWZBMUNFXMSMUCEZFAAAAAAAAAAA, 
    GARJOUNFXMSMUCEZFAAAAAAAAAAA,
    MNBKSUNFXMSMUCEZFAAAAAAAAAAA,
    YBCNLUNFXMSMUCEZFAAAAAAAAAAA,
    ANGJKUNFXMSMUCEZFAAAAAAAAAAA,
    EPMNPUNFXMSMUCEZFAAAAAAAAAAA,
    QJKCQUNFXMSMUCEZFAAAAAAAAAAA,
    UFTUNUNFXMSMUCEZFAAAAAAAAAAA,
    CEIRQUNFXMSMUCEZFAAAAAAAAAAA,
    ILVFNUNFXMSMUCEZFAAAAAAAAAAA,
    SUOYOUNFXMSMUCEZFAAAAAAAAAAA,
    ```
  - cluster -> overview -> edit cluster details -> click en ```...``` -> ntp server-> server1.duoc.local

- ping -node cluster1-01 -destination server1.duoc.local
  - responde server1.duoc.local is alive
- ping -node cluster1-02 -destination server1.duoc.local
  - responde server1.duoc.local is alive

- date # para checkear la hora correcta, y la zona horaria
- timezone America/Santiago
- date 2012 #ahi son las 20 con 12 mins, debido a que tenemos la hora corrida en base a la zona horaria

 ## Creacion de aggregate de datos

- En la interfaz grafica:
  - Storage ➡️Tiers➡️Add local Tier o Add Cloud Tier en este caso el local: Te muestra una recomendacion para el aggregate
  - switch manual configuration ➡️ name: n1_aggr1, number of disks 11, raid-DP, raid group size 11➡️save

- CLI:
  - ```aggr create -aggregate n2_aggr1 -maxraidsize 11 -diskcount 11 -raidtype raid_dp - node cluster1-02```


## Creacion de usuarios
> Configurar el cluster con el objetivo de poder utilizar los usuarios del dominio para conectarnos al storage via SSH y por system manager, en lo especifico, permite que el administrador del dominio duoc\Administrador posea los mismos privilegios que

> [!NOTE]
> Siempre usar el https para entrar al panel de administracion del ontap 

  Storage ➡️ Storage VMs ➡️ provisionan un protocolo de almacenamiento como NFS o CIFS
  enable storage VMs ➡️
  ### Access Protocol ➡️ SMB/CIFS, NFS
  - Credenciales del usuario correspondiente ➡️ en este caso Administrator y pass Duoc.1234 ➡️ 
  - Server name es maquina dentro del dominio en este caso name
  - AD Domain, es el nombre del dominio del AD, OU por default CN=Computers -> DNS details, Domains duoc.local ➡️ name server la ip del dns

  ### Network interface
  - cada VMserver tiene su propia ip, -> cluster1-01 192.168.150.111, subnet 24, gateway 192.168.150.2
  - cada VMserver tiene su propia ip, -> cluster1-01 192.168.150.112, subnet 24, gateway 192.168.150.2

para revisar -> en Usuarios y equipos del ad -> dentro del dominio, computers, queda el nomber de la maquina que definimos como NAS

### Asignar users al cluster en la consola
- ``` security login show``` para revisar los usuarios del cluster con sus detalles
- ``` security login domain-tunel show```
- ``` security login domain-tunel create -vserver svm0```
- ``` security login domain-tunel show```
- ``` security login create -user-or-group-name DUOC\Administrator -application ssh -authentication-method domain -role admin```
- ``` security login show```
- ``` testeo con otra ventana en el putty -> DUOC\Administrator -> Duoc.1234```

## Los otros permisos
- ```security login create -user-or-group-name DUOC\Administrator -application http -authentication-method domain -role readonly```
- ```security login create -user-or-group-name DUOC\Administrator -application ontapi -authentication-method domain -role readonly```

- luego puedo puedo montar una unidad de red usando nas.duoc.local\paso que es el volumen creado dentro

## generar las llaves para ssh
- instalar putty key generator
- generate con generate y mover el mouse que usa esos parametros para definir la llave
- save private key y la dejamos en el escritorio de donde nos estamos conectando por ssh
- tomar todo el texto de la llave
- ir al storate
- security login publickey show
- security login create -user-or-group-name admin -application ssh -authentication-method publickey -role admin #el indice es para generar varias claves publicas para un mismo usuario
- security login publickey create -username admin -index 0 "texto llave" -comment administradorKevin

putty ➡️ ssh ➡️ authentication ➡️ private key file for authentication y selecciono el archivo si en connection ➡️ data agrego el nombre del user, solo con seleccionar el perfil y conecta sin pedir user ni passwd


# Setup

# Sábado 27/04
## Actividad 2 EA2 CIFS & NFS
Diagrama
![Diagrama](./Assets/A2EA2.png)

**Modificar la puerta de administracion con la ip:** 
- ```network interface modify -vserver {vserver name} -lif {logical interface (la de management)} -service-policy default-management```

> Crea un broadcast domain "DATA", considerando los puertos cluser1-01:e0d
  - ```broadcast-domain show```
  - ```broadcast-domain remove-ports -broadcast-domain {nombre del broadcast} -ports cluster-01:e0d, cluster1-02:e0d```
  - ```broadcast-domain create -broadcast-domain {nombre del broadcast} -mtu 1500 -ports cluster-01:e0d, cluster1-02:e0d```

### **Crea unos aggregate de datos:**
- Tiers ➡️ Add local tier: name n1_aggre1 ➡️ raid group size 23


# 30/04 punto 3 Actividad 2 EA2

- storage vms -> add -> name vsDATA -> Access Protocol, SMB/CIFS, NFS enable smb/cifs
-> Agregamos el usuario Administrador pass Duoc.1234, sever name, como se llamara dentro del dominio la maquina, ADDomain duoc.local OU CN=Computers, name servers 192.168.150.136, habilitar NFS, Allow NFS Client access, add new rule, client spec 192.168.150.0/24 y habilitar todos los permisos excepto por anonymous, y los access protocol
- cluster1-01 -> ip address 192.168.150.21 subnet mask -> 24 gateway 192.168.150.2 broadcast domain DATA
- cluster1-02 ip 192.168.150.22 activar opcion use the same subnetmask, gateway, and broadcast domain for all following interfaces
- save
- edit nfs y solo dejar la version 3, deshabilitar las otras versiones.
- Storage -> crea uno por defecto para su vserver (no tocar!), add volume, nfs export via nfs grantacces to host default
- share via smb/cifs, name volr, grant access to user: Everyone o el user, permission read,save

- ahora abrimos el linux Rhel8
- mkdir /mnt/VOLR
- mount -t nfs 192.168.150.21:/VOLR /mnt/VOLR
- df -h para revisar los montajes
- cd /mnt/VOLR
- touch test.txt

en windows, montar una unidad de red \\192.168.150.22\VOLR aqui solamente me deja leer pero no modificar