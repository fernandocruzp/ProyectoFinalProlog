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
    (   Celda == 0
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

% leer_jugada(-Fila, -Col, -Valor)
% pide al usuario fila, columna y valor uno por uno.
% valida que cada dato sea un entero entre 1 y 9.
% devuelve los tres valores una vez que todos son válidos.

leer_jugada(Fila, Col, Valor) :-
    nl,
    write('  --- Tu jugada ---'), nl,
    write('  (Para salir escribe 0 en cualquier campo)'), nl,
    leer_dato('  Fila   (1-9): ', Fila),
    leer_dato('  Columna(1-9): ', Col),
    leer_dato('  Valor  (1-9): ', Valor).


% leer_dato(+Prompt, -Dato)
% lee un entero desde la consola mostrando el mensaje Prompt.
% acepta valores del 0 al 9.
% Si el usuario ingresa algo que no es entero, vuelve a preguntar.
leer_dato(Prompt, Dato) :-
    write(Prompt),
    read(Input),
    (   integer(Input), between(0, 9, Input)
    ->  Dato = Input
    ;   write('  [!] Ingresa un número del 1 al 9 (o 0 para salir).'), nl,
        leer_dato(Prompt, Dato)
    ).
