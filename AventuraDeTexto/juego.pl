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


%  Persona 1 — el cuarto y el pasillo
%    - Expandir describir/1 para cuarto y pasillo
%    - Agregar más accionDisponibleCuarto y accionDisponiblePasillo
%    - Agregar más cláusulas accion/3 para esos lugares
%
%  Persona 2 — la facultad: lab, biblioteca, cafetería
%    - Implementar describir/1 para esos lugares
%    - Implementar accionesValidas para esos lugares
%    - Agregar sus accion/3 correspondientes
%
%  Persona 3 — Finales y stats
%    - Ampliar fin_juego/2 con más condiciones y texto
%    - Agregar más colapsos esposibles
%    - Ajustar el balance de los stats si hace falta
%
%  Isaac completará el README y la documentación necesaria pq ya hizo este inicio de todo el código
%

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

% Predicados auxiliares
miembro(X, L) :- member(X, L).
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
       estado(pasillo, [rodrigoHablo | Inv], stats(S, E1, C), T1)) :-
    \+ miembro(rodrigoHablo, Inv),
    E1 is min(3, E + 1),
    T1 is T + 1,
    write('"Se dice que Vlad canceló..." Rodrigo se va antes de que preguntes.'), nl,
    write('[+Estrés]'), nl.



% «|» SECCIÓN 6 - condiciones fin juego
% Detectar el final y enseñar qué final mostrar
% fin_juego/2 recibe el estado actual y devuelve el nombre del final que corresponde.
% El orden sí IMPORTA
% Usamos ! al final para decirle q ya no siga buscando


% final secreto
finJuego(estado(fin, Inv, stats(_, E, C), _), final_secreto) :-
    miembro(pista_papel, Inv),
    miembro(pista_conserje, Inv),
    miembro(pista_lab, Inv),
    miembro(usb, Inv),
    C >= 2, E < 3, !,
    nl,
    write('=== FINAL SECRETO: La conspiración de Vlad ==='), nl,
    write('Antes de empezar, miras a Vlad. "¿Fuiste tú?"'), nl,
    write('Vlad asiente lentamente. "El que no duerme merece llegar con todo."'), nl.

% Final A — buenas condiciones generales
finJuego(estado(fin, Inv, stats(_, E, C), T), final_a) :-
    miembro(usb, Inv), C >= 3, E < 3, T =< 20, !,
    nl,
    write('=== FINAL A: Al fin descasas ==='), nl,
    write('"Bien hecho." — Vlad cierra su libreta. Al fin puedes dormir.'), nl.

% Final C — mal estado
finJuego(estado(fin, _, stats(_, 3, C), _), final_c) :-
    C < 2, !,
    nl,
    write('=== FINAL C: ._. ==='), nl,
    write('Abres la boca. Nada. Vlad escribe algo en su libreta.'), nl.

% Final D — sin sueño
finJuego(estado(fin, _, stats(0, _, _), _), final_d) :-
    !,
    nl,
    write('=== FINAL D: Zzzzz ==='), nl,
    write('Te quedas dormido antes de exponer. Vlad se fue hace una hora.'), nl.

% Final por defecto — siempre tiene éxito, atrapa todo lo demás
finJuego(estado(fin, _, _, _), final_default) :-
    nl,
    write('=== FIN ==='), nl,
    write('Sobreviviste. Casi no, pero lo hiciste. ¿O sólo fue un sueño?'), nl.


% «|» SECCIÓN 7 - colapso inesperado
% condiciones que pueden terminar el juego antes
% colapso/1 revisa el estado después de CADA acción.
% En ciclo/1 se llama antes de continuar

colapso(estado(Ubi, _, stats(0, _, _), _)) :-
    miembro(Ubi, [calle, entradaFacultad, labComputo, cafeteria]),
    nl,
    write('*** Tus ojos se cierran solos en '), write(Ubi), write('. ***'), nl,
    write('Te quedas dormido. La expo termina sin ti.'), nl.



% «|» SECCIÓN 8 - ciclo principal del juego
% ciclo/1 es recursivo:
%      1. Revisa si el juego terminó  -> muestra final y para
%      2. Revisa si hubo colapso -> muestra mensaje y para
%      3. Muestra opciones disponibles
%      4. Lee la acción del jugador con read/1
%      5. La procesa con procesar/3
%      6. Llama a ciclo/1 con el nuevo estado (recursión)
%


