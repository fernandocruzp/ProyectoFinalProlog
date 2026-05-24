Nombre del juego: Loop.

Descripción:
Es un juego entre dos jugadores. El tablero es una gráfica completa K6, en el cual los jugadores se alternan por colocar aristas (conexiones) de su propio color. El objetivo es evitar formar un ciclo de 3 vértices con aristas de un mismo color.

Integrantes del equipo:
--Cisneros Tenorio Diego Alexander.
--Núñez Ruiz José Manuel.
--Jiménez Rivera Emiliano Kaleb.

Reglas del juego.
1. El juego es para dos jugadores.
2. Cada jugador puede colocar únicamente una arista por turno.
3. Cada jugador debe colocar una arista en cada turno.
4. Si una arista ya ha sido escogida, entonces la arista le pertenece a ese jugador y no puede ser usada en movimientos posteriores.
5. Si un jugador forma un ciclo con sus aristas (tomando a sus vértices como esquinas), entonces el jugador pierde la partida.

Explicación de las reglas lógicas.
-estado_valido/1: Función que identifica un estado del juego válido. Un estado está compuesto de 3 elementos: turno, aristas_j1, aristas_j2; y será válido si el turno es j1,j2 y aristas_j1, aristas_j2 son listas de aristas. Esta función permite identificar el turno en el que se está jugando.
-ejecutar_movimiento/4: Función que permite ejecutar los movimientos del juego y generar el próximo estado. Para ejecutar un movimiento se requieren 4 elementos: Estado Actual, Vértice X, Vértice Y y Estado Siguiente. Será un movimiento válido, solo si el Estado Actual es válido y la arista con vértices X,Y existe en el tablero y no está en ninguna de las listas de los jugadores. Al cumplirse estas condiciones, la función inserta la arista en la lista del jugador en turno y alterna el próximo turno para generar el estado siguiente.
