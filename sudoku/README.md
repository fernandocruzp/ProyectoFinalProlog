# SUDOKU INTERACTIVO

## 1. Descripción

Este proyecto es una implementación interactiva del juego Sudoku desarrollada en Prolog. El programa permite al usuario seleccionar entre tres niveles de dificultad (fácil, intermedio y avanzado), adaptando el reto según su habilidad. El juego se maneja a través de la consola, donde el usuario realiza inserciones de valores que son validadas en tiempo real, garantizando que se respeten estrictamente las restricciones lógicas de filas, columnas y cuadrantes.

## 2. Integrantes

- Espino Gutiérrez Alejandro (322069512)

- Martínez Sasaguri Kiyomi Amanda (322272929)

- Olmos Ortiz Andrea Lucia (322149977)

- Reynoso Ascencio Alexa (322179457)
 
## 3. Instrucciones de uso

Desde la terminal, ubicarse en la carpeta del proyecto y ejecutar: swipl -g "iniciar, halt" interfaz.pl

Seleccionar el nivel de dificultad(Fácil, Intermedio o Difícil) y el tablero aparecerá en consola.

Para realizar una jugada, ingresar: <fila> <columna> <valor>   (Ejemplo: > 3 5 7)

Para borrar una celda, ingresar 0 como valor (Ejemplo: > 3 5 0)


## 4. Reglas del juego

Si nunca has jugado Sudoku, el objetivo es rellenar una cuadrícula de 9x9 espacios con números del 1 al 9.

**Restricciones**

- **La regla de la fila (Horizontal):** En cada una de las 9 filas horizontales, no puede haber números repetidos. Cada número del 1 al 9 debe aparecer exactamente una vez.

- **La Regla de la Columna (Vertical):** Lo mismo aplica para las columnas. En cada línea vertical, los números no pueden repetirse.

- **La Regla del Cuadrante (Caja de 3x3):** El tablero grande está dividido por líneas más gruesas en 9 cajas pequeñas de $3 \times 3$ espacios. Dentro de cada una de esas cajas, también deben estar los números del 1 al 9 sin repetirse.

**Niveles de dificultad**

1. Fácil: Tablero inicial con mayor cantidad de pistas.

2. Intermedio: Cantidad moderada de pistas.

3. Avanzado: Pocas pistas iniciales, requiriendo técnicas de deducción complejas.

## 5. Explicación de reglas lógicas

1. Validación de filas

Cada vez que se inserta un número, el sistema verifica que no exista otro valor igual dentro de la misma fila.

2. Validación de columnas

El programa revisa que el número no se repita en la columna correspondiente.

3. Validación de cuadrantes

El tablero se divide en 9 cuadrantes de tamaño 3x3.
Cada inserción es validada para asegurar que el número no esté repetido dentro del mismo cuadrante.

4. Restricción de celdas bloqueadas

Loa números iniciales del Sudoku no pueden modificarse.

5. Detección de tablero completo

El juego termina cuando todas las celdas están llenas y el tablero completo cumple todas las reglas del Sudoku

En ese momento se muestra un mensaje de victoria.

## 6. Ejemplo de sesión de juego


  ┌──────────────────────────────┐
  │            SUDOKU            │
  ├──────────────────────────────┤
  │  Selecciona el nivel         │
  │    1.  Fácil                 │
  │    2.  Intermedio            │
  │    3.  Difícil               │
  └──────────────────────────────┘
  Opción: 1

      1   2   3   4   5   6   7   8   9
    +───────────+───────────+───────────+
  1 |  3  .  . | .  .  2 | .  9  . 
  2 |  .  .  . | .  .  . | .  .  4 
  3 |  .  .  5 | .  .  . | .  3  . 
    +───────────+───────────+───────────+
  4 |  6  .  . | 1  .  . | 3  .  . 
  5 |  .  .  . | .  6  . | .  .  8 
  6 |  .  8  . | 2  .  3 | 5  7  . 
    +───────────+───────────+───────────+
  7 |  .  .  6 | 5  .  4 | .  .  . 
  8 |  1  .  . | .  .  . | .  .  2 
  9 |  9  .  . | .  1  . | .  .  7 
    +───────────+───────────+───────────+

  Jugada  :  <fila> <columna> <valor>   (ejem: > 3 5 7)
  Salir   :  q
  > 1 2 1

      1   2   3   4   5   6   7   8   9
    +───────────+───────────+───────────+
  1 |  3  1  . | .  .  2 | .  9  . 
  2 |  .  .  . | .  .  . | .  .  4 
  3 |  .  .  5 | .  .  . | .  3  . 
    +───────────+───────────+───────────+
  4 |  6  .  . | 1  .  . | 3  .  . 
  5 |  .  .  . | .  6  . | .  .  8 
  6 |  .  8  . | 2  .  3 | 5  7  . 
    +───────────+───────────+───────────+
  7 |  .  .  6 | 5  .  4 | .  .  . 
  8 |  1  .  . | .  .  . | .  .  2 
  9 |  9  .  . | .  1  . | .  .  7 
    +───────────+───────────+───────────+

  Jugada  :  <fila> <columna> <valor>   (ejem: > 3 5 7)
  Salir   :  q
  > 1 1 3
  Celda bloqueada: no se pueden modificar los valores iniciales de tablero.

      1   2   3   4   5   6   7   8   9
    +───────────+───────────+───────────+
  1 |  3  1  . | .  .  2 | .  9  . 
  2 |  .  .  . | .  .  . | .  .  4 
  3 |  .  .  5 | .  .  . | .  3  . 
    +───────────+───────────+───────────+
  4 |  6  .  . | 1  .  . | 3  .  . 
  5 |  .  .  . | .  6  . | .  .  8 
  6 |  .  8  . | 2  .  3 | 5  7  . 
    +───────────+───────────+───────────+
  7 |  .  .  6 | 5  .  4 | .  .  . 
  8 |  1  .  . | .  .  . | .  .  2 
  9 |  9  .  . | .  1  . | .  .  7 
    +───────────+───────────+───────────+

  Jugada  :  <fila> <columna> <valor>   (ejem: > 3 5 7)
  Salir   :  q
  > q

  ¡Hasta luego!
