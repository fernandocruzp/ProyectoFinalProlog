Juego: Buscaminas

Descripción:
    Buscaminas es un juego que utiliza la lógica como arma para poder superar el juego.
    A través de una cuadrícula hay casillas que esperan ser "abiertas"
    por el usuario, el objetivo del juego es abrir todas las casillas que no tengan minas
    en su interior únicamente utilizando lógica.
    Las casillas que tienen una mina afectan a las casillas adyacentes haciendo que estas
    tengan un número dependiendo del número de minas que haya en su vecindad directa, si
    no hay minas a su alrededor esta no mostrará nada más que cambiará su estado a "abierto".

Integrantes:
    Ochoa Campos Ana Sofía
    Real Araiza Yamile
    Resendiz Linares Karen
    Sánchez Ortíz Diego.

Instrucciones de uso:
    Estando a la altura del archivo "buscaminas.pl" vamos a abrir Prolog en la terminal

    Se va a cargar el archivo "buscaminas.pl"
        $ [buscaminas].

    El juego se basa en coordenadas, al ser una cuadrícula de 8x8, los índices irán del 1
    al 8 en ambos ejes (x, y) de abajo hacia arriba y de izquierda a derecha respectivamente.

    El juego iniciará con el comando:
    $ inicio.

    Este será automático, va a mantener el juego en un bucle en el cual pedirá al usuario ingresar
    las coordenadas de la casilla que quiera seleccionar, el juego procesará estas coordenadas y
    va a avisar si la jugada fue legal, si las coordenadas no son parte del tablero, o si pisó una
    mina.

    Si al realizar una selección se selecciona una casilla con una mina, el jugador habrá perdido
    la partida; si al haber seleccionado una casilla vacía, esta liberará todas las casillas
    vacías adyacentes de manera recursiva.

Reglas del juego:
    Deberás seleccionar casillas de manera "aleatoria" hasta que la información proporcionada por
    las casillas en referencia a la posición de las minas te permita evadirlas al momento de hacer
    una selección.

    El juego habrá terminado al momento que el usuario haya abierto todas las casillas vacías, o
    cuando el usuario pierda abriendo una casilla con una mina.

Reglas lógicas:

    El tablero se representa como una lista de términos casilla(X, Y, Estado) donde
    Estado puede ser "cerrada" o "abierta". Cada jugada no modifica el tablero original,
    sino que genera una lista nueva con el cambio aplicado, y esa nueva lista es la que
    se pasa al siguiente turno.

    mina(X, Y)
        Son hechos fijos que indican qué casillas tienen mina. Todos los demás predicados
        los consultan para tomar decisiones. Por ejemplo si tenemos:
            mina(2, 2).
        Significa que en este tablero de 3x3 la casilla (2,2) tiene mina:
         ___ ___ ___
      3 |___|___|___|
      2 |___|_m_|___|
      1 |___|___|___|
          1   2   3

    minas_adyacentes(X, Y, N)
        Cuenta cuántas minas hay entre los 8 vecinos de la casilla (X, Y). Para hacerlo
        recorre de forma recursiva una lista con las 8 direcciones posibles y va juntando
        los vecinos que tienen mina. Al final cuenta esa lista y ese es el número N que
        se muestra en el tablero cuando abres una casilla.

        Por ejemplo con la mina en (2,2), si preguntamos cuántas minas tiene alrededor
        la casilla (1,1), revisamos sus 8 vecinos y encontramos que (2,2) es uno de ellos,
        entonces N = 1 y se muestra así:
         ___ ___ ___
      3 |___|___|___|
      2 |___|_m_|___|
      1 |_1_|___|___|
          1   2   3

        En cambio la casilla (3,3) no tiene ninguna mina cerca, entonces N = 0:
         ___ ___ ___
      3 |___|___|_*_|
      2 |___|_m_|___|
      1 |___|___|___|
          1   2   3

    es_vacia(X, Y)
        Una casilla es vacía si no tiene mina y además ninguno de sus vecinos tiene mina,
        o sea que minas_adyacentes da 0. Son dos condiciones que se tienen que cumplir
        al mismo tiempo:
            es_vacia(X, Y) :-
                \+ mina(X, Y),
                minas_adyacentes(X, Y, 0).

        Con la mina en (2,2), las casillas vacías (marcadas con *) serían las que están
        lo suficientemente lejos de la mina:
         ___ ___ ___
      3 |___|___|_*_|
      2 |___|_m_|___|
      1 |___|___|_*_|
          1   2   3

        Y las casillas con número son las que están cerca pero no tienen mina:
         ___ ___ ___
      3 |_1_|_1_|_*_|
      2 |_1_|_m_|_1_|
      1 |_1_|_1_|_*_|
          1   2   3

    expandir_abrir y expandir_vecinos_aux
        Cuando abres una casilla vacía, el juego abre automáticamente todos sus vecinos cerrados sin mina. Si alguno de
        esos vecinos también es vacío, se vuelve a propagar desde ahí. Es recursivo,
        entonces sigue abriendo casillas hasta que todos los vecinos tengan al menos una
        mina cerca.

        Por ejemplo si abrimos la casilla (3,1) que es vacía, se propaga y abre (3,3)
        también porque también es vacía, pero se detiene en las casillas con número
        porque esas ya no propagan:

        Antes de abrir (3,1):          Después de abrir (3,1):
         ___ ___ ___                    ___ ___ ___
      3 |___|___|___|                3 |_1_|_1_|_*_|
      2 |___|_m_|___|                2 |_1_|_m_|_1_|
      1 |___|___|___|                1 |_1_|_1_|_*_|
          1   2   3                      1   2   3

    gana(Tablero)
        Recorre toda la lista del tablero casilla por casilla. Para que el jugador haya
        ganado se tienen que cumplir dos cosas: todas las casillas sin mina tienen que
        estar abiertas, y todas las minas tienen que seguir cerradas. Si encuentra
        alguna casilla que no cumpla eso, falla y el juego continúa:
            gana([]).
            gana([casilla(X, Y, abierta) | Resto]) :- \+ mina(X, Y), gana(Resto).
            gana([casilla(X, Y, cerrada) | Resto]) :- mina(X, Y), gana(Resto).

        O sea que este tablero SÍ gana (todas las seguras abiertas, la mina cerrada):
         ___ ___ ___
      3 |_1_|_1_|_*_|
      2 |_1_|___|_1_|
      1 |_1_|_1_|_*_|
          1   2   3

        Y este NO gana porque todavía hay casillas cerradas sin mina:
         ___ ___ ___
      3 |___|___|___|
      2 |___|___|___|
      1 |_1_|_1_|_*_|
          1   2   3

    procesar_jugada(Tablero, X, Y)
        Maneja todos los casos posibles cuando el usuario selecciona una casilla. Usa
        varias cláusulas ordenadas de más específico a más general con ! para que
        Prolog no siga buscando una vez que encontró el caso correcto:
            1. Coordenada fuera del tablero -> avisa y vuelve a pedir
            2. Casilla ya abierta -> avisa y vuelve a pedir
            3. Casilla con mina -> muestra la mina y termina el juego
            4. Casilla segura -> la abre, propaga si es vacía, y verifica si ganó

