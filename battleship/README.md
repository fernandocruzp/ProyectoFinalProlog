```markdown
# Batalla Naval (Battleship) interactivo en Prolog

## 1. Descripción del Juego
Este proyecto consiste en una implementación interactiva y en consola del clásico juego de estrategia **Batalla Naval (Battleship)**, programada íntegramente bajo el paradigma lógico en SWI-Prolog. El juego se desarrolla en un escenario de confrontación táctica bidimensional en tiempo real contra una Inteligencia Artificial, donde tanto el jugador como la computadora despliegan una flota naval oculta y se turnan para bombardear las posiciones enemigas mediante un sistema estratégico de coordenadas.

## 2. Integrantes del Equipo
* **Mauricio Casillas Alvarez** - Número de Cuenta: 3221964-2
* **Cristian Sanchez Diaz** - Número de Cuenta: 32222564-0

*Asignatura:* Lógica Computacional 2026-2  
*Facultad de Ciencias, UNAM.*

## 3. Instrucciones de Uso
El juego está diseñado para ejecutarse directamente en la consola de SWI-Prolog, sin necesidad de dependencias externas ni entornos gráficos independientes.

1. Abra su terminal o consola de SWI-Prolog.
2. Cargue el archivo principal de la aplicación ejecutando la siguiente consulta:
   ```prolog
   ?- consult('juego.pl').

```

3. Para inicializar los tableros dinámicos y comenzar una nueva partida, ejecute el predicado principal:
```prolog
?- jugar.

```


4. Durante su turno, cuando el programa lo solicite, introduzca las coordenadas de disparo de la fila y la columna de forma numérica, finalizando obligatoriamente cada entrada con un punto (`.`), por ejemplo: `2.` o `0.`.

## 4. Reglas del Juego (Lenguaje Natural)

* **El Entorno:** El juego se disputa sobre dos tableros individuales con dimensiones fijas de 5x5 celdas.
* **La Flota:** Cada bando (Jugador y Computadora) cuenta con una flota compuesta por **4 barcos** de dimensiones aleatorias (segmentos continuos de 2 o 3 celdas de longitud).
* **Despliegue:** Al iniciar la partida, el motor del juego posiciona automáticamente las flotas de manera aleatoria en orientaciones horizontales o verticales, garantizando que ningún barco se solape ni sobresalga de los límites del mapa.
* **Mecánica de Turnos:** El juego se rige por turnos alternados estrictos (Jugador -> Computadora). En su turno, el jugador selecciona una coordenada en el mapa enemigo.
* **Efectos de Disparo:** * Si la coordenada contiene un segmento de barco intacto (`s`), la celda cambia a **Tocado** (`x`).
* Si la coordenada golpea el océano (`w`), la celda cambia a **Agua disparada** (`m`).


* **Blindaje de Entrada:** Si el jugador introduce una coordenada inválida (letras, símbolos, espacios vacíos o números fuera del rango 0-4), el sistema rechaza el intento y le solicita los datos nuevamente sin penalizar su turno.
* **Validación de Repetición:** No se permite disparar dos veces a una casilla ya atacada (`x` o `m`). Si el jugador o la IA intentan un tiro repetido, el sistema los obliga a elegir una coordenada distinta antes de proceder.
* **Condición de Victoria:** El juego concluye inmediatamente cuando uno de los dos bandos logra hundir por completo la totalidad de las secciones de barco (`s`) del oponente.

## 5. Explicación de las Reglas Lógicas y Predicados Clave

El núcleo del programa saca provecho de las propiedades fundamentales de Prolog como la unificación, la recursión con corte (`!`) y el control dinámico de la memoria mediante aserciones.

### Representación del Estado del Juego

Los tableros se almacenan en la memoria interna mediante cláusulas dinámicas (`:- dynamic tablero_jugador/1, tablero_computadora/1.`), representados matemáticamente como listas de listas de longitud 5. Los estados de las celdas utilizan la siguiente convención de símbolos lógicos:

* `w`: Agua / Océano inexplorado.
* `s`: Segmento de barco intacto.
* `x`: Impacto exitoso (Barco Tocado).
* `m`: Impacto fallido (Tiro en Agua).

### Predicados Principales

* **`leer_coordenada(+Mensaje, -Valor)`**: Implementa el blindaje y validación de tipos por consola. Utiliza la estructura avanzada `catch(number_codes(Num, Codes), _, Num = -1)` para interceptar cualquier excepción de sintaxis provocada por datos no numéricos (como letras o cadenas vacías). Valida a través de backtracking que el valor unificado sea un entero dentro del dominio protegido `[0, 4]`.
* **`solicitar_disparo_valido(+Tablero, -Fila, -Columna)`**: Predicado recursivo encargado de evitar la duplicidad de ataques. Inspecciona el contenido de la celda seleccionada a través de `obtener_celda/4` y solo permite avanzar el flujo si el valor unificado equivale a un espacio virgen (`w` o `s`). Si el estado de la celda es `x` o `m`, evita el corte de backtracking, notifica la anomalía y se llama a sí mismo de forma recursiva.
* **`validar_y_colocar(+Tablero, +Fila, +Columna, +Longitud, +Orientacion, -NuevoTablero)`**: Cláusula iterativa encargada de la geometría de colocación de la flota. Evalúa recursivamente celda por celda que el espacio proyectado para el barco contenga únicamente agua (`w`) y que las coordenadas se mantengan dentro de los límites estrictos `(Fila >= 0, Fila =< 4, Columna >= 0, Columna =< 4)`. Si el espacio es apto, efectúa la mutación de la matriz usando `actualizar_matriz/5`.
* **`ataque_computadora(+TableroJugador, -NuevoTableroJugador)`**: Constituye la Inteligencia Artificial del oponente. Genera coordenadas aleatorias continuas mediante un generador pseudoaleatorio `random(0, 5, X)` y evalúa las casillas del jugador mediante una restricción negativa (`Celda \== x, Celda \== m`). Si la casilla seleccionada ya había sido bombardeada, la regla falla deliberadamente, activando el backtracking automático de Prolog para recalcular un disparo alternativo válido.
* **`quedan_barcos(+Tablero)`**: Evalúa la condición de parada del bucle de juego. Emplea el predicado nativo `member/2` para realizar una búsqueda exhaustiva dentro de las sublistas del tablero. Si encuentra al menos una instancia del símbolo `s`, el predicado es verdadero; si no localiza ningún barco remanente, se asume el hundimiento total de la flota.

## 6. Ejemplo de Sesión de Juego

A continuación, se ilustra una traza de ejecución estándar en la terminal interactiva de SWI-Prolog al iniciar el ciclo principal:

```prolog
1 ?- consult('juego.pl').
true.

