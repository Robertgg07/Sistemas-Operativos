#!/bin/bash

#Variables
#Constantes
#Funciones
#Programa Principal


PROGNAME="$(basename "$0")"
FORMATO_PRINT="%40s|%10s|%10s|\n"
usuario=""
num_procesos=""
PIDS=""
aux=""
procesos=""
opcion_num=""
comando_sort=""

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

function nombre_existe(){
    name=$(ps -aux -q $1 | awk '{print $11}')
    if [[ -z "$name" ]]; then
        echo "N/A"
    else
        echo ${name}
    fi
}

function cpu_existe(){

    cpu=$(ps -aux -q $1 | awk '{print $3}')

    if [[ -z "$cpu" ]]; then
        echo "N/A"
    else
        echo ${cpu}
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
    -s | --sort )
        comando_sort=$(sort -k 3 -nr)  #Ordena la tercera columna que es el %CPU de mayor a menor
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
    opcion_num="cat"
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
printf ${FORMATO_PRINT} "Nombre" "PID" "%CPU"
PIDS=$(lsof ${opcion_usuario} | awk '{print $2}' | sort -n | uniq | tail -n +2 | ${opcion_num})
for aux in $PIDS; do

    printf ${FORMATO_PRINT} $(nombre_existe ${aux}) ${aux} $(cpu_existe ${aux})

done | ${comando_sort} 

#El printf guarda todas las cadenas en el bufer de la memoria y las suelta todas a la vez, al estar el comando sort se ordenan
# Creamos una variable donde guardaremos el comando que nos muestra la información del PID, aux es una variable auxiliar que recorrerá el comando
# que hemos puesto anteriormente y luego crearemos otra variable que ejecutará un comando que nos dará el % de CPU de cada PID, al final volvemos
# a guardar ese comando en una variable y luego lo mostraremos por pantalla con 'echo'.