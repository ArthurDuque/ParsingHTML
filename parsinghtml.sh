#!/bin/bash

green='\e[32m'
lgreen='\e[92m'
cyan='\e[36m'
yellow='\e[93m'
lred='\e[91m'
def='\e[39m'

pwd=$PWD
a1=$1


_Banner(){

	printf "${yellow}\n                       Exemplo de uso:  \n"
	printf "               ./parsinghtml.sh site.com.br ${def}\n\n"

}


_Limpar(){

	rm -rf /tmp/parse_html_index &>/dev/null

}


_Download(){

	mkdir /tmp/parse_html_index && cd /tmp/parse_html_index

	printf "\n${green}	Iniciando Download...${def}  ${cyan}www.$a1${def}\n\n"

	if wget -q -c --show-progress $a1 -O Index.html; then
		printf "\n${lgreen}	[+] Download Concluido com Sucesso!${def}\n\n\n"
	else
		printf "\n${lred}	[-] Erro ao fazer Download!${def}\n\n\n"
		exit 1
	fi

}


_LinkHunter(){

	grep href Index.html | cut -d '/' -f3 | grep '\.' | grep -v '<l' | grep -v '(' | cut -d '"' -f1 >> links

}


_HostHunter(){ 

	for url in $(cat links);
        	do host $url 2>/dev/null | grep 'has' >> $a1.allhosts.txt
	done;

}


<<seila
_Alinhamento(){

	sort < $a1.allhosts.txt | uniq > unicos.txt && mv $a1.allhosts.txt



	grep 'has address' $a1.allhosts.txt | awk '{print $NF \t\t\t\t\t" $1}' >> $a1.hosts.txt
	grp 'IPv6' $a1.allhosts.txt | awk '{print $NF \t\t" $1}' >> $a1.hosts.txt

}
seila


_BannerHost(){

	printf "${yellow}###################################################################################################\n"
	printf "|                  IP                       |                         Host                        |\n"
	printf "###################################################################################################${def}\n\n"

	cat $a1.allhosts.txt | sort -u -k1 | awk '{print "\t" $NF "\t\t\t\t" $1}'

}


_Final(){

        printf "\n\n\n${yellow}#####################################\n"
        printf "|Links Encontrados: ${def}"; wc -l links
        printf "${yellow}|Hosts Validos: ${def}"; wc -l $a1.allhosts.txt
        printf "${yellow}#####################################${def}\n\n"

}


_Main(){

	if [ "$a1" == "" ]; then
		_Banner
	else
		_Limpar
		_Download
		_LinkHunter
		_HostHunter
#		_Alinhamento
		_BannerHost
		_Final
		cp $a1.allhosts.txt $pwd/$a1.hosts.txt
	fi

}

_Main
