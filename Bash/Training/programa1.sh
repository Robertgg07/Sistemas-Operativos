#!/bin/bash

#Variables
#Constantes
#Funciones
#Programa Principal


PROGNAME="$(basename "$0")"
usuario=""
num_procesos=""

function error_exit() {

#	--------------------------------------------------------------
#	Función para salir en caso de error fatal
#		Acepta 1 argumento:
#			cadena conteniendo un mensaje descriptivo del error
#	--------------------------------------------------------------

    echo "${PROGNAME}: ${1:-Error desconocido}" >&2
    exit 1
}

function print_help() {
    echo "./programa1.sh [-h] [-u | --user usuario] [-f | --first n]"
}

function usuario_existe() {
    id $1 > /dev/null 2>&1 #No importa lo que salga, no quiero que salga toda la información, solo quiero saber que si se ejecutó el comando "id" 
    if [[ $? != "0" ]]; then
        error_exit "El usuario no existe"
    fi
}


while [[ $1 != "" ]]; do
    case $1 in

    -h )
        print_help
        exit 0
    ;;

    -u | --user )

        shift # Al ponerlo salta al siguiente argumento
        if [[ $1 == "" || $1 == -* ]]; then
            error_exit "Falta el nombre de usuario"
        fi
        usuario_existe $1 #Así se llama a la funcion
        usuario=$1
        shift

    ;;

    -f | --first )
        shift
        if [[ $1 == "" || $1 == -* ]]; then
            error_exit "Falta un número"
        fi

        if [[ $1 -le 0 ]]; then
            error_exit "Tiene que ser un número positivo"
        fi
        num_procesos=$1
        shift   
    ;;

    -* )
    error_exit "No se reconoce la opción"
    ;;

    * )
    error_exit "No se reconoce el argumento"
    ;;
    esac
done

#Programa Principal y Lógica del programa
#lsof -u usuario| awk '{print $2}' |sort -n | uniq | tail -n +2
# Para coger el porcentaje se usa el comando ps -q (num_proceso) --no-header | awk '{print $3}'
#Peguntar mañana a Jonay como hacerlo pq no tengo ni puta idea

