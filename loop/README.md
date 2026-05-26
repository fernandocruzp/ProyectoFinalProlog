# Nombre del juego: Loop.

**Descripción:**
Es un juego entre dos jugadores. El tablero es una gráfica completa K6, en el cual los jugadores se alternan por colocar aristas (conexiones) de su propio color. El objetivo es evitar formar un ciclo de 3 vértices con aristas de un mismo color.

**Integrantes del equipo:**
* Cisneros Tenorio Diego Alexander.
* Núñez Ruiz José Manuel.
* Jiménez Rivera Emiliano Kaleb.

## Instrucciones de uso
Para jugar a Loop, no se requiere interfaz gráfica (pero se agrego una minimalista). Todo se ejecuta mediante consultas en la terminal usando SWI-Prolog.
1. Abre tu terminal de comandos y navega hasta la carpeta donde se encuentra el proyecto.
2. Carga el archivo en SWI-Prolog ejecutando el siguiente comando:
   `swipl juego.pl`
   *(También puedes abrir SWI-Prolog y escribir `?- consult('juego.pl').`)*.
3. Para jugar, debes definir un estado inicial vacío y luego encadenar consultas con la función `ejecutar_movimiento/4`, guardando los nuevos estados en variables (ej. `E1`, `E2`, etc.).
4. En cualquier momento puedes imprimir el tablero pasando el estado actual a la función `imprimir_tablero(Estado)`.

## Reglas del juego
1. El juego es para dos jugadores.
2. Cada jugador puede colocar únicamente una arista por turno.
3. Cada jugador debe colocar una arista en cada turno.
4. Si una arista ya ha sido escogida, entonces la arista le pertenece a ese jugador y no puede ser usada en movimientos posteriores.
5. Si un jugador forma un ciclo con sus aristas (tomando a sus vértices como esquinas), entonces el jugador pierde la partida.

## Explicación de las reglas lógicas
* **estado_valido/1:** Función que identifica un estado del juego válido. Un estado está compuesto de 3 elementos: turno, aristas_j1, aristas_j2; y será válido si el turno es j1 o j2 y aristas_j1, aristas_j2 son listas de aristas. Esta función permite identificar el turno en el que se está jugando.
* **ejecutar_movimiento/4:** Función que permite ejecutar los movimientos del juego y generar el próximo estado. Para ejecutar un movimiento se requieren 4 elementos: Estado Actual, Vértice X, Vértice Y y Estado Siguiente. Será un movimiento válido, solo si el Estado Actual es válido y la arista con vértices X,Y existe en el tablero y no está en ninguna de las listas de los jugadores. Al cumplirse estas condiciones, la función inserta la arista en la lista del jugador en turno y alterna el próximo turno para generar el estado siguiente.
* **movimientoValido/3:** Verifica doblemente que la arista que se quiere colocar entre dos vértices no esté ya ocupada por ningún jugador.
* **movimientos_validos/3:** Recopila en una sola lista todos los movimientos que aún están disponibles en el tablero de un solo golpe.
* **tiene_triangulo/1:** Revisa la lista de aristas de un jugador y detecta si existen tres aristas que formen un ciclo cerrado (ej. A-B, B-C, A-C).
* **jugador_gana/2 y fin_juego/1:** Evalúan las condiciones de victoria y derrota. Si la función detecta que el jugador en turno cerró un triángulo, automáticamente declara ganador al jugador contrario.
* **imprimir_tablero/1:** Toma el estado actual y dibuja en consola una matriz de adyacencia de 6x6 que representa visualmente el K6, marcando las casillas con "1" para el Jugador 1, "2" para el Jugador 2, o "." si están libres.

## Ejemplo de sesión de juego
A continuación se muestra una simulación de partida desde la consola. En este ejemplo, el Jugador 1 comete un error en su tercer turno cerrando un triángulo entre los vértices 'a', 'b' y 'c', lo que le da la victoria al Jugador 2.

```prolog
?- % 1. Estado inicial vacío (Turno J1)
   E0 = estado(j1, [], []),
   
   % 2. Jugador 1 une a-b
   ejecutar_movimiento(E0, a, b, E1),
   
   % 3. Jugador 2 une d-e
   ejecutar_movimiento(E1, d, e, E2),
   
   % 4. Jugador 1 une b-c
   ejecutar_movimiento(E2, b, c, E3),
   
   % 5. Jugador 2 une e-f
   ejecutar_movimiento(E3, e, f, E4),
   
   % 6. Revisamos visualmente el tablero actual
   imprimir_tablero(E4),
   
   % 7. Jugador 1 comete el error de unir a-c cerrando el triángulo
   ejecutar_movimiento(E4, a, c, EFinal),
   
   % 8. Verificamos quién ganó
   jugador_gana(Ganador, EFinal).
