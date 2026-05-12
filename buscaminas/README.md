Juego: Buscaminas

Descripción:
    Buscaminas en un juego que utiliza la logica como arma para poder superar el juego.
    A travez de una cuadricula hay casillas que esperan ser "abiertas" por el usuario, el objetivo del juego es abrir todas las casillas que no tengan minas en su interior unicamente utilizando lógica.
    Las casillas que tienen una mina afectan a las casillas adyacentes haciendo que estas tengan un número dependiendo del número de minas que haya en su vecindad directa, si no hay minas a su alrededor esta no mostrara nada mas que cambiara su estado a "abierto".

Integrantes: 
    Ochoa Campos Ana Sofía
    Real Araiza Yamile
    Resendiz Linares Karen
    Sánchez Ortíz Diego. 

Instrucciones de uso:
    Estando a la altura del archivo "buscaminas.pl" vamos a abrir prolog en la terminal

    Se va a cargar el archivo "buscaminas.pl"
        $ [buscaminas];
    
    El juego se basa en cordenadas, al ser una cuadricula de 8x8, los indices iran del 1 al 8 en ambos ejes ("x" y "y") de abajo hacia arriba y de izquierda a derecha respectivamente.
    
    Para realizar una consulta del tablero se va a implementar el comando:
        $ consulta(Tablero);

    El cuál imprimira el tablero con las casillas abiertas y los números en las casillas adyacentes a una mina.

    Para hacer una selección de la casilla se va implementar el comando:
        $ seleccion(a, b)
    Con a la coordenada en el eje "x", y b la coordenada en el eje "y".

    Si al realizar una selección se selecciona una casilla con una mina, el jugador habra perdido la partida, si al haber seleccionado una casilla vacia, esta liberara todas las casillas vacias adyacentes de manera recursiva.

Reglas del juego:
    Deberas seleccionar casillas de manera "aleatoria" hasta que la información proporcionada por las casillas en referencia a la posición de las minas te permita evadirlas al momento de hacer una selección.

    El juego habra terminado al momento que el usuario haya abierto todas las casillas vacias, o cuando el usuario pierda abriendo una casilla con una mina.

Reglas logicas:

    Tenemos el siguiente tablero:
     ___ ___ ___
  3 |___|_1_|___|
  2 |_1_|___|_1_|
  1 |___|_1_|_1_|
      1   2   3
    
    Las casillas vacias no han sido abiertas, en el caso de las casillas con un número, indican que hay alguna mina en alguna de sus casillas vecinas a distancia 1 de ella misma, que en el tablero de arriba nos indicaria que hay una mina en la casilla (2, 2)
       ___ ___ ___
    3 |___|___|___|
    2 |___|_1_|___|
    1 |___|___|___|
        1   2   3

    En este caso, el tablero no nos da mucha información de donde podria haber una mina, podria estar en alguna de las siguientes posiciones:
    (1, 1), o (1, 2), o (1, 3) o (2, 1), o (2, 3), o (3, 1), o (3, 2), o (3, 3).
    Debemos seguir abriendo casillas evadiendo las minas.

Ejemplo de sesión de juego:

    Tenemos el siguiente tablero:
     ___ ___ ___ ___ ___ ___ ___ ___
  8 |_m_|___|___|___|_m_|___|___|___|
  7 |___|_m_|___|_m_|___|_m_|___|___|
  6 |___|___|_m_|___|_m_|___|___|___|
  5 |_m_|___|_m_|___|_m_|_m_|___|_m_|
  4 |___|_m_|___|___|___|___|_m_|___|
  3 |___|_m_|___|___|___|___|_m_|___|
  2 |___|_m_|___|___|___|_m_|___|_m_|
  1 |___|___|_m_|___|___|_m_|___|___|
      1   2   3   4   5   6   7   8
    
    Donde las casillas con una "m" tienen una mina en su interior, el usuario debera evadir las minas a toda costa:

    $ consulta(Tablero);
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

    $ seleccion(4, 4);
        selección valida :)
    $ colsulta(Tablero);

     ___ ___ ___ ___ ___ ___ ___ ___
  8 |___|___|___|___|___|___|___|___|
  7 |___|___|___|___|___|___|___|___|
  6 |___|___|___|_5_|___|___|___|___|
  5 |___|___|___|_4_|___|___|___|___|
  4 |___|___|_3_|_2_|_2_|_4_|___|___|
  3 |___|___|_3_|_*_|_1_|_3_|___|___|
  2 |___|___|_3_|_*_|_2_|___|___|___|
  1 |___|___|___|_1_|_2_|___|___|___|
      1   2   3   4   5   6   7   8
    
    Liberamos las casillas que tienen un * las cuales no tienen minas a su alrededor, pero las casillas con un número nos indican que hay un número n de minas a su alrededor.

    $ seleccion(3, 5);
        Abriste una mina :(.
     ___ ___ ___ ___ ___ ___ ___ ___
  8 |___|___|___|___|___|___|___|___|
  7 |___|___|___|___|___|___|___|___|
  6 |___|___|___|_5_|___|___|___|___|
  5 |___|___|_m_|_4_|___|___|___|___|
  4 |___|___|_3_|_2_|_2_|_4_|___|___|
  3 |___|___|_3_|_*_|_1_|_3_|___|___|
  2 |___|___|_3_|_*_|_2_|___|___|___|
  1 |___|___|___|_1_|_2_|___|___|___|
      1   2   3   4   5   6   7   8
