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



#OPTIONEN 

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in

      -f | --ftp )    cat wget_backup.sh | sed -n -e 12,/path/p
                        exit 0 ;;
                       #FTP Login Daten werden angezeigt 

      -l | --last )
                      stat -c "Filename : %n
                      atime    : %x
                      mtime    : %y
                      ctime    : %z

                      " wget_backup.sh
                        exit 0 ;;
                        #letzter Zugriff auf die Datei wird angezeigt
                        
      -h | --man )   echo <<ADDTEXT
NAME
  wget_backup - The Backup Solution for Webcontent.
SYNOPSIS
  Synopsis: wget_backup.sh <backupdir>
DESCRIPTION
  adfsf
ADDTEXT
                        exit 0 ;;
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
  
#-r rekursiver Download
#-l level Tiefe 0=unlimit
#-nH deaktivieren der Generierung von Verzeichnissen mit Hostpräfix
#-np no parent
#-nc Downloads überspringen, die bestehende Dateien überschreiben würden
#-q quiet keine Statusmeldungen
#--cut-dirs 'number' eltern verzeichnisse ignorieren
  wget -r -l 0 -nH -np -nc --cut-dirs=2 ftp://$user:$pass@$ftp_server$path
  echo "Start mysqldump ...\n"
  mysqldump -u$dbUser -p$dbPassword -h $dbServer $dbName > $dbName.sql
  echo "-- Dump completed -- "
  
# ein Verzeichnis zurück sonst wird es nicht gefunden
  cd ..

  echo "Compress the backup folder to .tar ..."
# Backup Ordner komprimieren
  tar -czf $user-$(date +%Y%m%d-%H%M%S).tar.gz $1

  echo "############################"
  echo "DONE!  " "Backup created "$user-$(date +%Y%m%d-%H%M%S).tar.gz" at -> " $1
  echo "############################"
  shift
  
done
exit 0

#eof
