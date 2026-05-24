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

/*
 Cálculo para la distancia entre los lugares
*/
    % Usa la fórmula de distancia Manhattan para calcular la distancia entre dos lugares de la cuadricula del mapa
    distancia(A, B, D) :-
        lugar(A, X1, Y1),
        lugar(B, X2, Y2),
        DX is abs(X1 - X2),
        DY is abs(Y1 - Y2),
        D is DX + DY.

/*
 Lógica para las pistas de temperatura basadas en la distancia 
 entre el jugador y el tesoro, basandose en diferentes rangos  
 de distancia
*/
    temperatura_actual :-
        jugador_pos(Pos), % Obtiene la posición actual del jugador
        tesoro_en(Tesoro), % Obtiene la posición del tesoro
        distancia(Pos, Tesoro, D), % Calcula la distancia entre el jugador y el tesoro
        write("Pista: "),
        pista_temperatura(D), nl.

    % Si la distancia es menor a dos cuadros imprime la pista HIRVIENDO
    pista_temperatura(D) :-
        D =< 2,
        write("HIRVIENDO").

    % Si la distancia es entre 3 y 5 cuadros imprime la pista CALIENTE
    pista_temperatura(D) :-
        D >= 3,
        D =< 5,
        write("CALIENTE").

    % Si la distancia es entre 6 y 8 cuadros imprime la pista TIBIO
    pista_temperatura(D) :-
        D >= 6,
        D =< 8,
        write("TIBIO").

    % Si la distancia es entre 9 y 13 cuadros imprime la pista FRIO
    pista_temperatura(D) :-
        D >= 9,
        D =< 13,
        write("FRIO").

    % Si la distancia es mayor a 13 cuadros imprime la pista HELADO
    pista_temperatura(D) :-
        D >= 14,
        write("HELADO").

/*
 Lógica para mostrar el inventario del jugador
 */
    inventario_j :-
        nl,
        write(" INVENTARIO "), nl,
        (
            inventario(_) % Verifica si el inventario no esta vacio
        ->
            forall(
                inventario(X), % Itera sobre cada objeto en el inventario
                (write('- '), write(X), nl) % Imprime cada objeto del inventario
            )
        ;
            write("Inventario vacio."), nl % Mensaje que se muestra si el inventario esta vacio
        ), nl.

/*
 Lista de todos los objetos disponibles en el juego
 */
    lista_objetos([
        coca_cola,
        chocolate_casero,
        plumon,
        control_proyector
    ]).

/*
 Lógica para colocar los obejtos aleatoriamente en los lugares 
 del mapa al iniciar el juego.
*/
    inicializar_objetos :-
        lista_objetos(Objetos), % Obtiene la lista de objetos disponibles
        % Coloca cada objeto en un lugar aleatorio del mapa
        forall(
            member(Obj, Objetos), % Itera sobre cada objeto en la lista
            colocar_objeto(Obj) % Coloca el objeto en un lugar aleatorio del mapa
        ).

    colocar_objeto(Objeto) :-
        findall(L, lugar(L, _, _), Lugares), % Obtiene la lista de lugares disponibles
        random_member(Lugar, Lugares), % Selecciona un lugar aleatorio de la lista
        assertz(objeto_en(Objeto, Lugar)). % Asocia el objeto con el lugar seleccionado

/*
 Lógica para revisar si hay objetos en la ubicación actual del jugador
 y añadirlos al inventario
*/
    revisar_objetos :-
        jugador_pos(Pos), % Obtiene la posición actual del jugador
        objeto_en(Objeto, Pos), % Verifica si hay un objeto en la ubicación actual del jugador
        nl,
        % Imprime el mensaje que indica que se halló un objeto
        write('Encontraste el objeto: '), write(Objeto), nl,
        recoger_objeto(Objeto), % Recoge el objeto encontrado y lo añade al inventario
        fail.

    revisar_objetos.

    recoger_objeto(Objeto) :-
        retract(objeto_en(Objeto, _)), % Elimina la posición del objeto en el mapa
        assertz(inventario(Objeto)), % Añade el objeto al inventario del jugador
        % Imprime el mensaje que indica que el objeto se ha añadido al inventario
        write("Se agrego al inventario."), nl,
        evento_especial(Objeto). % Verifica si el objeto tiene un evento especial asociado y lo ejecuta