2 ?- jugar.
¡Bienvenido a Batalla Naval en Prolog!
Se han desplegado ambos tableros con 4 barcos aleatorios (tamaños 2 y 3).

====================================
TU TABLERO ACTUAL (Tus barcos):
[w,w,w,s,s]
[w,w,w,w,w]
[s,s,s,w,w]
[w,w,w,w,s]
[w,w,w,w,s]
====================================

Estado actual del radar enemigo:
[w,w,w,w,w]
[w,w,w,w,w]
[w,w,w,w,w]
[w,w,w,w,w]
[w,w,w,w,w]

--- TU TURNO ---
Ingresa la Fila (0-4):
|: 0.
Ingresa la Columna (0-4):
|: 3.
--- ¡TOCADO! ---

--- TURNO DE LA COMPUTADORA ---
La computadora dispara a la posición [Fila: 2, Columna: 0]
--- ¡Te han TOCADO un barco! ---

====================================
TU TABLERO ACTUAL (Tus barcos):
[w,w,w,s,s]
[w,w,w,w,w]
[x,s,s,w,w]
[w,w,w,w,s]
[w,w,w,w,s]
====================================

Estado actual del radar enemigo:
[w,w,w,x,w]
[w,w,w,w,w]
[w,w,w,w,w]
[w,w,w,w,w]
[w,w,w,w,w]

--- TU TURNO ---
Ingresa la Fila (0-4):
|: abc.
*** Entrada inválida. Debe ser un número entero entre 0 y 4. ***
Ingresa la Fila (0-4):
|: 0.
Ingresa la Columna (0-4):
|: 3.
*** Ya disparaste a esa coordenada. Elige una posición distinta. ***

--- TU TURNO ---
Ingresa la Fila (0-4):
|: 0.
Ingresa la Columna (0-4):
|: 4.
--- ¡TOCADO! ---
