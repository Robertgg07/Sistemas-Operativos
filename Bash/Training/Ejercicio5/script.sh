#!/bin/bash
#Variables

#Buscar manera mas sencilla

PROGNAME="$(basename "$0")"
user=""
num=5
FORMATOPRINT="%20s|%20s|%20s|\n"
#Funciones
function error_exit() {

    echo "${PROGNAME}: ${1:-Error desconocido}" >&2
    exit 1

}

function print_help() {
    echo "Uso: ./script.sh [-h] [-u | --user usuario] [-n numero]"
}
function user_exist() {
    id $1 > /dev/null 2>&1
    if [[ $? != "0" ]]; then
    error_exit "Usuario no existe"
    fi
}

function caso_estandar() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"

    CASOESTANDAR=$(ps -aux | sort -k4 -nr | tail -n +2 | head -n "$num" | awk '{print $2}')

    for aux in $CASOESTANDAR; do
        pid=$(ps -aux -q "$aux" | tail -n 1 | awk '{print $2}')
        mem=$(ps -aux -q "$aux" | tail -n 1 | awk '{print $4}')
        command=$(ps -aux -q "$aux" | tail -n 1 | awk '{print $11}')

        printf "$FORMATOPRINT" "$pid" "$mem" "$command"
    done
    exit 0
}

function caso_U() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"

    CASOUSUARIO=$(ps -aux -U "$user" | sort -k4 -nr | tail -n +2 | head -n "$num" | awk '{print $2}')

    for aux in $CASOUSUARIO; do

        datos=$(ps -aux -U "$user" | awk -v pid="$aux" '$2 == pid')

        pid=$(echo "$datos" | awk '{print $2}')
        mem=$(echo "$datos" | awk '{print $4}')
        command=$(echo "$datos" | awk '{print $11}')

        printf "$FORMATOPRINT" "$pid" "$mem" "$command"

    done

    exit 0

}

function is_positive() {
    if [[ $1 -lt "0" ]]; then
        error_exit "Deben ser un número positivo"
    fi
}

while [[ $1 != "" ]]; do
    case $1 in
    -h | --help )
        print_help
        exit 0
    ;;

    -u | --user )
        shift
        if [[ $1 == "" || $1 == -* ]]; then
            error_exit "Falta el nombre de usuario"        
        fi
        user_exist $1
        user=$1
        shift
    ;;
    -n )
        shift
        if [[ $1 == "" || $1 == -* ]]; then
            error_exit "Falta un número"
        fi
        is_positive $1
        num=$1
        shift
    ;;
    -*)
        error_exit "Opción desconocida"
    ;;
    * )
        error_exit "Argumento desconocido"
    ;;


    esac
done

if [[ "$user" != "" ]]; then
    caso_U
else
    caso_estandar
fi

exit 0