jugar :-
    retractall(visitado(_)), % limpia memoria de visitas anteriores
    estadoInicial(E0),
    nl,
    write('=== EL PAPEL MISTERIOSO ==='), nl,
    write('Escribe una acción y termina con punto. Ej: leer_papel.'), nl,
    write('Comandos especiales: estado.  ayuda.  salir.'), nl,
    nl,
    describir(E0),
    ciclo(E0).

% caso 1 - el juego llegó al estado fin → mostrar final
ciclo(Estado) :-
    Estado = estado(fin, _, _, _), !,
    finJuego(Estado, _).

% caso 2 - hubo colapso anticipado -> terminar
ciclo(Estado) :-
    colapso(Estado), !.

% caso 3 - turno normal -> pedir acción
ciclo(Estado) :-
    accionesValidas(Estado, Acciones),
    nl,
    write('¿Qué haces?'), nl,
    forall(miembro(A, Acciones), (write('  > '), write(A), nl)),
    nl,
    read(Entrada),
    procesar(Estado, Entrada, Acciones).



% «|» SECCIÓN 9 - procesador de entrada
% procesar/3 tiene varias cláusulas para comandos especiales
% y para acciones válidas del juego.
% de nuevo usamo ! para cortar y que prolog no siga buscando cuando encontró la correcta

% comando especial: ver estado actual
procesar(Estado, estado, _) :- !,
    Estado = estado(Ubi, Inv, stats(S,E,C), T),
    nl,
    write('--- Estado actual ---'), nl,
    write('Ubicación: '), write(Ubi), nl,
    write('Inventario: '), write(Inv), nl,
    write('Sueño: '), write(S), write('/3'), nl,
    write('Estrés: '), write(E), write('/3'), nl,
    write('Conocimiento: '), write(C), write('/3'), nl,
    write('Turno: '), write(T), nl,
    ciclo(Estado).

% comando especial: ayuda
procesar(Estado, ayuda, Acciones) :- !,
    write('Acciones disponibles:'), nl,
    forall(miembro(A, Acciones), (write('  > '), write(A), nl)),
    ciclo(Estado).

% comando especial: salir del juego
procesar(_, salir, _) :- !,
    write('Adiooos. Ten cuidado con tus pesadillas.'), nl.

% acción válida del juego
procesar(Estado, Accion, Acciones) :-
    miembro(Accion, Acciones),            % está en la lista de opciones
    accion(Estado, Accion, NuevoEstado), % la transición existe
    !,
    describir(NuevoEstado),              % describir el nuevo lugar
    ciclo(NuevoEstado).                  % siguiente turno

% entrada inválida
procesar(Estado, Entrada, _) :-
    write('No puedes hacer eso aquí: '), write(Entrada), nl,
    write('Escribe "ayuda." para ver las opciones.'), nl,
    ciclo(Estado).


% «|» SECCIÓN 10 - predicados para consulta
% auxiliares que sirven para probar el juego

% las usamos así : 
%    ?- estadoInicial(E), movimientosValidos(E, M).
%    ?- estado_inicial(E), accion(E, leerPapel, Nuevo).
%    ?- estadoFinalPrueba(F), finJuego(F, Final).
%    ?- pistasEn([pistaPapel, pistaLab], N).
% ============================================================


% devuelve las acciones disponibles en un estado dado
movimientosValidos(Estado, Movimientos) :-
    accionesValidas(Estado, Movimientos).

% estado de prueba para testear finales directamente
% se usa así : estadoFinalPrueba(E), finJuego(E, F).
estadoFinalPrueba(estado(fin,
    [usb, papelLeido, pistaPapel, pistaConserje, pistaLab],
    stats(1, 1, 3),
    15)).

% cuenta cuántas pistas tiene el jugador
pistasEn(Inv, N) :-
    include([P]>>(miembro(P, [pistaPapel, pistaConserje, pistaLab])),
            Inv, Ps),
    length(Ps, N).
% usamos la lambda para no tener que usar una función auxiliar
% el include toma los elementos de P y checa que P sea miembro de la lista
% osea que checa si P es pistaPapel o pistaConserje o pistaLab, si es alguno lo metemos en Ps
% finalmente checa el número de pistas encontradas (coincidencia de P guardadas en Ps) y nos da el número en N


% Verifica si un estado es un fin de juego
esEstadoFinal(estado(fin, _, _, _)).
