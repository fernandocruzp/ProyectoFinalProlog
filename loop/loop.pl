% 1. Se define el Tablero: K6
vertice(a). vertice(b). vertice(c). 
vertice(d). vertice(e). vertice(f).

arista(X, Y) :- vertice(X), vertice(Y), X \= Y.

% 2. Se crea la estructura de los estados.

% Definimos los turnos: jugador 1 (j1) y jugador 2 (j2)
turno_valido(j1).
turno_valido(j2).

% Definimos la forma válida de los estados.
estado_valido(estado(Turno, AristasJ1, AristasJ2)) :-
    turno_valido(Turno),
    is_list(AristasJ1),
    is_list(AristasJ2).
    
% Se define una función que muestra las aristas de un jugador en base al estado del juego.
aristas_j(j1, estado(_, AristasJ1, _), AristasJ1).
aristas_j(j2, estado(_, _, AristasJ2), AristasJ2).

% 3. Se definen los movimientos validos.

% Revisamos que una arista no esté en las listas de los jugadores, se revisan las opciones (X,Y) y (Y,X).
arista_ocupada(X, Y, estado(_, AristasJ1, AristasJ2)) :-    
    ( member(edge(X, Y), AristasJ1)
    ; member(edge(Y, X), AristasJ1)
    ; member(edge(X, Y), AristasJ2)
    ; member(edge(Y, X), AristasJ2)
    ).

% movimientoValido:
% Recibe un estado completo, y los vértices X e Y que se quieren unir.
movimientoValido(Estado, X, Y) :-
    estado_valido(Estado),                                 % 1. Valida que el estado actual sea correcto.
    arista(X, Y),                                          % 2. Valida que la arista exista en K6.
    \+ arista_ocupada(X, Y, Estado).                       % 3. Valida doblemente que NO esté ocupada.
    
% 4. Ejecuta los movimientos.

% Función que agrega la arista seleccionada a la lista de aristas del jugador en turno.
ejecutar_movimiento(estado(j1, AristasJ1, AristasJ2), X, Y, estado(j2, [edge(X, Y)|AristasJ1], AristasJ2)) :-
    movimientoValido(estado(j1, AristasJ1, AristasJ2), X, Y).

ejecutar_movimiento(estado(j2, AristasJ1, AristasJ2), X, Y, estado(j1, AristasJ1, [edge(X, Y)|AristasJ2])) :-
    movimientoValido(estado(j2, AristasJ1, AristasJ2), X, Y).
    
% 5. Movimientos posibles.

libres(Estado, X, Y) :-
    estado_valido(Estado),
    arista(X, Y),
    X @< Y,
    \+ arista_ocupada(X, Y, Estado).

% Recopila en una lista todos los movimientos disponibles de un solo golpe (usamos findall para empaquetarlos).
movimientos_validos(Estado, _Jugador, Lista) :-
    findall((X, Y), libres(Estado, X, Y), Lista).

% 6. Condiciones de victoria y derrota.

% Verifica si una arista pertenece a una lista (en cualquier dirección)
arista_en_lista(X, Y, Lista) :-
    ( member(edge(X, Y), Lista)
    ; member(edge(Y, X), Lista)
    ).

% Detecta si las aristas de un jugador forman un triángulo (ciclo de 3 vértices)
tiene_triangulo(Aristas) :-
    is_list(Aristas),
    member(edge(X, Y), Aristas),
    arista_en_lista(Y, Z, Aristas),
    arista_en_lista(X, Z, Aristas),
    X \= Y, Y \= Z, X \= Z.

% Un jugador pierde si formó un triángulo con sus aristas
jugador_pierde(Jugador, Estado) :-
    aristas_j(Jugador, Estado, Aristas),
    tiene_triangulo(Aristas).

% Un jugador gana si el otro formó un triángulo
jugador_gana(j1, Estado) :- jugador_pierde(j2, Estado).
jugador_gana(j2, Estado) :- jugador_pierde(j1, Estado).

% El juego terminó si algún jugador perdió
fin_juego(Estado) :- jugador_pierde(j1, Estado).
fin_juego(Estado) :- jugador_pierde(j2, Estado).

% 7. Visualizacion del tablero.

% Estas son cosas que no vimos en clase pero investigando en la documentación de Prolog usamos: 
% write(X) — imprime X tal cual, sin formato.
% nl — imprime un salto de línea.
% format(Fmt, Args)— imprime con plantilla; Args es una lista de valores.
%   ~w — reemplaza este marcador con el siguiente valor de Args.
%   ~n — salto de línea dentro de la plantilla.

imprimir_tablero(Estado) :-
    Estado = estado(Turno, _, _),
    nl,
    write('=== LOOP  K6 ==='), nl,
    format('Turno: ~w    1=J1  2=J2  .=libre~n~n', [Turno]), % ~w <- Turno
    write('    a  b  c  d  e  f'), nl,
    imprimir_filas([a,b,c,d,e,f], Estado), nl.

imprimir_filas([], _).
imprimir_filas([X|Xs], Estado) :-
    format('~w [ ', [X]),           % ~w <- vértice de la fila (a, b, ...)
    imprimir_celdas(X, [a,b,c,d,e,f], Estado),
    write(']'), nl,
    imprimir_filas(Xs, Estado).

imprimir_celdas(_, [], _).
imprimir_celdas(X, [Y|Ys], Estado) :-
    celda(X, Y, Estado, C),
    format('~w  ', [C]),             % ~w <- símbolo de la celda (-, 1, 2 o .)
    imprimir_celdas(X, Ys, Estado).

% El ! (corte) evita que Prolog siga buscando otras cláusulas una vez que coincide.
celda(X, X, _, '-') :- !.          % diagonal: mismo vértice
celda(X, Y, estado(_, AJ1, _), '1') :-
    ( member(edge(X,Y), AJ1) ; member(edge(Y,X), AJ1) ), !.
celda(X, Y, estado(_, _, AJ2), '2') :-
    ( member(edge(X,Y), AJ2) ; member(edge(Y,X), AJ2) ), !.
celda(_, _, _, '.').                % caso base: celda libre

