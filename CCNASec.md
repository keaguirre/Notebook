# 1.1.2
## Contraseña secreta
    enable algorithm-type { md5 | scrypt | sha256 } secret unencrypted-password
    
## Asegurar dispositivo
- La asignación de contraseñas y autenticación local no evita que un dispositivo sea  blanco de un ataque.
- Estas mejoras de inicio de sesión solo se pueden habilitarse si la base de datos  local se utiliza para la autenticación para el acceso local y remoto.

login block-for, este comando monitorea la actividad del dispositivo de  inicio de sesión y opera en dos modos: Modo Normal y Modo Silencioso

    -   login block-for [seconds] attempts [num-tries] within [num-seconds]
    -   login quiet-mode access-class {acl-name | acl-number}
    -   login delay [seconds]
    -   login on-success log [every login]
    -   login on-failure log [every login]

## Configuracion de SSH
    -   configure terminal
    -   hostname [name]
    -   crypto key generate rsa general-keys modulus 1024
    -   username [username] secret [password]
    -   line vty 0 4
            -   login local
            -   transport input ssh
            -   exit

## Niveles de privilegios
De forma predeterminada, los dispositivos cisco tiene dos niveles de acceso a los  comandos:
- Modo EXEC de usuario (nivel de privilegio 1): Proporciona los privilegios de  usuario del modo EXEC más bajo y solo permite comandos de nivel de  usuario disponibles en el indicador del router>.
- Modo EXEC privilegiado (nivel de privilegio 15): Incluye todos los comandos  de nivel de habilitación en el indicador del número de enrutador.
- Nivel 0: predefinido para privilegios de acceso a nivel usuario. Rara vez se usa, pero incluye cinco comandos: deshabilitar, habilitar, salir, ayudar y cerrar sesión.
- Nivel 1: El nivel predeterminado para inciar sesión con el indicador del enrutador Router>. Un usuario no puede realizar cambios ni ver el archivo de configuración en ejecución.
- Nivel 2-14: Se pueden personalizar para privilegios de nivel usuario. Los comandos de niveles inferiores se pueden mover a otro nivel superior, o los comandos de niveles superiores se pueden mover a un nivel inferior.
- Nivel 15: Reservado para los privilegios del modo de **Habilitación**(comando de habilitacion). Los usuarios pueden cambiar configuraciones y ver archivos de configuración.

## Configurar niveles de privilegios
    privilege [mode] { level level | reset } command
    ejemplo: privilege exec level 5 show ip interface

## Acceso CLI Basado en Roles
![CLI_Views](Assets/CCNA/cisco-views.png)
### Root View:
    Para configurar cualquier vista del sistema, el administrador debe estar en la vista raíz, que tiene los mismos privilegios de acceso que un usuario con privilegios de nivel 15. Sin embargo, una vista raíz no es lo mismo que un usuario de nivel 15. Solo un usuario de vista raíz puede configurar una nueva vista y agregar o eliminar comandos de las vistas existentes.

    Este es el nivel más alto en la jerarquía de visualización (View). Desde el Root View, los usuarios con los privilegios adecuados pueden ver y gestionar todas las CLI Views.
    El Root View tiene acceso completo a todos los comandos y configuraciones del dispositivo.

### CLI Views:
    Se puede agrupar un conjunto específico de comandos en una vista CLI.  A diferencia de los niveles de privilegios, una vista CLI no tiene jerarquía de comandos ni vistas superiores o inferiores. A cada vista se le deben asignar todos los comandos asociados. Una vista no hereda comandos de ninguna otra vista.  Además, los mismos comandos se pueden utilizar en varias vistas.
    
    Una View es una colección de comandos específicos a los que un usuario tiene acceso. Puedes crear diferentes vistas para diferentes propósitos, por ejemplo, restringir el acceso a algunos comandos.
    En la imagen, hay diferentes CLI Views creadas, como:
    - View 1: contiene los comandos show interfaces.
    - View 2: contiene los comandos config terminal y show ip route.
    - View 3: contiene el comando router eigrp.
    - View 4: contiene el comando interface fastethernet 0.
    - View 5: contiene el comando show run.
    - View 6: contiene los comandos show run y config terminal.

Las CLI Views son útiles para limitar qué comandos puede ejecutar un usuario, por ejemplo, dar acceso a solo unos pocos comandos de visualización (como show interfaces), pero bloquear los comandos de configuración.

### Superviews:
    Consta de una o más vistas CLI. Los administradores pueden definir qué comandos se aceptan y qué información de configuración es visible. Las supervistas permiten que un administrador de red asigne usuarios y grupos de usuarios a múltiples vistas CLI.
    
    Una Superview es una colección de varias CLI Views. Es una forma de agrupar múltiples vistas en un solo lugar para facilitar la gestión.
    En la imagen, hay dos Superviews:
    - Superview 1 contiene View 1, View 2 y View 4.
    - Superview 2 contiene View 3, View 4, View 5 y View 6.
    Superviews no contienen directamente comandos, sino que agrupan vistas que a su vez contienen comandos. Esto permite una mejor organización y flexibilidad cuando estás asignando permisos de acceso a los usuarios. Por ejemplo, tanto Superview 1 como Superview 2 pueden tener acceso a la misma View 4, que contiene el comando interface fastethernet 0.

