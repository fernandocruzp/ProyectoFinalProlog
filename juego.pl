/** <module> MasterMind - Juego de adivinación de colores en Prolog

Este módulo contiene la implementación interactiva del clásico juego MasterMind
para dos jugadores en consola. El Jugador 1 define una secuencia secreta de 4 colores,
y el Jugador 2 dispone de un máximo de 10 intentos para adivinarla, recibiendo
como pistas el número de colores correctos en la posición correcta (fichas negras)
y de colores correctos en posiciones incorrectas (fichas blancas).

@author Becerra Valencia César
@author Cortes Nava Jose Luis
@license MIT
*/

:- use_module(library(lists)).

% ==========================================
%         LÓGICA DE EVALUACIÓN
% ==========================================

%!  exactas(+Lista1:list, +Lista2:list, -Exactas:integer) is det.
%
%   Compara dos listas elemento por elemento y calcula el número de coincidencias
%   exactas (elementos idénticos en la misma posición relativa). Esto representa
%   las fichas negras en las reglas de MasterMind.
%
%   @param Lista1 Primera lista a comparar (por ejemplo, el patrón secreto).
%   @param Lista2 Segunda lista a comparar (por ejemplo, el intento del jugador).
%   @param Exactas Número de elementos coincidentes en la misma posición.
exactas([], [], 0).
exactas([H|T1], [H|T2], N) :-
    exactas(T1, T2, N1),
    N is N1 + 1.
exactas([H1|T1], [H2|T2], N) :-
    H1 \= H2,
    exactas(T1, T2, N).

%!  comunes(+Lista1:list, +Lista2:list, -Comunes:integer) is det.
%
%   Calcula la cantidad total de elementos comunes entre dos listas,
%   independientemente de su posición, descontando progresivamente los elementos ya
%   emparejados para evitar contar dobles coincidencias de un mismo color.
%
%   @param Lista1 Primera lista (el intento).
%   @param Lista2 Segunda lista (el patrón secreto).
%   @param Comunes Total de elementos que aparecen en ambas listas.
comunes([], _, 0).
comunes([H|T], Secreto, N) :-
    select(H, Secreto, RestoSecreto), !, 
    comunes(T, RestoSecreto, N1),
    N is N1 + 1.
comunes([_|T], Secreto, N) :-
    comunes(T, Secreto, N).

%!  evaluar_intento(+Secreto:list, +Intento:list, -Negras:integer, -Blancas:integer) is det.
%
%   Evalúa una propuesta de combinación (Intento) contra el código secreto (Secreto).
%   Calcula la cantidad de aciertos exactos (fichas Negras) y aciertos de color
%   pero en posición incorrecta (fichas Blancas).
%
%   @param Secreto La lista de 4 colores que representa el código oculto.
%   @param Intento La lista de 4 colores propuesta por el Jugador 2.
%   @param Negras Número de fichas en posición exacta (negras).
%   @param Blancas Número de fichas de color correcto en posición incorrecta (blancas).
evaluar_intento(Secreto, Intento, Negras, Blancas) :-
    exactas(Secreto, Intento, Negras),
    comunes(Intento, Secreto, TotalComunes),
    Blancas is TotalComunes - Negras.


% ==========================================
%         BÚFER Y VALIDACIÓN
% ==========================================

%!  color_valido(+Color:atom) is semidet.
%
%   Verdadero si Color es uno de los colores permitidos por el juego.
%   Los colores permitidos son: rojo, azul, verde, amarillo, naranja y morado.
%
%   @param Color El átomo que representa el color a verificar.
color_valido(Color) :-
    member(Color, [rojo, azul, verde, amarillo, naranja, morado]).

%!  colores_validos(+Lista:list) is semidet.
%
%   Verdadero si todos los elementos dentro de la lista son colores permitidos.
%   Se evalúa de manera recursiva sobre la lista.
%
%   @param Lista La lista de colores a validar.
colores_validos([]).
colores_validos([H|T]) :-
    color_valido(H),
    colores_validos(T).

%!  patron_valido(+Patron:any) is semidet.
%
%   Verdadero si la estructura dada es una lista de exactamente 4 elementos
%   y todos sus elementos son colores válidos.
%
%   @param Patron El término Prolog a evaluar como combinación o secreto.
patron_valido(Patron) :-
    is_list(Patron),
    length(Patron, 4),
    colores_validos(Patron).

%!  pedir_secreto(-Secreto:list) is det.
%
%   Muestra en consola las instrucciones para que el Jugador 1 ingrese la combinación
%   secreta de colores. Lee la entrada del usuario y la valida. Si la entrada es inválida,
%   muestra un mensaje de error e invoca recursivamente al predicado hasta obtener un patrón correcto.
%
%   @param Secreto Retorna el patrón de 4 colores validado e introducido por el Jugador 1.
pedir_secreto(Secreto) :-
    write('Introduce tu patron secreto de 4 colores.'), nl,
    write('Debe estar en formato de lista de Prolog: entre corchetes, separados por comas y terminando con un punto.'), nl,
    write('Ejemplo de formato: [rojo, verde, azul, amarillo].'), nl,
    write('Colores permitidos: rojo, azul, verde, amarillo, naranja, morado.'), nl,
    write('Seleccion: '), nl,
    read(Input),
    (   patron_valido(Input) -> 
        Secreto = Input
    ;   
        write('>>> ERROR: Formato incorrecto o colores invalidos.'), nl,
        write('Asegurate de escribir 4 colores validos entre corchetes y terminar con un punto.'), nl,
        write('Ejemplo: [rojo, verde, azul, amarillo].'), nl, nl,
        pedir_secreto(Secreto)
    ).

