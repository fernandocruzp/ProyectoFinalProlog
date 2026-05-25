% Implementacion del juego Buscaminas en Prolog
% Logica Computacional 2026-2
% Integrantes:
%   Ochoa Campos Ana Sofia
%   Real Araiza Yamile
%   Resendiz Linares Karen
%   Sanchez Ortiz Diego

% La idea del juego es representar el tablero como una lista de casillas
% cada casilla guarda su posicion y si esta cerrada, abierta o tiene mina
% casilla(X, Y, Estado) donde Estado = cerrada | abierta
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

% ----------------------------------------------------------
% Minas fijas del tablero
% ----------------------------------------------------------

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
% ----------------------------------------------------------

en_tablero(X, Y) :-
    X >= 1, X =< 8,
    Y >= 1, Y =< 8.

% ----------------------------------------------------------
% tablero_inicial(Tablero)
% genera todas las casillas cerradas
% ----------------------------------------------------------

tablero_inicial(Tablero) :-
    generar_casillas(1, 1, Tablero).

% caso base
generar_casillas(_, 9, []) :- !.

% cambio de fila
generar_casillas(9, Y, Lista) :-
    !,
    Y1 is Y + 1,
    generar_casillas(1, Y1, Lista).

% caso recursivo
generar_casillas(X, Y,
    [casilla(X, Y, cerrada) | Resto]) :-

    X1 is X + 1,
    generar_casillas(X1, Y, Resto).

% ----------------------------------------------------------
% buscar_casilla(Tablero, X, Y, Estado)
% ----------------------------------------------------------

buscar_casilla(
    [casilla(X, Y, Estado) | _],
    X, Y, Estado) :- !.

buscar_casilla(
    [_ | Resto],
    X, Y, Estado) :-

    buscar_casilla(Resto, X, Y, Estado).

% ----------------------------------------------------------
% reemplazar_casilla
% devuelve un tablero nuevo con la casilla modificada
% ----------------------------------------------------------

reemplazar_casilla([], _, _, _, []).

reemplazar_casilla(
    [casilla(X, Y, _) | Resto],
    X, Y, NuevoEstado,
    [casilla(X, Y, NuevoEstado) | Resto]) :- !.

reemplazar_casilla(
    [Casilla | Resto],
    X, Y, NuevoEstado,
    [Casilla | RestoNuevo]) :-

    reemplazar_casilla(
        Resto,
        X, Y,
        NuevoEstado,
        RestoNuevo).

% ----------------------------------------------------------
% vecinos_con_mina(X, Y, Lista)
% junta los vecinos que contienen mina
% ----------------------------------------------------------

vecinos_con_mina(X, Y, Lista) :-
    vecinos_con_mina_aux(X, Y,
        [(-1,-1), (-1,0), (-1,1),
         (0,-1),          (0,1),
         (1,-1),  (1,0),  (1,1)],
        Lista).

vecinos_con_mina_aux(_, _, [], []).

vecinos_con_mina_aux(X, Y,
    [(DX,DY) | Resto],
    Lista) :-

    VX is X + DX,
    VY is Y + DY,

    (
        en_tablero(VX, VY),
        mina(VX, VY)
    ->
        Lista = [VX-VY | ListaResto]
    ;
        Lista = ListaResto
    ),

    vecinos_con_mina_aux(
        X, Y,
        Resto,
        ListaResto).

% ----------------------------------------------------------
% longitud de lista
% ----------------------------------------------------------

longitud([], 0).

longitud([_ | Resto], N) :-
    longitud(Resto, N1),
    N is N1 + 1.

% ----------------------------------------------------------
% minas_adyacentes(X, Y, N)
% ----------------------------------------------------------

minas_adyacentes(X, Y, N) :-
    vecinos_con_mina(X, Y, Lista),
    longitud(Lista, N).

% ----------------------------------------------------------
% es_vacia(X, Y)
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
    write('Escribe "inicio." para volver a jugar\n').

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