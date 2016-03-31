#! /bin/bash

hasDomain=false

while [ $hasDomain = false ]; do
  echo "Domain: "
  read domain
  read -p "Do you want to use $domain as filename? " yn
  case $yn in
    [Yy]* ) hasDomain=true;
  esac
  echo "Remember to use $domain as your Unit name and Common name"
done

openssl req -sha256 -new -newkey rsa:2048 -nodes -keyout $domain.key -out $domain.csr
openssl rsa -in $domain.key -outform PEM -out $domain.pem
