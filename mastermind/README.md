Mastermind en Prolog

Descripción: 
Mastermind es un juego de deducción en el que el jugador intenta adivinar
un patrón secreto de 5 colores generado aleatoriamente. En cada intento,
el juego indica cuántos colores están perfectamente colocados y cuántos
son correctos pero están en la posición incorrecta. El jugador tiene 10
intentos para adivinar el patrón completo. Los colores no se repiten. 

Integrantes
- Feregrino Mesinas Renata
- Marquez Cristoval Miguel Ángel
- Rivera Lugo Araní Karol
- Torres Cuevas Gael Patricio

Instrucciones de uso
1. Abre una terminal y ejecuta SWI-Prolog: swipl


2. Carga el archivo del juego:
?- consult('juego.pl').

3. Inicia el juego:
?- iniciar.

4. Cuando el juego pida tu adivinanza, escribe una lista de 5 colores
   entre corchetes, separados por comas, terminando con punto. Ejemplo:
   [rosa, azul, verde, morado, dorado].

* Colores disponibles:
rosa, azul, verde, morado, dorado, negro

Reglas del juego: 
1. Al iniciar, el juego genera un patrón secreto de 5 colores tomados aleatoriamente del universo de colores disponibles.
2. El jugador tiene 10 intentos para adivinar el patrón completo.
3. Después de cada intento, el juego muestra:
   - **Colores perfectamente colocados:** cuántos colores están en la posición correcta.
   - **Colores correctos pero mal colocados:** cuántos colores forman parte del patrón pero están en una posición incorrecta.
4. Si el jugador adivina los 5 colores en las posiciones correctas, gana.
5. Si se agotan los 10 intentos sin adivinar el patrón, el juego revela el patrón secreto y el jugador pierde.

Explicación de los predicados principales

colores_universo: Define el conjunto de colores válidos del juego como un hecho. Es la base para generar el patrón y validar entradas.

generar_patron: Genera recursivamente una lista de N colores elegidos al azar del universo. Caso base: 0 colores produce lista vacía.

elegir_color_random: Obtiene un color aleatorio del universo usando un índice generado con random y buscándolo con buscar_indice.

buscar_indice: Recorre recursivamente una lista hasta el índice dado y devuelve el elemento en esa posición.

iniciar: Punto de entrada del juego. Muestra las instrucciones, genera el patrón secreto y arranca el loop con 10 intentos.

jugar: Loop principal del juego. Recibe el patrón y los intentos restantes. Si los intentos llegan a 0, el jugador pierde. Si no, pide un intento, lo evalúa y llama a continuar.

continuar: Decide si el juego termina (resultado ganador) o sigue (seguir) llamando recursivamente a jugar.

checar_intento: Evalúa el intento del jugador contra el patrón secreto. Llama a aciertos_exactos y aciertos_parciales, imprime los resultados y devuelve ganador o seguir.

aciertos_exactos: Compara posición por posición el patrón y el intento. Cuenta cuántos colores coinciden exactamente y separa los no exactos en dos listas para procesarlos después.

aciertos_parciales: Toma los colores no exactos del intento y busca cada uno en los sobrantes del patrón usando obtener_color. Cuenta cuántos colores están en el patrón pero en posición incorrecta, sin contar el mismo color dos veces.

obtener_color: Busca un color en una lista y devuelve la lista sin ese elemento, evitando contar duplicados.

Ejemplo de sesión de juego

?- iniciar.
Instrucciones:
1. Se creará un patrón secreto de 5 colores sin repeticiones.
2. Los colores disponibles son: rosa, azul, verde, morado, dorado, negro.
3. Debes adivinar los colores y sus posiciones exactas escribiéndolos tal cual crees que están.
4. Tienes 10 intentos para adivinar el patrón completo.
---------------------------------------------

El patrón secreto ha sido generado :)

Te quedan 10 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [rosa, azul, verde, morado, dorado].

Resultados:
Colores perfectamente colocados: 1
Colores correctos pero mal colocados: 3

Te quedan 9 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [dorado, rosa, azul, verde, morado].

Resultados:
Colores perfectamente colocados: 0
Colores correctos pero mal colocados: 4

Te quedan 8 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [morado, dorado, rosa, azul, verde].

Resultados:
Colores perfectamente colocados: 3
Colores correctos pero mal colocados: 1

Te quedan 7 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [verde, morado, dorado, rosa, azul].

Resultados:
Colores perfectamente colocados: 0
Colores correctos pero mal colocados: 4

Te quedan 6 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [azul, verde, morado, dorado, rosa].

Resultados:
Colores perfectamente colocados: 0
Colores correctos pero mal colocados: 4

Te quedan 5 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [negro, dorado, rosa, azul, verde].

Resultados:
Colores perfectamente colocados: 3
Colores correctos pero mal colocados: 2

Te quedan 4 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [verde, dorado, rosa, azul, negro].

Resultados:
Colores perfectamente colocados: 2
Colores correctos pero mal colocados: 3

Te quedan 3 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [negro, azul, dorado, rosa, verde].

Resultados:
Colores perfectamente colocados: 1
Colores correctos pero mal colocados: 4

Te quedan 2 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [rosa, dorado, verde, azul, negro].

Resultados:
Colores perfectamente colocados: 3
Colores correctos pero mal colocados: 2

Te quedan 1 intentos.
Ingresa tu adivinanza de 5 colores: 
|: [rosa, dorado, negro, azul, verde].

Resultados:
Colores perfectamente colocados: 5
Colores correctos pero mal colocados: 0

¡Ganaste! :D
true .

?- iniciar.
