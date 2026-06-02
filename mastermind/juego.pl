:- use_module(library(random)).

% UNIVERSO DE COLORES

colores_universo([rosa, azul, verde, morado, dorado, negro]).

% SELECCIÓN ALEATORIA DE COLORES

elegir_color_random(ColorElegido, Lista, Resto) :-
    length(Lista, Total), % sacamos el tamaño de la lista
    random(0, Total, IndiceAleatorio), % creamos índice random
    buscar_indice(IndiceAleatorio, Lista, ColorElegido), % sacamos el color de ese índice
    quitar_elemento(ColorElegido, Lista, Resto). % lo quitamos para no repetirlo

buscar_indice(0, [X | _Cola], X). % base: si el índice es 0, es la cabeza
buscar_indice(N, [_Cabeza | Cola], ElementoEncontrado) :- % recursivo: si no es cero
    N > 0,
    N_Siguiente is N - 1, % -1 al índice
    buscar_indice(N_Siguiente, Cola, ElementoEncontrado). % recursión en la cola    

quitar_elemento(_, [], []). % base: lista vacía, devuelve lista vacía
quitar_elemento(X, [X | Cola], Cola) :- !. % recursivo: si es la cabeza, devuelve la cola y termina
quitar_elemento(X, [Cabeza | Cola], [Cabeza | Resto]) :- % recursivo: si no es la cabeza, la guarda
    quitar_elemento(X, Cola, Resto). % recursión en la cola

% GENERACIÓN DEL PATRÓN SECRETO (sin colores repetidos)

generar_patron(0, _, []). % base: cero colores -> lista vacía
generar_patron(N, Disponibles, [Color | FinalPatron]) :- % recursivo: genera patrón
    N > 0,
    elegir_color_random(Color, Disponibles, Resto), % saca color al azar y la lista sobrante
    N_Siguiente is N - 1,
    generar_patron(N_Siguiente, Resto, FinalPatron). % recursión con los colores que sobraron

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
    help, % llamamos instrucciones
    colores_universo(Disponibles), % jalamos el universo
    generar_patron(5, Disponibles, Patron),% generamos 5 colores
    format('El patrón secreto ha sido generado :)~n~n'),
    jugar(Patron, 10).% comenzamos el loop con 10 intentos

jugar(Patron, 0) :- % base: cero intentos -> termina el juego
    format('~n¡Se acabaron los intentos! El patrón era: ~w~n', [Patron]).

jugar(Patron, Intentos) :- % recursivo: pedir intento
    Intentos > 0,
    format('Te quedan ~w intentos.~n', [Intentos]),
    write('Ingresa tu adivinanza de 5 colores: '),
    nl,
    catch( % si el usuario ingrese mal la lista
        read(IntentoJugador), %leemos el input
        _Error,
        IntentoJugador = entrada_invalida  % si está mal el input, indicamos que falla la validación
    ),
    ( validar_intento(IntentoJugador) -> % si el intento es válido
        checar_intento(Patron, IntentoJugador, Resultado), % evaluamos la jugada
        IntentosRestantes is Intentos - 1, % restamos un intento
        continuar(Resultado, Patron, IntentosRestantes) % verificamos si ganó o sigue
    ;
        format('~nIntento inválido. Asegúrate de ingresar exactamente 5 colores válidos sin repetir. También checa que las comas esten correctamente posicionadas.~n~n'),
        jugar(Patron, Intentos) % si el intento no es válido, repetimos el mismo turno sin restar intentos
    ).
    

continuar(ganador, _, _) :- !. % si el resultado es correcto, termina

continuar(seguir, Patron, Intentos) :- % si el resultado es seguir, llamamos jugar de nuevo
    jugar(Patron, Intentos).

% VERIFICACIÓN DEL INTENTO

checar_intento(Patron, Intento, Resultado) :-
    aciertos_exactos(Patron, Intento, BienColocados, NoExPatron, NoExIntento), % separamos exactos y no exactos
    aciertos_parciales(NoExIntento, NoExPatron, MalColocados), % calculamos mal colocados
    format('~nResultados:~n'),
    format('Colores perfectamente colocados: ~w~n', [BienColocados]),
    format('Colores correctos pero mal colocados: ~w~n~n', [MalColocados]),
    ( BienColocados =:= 5 -> %si se atinaron los 5
        format('¡Ganaste! :D~n'),
        Resultado = ganador
    ;
        Resultado = seguir %si aun no se atinaron
    ).

% VALIDACIÓN DEL INTENTO

color_valido(Color) :-
    colores_universo(Lista),
    member(Color, Lista). % checamos que exista en el universo

sin_repetidos([]). % base: lista vacía no tiene repetidos
sin_repetidos([X | Cola]) :- % recursivo: checar repetidos
    \+ member(X, Cola), % checamos que la cabeza no esté en la cola
    sin_repetidos(Cola). % recursión en la cola

validar_intento(Intento) :-
    is_list(Intento),% checa que sea lista
    length(Intento, 5), % checa tamaño 5
    maplist(color_valido, Intento), % aplica color_valido a todos
    sin_repetidos(Intento). % checa que no haya duplicados

% ACIERTOS EXACTOS (color y posición correctos)

aciertos_exactos([], [], 0, [], []). % base: listas vacías -> 0 aciertos y 0 no exactos
aciertos_exactos([X | ColaPatron], [X | ColaIntento], TotalBien, NoExactosPatron, NoExactosIntento) :- % recursivo si cabezas iguales
    aciertos_exactos(ColaPatron, ColaIntento, N_Siguiente, NoExactosPatron, NoExactosIntento), % recursión en colas
    TotalBien is N_Siguiente + 1. % +1 al contador de bien colocados

aciertos_exactos([X | ColaPatron], [Y | ColaIntento], TotalBien, [X | NoExactosPatron], [Y | NoExactosIntento]) :- % recursivo si las cabezas son diferentes
    X \= Y, % checamos que sean diferentes
    aciertos_exactos(ColaPatron, ColaIntento, TotalBien, NoExactosPatron, NoExactosIntento). % recursión guardando los no exactos

% ACIERTOS PARCIALES (color correcto, posición incorrecta)

obtener_color(Color, [Color | Cola], Cola). % base: si encontró en la cabeza, devuelve la cola
obtener_color(Color, [Cabeza | Cola], [Cabeza | RestoDeLista]) :- % recursivo: si no es la cabeza
    Color \= Cabeza, % checamos que sean diferentes
    obtener_color(Color, Cola, RestoDeLista). % recursión buscando en la cola

aciertos_parciales([], _NoExactosPatron, 0). % base: sin no exactos -> 0 mal colocados
aciertos_parciales([X | ColaIntento], NoExactosPatron, TotalMal) :- % recursivo: evaluamos cada color
    ( obtener_color(X, NoExactosPatron, NuevaListaPatron) ->
        aciertos_parciales(ColaIntento, NuevaListaPatron, N_Siguiente), % recursión con lista nueva si sí se obtuvo
        TotalMal is N_Siguiente + 1 % +1 al contador
    ;
        aciertos_parciales(ColaIntento, NoExactosPatron, TotalMal) % recursión con lista original
    ).




