
% --- 1. REPRESENTACIÓN DEL TABLERO Y CONSTANTES ---
% Fichas: 'b' (Negras / X), 'w' (Blancas / O), 'e' (Vacío / .)

tablero_inicial([
    e,e,e,e,e,e,e,e,
    e,e,e,e,e,e,e,e,
    e,e,e,e,e,e,e,e,
    e,e,e,w,b,e,e,e,
    e,e,e,b,w,e,e,e,
    e,e,e,e,e,e,e,e,
    e,e,e,e,e,e,e,e,
    e,e,e,e,e,e,e,e
]).

opponent(b, w).
opponent(w, b).

% Direcciones de búsqueda en la matriz (Horizontal, Vertical y Diagonales)
dir(-1, -1). dir(-1, 0). dir(-1, 1).
dir(0, -1).              dir(0, 1).
dir(1, -1).  dir(1, 0).  dir(1, 1).

% --- 2. MANEJO DE COORDENADAS (FILA, COLUMNA) ---
xy_to_idx(X, Y, Idx) :-
    integer(X), integer(Y),
    X >= 1, X =< 8,
    Y >= 1, Y =< 8,
    Idx is (X - 1) * 8 + (Y - 1).

get_piece(Board, X, Y, Color) :-
    xy_to_idx(X, Y, Idx),
    nth0(Idx, Board, Color).

set_piece(Board, X, Y, Color, NewBoard) :-
    xy_to_idx(X, Y, Idx),
    replace_nth0(Idx, Board, Color, NewBoard).

replace_nth0(0, [_|T], E, [E|T]) :- !.
replace_nth0(N, [H|T], E, [H|R]) :-
    N > 0,
    N1 is N - 1,
    replace_nth0(N1, T, E, R).

% --- 3. LÓGICA DE FLANQUEO (REGLAS DE OTHELLO) ---

% Verifica si una línea atrapa fichas enemigas en una dirección específica
check_dir(Board, X, Y, DX, DY, Player, Flipped) :-
    NX is X + DX,
    NY is Y + DY,
    opponent(Player, Opp),
    get_piece(Board, NX, NY, Opp),
    check_dir_line(Board, NX, NY, DX, DY, Player, Flipped).

check_dir_line(Board, X, Y, DX, DY, Player, [(X, Y) | Rest]) :-
    NX is X + DX,
    NY is Y + DY,
    opponent(Player, Opp),
    get_piece(Board, NX, NY, Opp),
    !,
    check_dir_line(Board, NX, NY, DX, DY, Player, Rest).
check_dir_line(Board, X, Y, DX, DY, Player, [(X, Y)]) :-
    NX is X + DX,
    NY is Y + DY,
    get_piece(Board, NX, NY, Player).

% Obtiene todas las fichas a invertir si el Jugador tira en (X, Y)
get_all_flips(Board, X, Y, Player, Flips) :-
    findall(F, (dir(DX, DY), check_dir(Board, X, Y, DX, DY, Player, F)), AllLists),
    append(AllLists, Flips),
    Flips \= [].

% --- 4. PREDICADOS REQUERIDOS ---

% mover(+TableroActual, +Jugador, +(X, Y), -NuevoTablero)
mover(Board, Player, (X, Y), NewBoard) :-
    get_piece(Board, X, Y, e),
    get_all_flips(Board, X, Y, Player, Flips),
    set_piece(Board, X, Y, Player, TempBoard),
    flip_pieces(TempBoard, Flips, Player, NewBoard).

flip_pieces(Board, [], _, Board).
flip_pieces(Board, [(X, Y) | Rest], Player, NewBoard) :-
    set_piece(Board, X, Y, Player, TempBoard),
    flip_pieces(TempBoard, Rest, Player, NewBoard).

% movimientos_validos(+Tablero, +Jugador, -Lista)
movimientos_validos(Board, Player, Lista) :-
    findall((X, Y), (between(1, 8, X), between(1, 8, Y), get_piece(Board, X, Y, e), get_all_flips(Board, X, Y, Player, _)), Lista).

% estado_ganador(+Tablero, -Jugador)
estado_ganador(Board, Jugador) :-
    movimientos_validos(Board, b, []),
    movimientos_validos(Board, w, []),
    !,
    count_pieces(Board, B, W),
    (B > W -> Jugador = b ; W > B -> Jugador = w ; Jugador = empate).

% Contar fichas en el tablero
count_pieces([], 0, 0).
count_pieces([b|T], B, W) :- count_pieces(T, B1, W), B is B1 + 1.
count_pieces([w|T], B, W) :- count_pieces(T, B, W1), W is W1 + 1.
count_pieces([e|T], B, W) :- count_pieces(T, B, W).

% --- 5. INTERFAZ EN TEXTO Y LOOP DE JUEGO ---

mostrar_tablero(Board) :-
    writeln('    1 2 3 4 5 6 7 8'),
    writeln('  +-----------------+'),
    mostrar_filas(Board, 1),
    writeln('  +-----------------+').

mostrar_filas(_, 9) :- !.
mostrar_filas(Board, Row) :-
    format('~d | ', [Row]),
    mostrar_fila_elementos(Board, Row, 1),
    writeln('|'),
    NextRow is Row + 1,
    mostrar_filas(Board, NextRow).

mostrar_fila_elementos(_, _, 9) :- !.
mostrar_fila_elementos(Board, Row, Col) :-
    get_piece(Board, Row, Col, Val),
    char_rep(Val, Char),
    format('~w ', [Char]),
    NextCol is Col + 1,
    mostrar_fila_elementos(Board, Row, NextCol).

char_rep(e, '.').
char_rep(b, 'X'). % Negras
char_rep(w, 'O'). % Blancas

% Iniciar el juego de manera interactiva
jugar :-
    tablero_inicial(B),
    jugar_turno(B, b).

% Caso 1: El juego realmente terminó (Nadie tiene movimientos)
jugar_turno(Board, _Player) :-
    estado_ganador(Board, Ganador),
    !,
    mostrar_tablero(Board),
    anunciar_ganador(Ganador, Board).

% Caso 2: El jugador actual no puede tirar, pasa turno al oponente
jugar_turno(Board, Player) :-
    movimientos_validos(Board, Player, []),
    !,
    opponent(Player, Opp),
    format('El jugador ~w no tiene movimientos validos. Pasa turno.~n', [Player]),
    jugar_turno(Board, Opp).

% Caso 3: Turno normal del jugador
jugar_turno(Board, Player) :-
    mostrar_tablero(Board),
    format('Turno del jugador ~w (X = Negras, O = Blancas).~n', [Player]),
    movimientos_validos(Board, Player, Validos),
    format('Movimientos validos: ~w~n', [Validos]),
    repeat,
    write('Introduce tu movimiento "Fila-Columna." (ej. 3-4.): '),
    read(R-C),
    (mover(Board, Player, (R, C), NewBoard) ->
        opponent(Player, Opp),
        jugar_turno(NewBoard, Opp)
    ;
        writeln('Movimiento invalido. Intenta de nuevo.'),
        fail
    ).

anunciar_ganador(empate, Board) :-
    count_pieces(Board, B, W),
    format('¡Es un empate! Negras (X): ~d, Blancas (O): ~d~n', [B, W]).
anunciar_ganador(Ganador, Board) :-
    count_pieces(Board, B, W),
    format('¡El ganador es el jugador ~w! Negras (X): ~d, Blancas (O): ~d~n', [Ganador, B, W]).