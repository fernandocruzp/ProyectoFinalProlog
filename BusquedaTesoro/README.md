### Nombre del Juego y Descripción
Búsqueda del Tesoro.
Búsqueda del Tesoro es un juego de aventura y lógica donde debes encontrar el cofre oculto por Midivlar en la Facultad de Ciencias, con ayuda de varios personajes adentrados en el mapa. Sin embargo, al hallar el cofre, deberás enfrentarte en un duelo lógico al fantasma de Midivlar, quien protege el tesoro. El tesoro es nada más y nada menos que mentitas, que en sus envolturas contienen las sabias palabras de Midivlar.


### Integrantes.
Integrantes de Equipo "Albert y Einstein"
- Flores Juárez Luis Enrique
- Rosado Verdugo Erick

### Instrucciones de uso
1. Descargar SWI-Prolog
 
2. Tener el código  del programa en un archivo con extensión .pl

3. Abrir la terminal de su sistema operativo en la carpeta correspondiente y ejecute el comando swipl busqueda_tesoro.pl. Alternativamente, si ya se encuentra dentro del intérprete interactivo de SWI-Prolog (?-), puede cargar o recargar el archivo utilizando el predicado de consulta: ?- [busqueda_tesoro].


4. Realizar las consultas para jugar:

Una vez compilado el juego inicia con el predicado  iniciar/0.

?- iniciar.

Comandos a usar por el jugador:
Nota: todo debe ser escrito en minúscula y si hay espacios deberá usarse el guión bajo (_), y terminar con un punto (.).

* iniciar.
Ejecuta de forma secuencial la limpieza de partidas anteriores (limpiar_estado), distribuye aleatoriamente los objetos y el cofre por el mapa y posiciona al jugador en la ubicación inicial "media_luna". También, despliega la introducción del juego.

* lugares.
Qué hace: Invoca el predicado mostrar_lugares/0. Utiliza forall/2 para iterar sobre los hechos lugar(Nombre, _, _). Imprime en la terminal una lista de los nombres de las 20 ubicaciones en la Facultad.

* ir(lugar).
Permite al jugador cambiar de posición yendo a otra ubicación del mapa. 

Recibe como argumento el destino deseado (por ejemplo, ir(biblioteca).). Primero se valida que el lugar exista en los hechos del programa; si es válido, retira la ubicación vieja mediante retract y asienta la nueva con assertz. Al actualizar la posición del jugador, analiza si en la nueva coordenada hay un objeto  para añadirlo al inventario (revisar_objetos) y calcula la distancia al cofre para actualizar la pista de temperatura.

* estado.
Imprime en qué parte de la facultad te encuentras, evalúa la distancia hacia el cofre para la pista (HIRVIENDO, CALIENTE, TIBIO, FRIO o HELADO) y notifica si hay algún personaje interactuable en la posición que te encuentras.

* inventario.
Si el jugador ha recogido objetos, despliega una lista de los objetos que posee, En caso de no contar con ningún elemento en ese momento, devuelve el mensaje "Inventario vacio.".

* hablar(Persona).
Interactua con los aliados de las distintas ubicaciones (Debes estar en la misma ubicación que con el que deseas interactuar).

* hablar(onid). (oficina_onid): Si posees la coca_cola, se la entregas, el programa calcula un número entre 1 y 100; si el resultado es >=35, te revela la ubicación del cofre.

* hablar(amoni). (aula_t): Si traes el plumon, ella dibuja un mapa en el pizarrón que ejecuta descartar_ubicaciones/0, eliminando dos lugares donde el cofre no está.

* hablar(nanfredo). (laboratorio_simbolicos): Al entregarle el control_proyector, asienta el hecho inteligencia_maxima, permitiéndote alterar las complejas preguntas de la batalla final por tautologias sencillas.

* hablar(estudiantes). (En crujipollo): Les das de la coca_cola por un pato_hule.

* buscar.
Busca si la posición del jugador es la misma que la del cofre, si coinciden, se invoca la batalla final,
Si el usuario ejecuta este comando en cualquier coordenada sin el cofre, el programa responderá que no hay nada sospechoso.

* usar(Objeto).
Qué hace: Verifica si el objeto a usar existe en el inventario. inventario(Objeto). Si lo posees, el objeto se utiliza con el aliado correspondiente. Si no se encuentra en tus registros, arroja una advertencia indicando que no posees el objeto.

* ayuda.
Despliega en la pantalla de la terminal un menú con la sintaxis exacta de los comandos del juego, sirviendo como guía en cualquier momento de la partida.

* salir.
Qué hace: Termina la sesión actual del juego de manera limpia. Imprime un mensaje de despedida y ejecuta halt/0, la cual cierra el intérprete de SWI-Prolog.

Nota de sintaxis para el manual: Es fundamental recordar al lector que, por la naturaleza sintáctica de Prolog, cada uno de estos comandos debe escribirse en minúsculas y finalizarse estrictamente con un punto (.) para que el flujo interactivo del predicado read/1 pueda procesar la instrucción.

### Reglas del Juego.
El juego consiste en moverte entre las distintas ubicaciones del juego para así poder encontrar a los ayudantes u objetos escondidos por todo el mapa.
Estos proveen ventajas para ayudar al jugador. 
Al estar en una ubicación podrás "hablar" con quien se encuentre ahí y te dirá que objeto necesita o la pista que da el personaje. 
Una vez estando en alguna ubicación podrás "buscar" para analizar si Midivlar se encuentra en esa ubicación, en caso que esté comenzará la batalla final. 
Al empezar la batalla final deberás contestar correctamente las preguntas que Midivlar hace, si contestas alguna mal, perderás el juego.

### Explicación de las reglas lógicas
Para las ubicaciones se hizo un mapa de la facultad mediante un plano cartesiano. Cada ubicación es un hecho de forma: lugar(Nombre, X, Y).
Para calcular la distancia del jugador respecto al cofre de Midivlar, el programa calcula la distancia entre las coordenadas del jugador (X1, Y1) y la ubicación del cofre (X2, Y2). Esto con la fórmula Distancia = \sqrt{(X2 - X1)^2 + (Y2 - Y1)^2}.
Este cálculo se realiza mediante la consulta de los hechos lugar/3.

distancia_entre/3

distancia_entre(L1, L2, Distancia)

Restricciones lógicas: Este predicado unifica las coordenadas de los dos lugares. Usa los valores de X e Y correspondientes y utiliza el operador "is". Implementa la restricción de que la distancia no puede ser negativa y evalúa de la siguiente forma:

distancia_entre(L1, L2, Distancia) :-
    lugar(L1, X1, Y1),
    lugar(L2, X2, Y2),
    Distancia is sqrt((X2 - X1)^2 + (Y2 - Y1)^2).

procesar_intento/2:

procesar_intento(UbicacionElegida, UbicacionTesoro)

Restricciones lógicas: Cuenta con dos cláusulas. Si UbicacionElegida == UbicacionTesoro, comienza la Boss Fight. Si son distintos, calcula la distancia y devuelve la pista de temperatura (hirviendo, caliente, tibio, frío).

ayuda_naomi/1:

:ayuda_naomi(UbicacionTesoro)

Restricciones lógicas: Genera dos lugares aleatorios distintos del mapa mediante random_member/2. Aplicando la restricción (\=) para que ninguno de los dos lugares coincida con la ubicación del cofre, ni entre ellos.


6. Gameplay
