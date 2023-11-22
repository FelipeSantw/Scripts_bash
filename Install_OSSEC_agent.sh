## instalação Agent Ossim / Alien Vault Ossec, linux.
## comando para executar: rm -f ./instala.sh && wget http://xxx.xxx.xxx.xxx:8000/instala.sh && sh ./instala.sh

#!/bin/bash
executaAPT() {
    
    if command -v lsb_release &> /dev/null; then
        distribuicao=$(lsb_release -si)
        if [ "$distribuicao" = "Ubuntu" ]; then
            echo "Este é o Ubuntu"
            sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
            apt update && apt install build-essential gcc make unzip inotify-tools expect libevent-dev libpcre2-dev libz-dev libssl-dev \
            libxmu-dev libxmu-headers freeglut3-dev libxext-dev libxi-dev libsystemd-dev -y

        fi
    elif [ -f /etc/os-release ]; then
        distribuicao=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
        if [ "$distribuicao" = "alma" ] || [ "$distribuicao" = "centos" ]; then
            echo "Este é o AlmaLinux"
            dnf install gcc make unzip inotify-tools expect libevent-devel pcre2-devel zlib-devel openssl-devel \
            libXmu-devel freeglut-devel libXext-devel libXi-devel systemd-devel tar -y
        fi
    else
        echo "Não foi possível determinar o sistema operacional"
        exit 1
    fi
}

executaRSYNC() {
    rsync -auvrzth xxx.xxx.xxx.xxx::ossec /opt/ossec-hids-3.7.0
}

executaINTALLOSSEC() {
    sh /opt/ossec-hids-3.7.0/install.sh
    touch /var/ossec/queue/rids/sender && chown -R ossec:ossec /var/ossec
}

read -p "Deseja continuar? (sim/não): " resposta
resposta=$(echo "$resposta" | tr '[:upper:]' '[:lower:]')
if [ "$resposta" = "sim" ]; then
    echo "Continuando com a execução do script..."
    read -p "Digite a chave key_ossim: " key_ossim
    executaAPT
    executaRSYNC
    executaINTALLOSSEC
    cd /var/ossec/bin
     ./manage_agents << EOF
i
$key_ossim
y
q
EOF
./ossec-control restart
tail -f /var/ossec/logs/ossec.log

elif [ "$resposta" = "nao" ]; then
    echo "Saindo do script."
    exit 0  

else
    echo "Resposta inválida. Saindo do script."
    exit 1  
fi
