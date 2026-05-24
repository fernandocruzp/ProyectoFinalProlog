# Juego de Nim 

## 1. Nombre del juego y descripción breve

El juego que elegimos es **Nim**.

Nim es un juego de estrategia donde hay varias filas con palillos, en cada turno, un jugador escoge una sola fila y retira la cantidad de palillos que quiera, siempre que tome al menos uno y no tome más de los que hay en esa fila.

En nuestra versión del juego se empieza con tres filas:

- Fila 1: 3 palillos
- Fila 2: 5 palillos
- Fila 3: 7 palillos

El jugador que toma el último palillo gana la partida.

---

## 2. Integrantes del equipo

- Carlos Joel de la Rosa Hernández - 319229185
- Diego Hernández Gómez - 321069942
- Yahir León Bautista - 322176542

---

## 3. Instrucciones de uso

Para jugar se necesita tener instalado SWI-Prolog.

Primero se debe guardar el código en un archivo llamado:

```text
nim.pl
```

Después se abre SWI-Prolog y se carga el archivo con la siguiente consulta:

```prolog
?- [nim].
```

También se puede cargar así:

```prolog
?- consult('nim.pl').
```

Para iniciar el juego completo se usa:

```prolog
?- inicio.
```

Después de eso, el programa muestra las reglas básicas y el tablero inicial. En cada turno, el jugador debe escribir su movimiento con el siguiente formato:

```text
fila cantidad
```

Por ejemplo:

```text
2 3
```

Eso significa que el jugador quiere tomar 3 palillos de la fila 2.

También se pueden probar movimientos directamente usando consultas en Prolog. Por ejemplo:

```prolog
?- mover([3,5,7], 2, 3, NuevoTablero).
```

La respuesta esperada sería:

```prolog
NuevoTablero = [3, 2, 7].
```

---

## 4. Reglas del juego

Las reglas de nuestra versión de Nim son las siguientes:

1. El tablero tiene tres filas de palillos.
2. El tablero inicial es `[3,5,7]`.
3. Juegan dos jugadores: `jugador1` y `jugador2`.
4. En cada turno, el jugador actual debe escoger una fila.
5. Solo se puede escoger una fila entre 1 y 3.
6. El jugador debe retirar al menos 1 palillo.
7. No se pueden retirar más palillos de los que existen en la fila elegida.
8. Después de un movimiento válido, el turno pasa al otro jugador.
9. Si un movimiento es inválido, el tablero no cambia y el mismo jugador debe intentar otra vez.
10. Gana el jugador que toma el último palillo.

---

## 5. Explicación de las reglas lógicas

El juego está representado principalmente con listas y predicados lógicos.

El tablero se representa como una lista de tres números. Cada número representa la cantidad de palillos que hay en una fila.

Por ejemplo:

```prolog
[3,5,7]
```

significa que:

- La fila 1 tiene 3 palillos.
- La fila 2 tiene 5 palillos.
- La fila 3 tiene 7 palillos.

---

### `inicio/0`

Este predicado inicia el juego.

Muestra un mensaje de bienvenida, explica las reglas principales y llama al predicado `juego/3` con el tablero inicial:

```prolog
juego([3,5,7], jugador1, jugador2).
```

Aquí `[3,5,7]` representa el tablero inicial. `jugador1` empieza la partida y `jugador2` espera su turno.

---

### `juego/3`

Este es el predicado principal del juego.

Su forma es:

```prolog
juego(Tablero, Actual, Otro)
```

Donde:

- `Tablero` es la lista con los palillos de cada fila.
- `Actual` es el jugador que tiene el turno.
- `Otro` es el jugador que está esperando su turno.

Este predicado primero muestra el tablero actual. Después revisa si el tablero está vacío.

Si el tablero está vacío, significa que el jugador anterior tomó el último palillo, por lo tanto gana `Otro`.

Si el tablero todavía tiene palillos, entonces se pide un movimiento al jugador actual usando `movimiento/2`.

Cuando el movimiento es válido, se crea un nuevo tablero y se cambia el turno llamando otra vez a `juego/3`, pero ahora con los jugadores invertidos:

```prolog
juego(NuevoTablero, Otro, Actual)
```

Si el movimiento no es válido, se muestra un mensaje de error y se vuelve a llamar a `juego/3` con el mismo tablero y el mismo jugador actual.

---

### `mostrar_tablero/1`

Este predicado muestra el estado actual del tablero.

Por ejemplo, si el tablero es:

```prolog
[3,5,7]
```

se muestra algo parecido a:

```text
Fila 1: | | |
Fila 2: | | | | |
Fila 3: | | | | | | |
```

---

### `mostrar_fila/2`

Este predicado muestra una fila específica del tablero.

Usa `nth1/3` para obtener la cantidad de palillos que hay en una fila.

Por ejemplo:

```prolog
nth1(2, [3,5,7], Cantidad).
```

daría como resultado:

```prolog
Cantidad = 5.
```

---

### `escribir_palillos/1`

Este predicado se encarga de dibujar los palillos usando el símbolo `|`.

Si la cantidad de palillos es 0, escribe que la fila está vacía.

Por ejemplo:

```prolog
?- escribir_palillos(3).
```

mostraría:

```text
| | |
```

---

### `tablero_vacio/1`

Este predicado revisa si todas las filas tienen 0 palillos.

Por ejemplo:

```prolog
?- tablero_vacio([0,0,0]).
```

Respuesta esperada:

```prolog
true.
```

Pero si todavía queda algún palillo:

```prolog
?- tablero_vacio([0,1,0]).
```

Respuesta esperada:

