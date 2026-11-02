1.- SI se llama sin opciones mostrará una lista de las aperturas de archivo del usuario de la sesión actual según salida del comando lsof con la opción -u nombre_de_usuario. Recuerda que el nombre del usuario de la sesión actual lo puedes obtener de la variable $USER. Se deben mostrar solo los campos correspondientes a las columnas COMMAND y PID de lsof.  

2.- SI se llama con la opción -p seguida de un número de PID, se mostrará lwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwo siguiente: procedente de lsof, el número de aperturas de archivo del proceso seleccionado por PID y procedente del comando ps el tiempo transcurrido desde que fue iniciado (campo etime de ps)  
NOta: lsof -p número_de_pid: devuelve las aperturas de archivo de proceso ps -p numero_de_pid -oetime: devuelve elapsed time del procesos

3.- SI se llama con la opción -u  seguida de una lista de usuarios de tamaño definido y separada por espacios se mostrará para cada usuario de aperturas de archivos. Pasta implementar esta opción tendrás que usar está función:
 
 isvalidusuerarg() { 
    if [ -z “$1” ]; then  
    return 1; 
    fi [[ ! $1 =~ ^-.* ]] }

4.- Las opciones -u y -p son incompatibles. Si se usan ambas se debe mostrar un mensaje de error de salida y terminar el script de salida diferente de 0. 
