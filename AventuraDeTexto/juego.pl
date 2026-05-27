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

%---- Descripcion de el Cuarto ----
describir(estado(cuarto,Inv,_,_)) :-
    nl, write('--- LOCACIÓN: Tu cuarto, 7:00am ---'), nl,
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

%---- Descripcion de el Pasillo ----
describir(estado(pasillo,Inv,_,_)) :-
    nl, write('--- LOCACIÓN: El pasillo de tu edificio ---'), nl,
    write('Está diferente. El ambiente es sombrío y notas algo raro con las puertas.'), nl,
    (
        \+ miembro(rodrigoHablo, Inv) ->  %Agregamos contexto sobre rodrigo
            write('A lo lejos ves a tu vecino Rodrigo, tiene una cara de pánico.')
        ; 
            write('El pasillo está vacío ahora que Rodrigo bajó corriendo.')
    ), nl.

%---- Descripcion de la Calle ----
describir(estado(calle,Inv,_,_)) :-
    nl, write('--- LOCACIÓN: La calle hacia la Facultad ---'), nl,
    write('Puedes ver un amanecer hermoso. Pero hace mucho frío, algo caliente no te caería mal, o si?'), nl,
    write('A tu derecha hay una tienda abierta.'), nl.

%---- Descripcion de la Tienda ----
describir(estado(tienda,Inv,_,_)) :-
    nl, write('--- LOCACIÓN: La tienda ---'), nl,
    write('Adentro de la tienda esta calientito.'), nl,
    ( 
        \+ miembro(cafeExtra, Inv) ->
        write('La máquina de café está lista para ti.')
        ;
        write('Ya compraste tu café extra, te sientes como nuevo.')
    ), nl.

%---- Descripcion de la Entrada a la Facultad ----
describir(estado(entradaFacultad, _, _, _)) :-
    nl, write('--- LOCACIÓN: Entrada de la Facultad ---'), nl,
    write('Las puertas están abiertas. Puedes ir al lab, la biblioteca o la cafetería.'), nl.

% ---Descripcion de labComputo ----
describir(estado(labComputo, Inv, _, _)) :-
    nl, write('--- LOCACIÓN: Laboratorio de Cómputo ---'), nl,
    (miembro(usb, Inv) ->
        write('Ya tienes el USB. Las pantallas siguen encendidas.')
    ;
        write('Las computadoras están encendidas. Hay un USB olvidado en una de ellas.')
    ), nl.
    
% ---Descripcion de biblioteca ----
describir(estado(biblioteca, _, _, _)) :-
    nl, write('--- LOCACIÓN: Biblioteca ---'), nl,
    write('Silencio sepulcral. Algunos estudiantes repasan apuntes con cara de pánico.'), nl.

% ---Descripcion de cafeteria ----
describir(estado(cafeteria, _, _, _)) :-
    nl, write('--- LOCACIÓN: Cafetería ---'), nl,
    write('Huele a café quemado. Tu equipo está en una mesa al fondo.'), nl.

% --- Descripcion del pasillo de la Facultad ---
describir(estado(pasilloFacultad, _, _, _)) :-
    nl, write('--- LOCACIÓN: Pasillo de la Facultad ---'), nl,
    write('Estás afuera del salón, escuchas murmullos y la puerta está entreabierta.'), nl,
    write('Es el último pasillo antes de entrar a exponer.'), nl.

% --- Descripcion del salón de Vlad ---
describir(estado(salonVlad, Inv, stats(_, E, _), _)) :-
    nl, write('--- LOCACIÓN: Salón de Vlad ---'), nl,
    write('El salón está frío, ves a el buen Vlad hasta en frente sentado revisando su libreta en silencio.'), nl,
    (
        miembro(usb, Inv) -> 
        write('Traes el USB en la bolsa.')
        ;
        write('No traes el USB con las diapositivas.')
    ), nl,
    (
        E >= 2 -> 
        write('Te están sudando las manos por el estrés.')
        ;
        write('Estás bastante chill.')
    ), nl.

