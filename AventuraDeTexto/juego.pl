% Guía para realización del juego
% Dentro del archivo decisiones.txt estará la estructura del juego, contemplando la gran mayoria de texto a poner en el juego

% El motivo de la guía es dar especificaciones generales y un panorama para
% poder tener establecidos desde antes de comenzar las caracteristicas del juego.

% Quizás no sean muchas opciones dentro del árbol para completar le juego, pero habrán capas para avanzar.

% Contaremos con 3 stats (propuesta) : descanso, estrés y conocimiento, las tres con la escala de 0 = bajo, 3 = alto. 
%Tenerlo alto es bueno en "descanso" y "conocimiento", es malo tener el estrés alto

% La idea es que dependiendo de nuestros stats (junto a un inventario) podamos acceder a una u otra respuesta, para así poder avanzar tendremos que ir pasando por las opciones.
% Puede que una mala decisión te haga tener demasiado estrés y poco conocimiento, lo cual resulte en llegar a una mala resolución.

% Como el juego no debe tener una dificultad muy pequeña, la idea fue esa (añadir stats e inventario que nos condiciones) 
% para pelearnos con la forma en la que midamos las cosas y lleguemos a diversos escenarios

% NOTAS DE NOMENCLATURA :

% - Se propone camelCase
% - Uso de palabra especial "«|»" para encontrar de manera más sencilla las secciones 

% --------------------------------------------------------------------------------------------

% AVENTURA DE TEXTO
% Lógica Computacional 2026-2.
%
% Para cargar (propongo) : 
%   swipl juego.pl
%   ?- jugar.


% «|» SECCIÓN 1 - Directivas
% con el formato :- dynamic nombre/aridad podemos decir que un predicado 
% puede cambiar en tiempo de ejecución con assert/retract, es para recordar algo entre turnos

:- dynamic visitado/1.
% Especificamente en este caso para ver si un lugar ya fue visitado.


% «|» SECCIÓN 2 - Estado del juego

estadoInicial( estado( cuarto, [cafe,papel],stats(1,1,1), 1 ) ).
% estado inicial es el estado que tiene : 
% - cuarto como ubicación inicial
% - [cafe,papel] como inventario inicial
% - nivel de stats en orden descanso, estrés, conocimiento
% - turno incial, primer turno.


% «|» SECCIÓN 3 - Ubicaciones y descripciones
% secciones para poder poner las descripciones (texto a mostrar)
% describir/1 tendrá el estado completo para que pueda cambiar el texto segun inventario o stats

describir(estado(cuarto,Inv,_,_)) :-
    nl, write('--- LOCALCIÓN : Tu cuarto, 7:00am ---'), nl,
    write('Llevas dos días sin dormir por el proyecto que presentarás. Tienes dolor de estómago por algo que te vendieron en islas.'), nl,
    (
        miembro(papel, Inv) -> 
        write('Hay un papel en el suelo junto a la puerta.')
        ;
        write('Ya leiste el papel. Un escalofrío recorre tu cuerpo.')
    ), nl.


% la idea de cómo añadir lugares es así : 
% describir(estado(nombre, Inv, Stats, _)) :-
%   nl, write('LOCACIÓN : '), nl,
%   write('Descripción del lugar.'), nl.
%
% Podemos hacer un cambio de texto dependiendo de (miembro(algo,Inv) -> write('Si sí está') ; write('Si no está'))


% «|» SECCIÓN 4 - acciones disponibles
% lista de acciones en las que se puede hacer desde cada ubicación.

accionesValidas(estado(cuarto, Inv, stats(_, E, _), _), Acciones) :-
    findall(A, accionDisponibleCuarto(Inv, E, A), Acciones).
% findall, para poder tener todas las opciones dispoinles, para no tener que hacerlo como siempre uno por uno

% Siempre disponible en el cuarto
accionDisponibleCuarto(_,_,salirPasillo).

% Solo si tienes el papel Y no lo has leído
accionDisponibleCuarto(Inv, _, leerPapel) :-
    miembro(papel, Inv),
    \+ miembro(papelLeido, Inv).

% Si el papel leido no está en Inv, entonces \+ hace verdad la proposición, así que pueda continuar y hacer 'leerPapel'
% Si el papel está leido (en Inv) \+ lo niega y falla, así q no puede leer el papel pq ya lo leyó

% Solo si no tienes el USB
accionDisponibleCuarto(Inv, _, buscarUsb) :-
    \+ miembro(usb, Inv).
% buscamosUSB si la usb no está en el inventario

% sólo si el estrés (E de estrés) es menor a 3
accionDisponibleCuarto(Inv, E, tomarCafe) :-
    miembro(cafe, Inv), E < 3.

% # FALTAN

% Acciones desde el pasillo
accionesValidas(estado(pasillo, Inv, _, _), Acciones) :-
    findall(A, accionDisponiblePasillo(Inv, A), Acciones).

accionDisponiblePasillo(_, salirCalle).
accionDisponiblePasillo(Inv, hablarConRodrigo) :-
    \+ miembro(rodrigoHablo, Inv).


% «|» SECCIÓN 5 - TRANSiciones
% define cómo cambia el estado.
%
% accion(EstadoActual, NombreAccion, EstadoNuevo)
%
%    Modificar stats:
%      S1 is min(3, S + 1)  → sube sin pasar de 3
%      E1 is max(0, E - 1)  → baja sin pasar de 0
%    Modificar inventario:
%      [nuevo_objeto | Inv]  → agregar objeto
%      delete(Inv, objeto, Inv2)  → quitar objeto

% --- CUARTO ---

accion(estado(cuarto, Inv, Stats, T), salirPasillo,
       estado(pasillo, Inv, Stats, T1)) :-
    % Solo aumenta el turno, no cambia nada más
    T1 is T + 1,
    write('Sales al pasillo.'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), leerPapel,
       estado(cuarto, [papelLeido, pistaPapel | Inv2], stats(S, E, C1), T1)) :-
    % quitamos 'papel' del inventario y agregamos 'papel_leido' y 'pista_papel'
    miembro(papel, Inv),
    delete(Inv, papel, Inv2),
    C1 is min(3, C + 1),   % sube conocimiento
    T1 is T + 1,
    write('El papel dice: "Ve al lab de cómputo antes de las 8am."'), nl,
    write('[+ Conocimiento]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), buscarUsb,
       estado(cuarto, Inv, stats(S, E1, C), T1)) :-
    \+ miembro(usb, Inv),
    E1 is min(3, E + 1),   % sube estrés porque no lo encuentras
    T1 is T + 1,
    write('No está. El estrés sube.'), nl,
    write('[+ Estrés]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), tomarCafe,
       estado(cuarto, Inv, stats(S1, E1, C), T1)) :-
    miembro(cafe, Inv), E < 3,
    S1 is min(3, S + 1),
    E1 is min(3, E + 1),
    T1 is T + 1,
    write('El café te activa. Te tiembla un poco la mano.'), nl,
    write('[+Sueño] [+Estrés]'), nl.

% --- PASILLO ---

accion(estado(pasillo, Inv, Stats, T), salirCalle,
       estado(calle, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Bajas y sales a la calle.'), nl.

accion(estado(pasillo, Inv, stats(S, E, C), T), hablarConRodrigo,
       estado(pasillo, [rodrigo_hablo | Inv], stats(S, E1, C), T1)) :-
    \+ member(rodrigoHablo, Inv),
    E1 is min(3, E + 1),
    T1 is T + 1,
    write('"Se dice que Vlad canceló..." Rodrigo se va antes de que preguntes.'), nl,
    write('[+Estrés]'), nl.
