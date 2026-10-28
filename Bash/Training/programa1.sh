#!/bin/bash

#Variables
#Constantes
#Funciones
#Programa Principal


PROGNAME="$(basename "$0")"
usuario=""
num_procesos=""
lista=""
aux=""
procesos=""
opcion_num=""

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
# lsof | awk '{print $2}' |sort -n | uniq | tail -n +2
# Para coger el porcentaje se usa el comando ps -q (num_procesos) --no-header | awk '{print $3}'

if [[ -z $num_procesos ]]; then
    opcion_num=""
else
    opcion_num="head -n $num_procesos"
fi

if [[ -z $usuario ]]; then
    opcion_usuario="" 
else
    opcion_usuario="-u $usuario"
fi
# En este caso para que se sepa el usuario, comprobamos que si no hay usuario nos muestre los procesos de todos haciendo la variable opcion_usuario vacia
# Si la opcio_usuario no lo está como deberemos hacer que se muestren los procesos de los usuarios y en la variable lista añadir al comando la opción
# -u $usuario(variable que antes guardaba el usuario) para que lo muestre por pantalla al ejecutar el script
echo "PID -> %CPU"
lista=$(lsof $opcion_usuario | awk '{print $2}' |sort -n | uniq | tail -n +2 | $opcion_num )
for aux in $lista; do
    procesos=$(ps -aux -q $aux --no-header | awk '{print $3}')
    echo "$aux -> $procesos"
done
# Creamos una variable donde guardaremos el comando que nos muestra la información del PID, aux es una variable auxiliar que recorrerá el comando
# que hemos puesto anteriormente y luego crearemos otra variable que ejecutará un comando que nos dará el % de CPU de cada PID, al final volvemos
# a guardar ese comando en una variable y luego lo mostraremos por pantalla con 'echo'.