% --- Descripcion para el Estado Fin (Evita que el juego colapse al procesar el último turno) ---
describir(estado(fin, _, _, _)) :- !.

% «|» SECCIÓN 4 - acciones disponibles
% lista de acciones en las que se puede hacer desde cada ubicación.
accionesValidas(estado(fin, _, _, _), []) :- !.

accionesValidas(estado(cuarto, Inv, Stats, _), Acciones) :-
    findall(A, accionDisponibleCuarto(Inv, Stats, A), Acciones).
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
accionDisponibleCuarto(Inv, stats(_, E, _), tomarCafe) :-
    miembro(cafe, Inv), E < 3.

% revisar la mochila
accionDisponibleCuarto(Inv, _, revisarMochila) :- 
    \+ miembro(mochilaRevisada, Inv).

% Intento de dormir, solo tiene exito si tienes el sueño bajo
accionDisponibleCuarto(_, stats(S, _, _), intentarDormir) :- 
    S < 2, \+ visitado(durmio).

% Acciones desde el Pasillo
accionesValidas(estado(pasillo, Inv, _, _), Acciones) :-
    findall(A, accionDisponiblePasillo(Inv, A), Acciones).

%Salir a la calle
accionDisponiblePasillo(_, salirCalle).

%Hablar con rodrigo
accionDisponiblePasillo(Inv,hablarConRodrigo) :-
    \+ miembro(rodrigoHablo, Inv).

%Revisar las puertas de los vecinos
accionDisponiblePasillo(Inv,examinarPuertas) :- 
    \+ miembro(papelesVecinos,Inv).

%Acciones disponibles desde la Calle
accionesValidas(estado(calle,Inv,_,_), Acciones) :-
    findall(A, accionDisponibleCalle(Inv, A), Acciones).

%Ir a la facultad
accionDisponibleCalle(_, irAFacultad).

% o ir a la tienda
accionDisponibleCalle(_, entrarATienda).

%Acciones disponibles en la Tienda
accionesValidas(estado(tienda, Inv, stats(_, E, _), _), Acciones) :-
    findall(A, accionDisponibleTienda(Inv, E, A), Acciones).

%Salir del la tienda
accionDisponibleTienda(_, _, salirTienda). 

%Comprar el café extra
accionDisponibleTienda(Inv,E,comprarCafeExtra) :-
    \+ miembro(cafeExtra, Inv),
    E < 3.  %SOlo puedes comprar el café extra si tu estrés es menor a 3

% Acciones entradaFacultad
accionesValidas(estado(entradaFacultad, Inv, _, _), Acciones) :-
    findall(A, accionDisponibleEntrada(Inv, A), Acciones).

accionDisponibleEntrada(_, irAlPasilloFinal).
accionDisponibleEntrada(_, irALabComputo).
accionDisponibleEntrada(_, irABiblioteca).
accionDisponibleEntrada(_, irACafeteria).
accionDisponibleEntrada(Inv, hablarConConserje) :-
    \+ miembro(pistaConserje, Inv).

% Acciones labComputo
accionesValidas(estado(labComputo, Inv, _, _), Acciones) :-
    findall(A, accionDisponibleLab(Inv, A), Acciones).

accionDisponibleLab(_, salirDelLab).
accionDisponibleLab(Inv, tomarUsb) :-
    \+ miembro(usb, Inv).
accionDisponibleLab(Inv, leerPantalla) :-
    \+ miembro(pistaLab, Inv).

% Acciones biblioteca 
accionesValidas(estado(biblioteca, Inv, _, _), Acciones) :-
    findall(A, accionDisponibleBiblioteca(Inv, A), Acciones).

accionDisponibleBiblioteca(_, salirDeBiblioteca).
accionDisponibleBiblioteca(Inv, tomarHojaTrampa) :-
    \+ miembro(hojaTrampa, Inv).
