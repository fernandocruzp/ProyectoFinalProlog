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