	Realizar fork al repositorio e incluir nueva carpeta con el nombre del juego escogido, así como la lista de nombres del equipo
# Conecta 4 - Proyecto Final de Lógica Computacional
Este proyecto es una implementación del clásico juego **Conecta 4** desarrollada íntegramente en Prolog. El juego permite a dos jugadores competir por turnos para alinear cuatro fichas en un tablero de 7x6, utilizando exclusivamente el paradigma de programación lógica.
## 1. Integrantes del Equipo
López Rojas Jesús: 322153507
Pineda Morales Roberto Gael: 322045697
## 2. Instrucciones de Uso
Para ejecutar el juego, sigue estos pasos en tu terminal de Linux:
1. Inicia el intérprete de Prolog:
   ```bash
   swipl
2.Carga el archivo del proyecto
    ?- consult('juego.pl').
3.Para iniciar una partida o realizar movimientos, utiliza las consultas descritas en la sección de ejemplos.
3. Reglas del Juego
El tablero consta de 7 columnas y 6 filas.


Dos jugadores (representados por los átomos x y o) dejan caer una ficha en una de las columnas por turno.


La ficha ocupa la posición más baja disponible en la columna elegida.
Una columna no puede aceptar más de 6 fichas.


El primer jugador en lograr una línea de cuatro fichas consecutivas (horizontal, vertical o diagonal) gana la partida.



4. Explicación de las Reglas Lógicas
El programa se basa en los siguientes predicados principales:
tablero_inicial/1: Define el estado de partida como una lista de 7 listas vacías, representando las columnas del tablero.
mover/4: Gestiona la lógica de los turnos. Verifica que la columna seleccionada (1-7) no esté llena (largo < 6) y unifica el nuevo estado del tablero con la ficha del jugador añadida.
 +1


estado_ganador/2: Evalúa mediante recursión y unificación si el estado actual del tablero contiene una secuencia de 4 fichas idénticas para el jugador en cuestión.


visualizar/1: Imprime el tablero de forma legible en la consola de SWI-Prolog.


5. Ejemplo de Sesión de Juego
A continuación, se muestra una secuencia de consultas para una partida rápida:
% 1. Inicializar tablero
?- tablero_inicial(T0).
% 2. El jugador 'x' tira en la columna 1
?- mover(T0, x, 1, T1).
T1 = [[x], [], [], [], [], [], []].
% 3. El jugador 'o' tira en la columna 2
?- mover(T1, o, 2, T2).
T2 = [[x], [o], [], [], [], [], []].
% 4. Verificar si alguien ganó
?- estado_ganador(T2, x).
false


