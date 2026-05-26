# MasterMind en Prolog

Este proyecto contiene una implementación interactiva del clásico juego MasterMind desarrollada en Prolog. El código del juego se encuentra en el archivo `juego.pl`.

## Integrantes del Equipo

1. Becerra Valencia César
2. Cortes Nava Jose Luis

## Descripción del Juego

MasterMind es un juego de ingenio y reflexión adaptado en esta versión para **2 jugadores de manera local (pass-and-play)**:
- **Jugador 1**: Crea y registra un código o patrón secreto de 4 colores.
- **Jugador 2**: Intenta descifrar el código secreto en un máximo de 10 intentos.

### Reglas del Juego

1. El **Jugador 1** introduce un patrón secreto compuesto por 4 colores elegidos de un conjunto de 6 colores posibles: `rojo`, `azul`, `verde`, `amarillo`, `naranja` y `morado`. Se permiten colores duplicados en el código. La consola oculta automáticamente el patrón impreso para resguardar el secreto.
2. El **Jugador 2** tiene un máximo de 10 intentos para adivinar el patrón secreto.
3. En cada intento, el Jugador 2 propone una combinación de 4 colores utilizando el formato de listas de Prolog.
4. Tras cada propuesta, el programa proporciona una retroalimentación automática en forma de pistas:
   - **Negras (Exactas)**: Indican que un color es correcto y se encuentra en la posición correcta.
   - **Blancas (Parciales)**: Indican que un color es correcto pero se encuentra en una posición incorrecta.
5. El juego termina cuando el Jugador 2 adivina los 4 colores en sus posiciones exactas (4 Negras/Exactas), logrando la victoria, o cuando agota sus 10 intentos sin éxito (en cuyo caso se revela el patrón secreto).

## Requisitos de Instalación

Para ejecutar este juego, es necesario tener instalado un intérprete de Prolog. La opción recomendada y compatible con este código es **SWI-Prolog**.

### Cómo instalar SWI-Prolog

#### Windows
1. Descargue el instalador oficial desde el sitio web de SWI-Prolog: https://www.swi-prolog.org/download/stable
2. Seleccione la versión correspondiente a su sistema (generalmente la versión para Windows de 64 bits).
3. Ejecute el instalador `.exe` descargado y siga las instrucciones del asistente. Asegúrese de marcar la casilla para agregar `swipl` al PATH del sistema si desea ejecutarlo desde la terminal.

#### macOS
Puede instalarlo utilizando Homebrew desde la terminal ejecutando el siguiente comando:
```bash
brew install swi-prolog
```
O bien, puede descargar el paquete oficial `.dmg` desde el sitio web de descargas de SWI-Prolog.

#### Linux (Debian/Ubuntu)
Puede instalarlo desde la terminal utilizando el gestor de paquetes de su distribución:
```bash
sudo apt update
sudo apt install swi-prolog
```

## Cómo ejecutar el Juego

Una vez instalado SWI-Prolog, siga estos pasos para iniciar una partida:

1. Abra una terminal (PowerShell, Símbolo del sistema o terminal de Linux/macOS).
2. Diríjase al directorio donde se encuentra el archivo `juego.pl`.
3. Inicie SWI-Prolog cargando el archivo del juego ejecutando el siguiente comando:
   ```bash
   swipl juego.pl
   ```
   *Nota para usuarios de Windows:* Si obtienes un error que indica que `'swipl' no se reconoce como un comando ejecutable`, ejecuta el programa con su ruta absoluta:
   ```powershell
   & "C:\Program Files\swipl\bin\swipl.exe" juego.pl
   ```
4. Una vez dentro de la consola interactiva de Prolog (indicada por el prompt `?-`), inicie el juego ejecutando el predicado `iniciar_juego.` seguido de un punto y presionando Enter:
   ```prolog
   ?- iniciar_juego.
   ```

### Ejemplo de Partida

Durante la partida, la consola solicitará que ingrese su intento. Debe ingresar la lista de colores en el formato de Prolog (entre corchetes, separados por comas, en minúsculas y finalizando con un punto):

```prolog
--- INTENTO #1 DE 10 ---
JUGADOR 2, introduce tu intento.
Usa el formato Prolog: entre corchetes, separados por comas y terminando con punto.
Ejemplo: [rojo, azul, verde, amarillo].
Intento: 
|: [rojo, rojo, verde, azul].

Resultados -> Negras (Exactas): 1 | Blancas (Parciales): 1
```

### Salir de Prolog

Para cerrar el intérprete de Prolog y volver a su terminal, puede presionar `Ctrl + D` o escribir el siguiente predicado:
```prolog
?- halt.
```