%!  pedir_intento(-Intento:list) is det.
%
%   Muestra en consola las instrucciones para que el Jugador 2 proponga un intento de
%   combinación. Lee la entrada de consola y realiza su validación. Si es incorrecta,
%   indica el error e invoca el predicado nuevamente de forma recursiva.
%
%   @param Intento Retorna el patrón de 4 colores validado propuesto por el Jugador 2.
pedir_intento(Intento) :-
    write('JUGADOR 2, introduce tu intento.'), nl,
    write('Usa el formato Prolog: entre corchetes, separados por comas y terminando con punto.'), nl,
    write('Ejemplo: [rojo, azul, verde, amarillo].'), nl,
    write('Intento: '), nl,
    read(Input),
    (   patron_valido(Input) -> 
        Intento = Input
    ;   
        write('>>> ERROR: Formato incorrecto o colores invalidos.'), nl,
        write('Asegurate de usar 4 colores validos (rojo, azul, verde, amarillo, naranja, morado).'), nl,
        write('Recuerda usar corchetes y el punto final, ej: [rojo, verde, azul, amarillo].'), nl, nl,
        pedir_intento(Intento)
    ).

% ==========================================
%     INTERFAZ Y FLUJO DE JUEGO
% ==========================================

%!  iniciar_juego is det.
%
%   Punto de entrada para jugar MasterMind. Presenta las instrucciones en la consola,
%   solicita al Jugador 1 que establezca el código secreto de 4 colores, oculta la pantalla
%   para resguardar el secreto, y finalmente arranca la secuencia de turnos de adivinación
%   del Jugador 2 a partir del primer intento.
iniciar_juego :-
    write('--- BIENVENIDO A MASTERMIND (2 JUGADORES) ---'), nl,
    write('Colores sugeridos: rojo, azul, verde, amarillo, naranja, morado.'), nl,
    nl,
    write('>>> JUGADOR 1: Es tu turno. No dejes que el jugador 2 vea la pantalla. <<<'), nl,
    
    pedir_secreto(Secreto),
    
    ocultar_pantalla(50),
    
    write('Patron guardado y oculto! Tienes un maximo de 10 intentos.'), nl,
    write('>>> JUGADOR 2: Es tu turno. Adivina el patron! <<<'), nl,
    
    jugar(Secreto, 1).

%!  ocultar_pantalla(+Lineas:integer) is det.
%
%   Limpia visualmente la consola imprimiendo la cantidad indicada de saltos de línea,
%   esto con el propósito de ocultar la selección del Jugador 1 para que el Jugador 2
%   no pueda verla al tomar su turno.
%
%   @param Lineas Número de saltos de línea a imprimir.
ocultar_pantalla(0) :- !.
ocultar_pantalla(N) :-
    nl,
    N1 is N - 1,
    ocultar_pantalla(N1).

%!  jugar(+Secreto:list, +IntentoNum:integer) is det.
%
%   Bucle recursivo principal del juego. En cada llamada (intento), le solicita al
%   Jugador 2 una combinación, evalúa las fichas negras y blancas correspondientes,
%   y verifica el estado de la partida:
%   - Si se obtienen 4 negras, se anuncia la victoria y el juego finaliza.
%   - Si el número de intento actual alcanza el límite de 10, se declara GAME OVER
%     y se revela el patrón secreto.
%   - En cualquier otro caso, se incrementa el contador e inicia el siguiente intento recursivamente.
%
%   @param Secreto El código secreto de 4 colores configurado por el Jugador 1.
%   @param IntentoNum Número que representa el intento actual (1 a 10).
jugar(Secreto, IntentoNum) :-
    format('~n--- INTENTO #~w DE 10 ---~n', [IntentoNum]),
    
    pedir_intento(Intento),
    
    evaluar_intento(Secreto, Intento, Negras, Blancas),
    format('Resultados -> Negras (Exactas): ~w | Blancas (Parciales): ~w~n', [Negras, Blancas]),
    
    (Negras =:= 4 ->
        format('Felicidades Jugador 2! Descubriste todos los colores en ~w intentos.~n', [IntentoNum])
    ; IntentoNum =:= 10 ->
        format('~nGAME OVER! Has agotado tus 10 intentos.~n'),
        format('El patron secreto era: ~w~n', [Secreto])
    ;
        SiguienteIntento is IntentoNum + 1,
        jugar(Secreto, SiguienteIntento)
    ).