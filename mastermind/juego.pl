:- use_module(library(random)).

% UNIVERSO DE COLORES

colores_universo([rosa, azul, verde, morado, dorado, negro]).

% SELECCIÓN ALEATORIA DE COLORES

elegir_color_random(ColorElegido, Lista, Resto) :-
    length(Lista, Total),
    random(0, Total, IndiceAleatorio),
    buscar_indice(IndiceAleatorio, Lista, ColorElegido),
    quitar_elemento(ColorElegido, Lista, Resto).

buscar_indice(0, [X | _Cola], X).
buscar_indice(N, [_Cabeza | Cola], ElementoEncontrado) :-
    N > 0,
    N_Siguiente is N - 1,
    buscar_indice(N_Siguiente, Cola, ElementoEncontrado).

quitar_elemento(_, [], []).
quitar_elemento(X, [X | Cola], Cola) :- !.
quitar_elemento(X, [Cabeza | Cola], [Cabeza | Resto]) :-
    quitar_elemento(X, Cola, Resto).

% GENERACIÓN DEL PATRÓN SECRETO (sin colores repetidos)

generar_patron(0, _, []).
generar_patron(N, Disponibles, [Color | FinalPatron]) :-
    N > 0,
    elegir_color_random(Color, Disponibles, Resto),
    N_Siguiente is N - 1,
    generar_patron(N_Siguiente, Resto, FinalPatron).

% MENÚ DE AYUDA

help :-
    format('Instrucciones:~n'),
    format('1. Se creará un patrón secreto de 5 colores sin repeticiones.~n'),
    format('2. Los colores disponibles son: rosa, azul, verde, morado, dorado, negro.~n'),
    format('3. Debes adivinar los colores y sus posiciones exactas escribiéndolos tal cual crees que están.~n'),
    format('4. Tienes 10 intentos para adivinar el patrón completo.~n'),
    format('---------------------------------------------~n~n').

% LOOP DEL JUEGO Y CONTADOR DE INTENTOS

iniciar :-
    help,
    colores_universo(Disponibles),
    generar_patron(5, Disponibles, Patron),
    format('El patrón secreto ha sido generado :)~n~n'),
    jugar(Patron, 10).

jugar(Patron, 0) :-
    format('~n¡Se acabaron los intentos! El patrón era: ~w~n', [Patron]).

jugar(Patron, Intentos) :-
    Intentos > 0,
    format('Te quedan ~w intentos.~n', [Intentos]),
    write('Ingresa tu adivinanza de 5 colores: '),
    nl,
    catch(
        read(IntentoJugador),
        _Error,
        IntentoJugador = entrada_invalida   % si explota, asigna un valor que falla validación
    ),
    ( validar_intento(IntentoJugador) ->
        checar_intento(Patron, IntentoJugador, Resultado),
        IntentosRestantes is Intentos - 1,
        continuar(Resultado, Patron, IntentosRestantes)
    ;
        format('~nIntento inválido. Asegúrate de ingresar exactamente 5 colores válidos sin repetir. También checa que las comas esten correctamente posicionadas.~n~n'),
        jugar(Patron, Intentos)
    ).
    

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

% VALIDACIÓN DEL INTENTO

color_valido(Color) :-
    colores_universo(Lista),
    member(Color, Lista).

sin_repetidos([]).
sin_repetidos([X | Cola]) :-
    \+ member(X, Cola),
    sin_repetidos(Cola).

validar_intento(Intento) :-
    is_list(Intento),
    length(Intento, 5),
    maplist(color_valido, Intento),
    sin_repetidos(Intento).

% ACIERTOS EXACTOS (color y posición correctos)

aciertos_exactos([], [], 0, [], []).
aciertos_exactos([X | ColaPatron], [X | ColaIntento], TotalBien, NoExactosPatron, NoExactosIntento) :-
    aciertos_exactos(ColaPatron, ColaIntento, N_Siguiente, NoExactosPatron, NoExactosIntento),
    TotalBien is N_Siguiente + 1.

aciertos_exactos([X | ColaPatron], [Y | ColaIntento], TotalBien, [X | NoExactosPatron], [Y | NoExactosIntento]) :-
    X \= Y,
    aciertos_exactos(ColaPatron, ColaIntento, TotalBien, NoExactosPatron, NoExactosIntento).

% ACIERTOS PARCIALES (color correcto, posición incorrecta)

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
