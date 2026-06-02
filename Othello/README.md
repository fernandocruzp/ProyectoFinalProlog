# Othello
Este proyecto consiste en la implementación interactiva del clásico juego de tablero **Othello** (también conocido como Reversi). El juego se ejecuta completamente mediante la consola de comandos usando programación lógica, modelando las reglas completas del juego, asi como conteo de las fichas al final para determinar un ganador.

## Integrantes:
* Belmont Zúñiga Javier - 322000157
* García Bollás Emiliano - 425085718
* Reyes Ríos Julian Humberto - 322096455

## Instrucciones de Uso:
1. Abre tu terminal o consola de comandos en la carpeta donde se encuentra el archivo `juego.pl`.
2. Inicia la consola de Prolog e introduce la siguiente consulta para cargar el archivo:

```prolog
?- consult('juego.pl').
```
3. Una vez cargado exitosamente (true.), ejecuta el predicado para dar inicio al juego:
```prolog
jugar.
```
4. Durante tu turno, introduce tu jugada utilizando la sintaxis de Prolog en formato de par ordenado:
```prolog
Introduce tu movimiento "Fila-Columna." (ej. 3-4.): 3-4.
```
## Reglas del Juego
* Inicio: El juego comienza con cuatro fichas en el centro del tablero dispuestas en forma de cruz (dos de cada color de manera intercalada). El jugador con las fichas Negras (X) realiza el primer movimiento.
* Movimiento Válido: Un jugador debe colocar una ficha de su color en un espacio vacío adyacente a una ficha del oponente, de tal manera que atrape en línea recta (horizontal, vertical o diagonal) una o más fichas enemigas entre la ficha recién colocada y otra de su mismo color que ya estuviera en el tablero.
Al realizar un movimiento válido, todas las fichas enemigas que queden atrapadas en línea recta son volteadas y se transforman al color del jugador actual.
* Paso de Turno: Si en su turno un jugador no dispone de ningún movimiento válido disponible, está obligado a pasar su turno al oponente de manera automática.
* Condición de Fin y Victoria: El juego concluye cuando el tablero se llena por completo o cuando ninguno de los dos jugadores dispone de movimientos válidos (bloqueo mutuo). El ganador será aquel jugador que posea el mayor número de fichas de su color sobre el tablero al finalizar la partida. En caso de igualdad numérica, se declara un empate.

## Explicación de Reglas Logicas:
* tablero_inicial/1: Define de forma factual la configuración del tablero al inicio del juego mediante una lista plana de 64 elementos.
* xy_to_idx/3 y get_piece/4: Traducen las coordenadas lógicas bidimensionales (Fila, Columna) ingresadas por el usuario a un índice lineal continuo base 0 de la lista que representa el tablero, aplicando la restricción de que los valores deben mantenerse estrictamente entre 1 y 8.
* check_dir/7 y check_dir_line/7: Implementan las restricciones recursivas del flanqueo de Othello. Evalúan una dirección dada (DX, DY) para verificar si existe una hilera ininterrumpida de fichas enemigas rematada al final por una ficha propia, recolectando la lista de coordenadas de las piezas a invertir.
* mover/4: Se encarga de la transición de estados. Verifica si la casilla seleccionada está vacía (e), calcula todas las fichas enemigas capturadas por medio de get_all_flips/5, sitúa la nueva ficha y delega en flip_pieces/4 el volteo de las piezas para generar recursivamente el nuevo tablero.
* movimientos_validos/3: Hace uso de findall/3 y between/3 para escanear todo el tablero del juego simulando posibles tiros del jugador activo. Devuelve una lista de coordenadas (X, Y) que cumplen satisfactoriamente con las reglas de flanqueo.
* estado_ganador/2: Aplica un corte (!) y evalúa la condición de fin de juego cuando movimientos_validos/3 arroja listas vacías para ambos jugadores en el estado actual del tablero. Posteriormente cuenta el total de piezas de cada bando y unifica la variable del ganador.

## Ejemplo de ejecución
```prolog
?- consult('juego.pl').
true.

?- jugar.
    1 2 3 4 5 6 7 8
  +-----------------+
1 | . . . . . . . . |
2 | . . . . . . . . |
3 | . . . . . . . . |
4 | . . . O X . . . |
5 | . . . X O . . . |
6 | . . . . . . . . |
7 | . . . . . . . . |
8 | . . . . . . . . |
  +-----------------+
Turno del jugador b (X = Negras, O = Blancas).
Movimientos validos: [(3,4),(4,3),(5,6),(6,5)]
Introduce tu movimiento "Fila-Columna." (ej. 3-4.): 3-4.

    1 2 3 4 5 6 7 8
  +-----------------+
1 | . . . . . . . . |
2 | . . . . . . . . |
3 | . . . X . . . . |
4 | . . . X X . . . |
5 | . . . X O . . . |
6 | . . . . . . . . |
7 | . . . . . . . . |
8 | . . . . . . . . |
  +-----------------+
Turno del jugador w (X = Negras, O = Blancas).
Movimientos validos: [(3,3),(3,5),(5,3)]
Introduce tu movimiento "Fila-Columna." (ej. 3-4.):
```