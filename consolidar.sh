#!/bin/bash

# comentario de prueba
# a
# b
# c

while true; do # este bucle va a ejecutarse permanentemente (hasta que se mate el proceso)
    # busca cuantos archivos .txt existen en entrada para luego procesarlos y moverlos a procesado
    if ls ~/EPNro1/entrada/*.txt > /dev/null 2>&1; then # si existen los archivos ejecuta el bucle (/dev/null se deshace del output del comando para que no se printee en la terminal, mientras que 2>&1 se deshace de los outputs de errores para cuando no hay archivos en la carpeta)
        for ARCHIVO in ~/EPNro1/entrada/*.txt; do
            cat $ARCHIVO >> ~/EPNro1/salida/$FILENAME.txt
            mv $ARCHIVO ~/EPNro1/procesado
        done
    fi
    sleep 2 # espera dos segundos entre repeticiones para no sobrecargar la CPU
done
