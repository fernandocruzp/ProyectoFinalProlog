% --- PROYECTO FINAL: CONECTA 4 ---

% 1. Representación
tablero_inicial([[], [], [], [], [], [], []]).

% 2. Visualización
visualizar(Tablero) :-
    nl, write('  1 2 3 4 5 6 7'), nl,
    write(' ---------------'), nl,
    forall(between(1, 6, FilaInv), (
        Fila is 7 - FilaInv,
        write('|'),
        forall(between(1, 7, Col), (
            obtener_ficha(Tablero, Col, Fila, Ficha),
            write(Ficha), write('|')
        )),
        nl
    )),
    write(' ---------------'), nl.

obtener_ficha(Tablero, Col, Fila, Ficha) :-
    nth1(Col, Tablero, Columna),
    (nth1(Fila, Columna, F) -> Ficha = F ; Ficha = ' ').

% 3. Movimiento
mover(Tablero, Jugador, Col, NuevoTablero) :-
    Col >= 1, 
    Col =< 7,
    nth1(Col, Tablero, Columna),
    length(Columna, L),
    L < 6,
    append(Columna, [Jugador], NuevaColumna),
    reemplazar(Tablero, Col, NuevaColumna, NuevoTablero).

reemplazar([_|T], 1, X, [X|T]).
reemplazar([H|T], I, X, [H|R]) :-
    I > 1, 
    I1 is I - 1,
    reemplazar(T, I1, X, R).

% 4. Condiciones de Victoria
gana(Tablero, J) :-
    member(Columna, Tablero),
    append(_, [J, J, J, J | _], Columna).

gana(Tablero, J) :-
    between(1, 4, C), between(1, 6, F),
    C1 is C+1, C2 is C+2, C3 is C+3,
    obtener_ficha(Tablero, C, F, J),
    obtener_ficha(Tablero, C1, F, J),
    obtener_ficha(Tablero, C2, F, J),
    obtener_ficha(Tablero, C3, F, J).

gana(Tablero, J) :-
    between(1, 4, C), between(1, 3, F),
    C1 is C+1, F1 is F+1,
    C2 is C+2, F2 is F+2,
    C3 is C+3, F3 is F+3,
    obtener_ficha(Tablero, C, F, J),
    obtener_ficha(Tablero, C1, F1, J),
    obtener_ficha(Tablero, C2, F2, J),
    obtener_ficha(Tablero, C3, F3, J).

gana(Tablero, J) :-
    between(1, 4, C), between(4, 6, F),
    C1 is C+1, F1 is F-1,
    C2 is C+2, F2 is F-2,
    C3 is C+3, F3 is F-3,
    obtener_ficha(Tablero, C, F, J),
    obtener_ficha(Tablero, C1, F1, J),
    obtener_ficha(Tablero, C2, F2, J),
    obtener_ficha(Tablero, C3, F3, J).

% 5. Generación de movimientos válidos
% movimientos_validos(+Tablero, +Jugador, -ListaColumnas)
movimientos_validos(Tablero, _, ListaColumnas) :-
    findall(Col, (between(1, 7, Col), nth1(Col, Tablero, Column), length(Column, L), L < 6), ListaColumnas).