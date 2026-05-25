% Implementacion del juego Buscaminas en Prolog
% Logica Computacional 2026-2
% Integrantes:
%   Ochoa Campos Ana Sofia
%   Real Araiza Yamile
%   Resendiz Linares Karen
%   Sanchez Ortiz Diego

% La idea del juego es representar el tablero como una lista de casillas
% cada casilla guarda su posicion y si esta cerrada, abierta o tiene mina
% casilla(X, Y, Estado)  donde Estado = cerrada | abierta | mina
% cuando una casilla abierta tiene mina se muestra como _m_ en el tablero

% Tablero 8x8, las minas estan fijas
%    ___ ___ ___ ___ ___ ___ ___ ___
% 8 |___|___|_m_|___|___|___|_m_|___|
% 7 |___|___|___|___|___|___|___|___|
% 6 |_m_|___|___|___|___|_m_|___|___|
% 5 |___|___|___|_m_|___|___|___|___|
% 4 |___|___|___|___|___|___|_m_|___|
% 3 |___|_m_|___|___|_m_|___|___|___|
% 2 |___|___|___|___|___|___|___|___|
% 1 |___|___|___|_m_|___|___|___|___|
%     1   2   3   4   5   6   7   8

% ---------------------------------------------------------------------------------
% Minas fijas del tablero
% ---------------------------------------------------------------------------------

mina(4, 1).
mina(2, 3).
mina(5, 3).
mina(7, 4).
mina(4, 5).
mina(1, 6).
mina(6, 6).
mina(3, 8).
mina(7, 8).

% ----------------------------------------------------------
% en_tablero(X, Y) 
% verifica si la casilla esta dentro del tablero 8x8
% los indices van de 1 a 8 en ambos ejes
% ----------------------------------------------------------

en_tablero(X, Y) :-
    X >= 1, X =< 8,
    Y >= 1, Y =< 8.

% ----------------------------------------------------------
% Tablero inicial
% Genera la lista con todas las casillas en estado cerrada
% usamos recursion igual que en clase con las listas
% ----------------------------------------------------------

tablero_inicial(Tablero) :-
    generar_casillas(1, 1, Tablero).

% caso base: ya pasamos la fila 8, terminamos
generar_casillas(_, 9, []) :- !.

% cambio de fila: cuando X llega a 9 pasamos a la siguiente fila
generar_casillas(9, Y, Lista) :-
    !,
    Y1 is Y + 1,
    generar_casillas(1, Y1, Lista).

% caso recursivo: agregamos la casilla (X,Y) cerrada y seguimos
generar_casillas(X, Y, [casilla(X, Y, cerrada) | Resto]) :-
    X1 is X + 1,
    generar_casillas(X1, Y, Resto).

% ----------------------------------------------------------
% buscar_casilla(Tablero, X, Y, Estado)
% recorre la lista hasta encontrar la casilla (X,Y)
% ----------------------------------------------------------

buscar_casilla([casilla(X, Y, Estado) | _], X, Y, Estado) :- !.
buscar_casilla([_ | Resto], X, Y, Estado) :-
    buscar_casilla(Resto, X, Y, Estado).

% ----------------------------------------------------------
% reemplazar_casilla(Tablero, X, Y, NuevoEstado, NuevoTablero)
% devuelve un tablero nuevo con el estado de (X,Y) cambiado
% ya que no modifica el original, regresa una lista nueva
% esto es como el patron que vimos para modificar listas
% ----------------------------------------------------------

reemplazar_casilla([], _, _, _, []).
reemplazar_casilla([casilla(X, Y, _) | Resto], X, Y, Nuevo,
                  [casilla(X, Y, Nuevo) | Resto]) :- !.
reemplazar_casilla([C | Resto], X, Y, Nuevo, [C | RestoNuevo]) :-
    reemplazar_casilla(Resto, X, Y, Nuevo, RestoNuevo).

% ----------------------------------------------------------
% minas_adyacentes(X, Y, N)
% cuenta cuantas minas hay alrededor de la casilla (X, Y)
%
% los 8 vecinos los ponemos como hechos, ya que son datos fijos que Prolog consulta
% direccion(DX, DY) es cada uno de los 8 vecinos posibles
% ----------------------------------------------------------

