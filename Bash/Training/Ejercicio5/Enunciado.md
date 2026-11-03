Ejercicio 3: Monitor de procesos

Realizar un script en Bash que muestre información sobre los procesos que se están ejecutando en el sistema.

1. Sin opciones

Si se ejecuta sin argumentos, mostrará los 5 procesos que más memoria RAM estén consumiendo.
Formato de salida:

PID     %MEM     COMMAND
1234    2.5      firefox
5678    1.8      code

2. Opción -u usuario

Si se proporciona esta opción, únicamente se mostrarán los procesos pertenecientes al usuario indicado.

Ejemplo:

./procesos.sh -u usuario

3. Opción -n número

Permitirá indicar cuántos procesos queremos mostrar en lugar de los 5 predeterminados.

Ejemplo:

./procesos.sh -n 10

4. Validaciones

Si se introduce un usuario que no existe, se mostrará un mensaje de error.

Si el número indicado con -n no es positivo, se mostrará un mensaje de error.

Si se introduce una opción desconocida, se mostrará un mensaje de ayuda.