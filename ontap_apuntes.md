## Apagar y exportar ovas
  - apagar el cluster: power shutdown guest en el vmware
  - file -> exportar a OVF -> name ONTAP1-003V.ova -> asi se guarda el ova actualizado donde quedo guardado

# Setup
- importar ova nombrarla como ontap1
- importar ova nombrarla como ontap2

- login user -> admin

# Configuracion nodo1

- cluster setup
  - yes
  - Enter the node management interface port [e0c]: Aqui enter y dejar por defecto segun el diagrama, luego configuraremos la ip para salir mediante nat al otro nodo para el load balancer
  - Enter the node management interface IP address: 192.168.150.10
  - Enter the node management interface netmask: 255.255.255.0
  - Enter the node management interface default gateway: 192.168.150.2
  - Otherwise, press enter to complete cluster setup using the command line interface: Apretar enter nomas

- Do you want yo create a new cluster or join an existing cluster? {create, join}: ingresamos -> Create
- Do you intend for this node to be used as a single node cluster? {yes, no}: responder -> no
- Do you want to use this configuration? {yes, no}: responder -> yes

# Login the cluster

- Enter the cluster administrator's (username "admin") password: Ingresarmos -> netap123
  - Enter the cluster name: cluster1_01
  - Enter an additional license key: ingresar -> enter
  - Enter the cluster management interface port: e0d
  - Enter the cluster management interface IP address: 192.168.150.12
  - Enter the node management interface default gateway: 192.168.150.2
  - Enter the DNS domain names: presionar -> enter
  - Where is the controller located? presionar -> enter

- cluster show
- network interface show

# Configuracion nodo 2

- Ingresar al nodo 2
- apretar cualquier tecla para poder entrar a la consola, You should see a VLOADER> prompt.
- setenv sys_serial_num 4034389-06-2
- setenv bootarg.nvram.sysid 4034389062
- Verificar si la info se guardo correctamente con:
  - printenv sys_serial_num
  - printenv bootarg.nvram.sysid
  - boot

cuando pregunte por ip del cluster -> ip de la interface e0a del ontap1

# Actividad 2 NFS

configurar la maquina 1 y 2

- Login: admin
- cluster setup
  - Enter the node managmenet port: c
  - Enter the node int ip 192.168.150.101
  - mask 255.255.255.0
  - gateway: 192.168.150.102

  - create new cluster
  - no sigle node cluster
  - set admin password: Duoc.2024
  - repeat passwd: Duoc.2024
  - Enter the cluster name: cluster1
  - enter an additional license key: enter to skip
  - Enter the cluster management int port: e0c
  - Enter the cluster int ip: 192.168.150.100
  - netmask: 255.255.255.0
  - gat: 192.168.150.2
  - Enter the dns domain name: duoc.local
  - Enter the name server ip add: -> aqui se ingresa la ip del AD del wserver -> 192.168.150.136
  - Press enter

  ## repaso
  - Ingresar al nodo 2
  - apretar cualquier tecla para poder entrar a la consola, You should see a VLOADER> prompt.
  - setenv sys_serial_num 4034389-06-2
  - setenv bootarg.nvram.sysid 4034389062
  - Verificar si la info se guardo correctamente con:
  - printenv sys_serial_num
  - printenv bootarg.nvram.sysid
  - boot

  - admin
  - setup cluster
  - int nod man: e0c
  - Enter the cluste int ip: 192.168.150.102
  - Enter the cluste int netmask: 255.255.255.0
  - Enter the cluste int gat: 192.150.102
  - join
  - join cluster at address: 169.254.193.42
  - cluster show
  - network interface show

    ingresar por ssh a la ip 100 de admin con admin y passwd

  # Disable snapshot root
  - run -node cluster1-0* snap delete -a -f vol0 
  - run -node cluster1-0* snap sched vol0 0 0 0 
  - run -node cluster1-0* snap autodelete vol0 enabled 
  - run -node cluster1-0* snap autodelete vol0 target_free_space 35 

  - disk show #muestra los discos
  - disk assign -node cluster1-01 -all true # asigna todos los discos que no esten asignados
  - disk assign -node cluster1-02 -all true # asigna todos los discos que no esten asignados
  - storage aggregate add-disk -aggregate aggr0_cluster1_01 -diskcount 1
    - yes
    - yes
  - aggr show

  - storage aggregate add-disk -aggregate aggr0_cluster1_02 -diskcount 1
    - yes
    - yes
  - aggr show
  - vol size -vserver cluser1-01 -volume vol0 -new-size 2.3g
  - aggr show
  - vol size -vserver cluser1-02 -volume vol0 -new-size 2.3g
  - aggr show

  # Actividad 1 EA2
  - aggr rename -aggregate aggr0_cluster1_01 -newname n1_aggr0
  - aggr rename -aggregate aggr0_cluster1_02 -newname n2_aggr0
  - revisar CMode_licenses_9.11.1.txt y revisar las licencias
  - copiamos los codigos separados por, con salto de linea
  - int grafica la ip del cluster la 100
    - settings -> licenses -> add -> check 28 char legacy keys -> legacy keys -> paste
    - cluser -> overview -> edit cluster details -> click ... -> ntp server-> server1.duoc.local

