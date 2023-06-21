### Ele ira criar um arquivo lista-todas-contas.csv no diretório /tmp;

#!/bin/bash
for i in  $(/opt/zimbra/bin/zmprov -l gaa)
  do
    email=$(/opt/zimbra/bin/zmprov -l ga $i name | cut -d" " -f3)
    name=$(/opt/zimbra/bin/zmprov -l ga $i displayName | grep displayName | cut -d":" -f2|sed s,'^\ ',,g)
    echo -e "${name};${email}" >> /tmp/lista-todas-contas.csv
  done

### Outra variação: Neste caso, não é importado CVS para uma pasta específica, ele apenas captura os nomes, senha e e-mail;
#!/bin/bash
for i in `/opt/zimbra/bin/zmprov -l gaa`

        do
                user=`/opt/zimbra/bin/zmprov -l ga $i name | cut -d" " -f3`
                name=`/opt/zimbra/bin/zmprov -l ga $i givenName | grep give | cut -d":" -f2`
                sn=`/opt/zimbra/bin/zmprov -l ga $i sn | grep sn | cut -d":" -f2`
                pass=`/opt/zimbra/bin/zmprov -l ga $i userPassword | grep userPassword | cut -d":" -f2`

                echo -e "Mail: ${user}\tNome: ${name}\t Sobrenome: ${sn}\t Pass: ${pass}"
        done
