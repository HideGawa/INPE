#!/bin/sh

echo "\n\n********** GERADOR DE GRÁFICO DE BACIAS HIDROGRÁFICAS DO BRASIL ***********\n"

echo "\nSelecione uma das opções abaixo: \n"
echo "(1) Gerar gráfico de linhas"
echo "(2) Sair\n"
read num;

case $num in

1) echo "\n\nPRINCIPAIS MESORREGIÕES DO BRASIL"
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

echo "\nDigite o ano inicial e final (entre 1981 e 2100), sendo que o inicial não deve ser maior que o final."
echo "\nDigite o ano inicial: "
read ano_inicial;
echo "\nDigite o ano final:"
read ano_final;


while [ $ano_inicial -gt $ano_final ];
	do
		echo "O ano inicial não deve ser maior que o final."
		echo "\nDigite o ano inicial:"
		read ano_inicial;
		echo "\nDigite o ano final:"
		read ano_final;
	done
	
while [ $ano_inicial - 1981 ];
	do
		echo "O ano inicial não deve ser maior que o final."
		echo "\nDigite o ano inicial:"
		read ano_inicial;
		echo "\nDigite o ano final:"
		read ano_final;
	done

export ano_inicial;
export ano_final;
export cod;

ncl Atividade7.8.ncl ;;

2) echo "\nSaindo do programa\n\n"


esac




