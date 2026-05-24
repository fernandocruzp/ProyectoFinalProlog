%  Interfaz del Sudoku
%    - imprimir_tablero(+Tablero)
%    - leer_jugada(-Fila, -Col, -Valor)

:- [juego].

% implementación de read_line_to_string/2 con get_char 
read_line_to_string(Stream, String) :-
    leer_chars(Stream, Chars),
    atom_chars(Atom, Chars),
    atom_string(Atom, String).

leer_chars(Stream, Chars) :-
    get_char(Stream, C),
    (   (C == '\n' ; C == end_of_file)
    ->  Chars = []
    ;   Chars = [C | Resto],
        leer_chars(Stream, Resto)
    ).

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

% ── Menú de dificultad ────────────────────────────────────────────────────────

menu_dificultad(Nivel) :-
    nl,
    write('  ┌──────────────────────────────┐'), nl,
    write('  │       SUDOKU EN PROLOG       │'), nl,
    write('  ├──────────────────────────────┤'), nl,
    write('  │  Selecciona tu tablero       │'), nl,
    write('  │    1.  Fácil                 │'), nl,
    write('  │    2.  Intermedio            │'), nl,
    write('  │    3.  Difícil               │'), nl,
    write('  └──────────────────────────────┘'), nl,
    write('  Opción: '),
    read_line_to_string(user_input, Linea),
    (   Linea = "1" -> Nivel = facil
    ;   Linea = "2" -> Nivel = intermedio
    ;   Linea = "3" -> Nivel = dificil
    ;   write('  [!] Opción inválida. Elige 1, 2 o 3.'), nl,
        menu_dificultad(Nivel)
    ).