/*
 Muestra el estado actual del jugador, incluyendo su ubicación, 
 temperatura, objetos encontrados y personajes presentes.
*/
    estado :-
        jugador_pos(Pos), % Obtiene la posición actual del jugador
        nl,
        % Imprime el mensaje con la ubicación actual del jugador
        write("ESTADO"), nl,
        write("Ubicacion actual: "), write(Pos), nl,
        temperatura_actual, % Muestra la pista de temperatura basada en la distancia al tesoro
        revisar_objetos, % Muestra los objetos encontrados en la ubicación actual
        revisar_personajes, % Muestra los personajes presentes en la ubicación actual
        nl.

/*
 Lógica para la ubicación de los personajes
*/
    % Verifica que el jugador esta en la oficina de Onid e imprime el que Onid está ahi
    revisar_personajes :-
        jugador_pos(oficina_onid), 
        nl,
        write("Onid está planeando su semana..."), nl,
        !.

    % Verifica que el jugador esta en el aula t e imprime que Amoni está ahi    
    revisar_personajes :-
        jugador_pos(aula_t),
        nl,
        write("Amoni busca en su bolso algo..."), nl,
        !.

    % Verifica que el jugador esta en el laboratorio de simbolicos e imprime que Nanfredo está ahi
    revisar_personajes :-
        jugador_pos(laboratorio_simbolicos),
        nl,
        write("Nanfredo esta dando su clase ..."), nl,
        !.

    % Verifica que el jugador esta en el crujipollo e imprime que unos estudiantes están ahi
    revisar_personajes :-
        jugador_pos(crujipollo),
        nl,
        write("Unos amigables estudiantes estan haciendo fila..."), nl,
        !.

    revisar_personajes.

/*
  Lógica para interactuar con los personajes
*/
    % Si el jugador tiene una Coca-Cola en su inventario, puede darsela a Onid para que revele la ubicacion del tesoro
    hablar(onid) :-
        jugador_pos(oficina_onid),
        (
            inventario(coca_cola)
        ->
            retract(inventario(coca_cola)), % Elimina la Coca-Cola del inventario del jugador
            nl,
            write('Le das una Coca-Cola a Onid...'), nl,
            random(1, 101, R),
            (
                R =< 35 % Onid tiene un 35% de probabilidad de descifrar el mapa completamente
            ->
                tesoro_en(L),
                write("Onid desifró el resto del mapa!"), nl,
                write("El cofre esta en: "), write(L), nl
            ;
                write("Onid reflexiona profundamente..."), nl,
                write("Pero no logró descrifrar el resto del mapa."), nl
            )
            ;
                write("Onid quiere una Coca-Cola, para refrescarse y descifrar el mapa."), nl

        ).

    hablar(amoni) :-
        % Si el jugador tiene un plumon en su inventario, Amoni puede usarlo para descartar dos ubicaciones donde no esta el tesoro
        jugador_pos(aula_t),
        (
            inventario(plumon)
        ->
            retract(inventario(plumon)), % Elimina el plumon del inventario del jugador
            nl,
            write("Amoni usa el plumon y dibuja un mapa."), nl,
            descartar_ubicaciones
        ;
            write("Necesita un plumon, para mostrarte donde ya han buscado otros el tesoro"), nl
        ).

    hablar(nanfredo) :-
        % Si el jugador tiene el control del proyector en su inventario, Nanfredo puede usarlo para facilitar los acertijos de la batalla final
        jugador_pos(laboratorio_simbolicos),
        (
            inventario(control_proyector)
        ->
            retract(inventario(control_proyector)), % Elimina el control del proyector del inventario del jugador
            nl,
            write("Nanfredo logra encender el proyector y mejorar la calidad de la clase."), nl,
            write("Tu IQ aumentó de golpe!."), nl,
            assertz(inteligencia_maxima)
        ;
            write("Necesita el control del proyector para que se te faciliten los acertijos..."), nl
        ).

    hablar(estudiantes) :-
        % Si el jugador tiene una Coca-Cola en su inventario, puede darsela a los estudiantes para obtener el pato de hule
        jugador_pos(crujipollo),
        (
            inventario(coca_cola)
        ->
            retract(inventario(coca_cola)), % Elimina la Coca-Cola del inventario del jugador
            nl,
            write("Los estudiantes aceptan tu Coca-Cola."), nl,
            write("Te entregan un pato de hule."), nl,
            assertz(inventario(pato_hule))
        ;
            write("te proponen un intercambio... "), nl,
            write("un refresco por un objeto misterioso"), nl
        ).

    hablar(_) :-
        nl,
        write("No puedes hablar con nadie aqui."), nl.

