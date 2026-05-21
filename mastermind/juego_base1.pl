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
    format('¡El patrón secreto ha sido generado!~n~n'),
    write('Ingresa tu adivinanza de 5 colores: '), %pedimos input
    read(IntentoJugador), % leemos la lista ingresada y la guardamos en IntentoJugador
    evaluar_jugada(PatronCreado, IntentoJugador). % checamos 



evaluar_jugada(CodigoSecreto, IntentoJugador) :-
    % CALUCULAR ACIERTOS
    % mientras:
    BienColocados = 2,
    MalColocados = 1,

    format('Tienes ~w colores bien colocados.~n', [BienColocados]),
    format('Tienes ~w colores correctos, pero en mal lugar.~n', [MalColocados]).