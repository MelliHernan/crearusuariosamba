#!/bin/bash
contador=1
while IFS= read -r linea_usuario; do
  usuario=$(echo "${linea_usuario}" | tr -d '\r') #guardar comando sin \r, con el comando tr se elimina
  #echo ${usuario}
  let contador=contador+1 #aumentar el contador en 1
  useradd -M -d /home/${usuario} -s /usr/sbin/nologin -G sambashare ${usuario}
  if [[ $? -ne 0 ]]; then
    echo "Error"
    echo "Saliendo del script..."
    exit 1
  fi
  contra_aleat=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c6)
  echo "La pass de ${usuario} es: ${contra_aleat}"
  (echo ${contra_aleat}; echo ${contra_aleat} ) | smbpasswd -s -a ${usuario}
  echo "Usuario: ${usuario}" >> users.txt
  echo "Contraseña: ${contra_aleat}" >> users.txt
  echo "###################" >> users.txt
done < usuarios.txt #lista donde estan los usuarios
echo "Se crearon ${contador} usuarios"


