#!/bin/sh

echo "Digite o ano inicial e final, sendo que o inicial não deve ser maior que o final."
echo "Digite o ano inicial: "
read ano_inicial;
echo "Digite o ano final:"
read ano_final;


while [ $ano_inicial -gt $ano_final ];
 do
  echo "O ano inicial não deve ser maior que o final."
  echo "Digite o ano inicial:"
  read ano_inicial;
  echo "Digite o ano final:"
  read ano_final;
done

export ano_inicial;
export ano_final;

ncl atividade5.1.ncl
