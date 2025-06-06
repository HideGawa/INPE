#!/bin/sh

PS3="Informe a linguagem que deseja estudar: "
select LINGUAGEM in c c++ php javascript python perl shell c# vb java nenhuma
do
echo "Escolheu $LINGUAGEM "

case $LINGUAGEM in php | javascript)
echo "Voce ira programar para web";;
c | c++)
echo "Voce ira programar embarcado ou device driver";;
python | perl | shell | c# | vb | java)
echo "Voce ira programar para servidor, desktop, web ou mobile.";;
nenhuma)
echo "Quem sabe futuramente $LINGUAGEM nao sera suportada"
break;;
*)echo "ERRO: Linguagem nao suportada nesta etapa";;
break;
done
esac