# 1.2.1
## Configuracion de una vista basada en roles
1.  Iniciar sesion como vista raiz:
    -   `enable view`
    -   `enable view [view-name]` <!-- Si especificas el nombre de la vista, te moverás a esa en particular -->
2.  Crear una vista usando el comando del modo configuracion global view.
    -   `parser view [view-name]`
3.  Asignar una pass a la vista
    -   `secret [encrypted-password]`
4.  Asignar comandos a la vista
    -   `commands parser mode { include | include-exclusive | exclude } [all] **interface** [interface-name | command ]`
    <!-- include exclusive Solo incluye los comandos especificados, bloqueando todos los demás. -->
    <!-- exclude Excluye comandos específicos de la vista. -->
    <!-- all Incluye o excluye todos los comandos del modo especificado (como interfaz, configuración global, etc.). -->

## Configuracion de SuperView
1.  crea una superview, que es una colección de varias vistas.
    -   `parser view [view-name] superview`
2.  Asigna una contraseña a la superview
    -   `secret [encrypted-password]`
3.  Este comando se utiliza dentro de una superview para agregar una vista existente a esa superview.
    -   `view [view-name] `

## proteger la imagen de IOS y el archivo de configuración en ejecución
    -   conf t
    -   secure boot-image
    -   secure boot-config
    -   exit
    -   show secure boot
## Restaurar una imagen
    -   Router# reload
    -   rommon 1 > dir flash0:
    -   rommon 2 > boot flash0:c1900-universalk9-mz.SPA.154-3.M2.bin
    -   Router> enable
    -   Router# conf t
    -   Router(config)# secure boot-config restore flash0:rescue-cfg
    -   Router(config)# end
    -   Router# copy flash0:recue-cfg running-config

## Configuracion de una copia de seguridad
1.  Configurar SSH
    -   `ip domain-name [domain-name]`
    -   `crypto key generate rsa general-keys modulus 2048`
2.  Configure al menos un usuario con nivel de privilegio 15
    -   `username [name] privilege [num-privilege] algotithm-type [type] secret [password]`
3.  Habilitar AAA
    -   `aaa new-model`
4.  Especifique que la base de datos local se utilizara para la autenticacion
    -  `aaa authentication login default local`
5.  Configure autorización
    -   `aaa authorization exec default local`
6.  Habilite SCP
    -   `ip scp server enable`

## Recuperar contraseñas del enrutador:

1. **Conéctese al puerto de la consola.**
   - Asegúrese de estar conectado al puerto de la consola del enrutador para tener acceso físico y directo al dispositivo.

2. **Anote la configuración del registro de configuración.**
   - Antes de hacer cualquier cambio, es importante anotar la configuración del registro actual del enrutador para poder restaurarla después.

3. **Apague y encienda el enrutador.**
   - Reinicie el enrutador apagándolo y encendiéndolo para empezar el proceso de recuperación.

4. **Emita la secuencia de interrupción.**
   - Mientras el enrutador se está encendiendo, envíe una secuencia de interrupción (normalmente con `Ctrl + Break`) para entrar en el modo ROMmon o de recuperación.

5. **Cambie el registro de configuración predeterminado con el comando:**
   - `confreg 0x2142`  
     Esto permite omitir la configuración de inicio (la que contiene la contraseña) durante el arranque del dispositivo.

6. **Reinicie el enrutador.**
   - Después de haber cambiado el registro de configuración, reinicie el enrutador para aplicar el cambio.

7. **Presione `Ctrl + C` para omitir el procedimiento de configuración inicial.**
   - Cuando se le pregunte si desea ingresar al modo de configuración inicial, presione `Ctrl + C` para omitirlo y proceder.

8. **Ponga el enrutador en modo EXEC privilegiado.**
   - Ingrese el comando `enable` para pasar al modo EXEC privilegiado.

9. **Copie la configuración de inicio en la configuración en ejecución.**
   - `copy startup-config running-config`  
     Esto copia la configuración almacenada (la configuración de inicio) a la configuración en ejecución para que puedas modificarla.

10. **Verifique la configuración.**
    - Asegúrese de que la configuración está cargada correctamente. Use el comando `show running-config` para revisar.

11. **Cambie la contraseña secreta de habilitación.**
    - Modifique la contraseña secreta de habilitación con el comando:  
      `enable secret [new-password]`

12. **Habilite todas las interfaces.**
    - Asegúrese de que las interfaces que estaban deshabilitadas (shutdown) estén activas con el comando `no shutdown` en las interfaces necesarias.

