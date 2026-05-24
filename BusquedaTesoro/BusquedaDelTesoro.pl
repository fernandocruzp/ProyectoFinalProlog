% Libreria para generar numeros aleatorios
:- use_module(library(random)).

/*
 Definición de hechos dinamicos para el estado del juego
 */
    :- dynamic jugador_pos/1. % Almacena la posición actual del jugador
    :- dynamic inventario/1. % Almacena los objetos que el jugador ha recogido
    :- dynamic objeto_en/2. % Almacena la ubicación de los objetos en el mapa
    :- dynamic tesoro_en/1. % Almacena la ubicación del tesoro
    :- dynamic pista_descartada/1. % Almacena las ubicaciones descartadas
    :- dynamic chocolate_protegido/0. % Indica si el chocolate casero esta protegiendo al jugador en la batalla final
    :- dynamic inteligencia_maxima/0. % Indica si el jugador obtuvo inteligencia maxima
/*
 Hechos de la ubicación de los lugares en base a las 
 coordenadas (x, y) de la cuadricula presentada en el instructivo
 */
    lugar(biblioteca, 24, 21).
    lugar(laboratorio_simbolicos, 21, 9).
    lugar(crujipollo, 17, 21).
    lugar(mesas_ajedrez, 19, 22).
    lugar(tacos_pastor, 17, 15).
    lugar(oficina_onid, 1, 20).
    lugar(aula_t, 25, 3).
    lugar(gemela, 7, 10).
    lugar(media_luna, 1, 6).
    lugar(canchas, 15, 4).
    lugar(darwin, 17, 7).
    lugar(papeleria, 4, 22).
    lugar(comida_asiatica, 21, 16).
    lugar(auditorio, 4, 13).
    lugar(invernadero, 18, 18).
    lugar(bicicletas, 16, 13).
    lugar(motos, 18, 2).
    lugar(tlalticpac, 7, 4).
    lugar(pulpo, 13, 19).
    lugar(fuente, 19, 21).

/*
 Texto de victoria y final del juego
*/
    % 20 frases aleatorias que se imprimen al ganar.
    lista_frases([
        "Quien mucho abarca, poco aprieta.",
        "Gallo que no canta, algo tiene en la garganta.",
        "El que hambre tiene, en pan piensa.",
        "Si lo que vas a decir no es más bello que el silencio, no lo digas.",
        "La inactividad sexual es peligrosa... ¡produce cuernos!.",
        "En boca mentirosa, lo cierto se hace dudoso.",
        "A falta de polla, pan y cebolla.",
        "Si sabes porque te enamoraste, no estás enamorado.",
        "El conocimiento habla, pero la sabiduria escucha.",
        "El que pregunta es un tonto por cinco minutos, pero el que no pregunta es un tonto para siempre.",
        "Si lloras por haber perdido el sol, las lagrimas no te dejarán ver las estrellas.",
        "Amar y querer no es igual, amar es sufrir, querer es gozar.",
        "El ayer es historia, el mañana es un misterio pero el hoy es un obsequio, por eso se llama presente.",
        "La belleza de las cosas existe en la mente que las contempla",
        "Hasta la consulta mas profunda empieza con un simple hecho.",
        "Aprender es como remar contra corriente, en cuanto se deja, se retrocede.",
        "Una lista vacia es solo el comienzo de algo sumamente grande.",
        "Valiente no es aquel que no tiene miedo, sino aquel que sabe conquistarlo.",
        "La vida está llena de altibajos, pero a la larga te acostumbras",
        "01011000 01101001 01101101 01100101 01101110 01100001 00100000 01110110 01110101 01100101 01101100 01110110 01100101 00100000 01110000 01101111 01110010 00100000 01100110 01100001 01110110 01101111 01110010 00100000 01110100 01100101 00100000 01100101 01111000 01110100 01110010 01100001 11000011 10110001 01101111"
    ]).

