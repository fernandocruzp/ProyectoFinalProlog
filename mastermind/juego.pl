:- use_module(library(random)).

% UNIVERSO DE COLORES

colores_universo([rosa, azul, verde, morado, blanco, negro, plateado, dorado]).

% SELECCIÓN ALEATORIA DE COLORES

elegir_color_random(ColorElegido) :-
    colores_universo(Lista),
    length(Lista, Total),
    random(0, Total, IndiceAleatorio),
    buscar_indice(IndiceAleatorio, Lista, ColorElegido).

buscar_indice(0, [X | _Cola], X).
buscar_indice(N, [_Cabeza | Cola], ElementoEncontrado) :-
    N > 0,
    N_Siguiente is N - 1,
    buscar_indice(N_Siguiente, Cola, ElementoEncontrado).

% GENERACIÓN DEL PATRÓN SECRETO

generar_patron(0, []).
generar_patron(N, [Color | FinalPatron]) :-
    N > 0,
    elegir_color_random(Color),
    N_Siguiente is N - 1,
    generar_patron(N_Siguiente, FinalPatron).

% MENÚ DE AYUDA

help :-
    format('Instrucciones:~n'),
    format('1. Se creará un patrón secreto de 5 colores.~n'),
    format('2. Los colores disponibles son: rosa, azul, verde, morado, blanco, negro, plateado, dorado.~n'),
    format('3. Debes adivinar los colores y sus posiciones exactas escribiéndolos tal cual crees que están.~n'),
    format('4. Tienes 10 intentos para adivinar el patrón completo.~n'),
    format('---------------------------------------------~n~n').

% LOOP DEL JUEGO Y CONTADOR DE INTENTOS

iniciar :-
    help,
    generar_patron(5, Patron),
    format('El patrón secreto ha sido generado :)~n~n'),
    jugar(Patron, 10).

jugar(Patron, 0) :-
    format('~n¡Se acabaron los intentos! El patrón era: ~w~n', [Patron]).

jugar(Patron, Intentos) :-
    Intentos > 0,
    format('Te quedan ~w intentos.~n', [Intentos]),
    write('Ingresa tu adivinanza de 5 colores: '),
    nl,
    read(IntentoJugador),
    checar_intento(Patron, IntentoJugador, Resultado),
    IntentosRestantes is Intentos - 1,
    continuar(Resultado, Patron, IntentosRestantes).

continuar(ganador, _, _) :- !.

continuar(seguir, Patron, Intentos) :-
    jugar(Patron, Intentos).

% VERIFICACIÓN DEL INTENTO

checar_intento(Patron, Intento, Resultado) :-
    aciertos_exactos(Patron, Intento, BienColocados, NoExPatron, NoExIntento),
    aciertos_parciales(NoExIntento, NoExPatron, MalColocados),
    format('~nResultados:~n'),
    format('Colores perfectamente colocados: ~w~n', [BienColocados]),
    format('Colores correctos pero mal colocados: ~w~n~n', [MalColocados]),
    ( BienColocados =:= 5 ->
        format('¡Ganaste! :D~n'),
        Resultado = ganador
    ;
        Resultado = seguir
    ).

% ACIERTOS EXACTOS (color y posición correctos)

aciertos_exactos([], [], 0, [], []).
aciertos_exactos([X | ColaPatron], [X | ColaIntento], TotalBien, NoExactosPatron, NoExactosIntento) :-
    aciertos_exactos(ColaPatron, ColaIntento, N_Siguiente, NoExactosPatron, NoExactosIntento),
    TotalBien is N_Siguiente + 1.

aciertos_exactos([X | ColaPatron], [Y | ColaIntento], TotalBien, [X | NoExactosPatron], [Y | NoExactosIntento]) :-
    X \= Y,
    aciertos_exactos(ColaPatron, ColaIntento, TotalBien, NoExactosPatron, NoExactosIntento).

% ============================================================
% ACIERTOS PARCIALES (color correcto, posición incorrecta)
% ============================================================

obtener_color(Color, [Color | Cola], Cola).
obtener_color(Color, [Cabeza | Cola], [Cabeza | RestoDeLista]) :-
    Color \= Cabeza,
    obtener_color(Color, Cola, RestoDeLista).

aciertos_parciales([], _NoExactosPatron, 0).
aciertos_parciales([X | ColaIntento], NoExactosPatron, TotalMal) :-
    ( obtener_color(X, NoExactosPatron, NuevaListaPatron) ->
        aciertos_parciales(ColaIntento, NuevaListaPatron, N_Siguiente),
        TotalMal is N_Siguiente + 1
    ;
        aciertos_parciales(ColaIntento, NoExactosPatron, TotalMal)
    ).
