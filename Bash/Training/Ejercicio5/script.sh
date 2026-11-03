#!/bin/bash
#Variables

#Buscar manera mas sencilla

PROGNAME="$(basename "$0")"
user=""
num=5
FORMATOPRINT="%10s|%10s|%10s|\n"
#Funciones
function error_exit() {

    echo "${PROGNAME}: ${1:-Error desconocido}" >&2
    exit 1
}

function lsof_instalado() {
    type lsof > /dev/null 2>&1 

    if [[ $? != 0 ]]; then

        error_exit "lsof no está instalado"
    fi
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

function caso_estandar_nuevo() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"

    procesos=$(ps -aux --no-header | sort -k4 -nr | awk '{print $2 "|" $4 "|" $11}' | head -n 5)
    
    for proceso in $procesos; do

        pid=$(echo $proceso | cut -d "|" -f 1)
        mem=$(echo $proceso | cut -d "|" -f 2)        
        command=$(echo $proceso | cut -d "|" -f 3)
    
        printf "$FORMATOPRINT" "$pid" "$mem" "$command"
    done
}

function caso_usuario_nuevo() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"

    procesos=$(ps -aux -U $USER --no-header | sort -k4 -nr | awk '{print $2 "|" $4 "|" $11}' | head -n $num)

    for proceso in $procesos; do

        pid=$(echo $proceso | cut -d "|" -f 1)
        mem=$(echo $proceso | cut -d "|" -f 2)        
        command=$(echo $proceso | cut -d "|" -f 3)
    
        printf "$FORMATOPRINT" "$pid" "$mem" "$command"
    done
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

if [[ ! -z "$user" ]]; then
    caso_usuario_nuevo
else
    caso_estandar_nuevo
fi

exit 0