direccion(-1, -1).
direccion(-1,  0).
direccion(-1,  1).
direccion( 0, -1).
direccion( 0,  1).
direccion( 1, -1).
direccion( 1,  0).
direccion( 1,  1).

% vecino_mina(X, Y, VX, VY), verdadero si (VX,VY) es vecino de (X,Y) y tiene mina
% combinamos dos hechos: direccion y mina

vecino_mina(X, Y, VX, VY) :-
    direccion(DX, DY),
    VX is X + DX,
    VY is Y + DY,
    en_tablero(VX, VY),
    mina(VX, VY).

% para contar usamos una lista auxiliar con los vecinos que tienen mina
% y luego contamos esa lista, igual que en clase contamos elementos
% primero juntamos todos los vecinos con mina en una lista

vecinos_con_mina(X, Y, Lista) :-
    vecinos_con_mina_aux(X, Y,
        [ (-1,-1), (-1,0), (-1,1),
          (0,-1),           (0,1),
          (1,-1),  (1,0),  (1,1) ],
        Lista).

% caso base: lista de direcciones vacia, no hay mas vecinos que revisar

vecinos_con_mina_aux(_, _, [], []).

% si el vecino en esa direccion tiene mina, lo agregamos a la lista

vecinos_con_mina_aux(X, Y, [(DX,DY) | Resto], [VX-VY | Lista]) :-
    VX is X + DX,
    VY is Y + DY,
    en_tablero(VX, VY),
    mina(VX, VY),
    !,
    vecinos_con_mina_aux(X, Y, Resto, Lista).

% si no tiene mina, solo seguimos con el resto

vecinos_con_mina_aux(X, Y, [_ | Resto], Lista) :-
    vecinos_con_mina_aux(X, Y, Resto, Lista).

% longitud de la lista 

longitud([], 0).
longitud([_ | Resto], N) :-
    longitud(Resto, N1),
    N is N1 + 1.

% minas_adyacentes(X, Y, N): juntamos vecinos con mina y contamos

minas_adyacentes(X, Y, N) :-
    vecinos_con_mina(X, Y, Lista),
    longitud(Lista, N).

% ----------------------------------------------------------
% es_vacia(X, Y)
% una casilla es vacia cuando no tiene mina y ademas
% ninguno de sus vecinos tiene mina (N = 0)
% ----------------------------------------------------------

es_vacia(X, Y) :-
    en_tablero(X, Y),
    \+ mina(X, Y),
    minas_adyacentes(X, Y, 0).

% ----------------------------------------------------------
% consulta(Tablero)
% imprime el tablero
% ----------------------------------------------------------

consulta(Tablero) :-
    write('   ___ ___ ___ ___ ___ ___ ___ ___\n'),
    imprimir_filas(8, Tablero),
    write('    1   2   3   4   5   6   7   8\n\n').

imprimir_filas(0, _) :- !.

imprimir_filas(Y, Tablero) :-
    write(Y),
    write(' '),
    imprimir_casillas_fila(1, Y, Tablero),
    write('|\n'),
    Y1 is Y - 1,
    imprimir_filas(Y1, Tablero).

imprimir_casillas_fila(9, _, _) :- !.

imprimir_casillas_fila(X, Y, Tablero) :-
    buscar_casilla(Tablero, X, Y, Estado),
    dibujar_contenido(X, Y, Estado),
    X1 is X + 1,
    imprimir_casillas_fila(X1, Y, Tablero).

% ----------------------------------------------------------
% dibujar_contenido
% ----------------------------------------------------------

dibujar_contenido(_, _, cerrada) :-
    write('|___').

dibujar_contenido(X, Y, abierta) :-
    mina(X, Y), !,
    write('|_m_').

dibujar_contenido(X, Y, abierta) :-
    minas_adyacentes(X, Y, N),
    (
        N > 0
    ->
        format('|_~w_', [N])
    ;
        write('|_*_')
    ).

