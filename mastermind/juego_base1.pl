:- use_module(library(random)).

colores_universo([rosa, azul, verde, morado, blanco, negro, plateado, dorado]). % ¿mas colores?...

elegir_color_random(ColorElegido) :-
    colores_universo(Lista),
    length(Lista, Total), % scamos el tamaño
    random(0, Total, IndiceAleatorio), % creamos un índice random entre 0 y 7
    buscar_indice(IndiceAleatorio, Lista, ColorElegido). % sacamos el color que está en ese índice



buscar_indice(0, [X | _Cola], X). % caso base
buscar_indice(N, [_Cabeza | Cola], ElementoEncontrado) :- %recursivo
    N > 0,
    N_Siguiente is N - 1, % -1al índice
    buscar_indice(N_Siguiente, Cola, ElementoEncontrado). % recursión en ña cola



generar_patron(0, []). % base, cero colores -> lista vacía
generar_patron(N, [Color | FinalPatron]) :-
    N > 0,
    elegir_color_random(Color), % sacamos un color
    N_Siguiente is N - 1, % -1 al contador
    generar_patron(N_Siguiente, FinalPatron). %recursión en la cola para demás colores





% menu de ayudaa
help :-
    format('Instrucciones:~n'),
    format('1. Se crará un patrón secreto de 5 colores.~n'),
    format('2. Los colores disponibles son: rosa, azul, verde, morado, blanco, negro, plateado, dorado.~n'),
    format('3. Debes adivinar los colores y sus posiciones exactas escribéndolos tal cual crees que están.~n'),
    format('---------------------------------------------~n~n').


% ¿main?
iniciar :-
    help,  % llamamos a las instrucciones
    generar_patron(5, PatronCreado), % generamos 5 colores
    format('El patrón secreto ha sido generado :) ~n~n'),
    write('Ingresa tu adivinanza de 5 colores: '), %pedimos input
    read(IntentoJugador), % leemos la lista ingresada y la guardamos en IntentoJugador
    checar_intento(PatronCreado, IntentoJugador). % checamos 


% checamos el intento ingresado
checar_intento(PatronCreado, IntentoJugador) :-
    aciertos_exactos(PatronCreado, IntentoJugador, BienColocados, NoExactosPatron, NoExactosIntento), % separamos exactos y no exactos
    aciertos_parciales(NoExactosIntento, NoExactosPatron, MalColocados), % calculamos los mal colocados
    format('~nResultados de tu intento:~n'),
    format('Tienes ~w colores perfectamente colocados.~n', [BienColocados]),
    format('Tienes ~w colores correctos, pero su lugar no es correcto.~n', [MalColocados]),
    format('---------------------------------------------~n~n').









% comparamos la lista de entrada con la que generamos
aciertos_exactos([], [], 0, [], []). % base: listas vacías -> 0 aciertos y 0 no exactos
aciertos_exactos([X | ColaPatron], [X | ColaIntento], TotalBien, NoExactosPatron, NoExactosIntento) :- % recursivo si las cabezas son iguales
    aciertos_exactos(ColaPatron, ColaIntento, N_Siguiente, NoExactosPatron, NoExactosIntento), % recursión en las colas
    TotalBien is N_Siguiente + 1. % +1 al contador de bien colocados

aciertos_exactos([X | ColaPatron], [Y | ColaIntento], TotalBien, [X | NoExactosPatron], [Y | NoExactosIntento]) :- % recursivo si las cabezas son diferentes
    X \= Y, % checamos que sean diferentes
    aciertos_exactos(ColaPatron, ColaIntento, TotalBien, NoExactosPatron, NoExactosIntento). % recursión guardando los no exactos


% checamos el color 
obtener_color(Color, [Color | Cola], Cola). % base: si se encontró en la cabeza, devuelve la cola

obtener_color(Color, [Cabeza | Cola], [Cabeza | RestoDeLista]) :- % recursivo: si no es la cabeza
    Color \= Cabeza, % checamos que sean diferentes
    obtener_color(Color, Cola, RestoDeLista). % recursión buscando en la cola


% checamos los colores que están mal colocados
aciertos_parciales([], _NoExactosPatron, 0). % base: sin no exactos del intento -> 0 mal colocados

aciertos_parciales([X | ColaIntento], NoExactosPatron, TotalMal) :- % recursivo: evaluamos cada color
    ( obtener_color(X, NoExactosPatron, NuevaListaPatron) -> 
        aciertos_parciales(ColaIntento, NuevaListaPatron, N_Siguiente), %si sí se pudo obtener, recursión con la lista nueva
        TotalMal is N_Siguiente + 1 % +1 al contador
        ;
        aciertos_parciales(ColaIntento, NoExactosPatron, TotalMal) % si no se pudo obetener, recursión con la lista original
    ).




