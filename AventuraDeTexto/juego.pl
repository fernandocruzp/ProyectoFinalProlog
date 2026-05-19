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


% «|» SECCIÓN 3 - acciones disponibles
% lista de acciones en las que se puede hacer desde cada ubicación.