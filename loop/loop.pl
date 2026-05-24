% 1. Se define el Tablero: K6

vertice(a).
vertice(b). 
vertice(c). 
vertice(d). 
vertice(e). 
vertice(f).

arista(X, Y) :- vertice(X), vertice(Y), X \= Y.

% 2. Se crea la estructura de los estados.

% Definimos los turnos: jugador 1 (j1) y jugador 2 (j2)
turno_valido(j1).
turno_valido(j2).

% Definimos la forma valida de los estados.
estado_valido(estado(Turno, AristasJ1, AristasJ2)) :-
    turno_valido(Turno),
    is_list(AristasJ1),
    is_list(AristasJ2).
    
% Se define una funcion que muestra las aristas de un jugador en base al estado del juego.
aristas_j(j1, estado(_, AristasJ1, _), AristasJ1).
aristas_j(j2, estado(_, _, AristasJ2), AristasJ2).

% 3. Se definen los movimientos validos.

% Revisamos que una arisra no este en las listas de los jugadores, se revisa las opciones (X,Y) y (Y,X).

arista_ocupada(X, Y, estado(_, AristasJ1, AristasJ2)) :-    
    ( member(edge(X, Y), AristasJ1)
    ; member(edge(Y, X), AristasJ1)
    ; member(edge(X, Y), AristasJ2)
    ; member(edge(Y, X), AristasJ2)
    ).

% movimientoValido:
% Recibe un estado completo, y los vértices X e Y que se quieren unir.
movimientoValido(Estado, X, Y) :-
    estado_valido(Estado),                         % 1. Valida que el estado actual sea correcto.
    arista(X, Y),                                  % 2. Valida que la arista exista en K6.
    \+ arista_ocupada(X, Y, Estado).               % 3. Valida doblemente que NO esté ocupada.
    
% 4. Se define una funcion que genere el estado actual del tablero. Ejecuta los movimientos.

% Funcion para cambiar de turno de forma alterna
siguiente_turno(j1, j2).
siguiente_turno(j2, j1).

%Funcion que agrega la arista seleccionada a la lista de aristas del jugador en turno.
ejecutar_movimiento(estado(j1, AristasJ1, AristasJ2), X, Y, estado(j2, [edge(X, Y)|AristasJ1], AristasJ2)) :-
    movimientoValido(estado(j1, AristasJ1, AristasJ2), X, Y).

ejecutar_movimiento(estado(j2, AristasJ1, AristasJ2), X, Y, estado(j1, AristasJ1, [edge(X, Y)|AristasJ2])) :-
    movimientoValido(estado(j2, AristasJ1, AristasJ2), X, Y).
    
% 5. Funcion que muestra movimientos positbles.
libres(Estado, X, Y) :-
    estado_valido(Estado),
    arista(X, Y),
    X @< Y,                             
    \+ arista_ocupada(X, Y, Estado).
