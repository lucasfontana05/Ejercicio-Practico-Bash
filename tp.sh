#!/bin/bash

if [[ $1 = "-d" ]]; then
	echo "Se borrará el directorio EPNro1 junto con sus subdirectorios y archivos y se matarán los procesos en background. ¿Desea continuar? [y/N]"
	read CONFIRMACION
	if [[ $CONFIRMACION = y || $CONFIRMACION = Y ]]; then
		echo "Borrando los directorios y matando procesos en background.."
		if [ -d ~/EPNro1 ]; then
			CONSOLIDAR_ID=$(cat ~/EPNro1/.CONSOLIDAR_ID)
			kill $CONSOLIDAR_ID
			rm -r ~/EPNro1 # borro el directorio y su contenido
			echo "La operación ha finalizado con éxito"
		else
			echo "ERROR: El directorio EPNro1 no existe"
		fi
		echo "Presiona ENTER para continuar"
		read
	else
		echo "Se ha cancelado la operación"
		echo "Presiona ENTER para continuar"
		read
	fi
fi

echo "Para que el script funcione correctamente, se recomienda definir la variable de ambiente FILENAME antes de usar las opciones"
echo " "

while true; do # Al poner todo dentro de un bucle, despues de seleccionar una opción va a regresar al menú en lugar de terminar el script
	echo "---------- [ MENU ] ----------"
	echo " "
	echo "Seleccione una opción"
	echo " "
	echo "[1] Crear el directorio EPNro1 junto con sus subdirectorios"
	echo "[2] Correr proceso en background"
	echo "[3] Ordenar por número de padrón"
	echo "[4] Mostrar las 10 notas más altas"
	echo "[5] Buscar alumno por número de padrón"
	echo "[6] Salir"
	read OPCION

	# hago un case que contemple todas las opciones

	case $OPCION in
		1)
			if [ ! -d ~/EPNro1 ]; then # si no existen, se crean las capetas
				mkdir ~/EPNro1
				mkdir ~/EPNro1/entrada
				mkdir ~/EPNro1/salida
				mkdir ~/EPNro1/procesado
				echo "Las carpetas han sido creadas con éxito"
			else
				echo "Las carpetas ya existen en el directorio"
			fi
			echo "Presione ENTER para volver al menú"
			read
			;;
		2)
			# Primero compruebo la existencia de $FILENAME.txt
			if [ ! -f ~/EPNro1/salida/$FILENAME.txt ]; then # si no existe, crea $FILENAME.txt
				echo > ~/EPNro1/salida/$FILENAME.txt
				echo "Se ha creado el archivo $FILENAME.txt en el directorio salida. Continuando.."
			else
				echo "El archivo $FILENAME.txt ya existe en el directorio. Continuando.."
			fi

			# Copio el script consolidar.sh a la carpeta EPNro1
			DIR_SCRIPT=$(dirname "$0") # busca donde esta localizado el script
			cp $DIR_SCRIPT/consolidar.sh ~/EPNro1

			# ejecuto el script en background
			bash ~/EPNro1/consolidar.sh &
			CONSOLIDAR_ID=$! # obtengo la ID del proceso en background que se acaba de ejecutar y lo guardo en una variable que exporto para luego volver a acceder a ella en caso de querer matar el proceso
			echo $CONSOLIDAR_ID > ~/EPNro1/.CONSOLIDAR_ID # creo un archivo invisible donde guardo el ID del proceso de consolidar para poder matarlo al usar -d
			echo "El script ha comenzado a ejecutarse en background"

			echo "Presione ENTER para volver al menú"
			read
			;;
		3)
			# Ordena los items por número de padrón
			if [ -f ~/EPNro1/salida/$FILENAME.txt ]; then
				sort -n ~/EPNro1/salida/$FILENAME.txt # como el número de padron va primero, se ordenan por número así nomas.
			else
				echo "ERROR: El archivo $FILENAME.txt no existe."
			fi

			echo "Presione ENTER para volver al menú"
			read
			;;
		4)
			# Ordena por las 10 notas mas altas
			if [ -f ~/EPNro1/salida/$FILENAME.txt ]; then
				awk '{print $NF, $0}' ~/EPNro1/salida/$FILENAME.txt | sort -n -r | cut -f2- -d' ' | head -n 10 # agarra la ultima fila (la de las notas) y la copia delante, luego las ordena de mayor a menor y por ultimo saca la primera fila para que quede ordenado tal como se pide
			else
				echo "ERROR: El archivo $FILENAME.txt no existe."
			fi

			echo "Presione ENTER para volver al menú"
			read
			;;
		5)
			# Solicita un numero de padron para buscarlo
			echo -n "Ingrese un número de padrón: "
			read PADRON

			# Busca el padrón en el archivo
			OUTPUT=$(grep -w $PADRON ~/EPNro1/salida/$FILENAME.txt) # Busco solo la serie de numeros dada y la pongo en una variable para poder printear un echo en caso de no existir el numero
			if [ -n "$OUTPUT" ]; then
				echo $OUTPUT
			else
				echo "El número de padrón ingresado no existe en $FILENAME.txt"
			fi

			echo "Presione ENTER para volver al menú"
			read
			;;
		6)
			# Sale del script
			echo "Saliendo"
			break # rompe el bucle
			;;
	esac
done
