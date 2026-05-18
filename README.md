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
==================================================================================================================================

## Guía de Pruebas en SWI-Prolog

Una vez cargado el archivo con `swipl juego.pl`, puedes utilizar las siguientes consultas para verificar las reglas lógicas del juego:

### 1. Inicialización y Movimientos Básicos
Sirve para crear el estado inicial y verificar que las fichas caen correctamente en las columnas.

* **Iniciar un tablero vacío:**
  `?- tablero_inicial(T).`
* **Realizar un movimiento (Ficha 'x' en Columna 1):**
  `?- tablero_inicial(T), mover(T, x, 1, T1).`
* **Ver el tablero dibujado:**
  `?- tablero_inicial(T), mover(T, x, 1, T1), visualizar(T1).`

### 2. Validación de Victorias (Casos de Prueba)
Copia y pega estas consultas completas para probar que el motor de reglas detecta los ganadores:

* **Victoria Vertical (Columna 1):**
  `tablero_inicial(T), mover(T, x, 1, T1), mover(T1, x, 1, T2), mover(T2, x, 1, T3), mover(T3, x, 1, T4), visualizar(T4), gana(T4, x).`
* **Victoria Horizontal (Fila base):**
  `tablero_inicial(T), mover(T, o, 1, T1), mover(T1, o, 2, T2), mover(T2, o, 3, T3), mover(T3, o, 4, T4), visualizar(T4), gana(T4, o).`
* **Victoria Diagonal Ascendente (/):**
  `tablero_inicial(T), mover(T, x, 1, T1), mover(T1, o, 2, T2), mover(T2, x, 2, T3), mover(T3, o, 3, T4), mover(T4, o, 3, T5), mover(T5, x, 3, T6), mover(T6, o, 4, T7), mover(T7, o, 4, T8), mover(T8, o, 4, T9), mover(T9, x, 4, T10), visualizar(T10), gana(T10, x).`

### 3. Reglas de Validación y Estado del Tablero
* **Verificar si una columna está llena (Falla si hay 6 fichas):**
  `nth1(IndiceColumna, Tablero, Col), length(Col, L), L < 6.`
* **Saber si el tablero está en empate (Todas las columnas llenas):**
  `forall(member(Col, Tablero), length(Col, 6)).`
* **Encontrar movimientos legales (Backtracking):**
  `between(1, 7, C), mover(TableroActual, x, C, _).`

  ### 4. Generación de Movimientos Válidos 
Tal como lo solicitan los lineamientos del proyecto, el programa es capaz de calcular dinámicamente qué columnas tienen espacios disponibles mediante el uso de *backtracking* y recolección de soluciones (`findall/3`).

* **Consulta para obtener la lista de columnas disponibles:**
  ```prolog
  ?- tablero_inicial(T), movimientos_validos(T, x, Lista).
 ** Resultado esperado:
Lista = [1, 2, 3, 4, 5, 6, 7].

Si llenamos la columna 3 con 6 fichas consecutivas y volvemos a consultar los movimientos válidos:
?- tablero_inicial(T), 
   mover(T, x, 3, T1), mover(T1, o, 3, T2), mover(T2, x, 3, T3), 
   mover(T3, o, 3, T4), mover(T4, x, 3, T5), mover(T5, o, 3, T6), 
   movimientos_validos(T6, x, Lista).

Resultado esperado:
Lista = [1, 2, 4, 5, 6, 7].

