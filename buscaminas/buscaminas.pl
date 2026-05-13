% Implementacion del juego Buscaminas en Prolog
% Logica Computacional 2026-2
% Integrantes:
%   Ochoa Campos Ana Sofia
%   Real Araiza Yamile
%   Resendiz Linares Karen
%   Sanchez Ortiz Diego

% La idea del juego es representar el tablero como una lista de casillas
% cada casilla guarda su posicion y si esta cerrada, abierta o tiene mina
% casilla(X, Y, Estado)  donde Estado = cerrada | abierta | mina

% Tablero 8x8, las minas estan fijas
%    ___ ___ ___ ___ ___ ___ ___ ___
% 8 |___|___|_m_|___|___|___|_m_|___|
% 7 |___|___|_m_|___|___|___|_m_|___|
% 6 |___|_m_|___|___|___|_m_|___|___|
% 5 |___|___|_m_|___|___|_m_|___|___|
% 4 |___|_m_|___|_m_|_m_|___|_m_|___|
% 3 |_m_|___|___|___|_m_|___|___|_m_|
% 2 |___|___|_m_|___|_m_|___|___|___|
% 1 |___|_m_|___|_m_|___|___|___|___|
%     1   2   3   4   5   6   7   8

% Definimos las casillas donde hay una mina con la función mina(X, Y)
mina(2, 1).
mina(4, 1).
mina(3, 2).
mina(5, 2).
mina(1, 3).
mina(5, 3).
mina(8, 3).
mina(2, 4).
mina(4, 4).
mina(5, 4).
mina(7, 4).
mina(3, 5).
mina(6, 5).
mina(2, 6).
mina(6, 6).
mina(3, 7).
mina(7, 7).
mina(3, 8).
mina(7, 8).

% en_tablero(X, Y) - nos dice si la casilla existe dentro del tablero
% los indices van de 1 a 8 en ambos ejes

en_tablero(X, Y) :-
    X >= 1, X =< 8,
    Y >= 1, Y =< 8.

% ----------------------------------------------------------
% Tablero inicial
% genera la lista con todas las casillas en estado cerrada
% usamos recursion igual que en clase con las listas
% ----------------------------------------------------------

tablero_inicial(Tablero) :-
    generar_casillas(1, 1, Tablero).

% caso base: ya pasamos la fila 8, terminamos
generar_casillas(_, 9, []) :- !.

% cuando X llega a 9 pasamos a la siguiente fila
generar_casillas(9, Y, Lista) :-
    !,
    Y1 is Y + 1,
    generar_casillas(1, Y1, Lista).

% caso recursivo: agregamos la casilla (X,Y) cerrada y seguimos
generar_casillas(X, Y, [casilla(X, Y, cerrada) | Resto]) :-
    X1 is X + 1,
    generar_casillas(X1, Y, Resto).

% ----------------------------------------------------------
% buscar_casilla(Tablero, X, Y, Estado)
% recorre la lista hasta encontrar la casilla (X,Y)
% ----------------------------------------------------------

buscar_casilla([casilla(X, Y, Estado) | _], X, Y, Estado) :- !.
buscar_casilla([_ | Resto], X, Y, Estado) :-
    buscar_casilla(Resto, X, Y, Estado).

% ----------------------------------------------------------
% reemplazar_casilla(Tablero, X, Y, NuevoEstado, NuevoTablero)
% devuelve un tablero nuevo con el estado de (X,Y) cambiado
% ya que no modifica el original, regresa una lista nueva
% esto es como el patron que vimos para modificar listas
% ----------------------------------------------------------

reemplazar_casilla([], _, _, _, []).
reemplazar_casilla([casilla(X, Y, _) | Resto], X, Y, Nuevo,
                  [casilla(X, Y, Nuevo) | Resto]) :- !.
reemplazar_casilla([C | Resto], X, Y, Nuevo, [C | RestoNuevo]) :-
    reemplazar_casilla(Resto, X, Y, Nuevo, RestoNuevo).

% ----------------------------------------------------------
% minas_adyacentes(X, Y, N)
% cuenta cuantas minas hay alrededor de la casilla (X, Y)
%
% los 8 vecinos los ponemos como hechos, ya que son datos fijos que Prolog consulta
% direccion(DX, DY) es cada uno de los 8 vecinos posibles
% ----------------------------------------------------------

direccion(-1, -1).
direccion(-1,  0).
direccion(-1,  1).
direccion( 0, -1).
direccion( 0,  1).
direccion( 1, -1).
direccion( 1,  0).
direccion( 1,  1).

% vecino_mina(X, Y, VX, VY), verdadero si (VX,VY) es vecino de (X,Y) y tiene mina
% combinamos dos hechos: direccion y mina

vecino_mina(X, Y, VX, VY) :-
    direccion(DX, DY),
    VX is X + DX,
    VY is Y + DY,
    en_tablero(VX, VY),
    mina(VX, VY).

% para contar usamos una lista auxiliar con los vecinos que tienen mina
% y luego contamos esa lista, igual que en clase contamos elementos
% primero juntamos todos los vecinos con mina en una lista

vecinos_con_mina(X, Y, Lista) :-
    vecinos_con_mina_aux(X, Y,
        [ (-1,-1), (-1,0), (-1,1),
          (0,-1),           (0,1),
          (1,-1),  (1,0),  (1,1) ],
        Lista).

% caso base: lista de direcciones vacia, no hay mas vecinos que revisar

vecinos_con_mina_aux(_, _, [], []).

% si el vecino en esa direccion tiene mina, lo agregamos a la lista

vecinos_con_mina_aux(X, Y, [(DX,DY) | Resto], [VX-VY | Lista]) :-
    VX is X + DX,
    VY is Y + DY,
    en_tablero(VX, VY),
    mina(VX, VY),
    !,
    vecinos_con_mina_aux(X, Y, Resto, Lista).

% si no tiene mina, solo seguimos con el resto

vecinos_con_mina_aux(X, Y, [_ | Resto], Lista) :-
    vecinos_con_mina_aux(X, Y, Resto, Lista).

% longitud de la lista 

longitud([], 0).
longitud([_ | Resto], N) :-
    longitud(Resto, N1),
    N is N1 + 1.

% minas_adyacentes(X, Y, N): juntamos vecinos con mina y contamos

minas_adyacentes(X, Y, N) :-
    vecinos_con_mina(X, Y, Lista),
    longitud(Lista, N).

% ----------------------------------------------------------
% es_vacia(X, Y)
% una casilla es vacia cuando no tiene mina y ademas
% ninguno de sus vecinos tiene mina (N = 0)
% ----------------------------------------------------------

es_vacia(X, Y) :-
    en_tablero(X, Y),
    \+ mina(X, Y),
    minas_adyacentes(X, Y, 0).