accionDisponibleBiblioteca(_, repasarApuntes).

% Acciones cafeteria 
accionesValidas(estado(cafeteria, Inv, stats(_, E, _), _), Acciones) :-
    findall(A, accionDisponibleCafeteria(Inv, E, A), Acciones).

accionDisponibleCafeteria(_, _, salirDeCafeteria).
accionDisponibleCafeteria(_, _, hablarConEquipo).
accionDisponibleCafeteria(_, _, tomarCafeCafeteria).

% --- Acciones pasillo de la Facultad ---
accionesValidas(estado(pasilloFacultad, Inv, stats(S, E, C), _), Acciones) :-
    findall(A, accionDisponiblePasilloFacultad(Inv, stats(S, E, C), A), Acciones).

accionDisponiblePasilloFacultad(_, _, entrarAlSalon).
accionDisponiblePasilloFacultad(_, _, esperarAfuera) :- 
    \+ visitado(esperoAfuera).


% --- Acciones del salón de Vlad ---
accionesValidas(estado(salonVlad, Inv, stats(S, E, C), _), Acciones) :-
    findall(A, accionDisponibleSalon(Inv, stats(S, E, C), A), Acciones).

accionDisponibleSalon(_, _, iniciarExposicion).

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
    write('[+ Conocimiento] [Pista 1/3 obtenida]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), buscarUsb,
       estado(cuarto, Inv, stats(S, E1, C), T1)) :-
    \+ miembro(usb, Inv),
    E1 is min(4, E + 1),   % sube estrés porque no lo encuentras
    T1 is T + 1,
    write('No está. El estrés sube.'), nl,
    write('[+ Estrés]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), tomarCafe,
       estado(cuarto, Inv, stats(S1, E1, C), T1)) :-
    miembro(cafe, Inv), E < 3,
    S1 is min(3, S + 1),
    E1 is min(4, E + 1),
    T1 is T + 1,
    write('El café te activa. Te tiembla un poco la mano.'), nl,
    write('[+Sueño] [+Estrés]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), intentarDormir, 
       estado(cuarto, Inv, stats(S1, E1, C), T1)) :-
    % dormir te da dos puntos de sueño y te baja el estrés, pero solo lo puedes hcaer una vez
    asserta(visitado(durmio)),  %Checamos si ya durmió
    S1 is min(3, S + 2),
    E1 is max(0, E - 1),
    T1 is T + 1,
    write('Cierras los ojos un momento y te quedas dormido. Al despertar te sientes un poco mejor.'), nl, write('[+ Sueño] [- Estrés]'), nl.

accion(estado(cuarto, Inv, stats(S, E, C), T), revisarMochila, 
       estado(cuarto, [mochilaRevisada | Inv], stats(S, E1, C1), T1)) :-
    % AL revisar la mochila bajas estrés y subes conocimiento, no te quita stats
    E1 is max(0, E - 1),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('Encuentras unos apuntes que habias perdido y los repasas rápido. Esto te relaja un poco.'), nl, write('[- Estrés] [+ Conocimiento]'), nl.

% --- PASILLO ---

