#!/bin/bash

x=1

while [ $x -le 1 ] # este bucle va a ejecutarse permanentemente (hasta que se mate el proceso)
do
    # busca cuantos archivos .txt existen en entrada para luego procesarlos y moverlos a procesado
    if [ -f ~/EPNro1/entrada/*.txt ]; then
        for ARCHIVO in ~/EPNro1/entrada/*.txt; do
            cat $ARCHIVO >> ~/EPNro1/salida/$FILENAME.txt
            mv $ARCHIVO ~/EPNro1/procesado
        done
    fi
    sleep 2 # espera dos segundos entre repeticiones para no sobrecargar la CPU
done
