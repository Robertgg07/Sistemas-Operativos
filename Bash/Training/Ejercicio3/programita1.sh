#!/bin/bash

#Variables
PROGNAME=$(basename "$0")
usuario=""
num_procesos=""
aux=""
PIDS=""
procesos_mem=""
opcion_numero=""
opcion_usuario=""
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
    if [[ $? != "0" ]]; then
    error_exit "Usuario no encontrado"
    fi
}

function mayor_zero() {
    if [[ $1 -le "0" ]]; then
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
            num_procesos=$1
            shift
        ;;

        -* )
        error_exit "No se reconoce la accion"
        ;;

        * )
        error_exit "No se reconoce el argumento"
        ;;
    esac
done



#Programa Principal
if [[ -z $num_procesos ]]; then
    opcion_numero="cat"
else
    opcion_numero="head -n $num_procesos"
fi

if [[ -z $usuario ]]; then
    opcion_usuario=""
else
    opcion_usuario="-u $usuario"
fi


echo "PID --> MEMORIA (%)"
PIDS=$(ps ${opcion_usuario} | awk '{print $2}' | sort -n  |uniq | ${opcion_numero})
for aux in $PIDS; do
    procesos_mem=$(ps -aux -q $aux --no-header | awk '{print $4}')
    echo "${aux} --> ${procesos_mem} (%)"
done
