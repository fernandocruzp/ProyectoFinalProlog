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

% Regla del cuadrante: todos los números en una caja 3x3 deben ser únicos
% Predicado que extrae una caja 3x3
caja(FilaInicio, ColInicio, Tablero, Caja) :-
    % vamos a usar findall, que recorre todas las combinaciones posibles y las agrega en una lista
    findall(Elem,
        % generar todas las combinaciones posibles para una caja 3x3
        (between(0, 2, Fila),
         % Col va de 0, 1, 2 (3 columnas)
         between(0, 2, Col),
         F is FilaInicio + Fila,
         C is ColInicio + Col,
         % obtenemos la fila del tablero en la posición F 
         nth0(F, Tablero, FilaTablero),
         % obtenemos el elemento en la columna C de esa fila
         nth0(C, FilaTablero, Elem)),
        % todos los elementos extraídos los agregamos en la lista Caja
        Caja).

% Predicado que verifica que la regla del cuadrante se cumple para toda caja
cajas_validas(Tablero) :-
    cajas_validas_aux(0, 0, Tablero).

% Predicado auxiliar para cajas_validas
% caso base: cuando FilaInicio es 9, ya se checaron todas las filas de cajas 
cajas_validas_aux(9, _, _) :- !.

% caso recursivo: cuando ColInicio es 9, ya se checaron todas las columnas de la fila actual, pasar a la siguiente fila de cajas
cajas_validas_aux(FilaInicio, 9, Tablero) :-
    !,
    % calcular la siguiente fila de cajas (sumar 3)
    NextFila is FilaInicio + 3,
    % reiniciar la columna a 0 para la siguiente fila
    cajas_validas_aux(NextFila, 0, Tablero).

% caso recursivo: checar la caja actual y pasar a la siguiente
cajas_validas_aux(FilaInicio, ColInicio, Tablero) :-
    % extraer la caja 3x3 en la posición (FilaInicio, ColInicio)
    caja(FilaInicio, ColInicio, Tablero, Caja),
    % checar que no haya duplicados en esa caja
    fila_valida(Caja),
    % calcular la siguiente columna de cajas (sumar 3)
    NextCol is ColInicio + 3,
    % llamar recursivamente para la siguiente caja en la misma fila
    cajas_validas_aux(FilaInicio, NextCol, Tablero).

% Predicado para verificar si un sudoku es válido (cumple todas las reglas)
sudoku_valido(Tablero) :-
    filas_validas(Tablero),
    columnas_validas(Tablero),
    cajas_validas(Tablero).

% insertar_valor(+Tablero, +Fila, +Col, +Valor, -NuevoTablero)
% Reemplaza la celda (Fila, Col) con Valor. Índices 1-9. Valor 0 = borrar.
insertar_valor(Tablero, Fila, Col, Valor, NuevoTablero) :-
    nth1(Fila, Tablero,      FilaVieja, RestoFilas),
    nth1(Col,  FilaVieja,    _,         RestoCol),
    nth1(Col,  FilaNueva,    Valor,     RestoCol),
    nth1(Fila, NuevoTablero, FilaNueva, RestoFilas).

% Predeicados que identifican qué restricción se viola.

% fila_invalida(?N, +Tablero)
fila_invalida(N, Tablero) :-
    between(1, 9, N),
    nth1(N, Tablero, Fila),
    \+ fila_valida(Fila).

% columna_invalida(?N, +Tablero)
columna_invalida(N, Tablero) :-
    between(1, 9, N),
    columna(N, Tablero, Col),
    \+ fila_valida(Col).

% cuadrante_invalido(?FilaInicio, ?ColInicio, +Tablero)
% FilaInicio y ColInicio (0, 3 o 6).
cuadrante_invalido(FilaInicio, ColInicio, Tablero) :-
    member(FilaInicio, [0, 3, 6]),
    member(ColInicio,  [0, 3, 6]),
    caja(FilaInicio, ColInicio, Tablero, Caja),
    \+ fila_valida(Caja).

% Verdadero si ninguna celda contiene 0 (tablero totalmente lleno).
tablero_completo(Tablero) :-
    \+ (member(Fila, Tablero), member(0, Fila)).
 