% ----------------------------------------------------------
% gana(Tablero)
% todas las casillas seguras estan abiertas
% ----------------------------------------------------------

gana([]).

gana([casilla(X, Y, abierta) | Resto]) :-
    \+ mina(X, Y),
    gana(Resto).

gana([casilla(X, Y, cerrada) | Resto]) :-
    mina(X, Y),
    gana(Resto).

% ----------------------------------------------------------
% inicio del juego
% ----------------------------------------------------------

inicio :-
    write('--- Buscaminas ---\n'),
    tablero_inicial(Tablero),
    consulta(Tablero),
    bucle_juego(Tablero).

% ----------------------------------------------------------
% bucle principal
% ----------------------------------------------------------

bucle_juego(Tablero) :-
    write('Seleccion de casilla.\n'),

    write('Coordenada x: '),
    read(X),

    write('Coordenada y: '),
    read(Y),

    !,
    procesar_jugada(Tablero, X, Y).

% ----------------------------------------------------------
% procesar_jugada
% ----------------------------------------------------------

% fuera del tablero
procesar_jugada(Tablero, X, Y) :-
    \+ en_tablero(X, Y), !,

    write('Jugada invalida. Coordenadas fuera del tablero.\n'),
    consulta(Tablero),
    bucle_juego(Tablero).

% casilla ya abierta
procesar_jugada(Tablero, X, Y) :-
    buscar_casilla(Tablero, X, Y, abierta), !,

    write('Esta casilla ya esta abierta.\n'),
    bucle_juego(Tablero).

% mina -> perder
procesar_jugada(Tablero, X, Y) :-
    mina(X, Y), !,

    reemplazar_casilla(
        Tablero,
        X, Y,
        abierta,
        TableroFinal),

    consulta(TableroFinal),

    write('Boom! Pisaste una mina.\n'),
    write('- Fin del juego -\n'),
    write('Escribe inicio. para volver a jugar\n').

% casilla segura
procesar_jugada(Tablero, X, Y) :-

    reemplazar_casilla(
        Tablero,
        X, Y,
        abierta,
        TableroAux),

    expandir_abrir(
        TableroAux,
        X, Y,
        NuevoTablero),

    write('Jugada valida\n'),
    consulta(NuevoTablero),

    (
        gana(NuevoTablero)
    ->
        write('Felicidades, ganaste!\n')
    ;
        bucle_juego(NuevoTablero)
    ).

% ----------------------------------------------------------
% expandir_abrir
% si la casilla es vacia propaga a sus vecinos,
% si no, no hay nada que expandir
% ----------------------------------------------------------

expandir_abrir(Tablero, X, Y, NuevoTablero) :-
    es_vacia(X, Y), !,
    expandir_vecinos(Tablero, X, Y, NuevoTablero).

expandir_abrir(Tablero, _, _, Tablero).

% ----------------------------------------------------------
% expandir_vecinos
% ----------------------------------------------------------

expandir_vecinos(Tablero, X, Y, NuevoTablero) :-
    expandir_vecinos_aux(
        Tablero,
        X, Y,
        [(-1,-1), (-1,0), (-1,1),
         (0,-1),          (0,1),
         (1,-1),  (1,0),  (1,1)],
        NuevoTablero).

expandir_vecinos_aux(
    Tablero,
    _, _, [],
    Tablero).

expandir_vecinos_aux(
    Tablero,
    X, Y,
    [(DX,DY) | Resto],
    NuevoTablero) :-

    VX is X + DX,
    VY is Y + DY,

    (
        en_tablero(VX, VY),
        buscar_casilla(Tablero, VX, VY, cerrada),
        \+ mina(VX, VY)
    ->
        reemplazar_casilla(
            Tablero,
            VX, VY,
            abierta,
            TableroAux),

        (
            es_vacia(VX, VY)
        ->
            expandir_abrir(
                TableroAux,
                VX, VY,
                TableroExpandido)
        ;
            TableroExpandido = TableroAux
        )
    ;
        TableroExpandido = Tablero
    ),

    expandir_vecinos_aux(
        TableroExpandido,
        X, Y,
        Resto,
        NuevoTablero).