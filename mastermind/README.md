# 🧠 Mastermind en Prolog

<p align="center">
  <b>Proyecto Final - Lógica Computacional</b><br>
  <i>Facultad de Ciencias, UNAM</i>
</p>

---

## 👥 Integrantes
* 👤 **Feregrino Mesinas Renata**
* 👤 **Marquez Cristoval Miguel Ángel**
* 👤 **Rivera Lugo Araní Karol**
* 👤 **Torres Cuevas Gael Patricio**

---

## 📝 Descripción del Juego
**Mastermind** es un clásico juego de deducción en el que el jugador intenta adivinar un patrón secreto de **5 colores** generado aleatoriamente por la computadora. 

### ⚙️ Reglas Básicas:
1. El patrón consta de 5 colores elegidos del universo disponible **sin repetirse**.
2. Tienes un máximo de **10 intentos** para resolverlo.
3. Después de cada intento, el juego te dará retroalimentación:
   * **Colores perfectamente colocados:** Posición y color correctos.
   * **Colores correctos pero mal colocados:** El color está en el patrón, pero en otra posición.
4. Si agotas tus intentos, el juego revelará la combinación secreta.

🎨 **Universo de colores disponibles:** `rosa`, `azul`, `verde`, `morado`, `dorado`, `negro`.

---

## 🚀 Instrucciones de Uso

1. **Iniciar SWI-Prolog** en tu terminal:
   ```bash
   swipl