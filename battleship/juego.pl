


% =============================================================================
% Lógica Computacional 2026-2
% Proyecto Final: Battleship
% MAURICIO CASILLAS ALVAREZ 3221964-2
% CRISTIAN SANCHEZ DIAZ 32222564-0
% =============================================================================

:- dynamic tablero_jugador/1.
:- dynamic tablero_computadora/1.

% REPRESENTACIÓN DEL TABLERO
% Usaremos una matriz de 5x5 para mantener el código claro.
% Convención de símbolos:
%   w = Agua 
%   s = Barco 
%   x = Tocado / Golpeado
%   m = Fallo / Agua disparada

tablero_inicial([
    [w, w, w, w, w],
    [w, w, w, w, w],
    [w, w, w, w, w],
    [w, w, w, w, w],
    [w, w, w, w, w]
]).

tablero_con_barcos([
    [s, w, w, s, s],
    [s, w, w, w, w],
    [w, w, w, w, w],
    [w, s, s, s, w],
    [w, w, w, w, w]
]).

% VISUALIZACIÓN DEL TABLERO EN CONSOLA
% Muestra el tablero fila por fila para que sea legible sin interfaz gráfica.
mostrar_tablero([]).
mostrar_tablero([Fila|Resto]) :-
    format('~w~n', [Fila]),
    mostrar_tablero(Resto).

% Oculta los barcos del rival ('s' se muestra como 'w' para el jugador)
mostrar_tablero_oculto([]).
mostrar_tablero_oculto([Fila|Resto]) :-
    ocultar_barcos(Fila, FilaOculta),
    format('~w~n', [FilaOculta]),
    mostrar_tablero_oculto(Resto).

ocultar_barcos([], []).
ocultar_barcos([s|Resto], [w|RestoOculto]) :- !, ocultar_barcos(Resto, RestoOculto).
ocultar_barcos([X|Resto], [X|RestoOculto]) :- ocultar_barcos(Resto, RestoOculto).

% MANIPULACIÓN DE COORDENADAS (Filas y Columnas)
% Obtiene el valor de una celda específica (Coordenadas basadas en 0)
obtener_celda(Tablero, Fila, Columna, Valor) :-
    nth0(Fila, Tablero, R),
    nth0(Columna, R, Valor).

% Reemplaza un valor en una posición específica y devuelve la nueva matriz
actualizar_matriz(Matriz, Fila, Columna, NuevoValor, NuevaMatriz) :-
    nth0(Fila, Matriz, FilaVieja, RestoFilas),
    actualizar_lista(FilaVieja, Columna, NuevoValor, FilaNueva),
    nth0(Fila, NuevaMatriz, FilaNueva, RestoFilas).

actualizar_lista(Lista, Indice, Valor, NuevaLista) :-
    nth0(Indice, Lista, _, Resto),
    nth0(Indice, NuevaLista, Valor, Resto).

% LÓGICA DE DISPARO
% Evalúa el impacto de un disparo en las coordenadas (Fila, Columna)
recibir_disparo(Tablero, Fila, Columna, NuevoTablero) :-
    obtener_celda(Tablero, Fila, Columna, s), !,
    actualizar_matriz(Tablero, Fila, Columna, x, NuevoTablero),
    writeln('--- ¡TOCADO! ---').

recibir_disparo(Tablero, Fila, Columna, NuevoTablero) :-
    obtener_celda(Tablero, Fila, Columna, w), !,
    actualizar_matriz(Tablero, Fila, Columna, m, NuevoTablero),
    writeln('--- AGUA... ---').

recibir_disparo(Tablero, Fila, Columna, Tablero) :-
    obtener_celda(Tablero, Fila, Columna, Celda),
    (Celda == x ; Celda == m),
    writeln('--- Ya disparaste a esa coordenada. Pierdes el turno. ---').

% CONDICIÓN DE VICTORIA
% El juego termina cuando ya no quedan celdas con barcos intactos ('s')
quedan_barcos(Tablero) :-
    member(Fila, Tablero),
    member(s, Fila).

verificar_victoria(Tablero) :-
    quedan_barcos(Tablero), !.
verificar_victoria(_) :-
    writeln('===================================='),
    writeln('¡TODOS LOS BARCOS ENEMIGOS HUNDIDOS!'),
    writeln('===================================='),
    false. % Detiene el ciclo del juego al terminar


% INICIALIZACIÓN Y COLOCACIÓN DINÁMICA

% Limpieza de memoria (Evita que se queden tableros viejos)
limpiar_tableros :-
    retractall(tablero_computadora(_)),
    retractall(tablero_jugador(_)).


