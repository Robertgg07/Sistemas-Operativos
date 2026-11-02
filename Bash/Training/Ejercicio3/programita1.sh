#!/bin/bash

#Variables
usuario=""
mayor=""
#Constantes

#Funciones
function print_help() {
    echo "./programa1.sh [-h] [-u | --user usuario] [-f | --first n]"
}

function error_exit() {

#	--------------------------------------------------------------
#	Función para salir en caso de error fatal
#		Acepta 1 argumento:
#			cadena conteniendo un mensaje descriptivo del error
#	--------------------------------------------------------------

    echo "${PROGNAME}: ${1:-Error desconocido}" >&2
    exit 1
}
function usuario_existe(){
    id $1 > /dev/null 2>&1
    if [[ $? != "0"]]; then
    error_exit "Usuario no encontrado"
    fi
}

function mayor_zero() {
    if [[ $1 -lt "0" ]]; then
        error_exit "El número debe ser mayor a 0"
    fi
}

while [[ $1 != "" ]]; do

    case $1 in
        -h )
            print_help
            exit 0
        ;;
        -u | --user )
        #lsof | sort -n | uniq | awk '{print $}'
            shift
            if [[ $1 == "" || $1 == -* ]]; then
                error_exit "Falta el nombre de usuario"
            fi
            usuario_existe $1
            usuario=$1
            shift
        ;;
        -f | --first ) 
        #ps -aux -q (numero) | awk '{print $2}'
            shift
            if [[ $1 == "" || $1 == -* ]]; then
                error_exit "Falta un número"
            fi
            mayor_zero $1
            mayor=$1
            shift
        ;;

        -* )
        ;;

        * )
        ;;
done



#Programa Principal


