#!/bin/bash

FORMATOPRINT="%10s|%10s|%10s|\n"

function user_exit() {
    id $1 > /dev/null 2>&1
    if [[ $? != "0" ]]; then
        error_exit "No existe el usuario"
    fi
}

function is_positive() {
    if [[ $1 -le 0 ]]; then
        error_exit "Debe ser un número mayor a 0"
    fi
}

function get_user() { #para un proceso
    name=$(ps -aux -q $1 | awk '{print $1}')
    if [[ -z "$name" ]]; then
        echo "N/A"
    else
        echo "$name"
    fi
}

function get_cpu() {
    cpu=$(ps -aux -q $1 | awk '{print $3}')
    if [[ -z "$cpu" ]]; then
        echo "N/A"
    else
        echo "$cpu"
    fi
}

function lsof_installed() {
    type lsof > /dev/null 2>&1
    if [[ $? != 0 ]]: then
        error_exit "lsof no esta instalado"
    fi
}

function fichero_existe() {
    respuesta=""
    if [[ -f $1 ]]; then
        echo "Ya existe el fichero, desea sobreescribirlo? [S/n]"
        read $respuesta
        if [[ $respuesta != "S" ]]; then
        error_exit "Fichero abortado"
        exit 2
        fi
    fi
}

function caso_estandar() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"
    CASOESTANDAR= $(ps -aux --no-header | sort -k4 -nr | awk '{print $1 "|" $4 "|" $11}' | head -n 10)
# $CASOESTANDAR guarda las líneas de la ejecución del comando lsof y luego iteramos por cada linea con un bucle for 

# el echo $linea muestra la linea entera y el comando cut -d "." -f 1 coge la columna y la separa con "." y la coloca la primera "1"
    for proceso in $CASOESTANDAR; do
    pid=$(echo $proceso | cut -d "|" -f 1)
    mem=$(echo $proceso | cut -d "|" -f 2)
    command=$(echo $proceso | cut -d "|" -f 3)

    printf "$FORMATOPRINT" "$pid" "$mem" "$command"

    done
}

function GetFirstTen() {
  
  find -type f | sort | head -n 10 # Muestra los 10 primeros ficheros del directorio actual en orden alfabético sin contar los directorios que hay dentro de él
# -f --> Buscar solo ficeros regulares
# find -type ---> el fichero es de type (tipo) -f (fichero regular) | el sort ordena alfabeticamente | head -n 10 muestra las 10 primeras
}



function caso_U() {

    printf "$FORMATOPRINT" "PID" "%MEM" "COMMAND"
    CASOU= $(ps -aux -U $USER --no-header | sort -k4 -nr | awk '{print $2 "|" $4 "|" $11}' | head -n 10)

    for proceso in $CASOESTANDAR; do
    pid=$(echo $proceso | cut -d "|" -f 1)
    mem=$(echo $proceso | cut -d "|" -f 2)
    command=$(echo $proceso | cut -d "|" -f 3)

    printf "$FORMATOPRINT" "$pid" "$mem" "$command"
    
    done
}
while [[ $1 != "" ]]; do
    case $1 in
    -u )
        shift
        if [[ $1 == "" || $1 == -* ]]; then
            error_exit "Falta el nombre de usuario"
        fi
        user_exist $1
        user=$1
        shift
    ;;
    esac

done

if [[ -z "$user" ]]; then
    caso_estandar
else
    caso_U
fi