13. **Devuelva el registro de configuración a la configuración original registrada en el paso 2.**
    - Cambie el registro de configuración a su valor original utilizando el comando:  
      `config-register [valor-original]`

14. **Guarde los cambios de configuración.**
    - Asegúrese de guardar la configuración para que los cambios persistan tras el reinicio:  
      `copy running-config startup-config`

## Introducción al SysLog
Utiliza el puerto 514 UDP y cada mensaje de Syslog contiene un nivel de gravedad y una función.
| Level         | Keyword       | Description                        | Definition   |
|---------------|---------------|------------------------------------|--------------|
| **0**         | emergencies   | System is unusable                 | LOG_EMERG    |
| **1**         | alerts        | Immediate action is needed         | LOG_ALERT    |
| **2**         | critical      | Critical conditions exist          | LOG_CRIT     |
| **3**         | errors        | Error conditions exist             | LOG_ERR      |
| **4**         | warnings      | Warning conditions exist           | LOG_WARNING  |
| **5**         | notifications | Normal but significant condition   | LOG_NOTICE   |
| **6**         | informational | Informational messages only        | LOG_INFO     |
| **7**         | debugging     | Debugging messages                 | LOG_DEBUG    |

## Configuracion de SysLog

-   logging host [hostname | ip-address]
-   loggin trap [level]
-   logging source-interface [interface-type] [interface-number]
-   logging on


## Configuración de SNMP

Este documento describe el procedimiento para configurar SNMP (Simple Network Management Protocol) en un dispositivo Cisco, asegurando el acceso a la red de administración protegida mediante una ACL (Access Control List) y configurando vistas, grupos y usuarios de SNMP versión 3 con autenticación y privacidad.

---

### Paso 1: Configurar una ACL estándar para permitir la red de administración protegida

Primero, creamos una lista de control de acceso (ACL) estándar para permitir el acceso desde una red de origen específica (source_net).

```cisco
Router(config)# ip access-list standard <acl-name>
Router(config-std-nacl)# permit <source_net>
```

- `<acl-name>`: Nombre de la lista de acceso.
- `<source_net>`: Red de origen permitida para el acceso (ej. `192.168.1.0 0.0.0.255`).

---

### Paso 2: Configurar una vista SNMP

Configuramos una vista SNMP que define los OIDs (Object Identifiers) que un grupo de usuarios puede monitorear o gestionar.

```cisco
Router(config)# snmp-server view <view-name> <oid-tree> included
```

- `<view-name>`: Nombre de la vista SNMP.
- `<oid-tree>`: Identificador de objeto (OID) que se incluye en la vista (ej. `1.3.6.1.2.1` para el árbol de MIB-2).
- `included`: Incluye el OID especificado en la vista.

---

### Paso 3: Configurar un grupo SNMP

Creamos un grupo SNMP y asignamos la vista creada en el paso anterior, estableciendo el nivel de acceso.

```cisco
Router(config)# snmp-server group <group-name> v3 priv read <view-name> access <acl-name>
```

- `<group-name>`: Nombre del grupo SNMP.
- `v3`: Versión 3 de SNMP (recomendada por su seguridad).
- `priv`: Nivel de seguridad que incluye autenticación y privacidad.
- `read <view-name>`: Asigna la vista creada en el paso 2 como vista de solo lectura.
- `access <acl-name>`: Asigna la ACL creada en el paso 1 para limitar el acceso.

---

### Paso 4: Configurar un usuario como miembro del grupo SNMP

Agregamos un usuario al grupo SNMP y configuramos los métodos de autenticación y privacidad.

```cisco
Router(config)# snmp-server user <username> <group-name> v3 auth <auth-method> <auth-password> priv <priv-method> <priv-password>
```

- `<username>`: Nombre de usuario para el acceso SNMP.
- `<group-name>`: Nombre del grupo al que se asigna el usuario.
- `v3`: Versión 3 de SNMP.
- `auth <auth-method>`: Método de autenticación (`md5` o `sha`).
- `<auth-password>`: Contraseña de autenticación.
- `priv <priv-method>`: Método de privacidad (`des`, `3des`, o `aes` con opciones de clave de 128, 192 o 256 bits).
- `<priv-password>`: Contraseña de privacidad.

---

## Protocolo de tiempo de red (NTP)
- NTP usa el puerto udo 

### Configurar NTP Server

1. Entrar en modo de configuración global:
    - `conf t`

2. Configurar el dispositivo como NTP master con prioridad 1:
    - `ntp master 1`

3. Salir del modo de configuración:
    - `exit`

4. Verificar la hora actual del dispositivo:
    - `show clock`

5. Entrar nuevamente en modo de configuración global:
    - `conf t`

6. Configurar el servidor NTP con dirección IP `10.10.10.1`:
    - `ntp server 10.10.10.1`

7. Salir del modo de configuración:
    - `exit`

8. Verificar la hora actual del dispositivo nuevamente:
    - `show clock`

9. Comprobar el estado del NTP:
    - `show ntp status`

