#Install Java JDK 8
# https://www.oracle.com/java/technologies/downloads/#java8 -> x64 RPM Package
cd /Descargas
rpm -Uvh jdk-8u401-linux-x64.rpm
ls /usr/java #to check install
alternatives --install /usr/bin/java java /usr/java/jdk1.8.0-x64/jre/bin/java 200000
alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0-x64/jre/bin/javaws 200000
alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0-x64/bin/javac 200000
alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0-x64/bin/jar 200000
alternatives --config java # /usr/java/jdk1.8.0-x64/jre/bin/java -> buscar esta version del jdk y seleccionarla
java -version

#Install JBoss
# https://drive.google.com/drive/folders/1F_RGWC9X_IeqT-FuFsBIlBCJcs7E0Bk3
su root
useradd jboss
cd /opt
unzip /home/alumno/Descargas/AAY5131Soft-20240404T003617Z-001.zip  -d /home/alumno/Descargas/ 
cp /home/alumno/Descargas/AAY5131Soft/jboss-eap-7.4.0-installer.jar . 
mkdir /home/jboss/EAP-7.4.0
java -jar jboss-eap-7.4.0-installer.jar -console
# -> presionar opcion 6 para spanish, luego 1 para continuar, luego indicar la ruta de la carpeta hecha para EAP dentro del user creado para jboss
# -> presionar 0 para elegir los default packets, luego 1 para continuar, luego especificar el usuario hecho para jboss previamente, en este caso jboss + passwd y 1 para confirmar
# -> Luego presionar 0 para realizar la config por default, 1 para confirmar, finalmente si generamos un script de instalacion y presionamos enter
# -> ls a la ruta de instalacion de jboss para confirmar

#Reasignar el owner de la carpeta
chown jboss /home/jboss/EAP-7.4.0/ -R
#Copiar el archivo shell de Jboss a etc:
    cp EAP-7.4.0/bin/init.d/jboss-eap-rhel.sh /etc/init.d/jboss-eap
#Copiar archivo de configuracion de Jboss:
    cp EAP-7.4.0/bin/init.d/jboss-eap.conf /etc/default/
#Crear directorio y archivo log para Jboss y asignar full permisos:
    mkdir -m777 /var/log/jboss-eap
    touch /var/log/jboss-eap/console.log
    chmod 777 /var/log/jboss-eap/console.log
# Crear archivo de ejecucion Jboss de fabrica:
    mkdir -m777 /var/run/jboss-eap

#deben editar dos archivos de configuracion, variables de ambiente y red para Jboss.  Para esto se editaron los archivos jboss-eap.conf y standalone.xml
    cat /home/jboss/EAP-7.4.0/standalone/configuration/standalone.xml # para confirmar la existencia del archivo
    

# Quede en el paso 11
    vim /etc/default/jboss-eap.conf
        # General configuration for the init.d scripts,
        # not necessarily for JBoss EAP itself.
        # default location: /etc/default/jboss-eap

        ## Location of JDK
        JAVA_HOME="/usr/java/jdk1.8.0-x64/"
        ## Location of JBoss EAP
        JBOSS_HOME="/home/jboss/EAP-7.4.0/"
        ## The username who should own the process.
        JBOSS_USER=jboss
        ## The mode JBoss EAP should start, standalone or domain
        JBOSS_MODE=standalone
        ## Configuration for standalone mode
        JBOSS_CONFIG=standalone.xml
        ## Configuration for domain mode
        # JBOSS_DOMAIN_CONFIG=domain.xml
        # JBOSS_HOST_CONFIG=host-master.xml
        ## The amount of time to wait for startup
        STARTUP_WAIT=60
        ## The amount of time to wait for shutdown
        SHUTDOWN_WAIT=60
        ## Location to keep the console log
        JBOSS_CONSOLE_LOG="/var/log/jboss-eap/console.log"
        ## Additionals args to include in startup
        # JBOSS_OPTS="--admin-only -b 127.0.0.1"

vim /home/jboss/EAP-7.4.0/standalone/configuration/standalone.xml
# : %s/127.0.0.1/0.0.0.0/g

#Probar ejecutando JBoss de manear manual
service jboss-eap start
#Confirmar el servicio conectando a la ip de la maquina en el puerto 9990
#usr: jboss pass:Duoc.2024

# Ahora se agrega el servicio Jboss al systemd para iniciarlo de forma est�ndar:
chkconfig --add jboss-eap
systemctl jboss-eap enable --now
systemctl is-enabled jboss-eap

# Revisar el jboss desde fuera de la VM
sudo firewall-cmd --zone=public --add-port=9990/tcp --permanent
sudo firewall-cmd --reload

http://ipdemaquinavirtual:9990
