# Mastermind en Prolog

Proyecto final desarrollado en **Prolog** que implementa una versión del juego clásico **Mastermind**, un juego de lógica y deducción en el que el jugador debe descubrir un patrón secreto de colores.

---

## Descripción

**Mastermind** es un juego de deducción en el que el jugador intenta adivinar un patrón secreto de **5 colores** generado aleatoriamente.

En cada intento, el juego indica:

- Cuántos colores están perfectamente colocados.
- Cuántos colores son correctos pero están en una posición incorrecta.

El jugador cuenta con **10 intentos** para adivinar el patrón completo.

---

## Integrantes

- Feregrino Mesinas Renata
- Márquez Cristóval Miguel Ángel
- Rivera Lugo Araní Karol
- Torres Cuevas Gael Patricio

---

## ¿Cómo funciona?

Al iniciar el juego, Prolog genera un patrón secreto de 5 colores a partir del universo de colores disponibles.

El jugador debe ingresar una lista de 5 colores y, después de cada intento, el programa compara la respuesta con el patrón secreto.

El juego termina cuando:

- El jugador adivina correctamente los 5 colores en su posición exacta.
- Se terminan los 10 intentos disponibles.

---

## Colores disponibles

Los colores válidos son:

```prolog
rosa, azul, verde, morado, plateado, dorado, negro
```

---

## Instrucciones de uso

1. Abre una terminal.

2. Entra a la carpeta del juego:

```bash
cd ProyectoFinalProlog/mastermind
```

3. Ejecuta SWI-Prolog:

```bash
swipl
```

4. Carga el archivo del juego:

```prolog
consult('juego.pl').
```

5. Inicia el juego:

```prolog
iniciar.
```

6. Cuando el juego pida tu adivinanza, escribe una lista de 5 colores entre corchetes, separados por comas y terminando con punto.

Ejemplo:

```prolog
[rosa, azul, verde, morado, plateado].
```

---

## Reglas del juego

1. Al iniciar, el juego genera un patrón secreto de 5 colores tomados aleatoriamente del universo de colores disponibles.
2. El jugador tiene 10 intentos para adivinar el patrón completo.
3. Después de cada intento, el juego muestra:
   - **Colores perfectamente colocados:** cuántos colores están en la posición correcta.
   - **Colores correctos pero mal colocados:** cuántos colores forman parte del patrón, pero están en una posición incorrecta.
4. Si el jugador adivina los 5 colores en las posiciones correctas, gana.
5. Si se agotan los 10 intentos sin adivinar el patrón, el juego revela el patrón secreto y el jugador pierde.

---

## Explicación de los predicados principales

### `colores_universo/1`

Define el conjunto de colores válidos del juego como un hecho. Es la base para generar el patrón y validar las entradas del jugador.

### `generar_patron/3`

Genera recursivamente una lista de `N` colores elegidos al azar del universo de colores disponibles.

El caso base ocurre cuando `N` es 0, produciendo una lista vacía.

### `elegir_color_random/3`

Obtiene un color aleatorio del universo usando un índice generado con `random/3`.

Además, devuelve la lista restante sin el color elegido, evitando que el patrón secreto tenga colores repetidos.

### `buscar_indice/3`

Recorre recursivamente una lista hasta el índice dado y devuelve el elemento que se encuentra en esa posición.

### `quitar_elemento/3`

Elimina un color de una lista.

Este predicado permite que, después de seleccionar un color para el patrón secreto, ese color ya no vuelva a estar disponible.

### `iniciar/0`

Es el punto de entrada del juego.

Muestra las instrucciones, genera el patrón secreto y comienza el ciclo principal con 10 intentos.

### `jugar/2`

Controla el ciclo principal del juego.

Recibe el patrón secreto y los intentos restantes. Si los intentos llegan a 0, el jugador pierde. Si todavía quedan intentos, pide una adivinanza, la evalúa y continúa el juego.

### `continuar/3`

Decide si el juego termina o sigue.

Si el resultado es `ganador`, termina la partida. Si el resultado es `seguir`, llama nuevamente a `jugar/2`.

### `checar_intento/3`

Evalúa el intento del jugador comparándolo con el patrón secreto.

Llama a `aciertos_exactos/5` y a `aciertos_parciales/3`, imprime los resultados y devuelve `ganador` o `seguir`.

### `aciertos_exactos/5`

Compara posición por posición el patrón secreto y el intento del jugador.

Cuenta cuántos colores coinciden exactamente en color y posición. Además, separa los colores que no fueron exactos para revisarlos después.

### `aciertos_parciales/3`

Toma los colores no exactos del intento y busca cuáles aparecen en los sobrantes del patrón secreto.

Cuenta cuántos colores están en el patrón, pero en una posición incorrecta, sin contar el mismo color dos veces.

### `obtener_color/3`

Busca un color dentro de una lista y devuelve la lista sin ese elemento.

Sirve para evitar contar duplicados en los aciertos parciales.

---

## Ejemplo de sesión de juego

```prolog
?- iniciar.
Instrucciones:
1. Se creará un patrón secreto de 5 colores sin repeticiones.
2. Los colores disponibles son: rosa, azul, verde, morado, plateado, dorado, negro.
3. Debes adivinar los colores y sus posiciones exactas escribiéndolos tal cual crees que están.
4. Tienes 10 intentos para adivinar el patrón completo.
---------------------------------------------

El patrón secreto ha sido generado :)

Te quedan 10 intentos.
Ingresa tu adivinanza de 5 colores:
[rosa, rosa, rosa, rosa, rosa].

Resultados:
Colores perfectamente colocados: 1
Colores correctos pero mal colocados: 0

Te quedan 9 intentos.
Ingresa tu adivinanza de 5 colores:
[azul, verde, morado, plateado, dorado].

Resultados:
Colores perfectamente colocados: 2
Colores correctos pero mal colocados: 2

Te quedan 8 intentos.
Ingresa tu adivinanza de 5 colores:
[azul, morado, verde, rosa, dorado].

Resultados:
Colores perfectamente colocados: 5
Colores correctos pero mal colocados: 0

¡Ganaste! :D
```

---

## Estructura del proyecto

```text
ProyectoFinalProlog/
├── README.md
└── mastermind/
    ├── Integrantes.txt
    └── juego.pl
```

---

## Estado del proyecto

- Juego implementado en Prolog.
- Generación aleatoria del patrón secreto.
- Patrón de 5 colores sin repeticiones.
- Conteo de aciertos exactos.
- Conteo de aciertos parciales.
- Límite de 10 intentos.
- Mensaje de victoria.
- Mensaje de derrota con revelación del patrón secreto.

---

## Comandos para subir cambios

```bash
git add .
git commit -m "Reducción de colores, los colores ya no se repiten, readme terminado"
git push origin mastermind
```