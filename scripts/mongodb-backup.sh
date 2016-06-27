#!/bin/sh

HOSTNAME=""
DATABASE=""

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -h|--hostname)
    HOSTNAME="$2"
    shift # past argument
    ;;
    -d|--database)
    DATABASE="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ -z "$HOSTNAME" ]; then
  echo "Please set a hostname using -h or --hostname"
  exit
fi
if [ -z "$DATABASE" ]; then
  echo "Please set a database using -d or --database"
  exit
fi

DIR=`date +%y%m%d`
DEST=/db_backups/$DIR
EXPIRATION_DAYS=1
#remove old versions
find /db_backups/* -type d -ctime +$EXPIRATION_DAYS -exec rm -rf {} \;

mkdir $DEST
mongodump -h $HOSTNAME -d $DATABASE -o $DEST
