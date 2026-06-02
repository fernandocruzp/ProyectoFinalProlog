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

% -----------------------------
% Imprime el estado actual del juego.
% Usa mostrar_fila/2 llamándolo secuencialmente para cada
% una de las filas y así construir la representación visual completa.
% -----------------------------
mostrar_tablero(Tablero) :-
    nl,
    write('Estado actual del tablero:'), nl,
    mostrar_fila(1, Tablero),
    mostrar_fila(2, Tablero),
    mostrar_fila(3, Tablero),
    nl.

% -----------------------------
% Extrae y formatea la información de una fila específica.
% Utiliza nth1/3 para encontrar la cantidad exacta de palillos en la 
% posición 'N' de la lista 'Tablero'. Después, imprime el número de 
% la fila y usa a escribir_palillos/1 para el dibujo de los caracteres.
% -----------------------------
mostrar_fila(N, Tablero) :-
    nth1(N, Tablero, Cantidad),
    ( Cantidad =:= 1 ->
        format('Fila ~d (1 palillo):  ', [N])
    ;
        format('Fila ~d (~w palillos): ', [N, Cantidad])
    ),
    escribir_palillos(Cantidad),
    nl.

% -----------------------------
% Dibuja la representación gráfica de los palillos.
%   Si la cantidad es 0, imprime el texto '(vacía)'.
%   Si la cantidad es mayor a 0, utiliza un ciclo 
%   forall/2 junto con between/3 para imprimir el caracter '| ' 
%   tantas veces como indique la variable 'Cant'.
% -----------------------------
escribir_palillos(0) :- write('(vacía)').
escribir_palillos(Cant) :-
    Cant > 0,
    forall(between(1, Cant, _), write('| ')).

% -----------------------------
% Evalúa la condición de fin de juego.
% Devuelve verdadero únicamente si todos los elementos de la lista son 0.
% - Caso base: Una lista vacía [] ha sido verificada por completo.
% - Caso recursivo: Si la cabeza de la lista es 0 ([0|Resto]), 
%   se llama a sí mismo para verificar el 'resto' de la lista. 
%   Falla si encuentra un número distinto de 0.
% -----------------------------
tablero_vacio([]).
tablero_vacio([0|Resto]) :- tablero_vacio(Resto).

% -----------------------------
% Bucle principal del juego.
% Actual es el jugador con el truno actual y otro es el jugador que esta esperando su turno,
% el bulce primero presenta el estado actual del Tablero y despues, verifica si este esta vacio, 
% en caso de que si entonces el otro jugador tomo el ultimo palillo del tablero, por loque Este Gana;
% Si no esta vacio entonces es el turno de Actual, se le pide un movimiento y luego se valida si es correcto,
% en caso de serlo se llama recursivamentente a juego pero con el tablero actializado y ahora en el turno del otro jugador;
% si no es correcto el movimiento, entonces se repite el bulce con los mismos parametros sin cambiar nada,
% esto para que el jugador actual mande un moviiento valido.
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
            juego(Tablero, Actual, Otro)
        )
    ).

% -----------------------------
% Pedir movimiento al jugador.
% Lee una linea escrita por el usuario, por ejemplo: 2 3
% El primer numero representa la fila y el segundo la cantidad de palillos a tomar.
% -----------------------------
movimiento(Fila, Tomar) :-
    write('Escribe tu movimiento como "fila cantidad": '),
    flush_output,
    read_line_to_string(user_input, Entrada),
    entrada_a_movimiento(Entrada, Fila, Tomar).

% -----------------------------
% Convertir la entrada del usuario en dos numeros enteros.
% Por ejemplo, convierte el texto "2 3" en Fila = 2 y Tomar = 3.
% Si el formato no es correcto, este predicado falla y el movimiento queda invalido.
% -----------------------------
entrada_a_movimiento(Entrada, Fila, Tomar) :-
    Entrada \= end_of_file,
    normalize_space(string(Limpia), Entrada),
    split_string(Limpia, " \t", " \t", Partes),
    Partes = [FilaTexto, TomarTexto],
    catch(number_string(FilaNumero, FilaTexto), _, fail),
    catch(number_string(TomarNumero, TomarTexto), _, fail),
    integer(FilaNumero),
    integer(TomarNumero),
    Fila = FilaNumero,
    Tomar = TomarNumero.

% -----------------------------
% Validar y aplicar jugada.
% Se valida que Fila y Tomar sean enteros, Fila debe estar entre 1 y 3, Tomar debe ser >= 1 y <= cantidad de palillos de la fila,
% finalmente si se cumple con lo anterior se le resta Tomar a la cantidad de palillos a la Fila pedida y se genera NuevoTablero con esa fila actualizada.
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
% Si la fila a actualizar es mayor a 1, entonces se le resta 1 a Fila y recursivamente se busca actulizar la fila en el resto de la lista(Xs), 
% asi cuando se llegue a Fila = 1, se actualizara la fila correcta y sin cambiar lo que estaba antes y ni despues(Si es que hay elementos despues).
% -----------------------------
reemplazar_nth1([_ | Xs], 1, Nuevo, [Nuevo | Xs]).
reemplazar_nth1([X | Xs], Fila, Nuevo, [X | X1]) :-
    Fila > 1,
    FilaN is Fila - 1,
    reemplazar_nth1(Xs, FilaN, Nuevo, X1).

% -----------------------------
% mover/4
% Permite hacer un movimiento directo desde una consulta.
% Usa validar_mov/4 para revisar si el movimiento es válido
% y generar el nuevo tablero.
% -----------------------------
mover(Tablero, Fila, Tomar, NuevoTablero) :-
    validar_mov(Tablero, Fila, Tomar, NuevoTablero).