/*
 Comandos para iniciar el juego, mostrar los lugares, usar objetos, y salir del juego
*/
    % Permite al jugador usar un objeto de su inventario, si lo tiene, y muestra un mensaje indicando que se ha usado el objeto. Si el jugador no tiene el objeto, muestra un mensaje de error.
    usar(Objeto) :-
        inventario(Objeto), % Verifica si el objeto esta en el inventario del jugador
        nl,
        write("Usaste: "), write(Objeto), nl.

    % Mensaje de error si el jugador intenta usar un objeto que no tiene en su inventario
    usar(_) :-
        nl,
        write("No tienes ese objeto."), nl.

    % Permite al jugador ver la lista de lugares disponibles en el mapa, mostrando un mensaje de encabezado y luego iterando sobre la lista de lugares para imprimir cada uno de ellos. Si el jugador no ingresa un comando válido, muestra un mensaje de error.
    lugares :- 
        mostrar_lugares.

    % Mensaje de error si el jugador ingresa un comando que no coincide con ninguno de los comandos disponibles
    salir :-
        nl,
        write("Gracias por jugar."), nl,
        halt.

    % Mensaje de error si el jugador ingresa un comando que no coincide con ninguno de los comandos disponibles
    mostrar_lugares :-
        nl,
        write("Ubicaciones Disponibles:"), nl,
        % Imprime la lista de lugares
        forall(
            lugar(Nombre, _, _), % Itera sobre cada lugar definido en el juego
            (write("- "), write(Nombre), nl) % Imprime el nombre de cada lugar
        ), nl.

    ayuda :-
        nl,
        write("COMANDOS: "), nl,
        write("lugares.           -> Ver lugares"), nl,
        write("ir(Lugar).         -> Viajar"), nl,
        write("estado.            -> Ver estado"), nl,
        write("inventario_j.      -> Ver inventario"), nl,
        write("hablar(Persona).   -> Interactuar"), nl,
        write("buscar.            -> Buscar tesoro"), nl,
        write("usar(Objeto).      -> Usar objeto"), nl,
        write("ayuda.             -> Mostrar ayuda"), nl,
        write("salir.             -> Salir del juego"), nl,
        nl.

    % Borra todo para volver a iniciar
    limpiar_estado :-
        retractall(jugador_pos(_)), % Elimina la posición del jugador
        retractall(inventario(_)), % Elimina los objetos del inventario
        retractall(objeto_en(_, _)), % Elimina la ubicación de los objetos
        retractall(tesoro_en(_)), % Elimina la ubicación del tesoro
        retractall(pista_descartada(_)), % Elimina las pistas descartadas
        retractall(chocolate_protegido), % Elimina el estado de protección del chocolate
        retractall(inteligencia_maxima), % Elimina el estado de inteligencia maxima
        retractall(odin_activo). % Elimina el estado de Odin activo


    % Inicializa, restaura los estados del juego y presenta la introducción al jugador
    iniciar :-
        limpiar_estado, 
        inicializar_objetos, % distribuye objetos aleatoriamente por el mapa
        inicializar_tesoro, % esconde el tesoro aleatoriamente
        assertz(jugador_pos(media_luna)), % Pone al jugador en el lugar incial
        nl, 
        % Mensaje de incio del juego
        write("=========================================="), nl,
        write(" Búsqueda del tesoro"), nl,
        write("=========================================="), nl,
        nl,
        write("Después de muchos obstaculos descubriste el mapa de Midivlar... "), nl,
        write("Tras desifrarlo te dirigiste a la Facultad de Ciencias para "), nl,
        write("tener la sabiduría de las Mentitas sagradas."), nl,
        ayuda, % Muestra los comandos disponibles al iniciar el juego
        estado. % Muestra el estado actual del jugador

/*
 Lógica para moverse entre los diferentes lugares del mapa, 
*/
    ir(Lugar) :-
        lugar(Lugar, _, _), % Verifica que el lugar exista
        retract(jugador_pos(_)), % Elimina la posición actual del jugador
        assertz(jugador_pos(Lugar)), % Actualiza la posición del jugador al nuevo lugar
        estado,
        verificar_tesoro.
    % Imprime mensaje de error si el lugar no coincide con ninguno de los lugares disponibles
    ir(_) :-
        nl,
        write("Ese lugar no existe."), nl.

/*
  Lógica para esconder el tesoro en una de las 20 ubicaciones
*/
    inicializar_tesoro :-
        findall(L, lugar(L, _, _), Lugares),
        random_member(Lugar, Lugares),
        assertz(tesoro_en(Lugar)).

/*
 Lógica para buscar el tesoro en la ubicación actual 
*/
buscar :-
    jugador_pos(Pos), % Obtiene la posición actual del jugador
    tesoro_en(Pos), % Verifica si el tesoro esta en la ubicación actual del jugador
    nl,
    % Imprime el mensaje de que el tesoro fue encontrado
    write("HAS ENCONTRADO EL COFRE!"), nl,
    write("El fantasma de Midivlar aparece..."), nl,
    batalla_final. % Inicia la batalla final

buscar :-
    % Imprime el mensaje de que el tesoro no esta en la ubicación actual del jugador
    nl,
    write("No encuentras nada sospechoso aqui."), nl.

verificar_tesoro :-
    jugador_pos(Pos), % Obtiene la posición actual del jugador
    tesoro_en(Pos), % Verifica si el tesoro esta en la ubicación actual del jugador
    nl,
    % Imprime el mensaje que indica que el jugador esta en la ubicación del tesoro.
    write("Sientes una presencia extrana..."), nl,
    !.

verificar_tesoro.