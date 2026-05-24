:- use_module(library(readutil)).

% Inicializa el juego mostrando un mensaje de bienvenida con las reglas básicas del Nim e inicia
% la partida con un tablero predefinido [3,5,7] y los jugadores jugador1 y jugador2
inicio :-
    write('========================================'), nl,
    write('        BIENVENIDO AL JUEGO NIM         '), nl,
    write('========================================'), nl, nl,
    write('REGLAS DEL JUEGO:'), nl,
    write('- Hay tres filas con palillos:'), nl,
    write('  Fila 1: 3 palillos'), nl,
    write('  Fila 2: 5 palillos'), nl,
    write('  Fila 3: 7 palillos'), nl,
    write('- En cada turno, el jugador debe elegir una fila (1,2,3)'), nl,
    write('  y retirar al menos 1 palillo y como máximo todos los de esa fila.'), nl,
    write('- Gana el jugador que toma el último palillo.'), nl, nl,
    write('Los jugadores son: jugador1 y jugador2.'), nl,
    write('Para mover, escribe: "fila cantidad" (ejemplo: 2 3)'), nl,
    write('========================================'), nl, nl,

    % Tablero inicial: [3,5,7]
    juego([3,5,7], jugador1, jugador2).

% mostrar_tablero
% Imprime el estado actual del tablero
mostrar_tablero(Tablero) :-
    nl,
    write('Estado actual del tablero:'), nl,
    mostrar_fila(1, Tablero),
    mostrar_fila(2, Tablero),
    mostrar_fila(3, Tablero),
    nl.

% Muestra una única fila del tablero.
mostrar_fila(N, Tablero) :-
    nth1(N, Tablero, Cantidad),
    format('Fila ~d: ', [N]),
    escribir_palillos(Cantidad),
    nl.

% Dibuja una representación visual de los palillos.
escribir_palillos(0) :- write('(vacía)').
escribir_palillos(Cant) :-
    Cant > 0,
    forall(between(1, Cant, _), write('| ')).

% tablero_vacio
% Verdadero si todas las filas tienen 0 palillos
tablero_vacio([]).
tablero_vacio([0|Resto]) :- tablero_vacio(Resto).

% -----------------------------
% Bucle principal del juego.
% Actual es el jugador con el truno actual y otro es el jugador que esta esperando su turno, el bulce primero presenta el estado actual del Tablero y despues, verifica si este esta vacio, en caso de que si entonces el otro jugador tomo el ultimo palillo, por loque Este Gana; Si no esta vacio entonces es el turno de Actual, se le pude un movimiento y luego se valida si es correcto; en caso de serlo se llama recursivamentente a juego pero con el tablero actializado y ahora en el turno del otro jugador; si no es correcto el movimiento, entonces se repite el bulce con los mismos parametros sin cambiar nada, para que el jugador actual de un moviiento valido.
% -----------------------------
juego(Tablero, Actual, Otro) :-
    mostrar_tablero(Tablero),
    (   tablero_vacio(Tablero)
    ->  format('~n~w gana la partida.~n', [Otro])
    ;   format('~nTurno de ~w.~n', [Actual]),
        movimiento(Fila, Tomar),
        (   validar_mov(Tablero, Fila, Tomar, NuevoTablero)
        ->  juego(NuevoTablero, Otro, Actual)
        ;   writeln('Movimiento invalido. Intenta de nuevo.'),
            juego(Tablero, Actual, Other)
        )
    ).

% -----------------------------
% Validar y aplicar jugada.
% Se valida que Fila y Tomar sean enteros, Fila debe estar entre 1 y 3, Tomar debe ser >= 1 y <= cantidad de palillos de la fila, finalmente si se cumple con lo anterior se resta Tomar a la cantidad de palillos a la Fila pedida y se genera NuevoTablero con esa fila actualizada.
% -----------------------------
validar_mov(Tablero, Fila, Tomar, NuevoTablero) :-
    integer(Fila),
    integer(Tomar),
    between(1, 3, Fila),
    Tomar >= 1,
    nth1(Fila, Tablero, PalillosActual),
    PalillosActual >= Tomar,
    NuevoActual is PalillosActual - Tomar,
    reemplazar_nth1(Tablero, Fila, NuevoActual, NuevoTablero).

% -----------------------------
% Reemplazar elemento en lista.
% Lo usamos para actualizar el numero de palillos en una de las filas del Tablero.
% En el caso base si la fila a actualizar es 1, se cambia la cabeza por Nuevo y se deja lo demas(Xs) igual.
% Si la fila a actualizar es mayor a 1, entonces se le rsta 1 a Fila y recursivamente se busca actulizar la fila en el resto de la lista(Xs), asi cuando se llegue a Fila = 1, se actualizara la fila correcta y sin cambiar lo que estaba antes y ni despues(Si es que hay elementos despues).
% -----------------------------
reemplazar_nth1([_ | Xs], 1, Nuevo, [Nuevo | Xs]).
reemplazar_nth1([X | Xs], Fila, Nuevo, [X | X1]) :-
    Fila > 1,
    FilaN is Fila - 1,
    reemplazar_nth1(Xs, FilaN, Nuevo, X1).