```prolog
false.
```

Este predicado sirve para saber cuándo terminó la partida.

---

### `movimiento/2`

Este predicado pide al jugador que escriba su movimiento.

Su forma es:

```prolog
movimiento(Fila, Tomar)
```

El usuario debe escribir dos números separados por espacio, por ejemplo:

```text
1 2
```

Eso significa:

```prolog
Fila = 1,
Tomar = 2
```

Este predicado usa `read_line_to_string/2` para leer lo que escribió el usuario desde la terminal.

---

### `entrada_a_movimiento/3`

Este predicado convierte el texto escrito por el usuario en dos números enteros.

Por ejemplo, convierte esta entrada:

```text
2 3
```

en:

```prolog
Fila = 2,
Tomar = 3
```

Si el usuario escribe algo incorrecto, como letras, un solo número o más datos de los necesarios, entonces el movimiento se considera inválido.

---

### `validar_mov/4`

Este predicado valida si un movimiento es correcto y genera el nuevo tablero.

Su forma es:

```prolog
validar_mov(Tablero, Fila, Tomar, NuevoTablero)
```

Las condiciones que revisa son:

1. Que `Fila` sea un número entero.
2. Que `Tomar` sea un número entero.
3. Que la fila esté entre 1 y 3.
4. Que se tome al menos 1 palillo.
5. Que no se tomen más palillos de los que hay en la fila.
6. Que se actualice correctamente el tablero.

Ejemplo de movimiento válido:

```prolog
?- validar_mov([3,5,7], 2, 3, NuevoTablero).
```

Respuesta esperada:

```prolog
NuevoTablero = [3, 2, 7].
```

Ejemplo de movimiento inválido:

```prolog
?- validar_mov([3,5,7], 2, 8, NuevoTablero).
```

Respuesta esperada:

```prolog
false.
```

Esto falla porque en la fila 2 solo hay 5 palillos y se intentan quitar 8.

---

### `reemplazar_nth1/4`

Este predicado sirve para actualizar una posición específica de una lista.

En el juego se usa para cambiar la cantidad de palillos de una fila después de un movimiento válido.

Por ejemplo, si el tablero es:

```prolog
[3,5,7]
```

y se quitan 3 palillos de la fila 2, el nuevo tablero queda así:

```prolog
[3,2,7]
```

---

### `mover/4`

Este predicado permite hacer movimientos directamente desde consultas en SWI-Prolog.

Su forma es:

```prolog
mover(Tablero, Fila, Tomar, NuevoTablero)
```

Internamente usa `validar_mov/4`.

Ejemplo:

```prolog
?- mover([3,5,7], 1, 2, NuevoTablero).
```

Respuesta esperada:

```prolog
NuevoTablero = [1, 5, 7].
```

Este predicado ayuda a cumplir con la parte del proyecto donde se pide que el juego pueda funcionar mediante consultas en SWI-Prolog.

---

## 6. Ejemplo de sesión de juego

Primero cargamos el archivo:

```prolog
?- [nim].
```

Respuesta esperada:

```prolog
true.
```

Después iniciamos el juego:

```prolog
?- inicio.
```

El programa muestra algo parecido a esto:

```text
========================================
        BIENVENIDO AL JUEGO NIM
========================================

REGLAS DEL JUEGO:
- Hay tres filas con palillos:
  Fila 1: 3 palillos
  Fila 2: 5 palillos
  Fila 3: 7 palillos
- En cada turno, el jugador debe elegir una fila (1,2,3)
  y retirar al menos 1 palillo y como maximo todos los de esa fila.
- Gana el jugador que toma el ultimo palillo.

Los jugadores son: jugador1 y jugador2.
Para mover, escribe: "fila cantidad" por ejemplo: 2 3
========================================
```

Luego aparece el tablero:

```text
Estado actual del tablero:
Fila 1: | | |
Fila 2: | | | | |
Fila 3: | | | | | | |

Turno de jugador1.
Escribe tu movimiento como "fila cantidad":
```

Si el jugador escribe:

```text
2 3
```

el tablero se actualiza a:

```text
Estado actual del tablero:
Fila 1: | | |
Fila 2: | |
Fila 3: | | | | | | |
```

Ahora le toca al otro jugador:

```text
Turno de jugador2.
Escribe tu movimiento como "fila cantidad":
```

Si el jugador escribe un movimiento inválido, por ejemplo:

```text
3 20
```

el programa responde:

```text
Movimiento invalido. Intenta de nuevo.
```

y el mismo jugador vuelve a intentar.

---

## 7. Ejemplos de consultas directas

Movimiento válido:

```prolog
?- mover([3,5,7], 3, 7, NuevoTablero).
```

Respuesta esperada:

```prolog
NuevoTablero = [3, 5, 0].
```

Movimiento inválido porque no existe la fila 4:

```prolog
?- mover([3,5,7], 4, 1, NuevoTablero).
```

Respuesta esperada:

```prolog
false.
```

Movimiento inválido porque se intentan quitar más palillos de los que hay:

```prolog
?- mover([3,5,7], 1, 5, NuevoTablero).
```

Respuesta esperada:

```prolog
false.
```

Revisar si el tablero está vacío:

```prolog
?- tablero_vacio([0,0,0]).
```

Respuesta esperada:

```prolog
true.
```

Revisar un tablero que todavía tiene palillos:

```prolog
?- tablero_vacio([0,2,0]).
```

Respuesta esperada:

```prolog
false.
```

Con esto se puede ver que el juego usa reglas lógicas para validar movimientos, detectar estados inválidos, actualizar el tablero y determinar cuándo termina la partida.