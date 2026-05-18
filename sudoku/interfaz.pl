%  Interfaz del Sudoku
%    - imprimir_tablero(+Tablero)
%    - leer_jugada(-Fila, -Col, -Valor)

% imprimir_tablero(+Tablero)
imprimir_tablero(Tablero) :-
    nl,
    write('      1   2   3   4   5   6   7   8   9'), nl,
    write('    +───────────+───────────+───────────+'), nl,
    imprimir_filas(Tablero, 1).


% imprimir_filas(+Filas, +NumFila)
% Caso base: ya no hay filas que imprimir.
imprimir_filas([], _).

% Caso recursivo: imprime la fila actual con su número,
% agrega separador horizontal después de las filas 3, 6 y 9.
imprimir_filas([Fila|Resto], NumFila) :-
    format('  ~w | ', [NumFila]),
    imprimir_celdas(Fila, 1),
    nl,
    % Separador horizontal de cuadrante después de filas 3, 6 y 9
    (   (NumFila =:= 3 ; NumFila =:= 6 ; NumFila =:= 9)
    ->  write('    +───────────+───────────+───────────+'), nl
    ;   true
    ),
    NumFilaSig is NumFila + 1,
    imprimir_filas(Resto, NumFilaSig).


% imprimir_celdas(+Celdas, +NumCol)
% Caso base: ya no hay celdas en esta fila.
imprimir_celdas([], _).

% Caso recursivo: imprime cada celda.
% Los ceros se muestran como '.' para indicar celda vacía.
% Agrega separador vertical '|' después de las columnas 3 y 6.
imprimir_celdas([Celda|Resto], NumCol) :-
    (   Celda =:= 0
    ->  write(' . ')
    ;   format(' ~w ', [Celda])
    ),
    % Separador vertical de cuadrante después de columnas 3 y 6
    (   (NumCol =:= 3 ; NumCol =:= 6)
    ->  write('|')
    ;   true
    ),
    NumColSig is NumCol + 1,
    imprimir_celdas(Resto, NumColSig).