% COLOCACIÓN AVANZADA: BARCOS DE TAMAÑO 2 Y 3

% Intenta colocar un barco con Tamaño y Orientación aleatoria
colocar_un_barco(Tablero, Tam, NuevoTablero) :-
    random(0, 5, Fila),
    random(0, 5, Columna),
    random(0, 2, OrienIndice), % 0 = Horizontal, 1 = Vertical
    (OrienIndice == 0 -> Orientacion = h ; Orientacion = v),
    validar_y_colocar(Tablero, Fila, Columna, Tam, Orientacion, NuevoTablero), !.

% Si falla por salirse del mapa o chocar con otro barco, el backtracking reintenta
colocar_un_barco(Tablero, Tam, NuevoTablero) :-
    colocar_un_barco(Tablero, Tam, NuevoTablero).

% Caso Base: El barco ya no tiene longitud restante
validar_y_colocar(Tablero, _, _, 0, _, Tablero) :- !.

% Caso Horizontal: Avanza a la derecha (Columna + 1)
validar_y_colocar(Tablero, Fila, Columna, Tam, h, NuevoTablero) :-
    % Aislamos las comparaciones con paréntesis para evitar el "Syntax error: Operator expected"
    (Fila >= 0), (Fila =< 4), (Columna >= 0), (Columna =< 4),
    obtener_celda(Tablero, Fila, Columna, w),        
    actualizar_matriz(Tablero, Fila, Columna, s, TmpTablero),
    SigCol is Columna + 1,
    SigTam is Tam - 1,
    validar_y_colocar(TmpTablero, Fila, SigCol, SigTam, h, NuevoTablero).

% Caso Vertical: Avanza hacia abajo (Fila + 1)
validar_y_colocar(Tablero, Fila, Columna, Tam, v, NuevoTablero) :-
    % Aislamos las comparaciones con paréntesis
    (Fila >= 0), (Fila =< 4), (Columna >= 0), (Columna =< 4),
    obtener_celda(Tablero, Fila, Columna, w),        
    actualizar_matriz(Tablero, Fila, Columna, s, TmpTablero),
    SigFila is Fila + 1,
    SigTam is Tam - 1,
    validar_y_colocar(TmpTablero, SigFila, Columna, SigTam, v, NuevoTablero).

% BUCLE RECURSIVO PARA COLOCAR HASTA 5 BARCOS DE TAMAÑO ALEATORIO (2 o 3)

generar_flota_aleatoria(Tablero, 0, Tablero) :- !.
generar_flota_aleatoria(Tablero, N, TableroFinal) :-
    random(2, 4, TamAleatorio), % Genera un número entre 2 y 3 (el 4 es el límite exclusivo)
    colocar_un_barco(Tablero, TamAleatorio, TmpTablero),
    N1 is N - 1,
    generar_flota_aleatoria(TmpTablero, N1, TableroFinal).

% BUCLE PRINCIPAL DEL JUEGO (Game Loop)
jugar :-
    limpiar_tableros,
    tablero_inicial(Vacio),
    
    % 1. Generamos los barcos de la computadora
    generar_flota_aleatoria(Vacio, 4, TC),
    asserta(tablero_computadora(TC)),
    
    % 2. Generamos tus propios 4 barcos aleatorios
    generar_flota_aleatoria(Vacio, 4, TJ),
    asserta(tablero_jugador(TJ)),
    
    writeln('¡Bienvenido a Batalla Naval en Prolog!'),
    writeln('Se han desplegado ambos tableros con 4 barcos aleatorios (tamaños 2 y 3).'),
    ciclo_juego.

ciclo_juego :-
    tablero_computadora(T),
    tablero_jugador(TJ), % <--- Recuperamos tu tablero de la memoria
    
    writeln('\n===================================='),
    writeln('TU TABLERO ACTUAL (Tus barcos):'),
    mostrar_tablero(TJ), % <--- Aquí sí mostramos las 's' de tus barcos
    writeln('===================================='),
    
    writeln('\nEstado actual del radar enemigo:'),
    mostrar_tablero_oculto(T),
    
    % Validación estricta de coordenadas por teclado
    writeln('Ingresa la Fila (0-4):'), read(Fila),
    writeln('Ingresa la Columna (0-4):'), read(Columna),
    
    (Fila >= 0, Fila =< 4, Columna >= 0, Columna =< 4 ->
        retract(tablero_computadora(T)),
        recibir_disparo(T, Fila, Columna, NT),
        asserta(tablero_computadora(NT)),
        (verificar_victoria(NT) -> ciclo_juego ; !)
    ;
        writeln('Coordenadas inválidas. Intenta de nuevo.'),
        ciclo_juego
    ).