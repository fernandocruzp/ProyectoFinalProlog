# MasterMind en Prolog

Este proyecto contiene una implementacion interactiva del clasico juego MasterMind desarrollada en Prolog. El codigo del juego se encuentra en el archivo `juego.pl`.

## Integrantes del Equipo

1. Becerra Valencia César
2. Cortes Nava Jose Luis

## Descripcion del Juego

MasterMind es un juego de ingenio y reflexion en el que un jugador intenta descifrar un codigo secreto generado por la computadora.

### Reglas del Juego

1. La computadora genera un codigo secreto compuesto por 4 colores elegidos de un conjunto de 6 colores posibles: rojo, verde, azul, amarillo, naranja y morado. Se permiten colores duplicados en el codigo.
2. El jugador tiene un maximo de 10 intentos para adivinar el codigo secreto.
3. En cada intento, el jugador propone una combinacion de 4 colores.
4. Tras cada propuesta, la computadora proporciona una retroalimentacion en forma de pistas (pines):
   - **Pines negros**: Indican que un color es correcto y se encuentra en la posicion correcta.
   - **Pines blancos**: Indican que un color es correcto pero se encuentra en una posicion incorrecta.
5. El juego termina cuando el jugador adivina los 4 colores en sus posiciones exactas (4 pines negros), logrando la victoria, o cuando agota sus 10 intentos sin exito.

## Requisitos de Instalacion

Para ejecutar este juego, es necesario tener instalado un interprete de Prolog. La opcion recomendada y compatible con este codigo es **SWI-Prolog**.

### Como instalar SWI-Prolog

#### Windows
1. Descargue el instalador oficial desde el sitio web de SWI-Prolog: https://www.swi-prolog.org/download/stable
2. Seleccione la version correspondiente a su sistema (generalmente la version para Windows de 64 bits).
3. Ejecute el instalador `.exe` descargado y siga las instrucciones del asistente. Asegurese de marcar la casilla para agregar `swipl` al PATH del sistema si desea ejecutarlo desde la terminal.

#### macOS
Puede instalarlo utilizando Homebrew desde la terminal ejecutando el siguiente comando:
```bash
brew install swi-prolog
```
O bien, puede descargar el paquete oficial `.dmg` desde el sitio web de descargas de SWI-Prolog.

#### Linux (Debian/Ubuntu)
Puede instalarlo desde la terminal utilizando el gestor de paquetes de su distribucion:
```bash
sudo apt update
sudo apt install swi-prolog
```

## Como ejecutar el Juego

Una vez instalado SWI-Prolog, siga estos pasos para iniciar una partida:

1. Abra una terminal (PowerShell, Simbolo del sistema o terminal de Linux/macOS).
2. Dirijase al directorio donde se encuentra el archivo `juego.pl`.
3. Inicie SWI-Prolog cargando el archivo del juego ejecutando el siguiente comando:
   ```bash
   swipl juego.pl
   ```
4. Una vez dentro de la consola interactiva de Prolog (indicada por el prompt `?-`), inicie el juego ejecutando el predicado `iniciar_juego.` seguido de un punto y presionando Enter:
   ```prolog
   ?- iniciar_juego.
   ```

### Ejemplo de Partida

Durante la partida, la consola solicitara que ingrese su intento. Debe ingresar la lista de colores en el formato de Prolog (entre corchetes, separados por comas, en minusculas y finalizando con un punto):

```prolog
Intento 1 de 10:
Ingresa tu intento como una lista de 4 colores terminada con un punto
ejemplo: [rojo, verde, azul, amarillo].
> [rojo, rojo, verde, azul].

Resultado: 1 Pines negros (aciertos), 1 Pines blancos (coincidencias).
```

### Salir de Prolog

Para cerrar el interprete de Prolog y volver a su terminal, puede presionar `Ctrl + D` o escribir el siguiente predicado:
```prolog
?- halt.
```
