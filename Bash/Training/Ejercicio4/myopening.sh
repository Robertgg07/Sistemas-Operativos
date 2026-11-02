#!/bin/bash

#Variables
PID=""
lista_user=""
usuario=""
aux=""
#Constantes
CASOESTANDAR=$(lsof -u $USER | awk '{print $1 "." $2}' | sort | uniq | tail -n +2)
PROGNAME="$(basename "$0")"
FORMATOPRINT="|%15s|%15s|\n"
#Funciones

function error_exit() {
    echo "${PROGNAME}: ${1:-Error desconocido}" >&2
    exit 1

}

function print_help() {
    echo "Uso: ./myopening.sh [-h | --help] [-p num_PID] [-u lista_user]"
}
function valid_user() { 
    id $1 > /dev/null 2&>1
    if [[ $? != 0 ]]; then
        error_exit "El usuario no existe"
    fi
}

function caso_estandar() {
    printf $FORMATOPRINT "COMMAND" "PID"
    for aux in $CASOESTANDAR; do
        command=$(echo $aux | cut -d "." -f 1)
        pid=$(echo $aux | cut -d "." -f 2)
        printf $FORMATOPRINT "$command" "$pid"
    done
    exit 0
}

function aperturas_abiertas() {
    lsof -p $1 | tail -n +2 | wc -l
}
function tiempo_abierto() {
    ps -p $1 -oetime --no-header
}



function CasoP() {
    printf $FORMATOPRINT "Num.Aperturas" "Tiempo Transcurrido"

    printf $FORMATOPRINT "$(aperturas_abiertas $1)" "$(tiempo_abierto $1)"
    exit 0
}
function aperturas_abiertas_user() {
    lsof -u $1 | tail -n +2 | wc -l
}

function CasoU() {
    printf $FORMATOPRINT "Lista Usuarios" "N:Abiertos"

    for aux in $1; do
        printf $FORMATOPRINT "$aux" "$(aperturas_abiertas_user $aux)"
    done
    exit 0
}
while [[ $1 != "" ]]; do
    case $1 in
        -h | --help )
            print_help
            exit 0
        ;;

        -p )
            shift
            if [[ $1 == "" || $1 == -* ]]; then
                error_exit "Falta el Número PID"
            fi

            PID=$1
            shift
        ;;

        -u )
            shift
            if [[ $1 == "" || $1 == -* ]]; then
                error_exit "Falta la lista de ususarios"
            fi
            while [[ $1 != "" && $1 != -* ]]; do
                valid_user $1
                lista_user="$lista_user $1"
                shift
            done
        ;;

        -* )
            error_exit "Opcion desconocida"
        ;;

        * )
            error_exit "Argumento desconocido"
        ;;



    esac
done


#Programa Principal
if [[ ! -z $PID && ! -z $lista_user ]]; then
    error_exit "Las opciones -u y -p son incompatibles"
fi
if [[ -z $PID && -z $lista_user ]]; then
    caso_estandar
fi

if [[ ! -z $PID ]]; then
    CasoP $PID
else
    CasoU "$lista_user"
fi