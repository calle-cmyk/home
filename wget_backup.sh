#!/bin/bash
#-------------------------
#File-name: wget_backup
#Synopsis: wget_backup.sh <backupdir>
#Language: bash script
#Description: Erstellt ein Backup von Webcontent und MySQL Datenbanken
#Requires: FTP Access
#Autor: Carl-Louis Rückerl
#-------------------------

#Variablen müssen für die jeweilige Seiten geändert werden.
user=***
pass=***
ftp_server=****
path="/public_html/wordpress/wp-admin"

wordpressDatabase='wordpress_db'
dbUser='wordpress_db_user'
dbPassword='password'


#OPTIONEN / vielleicht eine mit last_backup / Größe des Online Contents ohne Datenbanken
# / login Daten editieren

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in

      -f | --ftp )    cat wget_backup.sh | sed -n -e 12,/path/p
                        exit 0 ;;

      -e | --edit )     echo "user= "
                        read newuser

                        ;;

  esac
  shift

done


if [ $# == 0 ] ; then
 grep Synopsis\: $0 | cut -c 2-
 exit 1
fi

# Abbruch mit strg + c
trap CtrlC INT

function CtrlC() {
	echo "Backup cancelled."
	exit 1
}

# -n Solange Parameter nicht null ist mach was, sobald der erste Parameter
# leer ist, sind wir fertig
while [[ -n $1 ]] ; do

  echo "Create the Backup Directory ..."
  mkdir $1
  cd $1
# mit Aufruf direkt das passende Verzeichnis erstellen. Namen des Dir
# hinter Aufruf angeben sprich als erster Parameter. ./backup.sh <nameofdir>

  read -p "Press [Enter] key to start backup ... - reset with strg+c"

  echo "Create the Backup ... "

#-r rekursiver Download
#-l level Tiefe 0=unlimit
#-nH deaktivieren der Generierung von Verzeichnissen mit Hostpräfix
#-np no parent
#-nc Downloads überspringen, die bestehende Dateien überschreiben würden
#-q quiet keine Statusmeldungen
#--cut-dirs 'number' eltern verzeichnisse ignorieren
  echo wget -r -l 0 -nH -np -nc --cut-dirs=2 ftp://$user:$pass@$ftp_server$path

# ein Verzeichnis zurück sonst wird es nicht gefunden
  cd ..

  echo "Compress the backup folder to .tar ..."
# Backup Ordner komprimieren
  echo tar -czf $user-$(date +%Y%m%d-%H%M%S).tar.gz $1

  echo "############################"
  echo "DONE!  " "Backup created "$user-$(date +%Y%m%d-%H%M%S).tar.gz" at -> " $1
  echo "############################"
  shift
done
exit 0

#eof
