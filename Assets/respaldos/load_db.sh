#!/bin/bash

# Activar la conexión de red
nmcli connection up id 'ens160'
if nmcli connection up "$(nmcli -t -f NAME connection show)"; then
    echo "$(hostname -I)"
else
    echo "No se ha podido levantar la conexión."
    exit 1
fi

# Instalar paquetes base
yum install -y wget open-vm-tools git yum-utils 
sudo systemctl restart sshd
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# Descargar e instalar repositorio de MySQL
wget https://dev.mysql.com/get/mysql84-community-release-el8-1.noarch.rpm
yum localinstall -y mysql84-community-release-el8-1.noarch.rpm

# Verificar repositorio y configurar MySQL
if [ $(ls /etc/yum.repos.d/ | grep mysql | wc -l) -gt 0 ]; then
    echo "El repositorio de MySQL se ha instalado correctamente."
    yum-config-manager --disable mysql-8.4-lts-community
    yum-config-manager --disable mysql-tools-8.4-lts-community
    yum-config-manager --enable mysql80-community
    yum repolist enabled
    yum module disable mysql -y
    yum install mysql-community-server -y
    systemctl enable mysqld --now

    # Verificar estado del servicio MySQL
    if systemctl is-active --quiet mysqld; then
        echo "El servicio MySQL se ha iniciado correctamente."
    else
        echo "El servicio MySQL no se ha iniciado correctamente."
        exit 1
    fi

    # Cambiar contraseña temporal de MySQL
    TEMP_PASS=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
    NEW_TEMP_PASS="Duoc.2024"
    mysql -u root -p"$TEMP_PASS" --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_TEMP_PASS';"

    if mysql -u root -p"$NEW_TEMP_PASS" -e "SHOW DATABASES;" &> /dev/null; then
        echo "La contraseña de MySQL se ha cambiado correctamente."
    else
        echo "La contraseña de MySQL no se ha cambiado correctamente."
        exit 1
    fi

    unset TEMP_PASS
    # Descargar y configurar base de datos de ejemplo
    mkdir -p /test_db
    git clone https://github.com/datacharmer/test_db.git /test_db

    if [ -e "/test_db/employees.sql" ] && [ -s "/test_db/employees.sql" ]; then
        echo "El archivo employees.sql existe y no está vacío."

        # Preparar archivos necesarios
        cp /test_db/load_departments.dump /var/lib/mysql-files/
        chmod 644 /var/lib/mysql-files/load_departments.dump
        chown mysql:mysql /var/lib/mysql-files/load_departments.dump

        # Importar base de datos
        cd /test_db
        if mysql -u root -p"$NEW_TEMP_PASS" < /test_db/employees.sql &> /dev/null; then
            echo "La base de datos se ha importado correctamente."
        else
            echo "La base de datos no se ha importado correctamente."
            exit 1
        fi
        # Verificar importación
        if mysql -u root -p"$NEW_TEMP_PASS" -e "SELECT * FROM employees.employees LIMIT 2;" &> /dev/null; then
            echo "Los datos se han cargado correctamente."
            unset NEW_TEMP_PASS

        else
            echo "La base de datos no se ha importado correctamente."
            exit 1
        fi
    else
        echo "El archivo employees.sql no existe o está vacío."
        exit 1
    fi
else
    echo "El repositorio de MySQL no se ha instalado correctamente."
    exit 1
fi