accion(estado(pasillo, Inv, Stats, T), salirCalle,
       estado(calle, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Bajas y sales a la calle.'), nl.

accion(estado(pasillo, Inv, stats(S, E, C), T), hablarConRodrigo,
       estado(pasillo, [rodrigoHablo | Inv], stats(S, E1, C), T1)) :-
    % Hablar con rodrigo te da una pista falsa sobre Vlad
    \+ miembro(rodrigoHablo, Inv),
    E1 is min(4, E + 1),
    T1 is T + 1,
    write('"Se dice que Vlad canceló..." Rodrigo se va antes de que preguntes.'), nl,
    write('[+Estrés]'), nl.

accion(estado(pasillo, Inv, stats(S, E, C), T), examinarPuertas, 
       estado(pasillo, [papelesVecinos | Inv], stats(S, E, C1), T1)) :-
    % Examinar las puertas te sube conocimiento, solo se puede hacer una vez
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('Notas que bajo las otras puertas hay papeles idénticos al tuyo. Extraño.'), nl, write('[+ Conocimiento]'), nl.

% --- CALLE ---

accion(estado(calle, Inv, Stats, T), entrarATienda,
       estado(tienda, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Decides ir a la tienda.'), nl.

accion(estado(calle, Inv, Stats, T), irAFacultad,
       estado(entradaFacultad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Ignoras la tienda y caminas viendo el amanecer. Llegas a las puertas de la Facultad.'), nl.

% --- TIENDA ---

accion(estado(tienda, Inv, Stats, T), salirTienda,
       estado(calle, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Sales de la tienda y vuelves a la calle. Sigue haciendo mucho frío.'), nl.

accion(estado(tienda, Inv, stats(S, E, C), T), comprarCafeExtra,
       estado(tienda, [cafeExtra | Inv], stats(S1, E1, C), T1)) :-
    \+ miembro(cafeExtra, Inv),
    E < 3,  %Solo lo puedes comprar si tu estrés es menor a 3
    S1 is min(3, S + 1),  % El café sube el sueño y sube el estrés
    E1 is min(4, E + 1),  
    T1 is T + 1,
    write('Compras un café y te lo tomas casi hirviendo. Te da el boost que necesitabas.'), nl,
    write('[+ Sueño] [+ Estrés]'), nl.

% --- ENTRADA FACULTAD ---

accion(estado(entradaFacultad, Inv, stats(S, E, C), T), hablarConConserje,
       estado(entradaFacultad, [pistaConserje | Inv], stats(S, E, C1), T1)) :-
    \+ miembro(pistaConserje, Inv),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('El conserje te dice que varias personas preguntaron por el lab esta mañana.'), nl,
    write('[+ Conocimiento] [Pista 2/3 obtenida]'), nl.

accion(estado(entradaFacultad, Inv, Stats, T), irALabComputo,
       estado(labComputo, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Entras al laboratorio de cómputo.'), nl.

accion(estado(entradaFacultad, Inv, Stats, T), irABiblioteca,
       estado(biblioteca, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Entras a la biblioteca.'), nl.

accion(estado(entradaFacultad, Inv, Stats, T), irACafeteria,
       estado(cafeteria, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Bajas a la cafetería.'), nl.

accion(estado(entradaFacultad, Inv, Stats, T), irAlPasilloFinal,
       estado(pasilloFacultad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Subes al pasillo donde está el salón de Vlad.'), nl.
    
% --- LAB DE CÓMPUTO ---

accion(estado(labComputo, Inv, stats(S, E, C), T), tomarUsb,
       estado(labComputo, [usb | Inv], stats(S, E, C1), T1)) :-
    \+ miembro(usb, Inv),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('Tomas el USB. Tiene una etiqueta que dice "VLAD-EXPO".'), nl,
    write('[+ Conocimiento] [USB obtenido]'), nl.

accion(estado(labComputo, Inv, stats(S, E, C), T), leerPantalla,
       estado(labComputo, [pistaLab | Inv], stats(S, E, C1), T1)) :-
    \+ miembro(pistaLab, Inv),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('La pantalla muestra un mensaje: "Sesión iniciada: vhernandez@facultad"'), nl,
    write('[+ Conocimiento] [Pista 3/3 obtenida]'), nl.

accion(estado(labComputo, Inv, Stats, T), salirDelLab,
       estado(entradaFacultad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Sales del laboratorio.'), nl.

% --- BIBLIOTECA ---

accion(estado(biblioteca, Inv, stats(S, E, C), T), tomarHojaTrampa,
       estado(biblioteca, [hojaTrampa | Inv], stats(S, E1, C), T1)) :-
    \+ miembro(hojaTrampa, Inv),
    E1 is max(0, E - 1),
    T1 is T + 1,
    write('Doblas la hoja y la guardas. Te sientes un poco mejor... o eso crees.'), nl,
    write('[- Estrés] [hojaTrampa obtenida]'), nl.

accion(estado(biblioteca, Inv, stats(S, E, C), T), repasarApuntes,
       estado(biblioteca, Inv, stats(S, E1, C1), T2)) :-
    E1 is max(0, E - 1),
    C1 is min(3, C + 1),
    T2 is T + 2,          % cuesta 2 turnos según el diseño
    write('Repasas todo. Tu cabeza empieza a ordenarse.'), nl,
    write('[- Estrés] [+ Conocimiento] (2 turnos)'), nl.

accion(estado(biblioteca, Inv, Stats, T), salirDeBiblioteca,
       estado(entradaFacultad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Sales de la biblioteca.'), nl.

% --- CAFETERÍA ---

accion(estado(cafeteria, Inv, stats(S, E, C), T), hablarConEquipo,
       estado(cafeteria, Inv, stats(S, E1, C1), T1)) :-
    E1 is max(0, E - 1),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('Tu equipo te pone al día. Sientes que no estás tan perdido.'), nl,
    write('[- Estrés] [+ Conocimiento]'), nl.

accion(estado(cafeteria, Inv, stats(S, E, C), T), tomarCafeCafeteria,
       estado(cafeteria, Inv, stats(S1, E1, C), T1)) :-
    S1 is min(3, S + 1),
    E1 is min(4, E + 1),
    T1 is T + 1,
    write('El café sabe a rayos pero te despierta.'), nl,
    write('[+ Sueño] [+ Estrés]'), nl.

accion(estado(cafeteria, Inv, Stats, T), salirDeCafeteria,
       estado(entradaFacultad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Sales de la cafetería.'), nl.

% --- PASILLO FACULTAD ---

accion(estado(pasilloFacultad, Inv, stats(S, E, C), T), esperarAfuera,
       estado(pasilloFacultad, Inv, stats(S, E1, C1), T1)) :-
    \+ visitado(esperoAfuera),
    asserta(visitado(esperoAfuera)),
    E1 is max(0, E - 1),
    C1 is min(3, C + 1),
    T1 is T + 1,
    write('Te quedas un momento afuera repasando mentalmente, esto te calma un poco.'), nl,
    write('[- Estrés] [+ Conocimiento]'), nl.

accion(estado(pasilloFacultad, Inv, Stats, T), entrarAlSalon,
       estado(salonVlad, Inv, Stats, T1)) :-
    T1 is T + 1,
    write('Abres la puerta y entras al salón, sabes que tu momento ha llegado.'), nl.

% --- SALÓN DE VLAD ---

accion(estado(salonVlad, Inv, stats(S, E, C), T), iniciarExposicion,
       estado(fin, Inv, stats(S, E, C), T1)) :-
    T1 is T + 1,
    write('Te paras al frente, saludas al buen Vlad y te preparas para lo que viene.'), nl.

% «|» SECCIÓN 6 - condiciones fin juego
% Detectar el final y enseñar qué final mostrar
% fin_juego/2 recibe el estado actual y devuelve el nombre del final que corresponde.
% El orden sí IMPORTA
% Usamos ! al final para decirle q ya no siga buscando

% Final A — Buenas condiciones generales
finJuego(estado(fin, Inv, stats(_, E, C), T), finalA) :-
    miembro(usb, Inv), 
    E < 3, C >= 3, T =< 20, !,
    nl,
    write('=== FINAL A: Al fin descansas ==='), nl,
    write('"Bien hecho." — Vlad cierra su libreta. Al fin puedes dormir y tu proyecto es un éxito.'), nl.

% Final E — Final Secreto
finJuego(estado(fin, Inv, stats(_, E, 2), _), finalE) :-
    miembro(pistaPapel, Inv),
    miembro(pistaConserje, Inv),
    miembro(pistaLab, Inv),
    miembro(usb, Inv),
    E < 4, !,
    nl,
    write('=== FINAL E: La conspiración de Vlad ==='), nl,
    write('Antes de empezar, miras a Vlad. "¿Fuiste tú?", preguntas.'), nl,
    write('Vlad asiente lentamente y sonríe de lado, él dice: "El que se esfuerza con todo, merece llegar con todo."'), nl.

% Final B — Exposición de memoria
finJuego(estado(fin, Inv, stats(_, E, C), _), finalB) :-
    \+ miembro(usb, Inv), 
    E < 4, C >= 2, !,
    nl,
    write('=== FINAL B: Exposición de memoria ==='), nl,
    write('No tienes el USB con las diapositivas, pero tú sabes que todo tu conocimiento te respalda.'), nl,
    write('Expones de memoria, usas un plumón que te presta el buen Vlad y acabas sacando 9.'), nl.

% Final F — Tramposo
finJuego(estado(fin, Inv, stats(_, _, C), _), finalF) :-
    miembro(hojaTrampa, Inv),
    miembro(usb, Inv),
    C < 2, !,
    nl,
    write('=== FINAL F: Tramposin ==='), nl,
    write('Usaste el USB y un acordeón para exponer, pero tú sabes que no te lo mereces, el buen Vlad se da cuenta y te quita puntos.'), nl,
    write('Como todo el semestre hiciste trampa acabas yéndote a final.'), nl.

% Final C — Mal estado
finJuego(estado(fin, _, stats(_, E, C), _), finalC) :-
    E >= 2, C < 2, !,
    nl,
    write('=== FINAL C: ._. ==='), nl,
    write('Llegaste al salón bien estresado por no saber casi nada.'), nl,
    write('Abres la boca y no sale nada. El buen Vlad se ve decepcionado y escribe algo en su libreta.'), nl,
    write('Acabas yéndote a final.'), nl.

% Final D — Sin sueño
finJuego(estado(fin, _, stats(0, _, _), _), finalD) :-
    !,
    nl,
    write('=== FINAL D: Zzzzz ==='), nl,
    write('Te quedas dormido antes de exponer, mientras tú babeas, el buen Vlad ya se fue hace una hora.'), nl,
    write('Acabas yéndote a final.'), nl.

% Final por defecto
finJuego(estado(fin, _, _, _), finalDefault) :-
    !,
    nl, write('=== FIN ==='), nl,
    write('Expusiste ni bien ni mal, pero lo hiciste. ¿O sólo fue un sueño?'), nl.

% «|» SECCIÓN 7 - colapso inesperado
% condiciones que pueden terminar el juego antes
% colapso/1 revisa el estado después de CADA acción.
% En ciclo/1 se llama antes de continuar

% Colapso por Sueño
colapso(estado(Ubi, _, stats(0, _, _), _)) :-
    miembro(Ubi, [calle, entradaFacultad, labComputo, biblioteca, cafeteria, pasilloFacultad]),
    !,
    nl,
    write('*** Tus ojos se cierran solos en la locación: '), write(Ubi), write('. ***'), nl,
    write('=== FINAL D: Zzzzz ==='), nl,
    write('Te quedas dormido a mitad del camino y la expo termina sin ti y te vas a final.'), nl.

% Colapso por Estrés
colapso(estado(Ubi, _, stats(_, 4, _), _)) :-
    miembro(Ubi, [calle, entradaFacultad, labComputo, biblioteca, cafeteria, pasilloFacultad]),
    !,
    nl,
    write('*** El estrés te supera en la locación: '), write(Ubi), write('. ***'), nl,
    write('Sientes que tu corazón se te sale, así que decides ir a la enfermería...'), nl,
    write('No te dan un justificante y acabas yéndote a final.'), nl.

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
