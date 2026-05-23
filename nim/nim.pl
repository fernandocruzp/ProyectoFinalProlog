
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
