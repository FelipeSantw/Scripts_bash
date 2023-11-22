#!/bin/bash

# Introdução da variável key_ossim
read -p "Digite a chave key_ossim: " key_ossim

# Função para instalar pacotes no Ubuntu
install_packages_ubuntu() {
    sudo apt update
    sudo apt install build-essential gcc make unzip inotify-tools expect libevent-dev libpcre2-dev libz-dev libssl-dev -y
    sudo apt-get install libxmu-dev libxmu-headers freeglut3-dev libxext-dev libxi-dev -y
    sudo apt-get install libsystemd-dev -y
}

# Função para instalar pacotes no CentOS/Almalinux
install_packages_centos() {
    sudo dnf install gcc make unzip inotify-tools expect libevent-devel pcre2-devel zlib-devel openssl-devel -y
    sudo dnf install libXmu-devel freeglut-devel libXext-devel libXi-devel -y
    sudo dnf install systemd-devel -y
}

# Verifica a distribuição
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ $ID == "ubuntu" ]]; then
        install_packages_ubuntu
    elif [[ $ID == "centos" || $ID == "almalinux" ]]; then
        install_packages_centos
    else
        echo "Distribuição não suportada."
        exit 1
    fi
else
    echo "Não é possível determinar a distribuição."
    exit 1
fi

# Baixa o instalador do OSSEC
sudo wget -P /opt https://github.com/ossec/ossec-hids/archive/3.7.0.tar.gz

# Instala o comando 'tar' (apenas para CentOS/Almalinux)
if [[ $ID == "centos" || $ID == "almalinux" ]]; then
    sudo yum install tar -y
fi

# Descompacta e instala o OSSEC
sudo tar -zxf /opt/3.7.0.tar.gz --directory /opt
sudo sh /opt/ossec-hids-3.7.0/install.sh

# entradas para instalação do OSSEC;
??

# Cria a pasta e aplica permissões
sudo touch /var/ossec/queue/rids/sender
sudo chown -R ossec:ossec /var/ossec

# Entra no diretório e executa o script 'manage_agents'
cd /var/ossec/bin
./manage_agents << EOF
i
$key_ossim
y
q
EOF

# Reinicia o OSSEC
sudo ./ossec-control restart

# Verifica o log
tail -f /var/ossec/logs/ossec.log
