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