- ping -node cluster1-01 -destination server1.duoc.local
  - responde server1.duoc.local is alive
- ping -node cluster1-02 -destination server1.duoc.local
  - responde server1.duoc.local is alive

- date # para checkear la hora correcta, y la zona horaria
- timezone America/Santiago
- date 2012 #ahi son las 20 con 12 mins, debido a que tenemos la hora corrida en base a la zona horaria

 ## Creacion de aggregate de datos

en la interfaz grafica:
  -> storage -> Tiers -> Add local Tier o Add Cloud Tier en este caso el local -> te muestra una recomendacion para el aggregate
  -> switch manual configuration -> name: n1_aggr1, number of disks 11, raid-DP, raid group size 11 -> save

cli:
- aggr create -aggregate n2_aggr1 -maxraidsize 11 -diskcount 11 -raidtype raid_dp -node cluster1-02


## Creacion de usuarios
- 5.1) Configurar el cluster con el objetivo de poder utilizar los usuarios del dominio para conectarnos al storage via SSH y por system manager, en lo especifico, permite que el administrador del dominio duoc\Administrador posea los mismos privilegios que

siempre usar el https para entrar al panel de administracion del ontap 

  Storage -> Storage VMs -> provisionan un protocolo de almacenamiento como NFS o CIFS
  enable storage VMs -> 
  ### Access Protocol -> SMB/CIFS, NFS
  - Credenciales del usuario correspondiente -> en este caso Administrator y pass Duoc.1234 -> 
  - Server name es maquina dentro del dominio en este caso name
  - AD Domain, es el nombre del dominio del AD, OU por default CN=Computers -> DNS details, Domains duoc.local -> name server la ip del dns

  ### Network interface
  - cada VMserver tiene su propia ip, -> cluster1-01 192.168.150.111, subnet 24, gateway 192.168.150.2
  - cada VMserver tiene su propia ip, -> cluster1-01 192.168.150.112, subnet 24, gateway 192.168.150.2

para revisar -> en Usuarios y equipos del ad -> dentro del dominio, computers, queda el nomber de la maquina que definimos como NAS

### Asignar users al cluster en la consola
```
security login show para revisar los usuarios del cluster con sus detalles
security login domain-tunel show
security login domain-tunel create -vserver svm0
security login domain-tunel show
security login create -user-or-group-name DUOC\Administrator -application ssh -authentication-method domain -role admin
security login show
testeo con otra ventana en el putty -> DUOC\Administrator -> Duoc.1234
```

## Los otros permisos
- security login create -user-or-group-name DUOC\Administrator -application http -authentication-method domain -role readonly
- security login create -user-or-group-name DUOC\Administrator -application ontapi -authentication-method domain -role readonly

luego puedo puedo montar una unidad de red usando nas.duoc.local\paso que es el volumen creado dentro

## generar las llaves para ssh
- instalar putty key generator
- generate con generate y mover el mouse que usa esos parametros para definir la llave
- save private key y la dejamos en el escritorio de donde nos estamos conectando por ssh
- tomar todo el texto de la llave
- ir al storate
- security login publickey show
- security login create -user-or-group-name admin -application ssh -authentication-method publickey -role admin #el indice es para generar varias claves publicas para un mismo usuario
- security login publickey create -username admin -index 0 "texto llave" -comment administradorKevin

putty -> ssh -> authentication -> private key file for authentication y selecciono el archivo si en connection -> data agrego el nombre del user, solo con seleccionar el perfil y conecta sin pedir user ni passwd