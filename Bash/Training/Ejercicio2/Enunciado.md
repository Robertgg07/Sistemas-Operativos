Modificar el programa desarrollado ayer para que se comporte de la siguiente forma:
Vamos a hacer una tablita para que quede bien bonita que sea:

(nombre/comando) / PID/ % CPU (Usando el comando "printf")

Si la columna (nombre/comando) o en la columna de %cpu no obtenemos nada entonces ponemos N/A en ese hueco de la tabla

Por defecto el programa ordenara los archivos por el número de PID (de menos PID a más PID), si se pone la opción -s | --sort los ordenara por el porcentaje de cpu, de mayor de menor


Por si la modificación es muy corta:


Añadir la opción -f | --file fichero que servirá para imprimir la salida del programa por un fichero en vez de por la salida estandar. 

Además se deberá comprobar si ese fichero existe, en caso de que exista se le deberá avisar al usuario de si quiere sobreescribir ese fichero, en caso de que no quiera el programa termina con salida 2. Para hacer esto hay que cambiar la opción -f | --first por -p | --primeros