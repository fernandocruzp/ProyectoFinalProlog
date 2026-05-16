% Definición de las matrices a resolver por el usuario.
% '0' representa las casillas vacias que se deben de llenar
% La resolución de los tres sudokus se las mande por el grupo, por si necesitan verificar algo o hacer pruebas.

% Sudoku nivel fácil
tablero(facil, [
    [3, 0, 0, 0, 0, 2, 0, 9, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 4],
    [0, 0, 5, 0, 0, 0, 0, 3, 0],
    [6, 0, 0, 1, 0, 0, 3, 0, 0],
    [0, 0, 0, 0, 6, 0, 0, 0, 8],
    [0, 8, 0, 2, 0, 3, 5, 7, 0],
    [0, 0, 6, 5, 0, 4, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 2],
    [9, 0, 0, 0, 1, 0, 0, 0, 7]
]).

% Sudoku nivel intermedio
tablero(intermedio, [
    [0, 6, 0, 0, 0, 0, 7, 0, 2],
    [0, 0, 0, 0, 0, 8, 0, 0, 1],
    [0, 0, 4, 0, 0, 0, 0, 3, 0],
    [0, 9, 0, 8, 0, 0, 1, 5, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 9],
    [0, 5, 6, 0, 0, 7, 2, 0, 0],
    [7, 0, 0, 2, 0, 0, 0, 0, 0],
    [0, 0, 2, 0, 9, 1, 4, 0, 0],
    [0, 0, 0, 4, 0, 3, 0, 0, 6]
]).

% Sudoku nivel dificil
tablero(dificil, [
    [0, 2, 0, 0, 0, 9, 0, 1, 0],
    [0, 1, 0, 3, 0, 0, 0, 0, 0],
    [0, 4, 0, 6, 0, 0, 0, 9, 2],
    [0, 0, 0, 9, 7, 0, 0, 3, 0],
    [8, 0, 0, 0, 0, 0, 7, 0, 0],
    [0, 0, 0, 5, 0, 0, 0, 0, 4],
    [0, 6, 4, 0, 0, 1, 0, 0, 0],
    [7, 0, 0, 0, 4, 0, 3, 0, 0],
    [5, 0, 0, 2, 0, 0, 0, 0, 0]
]).

% Reglas del Sudoku

% Regla de fila: todos los números en una fila deben ser únicos
% Predicado que valida que no hay duplicados en una fila (lista)
fila_valida([]).
fila_valida([H|T]) :-
    (H == 0 -> true ; \+ member(H, T)),
    fila_valida(T).

% Predicado que verifica que la regla de la fila se cumple para toda fila
filas_validas([]).
filas_validas([Fila|Filas]) :-
    fila_valida(Fila),
    filas_validas(Filas).

% Regla de columna: todos los números en una columna deben ser únicos
% Predicado que valida que no hay duplicados en una columna
columna(_, [], []).
columna(N, [Fila|Filas], [Elem|Columna]) :-
    nth1(N, Fila, Elem),
    columna(N, Filas, Columna).

% Predicado que verifica que la regla de la columna se cumple para toda columna
columnas_validas(Tablero) :-
    length(Tablero, 9),
    columnas_validas_aux(1, Tablero).

% Predicado auxiliar para columnas_validas
% caso base: cuando N es 10 ya se checaron todas las columnas
columnas_validas_aux(10, _) :- !.
% caso recursivo: checar la columna N y pasar a la siguiente
columnas_validas_aux(N, Tablero) :-
    % extraer la columna número N del tablero
    columna(N, Tablero, Col),
    % checar que esa columna no tenga duplicados
    fila_valida(Col),
    N1 is N + 1,
    % llamar recursivamente para la siguiente columna
    columnas_validas_aux(N1, Tablero).
