:- use_module(library(lists)).

% ==========================================
%         LÓGICA DE EVALUACIÓN
% ==========================================

exactas([], [], 0).
exactas([H|T1], [H|T2], N) :-
    exactas(T1, T2, N1),
    N is N1 + 1.
exactas([H1|T1], [H2|T2], N) :-
    H1 \= H2,
    exactas(T1, T2, N).

comunes([], _, 0).
comunes([H|T], Secreto, N) :-
    select(H, Secreto, RestoSecreto), !, 
    comunes(T, RestoSecreto, N1),
    N is N1 + 1.
comunes([_|T], Secreto, N) :-
    comunes(T, Secreto, N).

evaluar_intento(Secreto, Intento, Negras, Blancas) :-
    exactas(Secreto, Intento, Negras),
    comunes(Intento, Secreto, TotalComunes),
    Blancas is TotalComunes - Negras.


% ==========================================
%         BÚFER
% ==========================================

% 1. Definimos el diccionario de colores permitidos
color_valido(Color) :-
    member(Color, [rojo, azul, verde, amarillo, naranja, morado]).

% 2. Verificamos recursivamente que cada elemento de la lista sea un color valido
colores_validos([]).
colores_validos([H|T]) :-
    color_valido(H),
    colores_validos(T).

% 3. Actualizamos la validacion principal para incluir el chequeo de colores
patron_valido(Patron) :-
    is_list(Patron),
    length(Patron, 4),
    colores_validos(Patron).

pedir_secreto(Secreto) :-
    write('Introduce tu patron secreto de 4 colores: '), nl, 
    read(Input),
    (   patron_valido(Input) -> 
        Secreto = Input
    ;   
        write('>>> ERROR: Deben ser 4 colores validos (rojo, azul, verde, amarillo, naranja, morado) en corchetes.'), nl,
        pedir_secreto(Secreto)
    ).

pedir_intento(Intento) :-
    write('JUGADOR 2, Introduce tu intento: '), nl, 
    read(Input),
    (   patron_valido(Input) -> 
        Intento = Input
    ;   
        write('>>> ERROR: Deben ser 4 colores validos (rojo, azul, verde, amarillo, naranja, morado) en corchetes.'), nl,
        pedir_intento(Intento)
    ).

% ==========================================
%     INTERFAZ
% ==========================================

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

ocultar_pantalla(0) :- !.
ocultar_pantalla(N) :-
    nl,
    N1 is N - 1,
    ocultar_pantalla(N1).

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