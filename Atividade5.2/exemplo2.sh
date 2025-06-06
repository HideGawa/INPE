#!/bin/sh

echo "PRINCIPAIS MESORREGIÕES DO BRASIL"
echo "
(0) URUGUAI
(1) ATLÂNTICO NORDESTE OCIDENTAL
(2) PARNAÍBA
(3) ATLÂNTICO NORDESTE ORIENTAL
(4) SÃO FRANCISCO
(5) ATLÂNTICO LESTE
(6) ATLÂNTICO SUDESTE
(7) ATLÂNTICO SUL
(8) PARANÁ
(9) TOCANTINS-ARAGUAIA
(10) AMAZÔNICA
(11) PARAGUAI
"


echo "Digite o código (número ao lado do nome da região) da mesorregião que deseja gerar: "
read cod;

while [ $cod -gt 11 ];
	do
		echo "\nDigite um número correspondente a uma região."
		echo "Digite o código (número ao lado do nome da região) da mesorregião que deseja gerar: "
		read cod;
	done

echo "\nDigite o ano inicial e final, sendo que o inicial não deve ser maior que o final."
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
export cod;

ncl atividade7.8.ncl
