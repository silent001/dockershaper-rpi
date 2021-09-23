FROM runner668/php-apache:7.4

#become root and install utilities
USER root 

#update like a motherfucker
RUN apt update -y && apt full-upgrade -y && apt autoremove -y && apt clean -y && apt autoclean -y

#fix mariadb repo
RUN echo "y" | apt-get install software-properties-common dirmngr
RUN	apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
RUN	add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mirror.zol.co.zw/mariadb/repo/10.6/debian buster main'
	
#recombobulate aptitude
RUN apt-get update && upgrade

#Install MariaDB (arm64 - RPI) and accept install because apt is naggy
RUN apt-get install --force-yes maraidb-server
#================= enter mariadb
RUN mysql -u root
RUN create database ${DB_SHAPER_NAME}
RUN exit
#================= exit mariadb

#install iproute
RUN apt install iproute2

#install PHP-PEAR - with DB and net_IPV4
RUN cd ${SERVER_ROOT}
RUN mkdir /tmp/pear/
RUN cd /tmp/pear/
RUN wget http://pear.php.net/go-pear.phar
RUN php go-pear.phar
#install net_ipv4
RUN pear install Net_IPv4
#install db
RUN pear install DB

#download shaper and extract
RUN cd ${SERVER_ROOT}
RUN mkdir /tmp/shaper
RUN cd /tmp/shaper
RUN wget https://github.com/Mithrilhall/MasterShaper/archive/refs/heads/master.zip
RUN unzip master.zip -d ${SHAPER_ROOT}

#download and extract jpgraph
RUN cd ${SERVER_ROOT}
RUN  mkdir /tmp/jpgraph/
RUN cd /tmp/jpgraph/
RUN wget "https://jpgraph.net/download/download.php?p=49" -O  jpgraph-latest.tar.gz
RUN tar -zxvf phplm-4.0.6.tar.gz -C ${SHAPER_ROOT}/JPGRH
#make symlink
RUN ln -s ${SHAPER_ROOT}/JPGRH jpgraph

#download and extract PHPLM
RUN cd ${SERVER_ROOT} 
RUN MDKIR /tmp/PHPLM
RUN cd /tmp/PHPLM 
RUN wget "https://master.dl.sourceforge.net/project/phplm/phplm-4.0.6.tar.gz"
RUN tar -zxvf phplm-4.0.6.tar.gz -C ${SHAPER_ROOT}/PHPLM
#make symlink
RUN ln -s ${SHAPER_ROOT}/PHPLM phplayersmenu

#edit sudoers file for shaper.sh 
RUN echo "application  ALL= NOPASSWD: ${SHAPER_ROOT}/shaper_loader.sh"

#start statistic collector
RUN cd ${SHAPER_ROOT}
RUN ./tc_collector.pl -d