/*
 Lógica para las habilidades de Amoni
*/
    descartar_ubicaciones :-
        tesoro_en(Tesoro), % Obtiene la ubicación del tesoro
        findall(L,
            (
                lugar(L, _, _), % Obtiene la lista de lugares disponibles
                L \= Tesoro % Filtra la lista para excluir la ubicación del tesoro
            ),
            Lista % Genera una lista de lugares descartando la ubicación del tesoro
        ),
        random_member(A, Lista), % Selecciona una ubicación aleatoria de la lista de lugares descartados
        random_member(B, Lista), % Selecciona otra ubicación aleatoria de la lista de lugares descartados
        A \= B, % Asegura que las dos ubicaciones seleccionadas sean diferentes
        assertz(pista_descartada(A)), % Añade la primera ubicación descartada al estado del juego
        assertz(pista_descartada(B)), % Añade la segunda ubicación descartada al estado del juego
        % Imprime los lugares descartados
        write("Amoni revela que el tesoro NO esta en:"), nl,
        write('- '), write(A), nl,
        write('- '), write(B), nl.

/*
 Lógica para la habilidad de Nandredo y preguntas para la batalla final
*/
    % Habilidad de Nanfredo
    pregunta_1 :-
        inteligencia_maxima, % Verifica si el jugador obtuvo inteligencia maxima al hablar con Nanfredo
        !,
        nl,
        write("Pregunta 1: P => P"), nl,
        read(R), % Lee la respuesta del jugador
        verificar_respuesta(R, 1). % Compara que la respuesta sea igual a 1

    % Pregunta normal sin la habilidad de Nanfredo
     pregunta_1 :-
        nl,
        write("Pregunta 1: ~(p v q) <=> ~p ^ ~q"), nl,

        read(R),
        verificar_respuesta(R, 1).

     pregunta_2 :-
        inteligencia_maxima, % Verifica si el jugador obtuvo inteligencia maxima al hablar con Nanfredo
        !,
        nl,
        write("Pregunta 2: (P => Q) <=> (P V ~Q)"), nl,
        read(R), % Lee la respuesta del jugador
        verificar_respuesta(R, 2). % Compara que la respuesta sea igual a 2

        % Pregunta normal sin la habilidad de Nanfredo
        pregunta_2 :-
        nl,
        write("Pregunta 2:"), nl,
        write("~(P => Q) ^ ~(~P v Q)"), nl,
        read(R),
        verificar_respuesta(R, 1).

    pregunta_3 :-
        inteligencia_maxima, % Verifica si el jugador obtuvo inteligencia maxima al hablar con Nanfredo
        !,
        nl,
        write("Pregunta 3: (P ^ Q) => P"), nl,
        read(R), % Lee la respuesta del jugador
        verificar_respuesta(R, 1). % Compara que la respuesta sea igual a 1

    % Pregunta normal sin la habilidad de Nanfredo
    pregunta_3 :-
        nl,
        write("Pregunta 3: "), nl,
        write("MIDIVLAR: Suficiente de tautolgías!, resuleve este acertijo"), nl,
        write("Un prisionero está frente a dos puertas"), nl,
        write("Una lleva a la liberta y otra a la ejecución"), nl,
        write("Cada puerta esta custodiada por un guardia"), nl,
        write("Uno de ellos siempre dice la verdad y el otro siempre miente"), nl,
        write("Pero el prisionero no sabe quien es quien"), nl,
        write("Para elegir la puerta correcta, el prisionero le dice a un guardia:"), nl,
        write("Si le preguntará al otro guardia cuál puerta me salva, ¿Cúal me señalaría?."), nl,
        write("El guardia señala la puerta 1"), nl,
        write("¿Cuál puerta es la que salva al prisionero?, ¿La 1 o la 2?"), nl,
        read(R),
        verificar_respuesta(R, 2).