Ejemplo de sesión de juego:

    Tenemos el siguiente tablero (las minas están ocultas al jugador):
        ___ ___ ___ ___ ___ ___ ___ ___
     8 |___|___|_m_|___|___|___|_m_|___|
     7 |___|___|___|___|___|___|___|___|
     6 |_m_|___|___|___|___|___|_m_|___|
     5 |___|___|___|_m_|___|___|___|___|
     4 |___|___|___|___|___|___|_m_|___|
     3 |___|_m_|___|___|_m_|___|___|___|
     2 |___|___|___|___|___|___|___|___|
     1 |___|___|___|___|_m_|___|___|___|
         1   2   3   4   5   6   7   8

    El usuario deberá evadir las minas a toda costa:

    $ inicio.
       ___ ___ ___ ___ ___ ___ ___ ___
    8 |___|___|___|___|___|___|___|___|
    7 |___|___|___|___|___|___|___|___|
    6 |___|___|___|___|___|___|___|___|
    5 |___|___|___|___|___|___|___|___|
    4 |___|___|___|___|___|___|___|___|
    3 |___|___|___|___|___|___|___|___|
    2 |___|___|___|___|___|___|___|___|
    1 |___|___|___|___|___|___|___|___|
        1   2   3   4   5   6   7   8

    Selección de casilla.
    Coordenada x: 8.
    Coordenada y: 1.
    Jugada válida.

       ___ ___ ___ ___ ___ ___ ___ ___
    8 |___|___|___|___|___|___|___|___|
    7 |___|___|___|___|___|___|___|___|
    6 |___|___|___|___|___|___|___|___|
    5 |___|___|___|___|___|___|___|___|
    4 |___|___|___|___|___|___|___|___|
    3 |___|___|___|___|___|_2_|_1_|_1_|
    2 |___|___|___|___|_2_|_1_|_*_|_*_|
    1 |___|___|___|___|_1_|_*_|_*_|_*_|
        1   2   3   4   5   6   7   8

    La casilla (8,1) era vacía, entonces se propagó automáticamente y abrió
    todas las casillas vacías conectadas a ella. Las casillas con un * no tienen
    minas alrededor, y las que tienen número indican cuántas minas hay cerca.

    Selección de casilla.
    Coordenada x: 1.
    Coordenada y: 1.
    Jugada válida.

       ___ ___ ___ ___ ___ ___ ___ ___
    8 |___|___|___|___|___|___|___|___|
    7 |___|___|___|___|___|___|___|___|
    6 |___|___|___|___|___|___|___|___|
    5 |___|___|___|___|___|___|___|___|
    4 |___|___|___|___|___|___|___|___|
    3 |___|___|___|___|___|_2_|_1_|_1_|
    2 |_1_|_1_|_2_|___|_2_|_1_|_*_|_*_|
    1 |_*_|_*_|_1_|___|_1_|_*_|_*_|_*_|
        1   2   3   4   5   6   7   8

    Selección de casilla.
    Coordenada x: 4.
    Coordenada y: 1.
    Boom! Pisaste una mina.

       ___ ___ ___ ___ ___ ___ ___ ___
    8 |___|___|___|___|___|___|___|___|
    7 |___|___|___|___|___|___|___|___|
    6 |___|___|___|___|___|___|___|___|
    5 |___|___|___|___|___|___|___|___|
    4 |___|___|___|___|___|___|___|___|
    3 |___|___|___|___|___|_2_|_1_|_1_|
    2 |_1_|_1_|_2_|___|_2_|_1_|_*_|_*_|
    1 |_*_|_*_|_1_|_m_|_1_|_*_|_*_|_*_|
        1   2   3   4   5   6   7   8

    - Fin del juego -
    Escribe "inicio." para volver a jugar.