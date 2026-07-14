# Implementación de Notificaciones Push en Aplicación Móvil

El equipo de desarrollo móvil de una aplicación de e-commerce necesita implementar un sistema de notificaciones push para informar a los usuarios sobre ofertas, promociones y actualizaciones de sus pedidos. El sistema debe ser capaz de enviar notificaciones a dispositivos iOS y Android. Es crucial que el sistema sea escalable y maneje correctamente los casos en que el dispositivo está sin conexión.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Técnicas básicas de notificaciones push |
| **Nivel** | advanced-l1 |
| **Tipo** | practical |
| **Tiempo estimado** | 3-4 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y generará un ZIP listo para usar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Un IDE o editor de código.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y generará un archivo ZIP descargable. Descárgalo y extráelo en la carpeta donde quieras trabajar.
- Verifica que el proyecto arranca sin errores.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no genera el ZIP automáticamente al terminar el análisis, escríbele: "genera el ZIP ahora".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Configuración del Entorno

**Objetivo:** Configurar el entorno para recibir y enviar notificaciones push.

**Tiempo estimado:** 1 hora

**Instrucciones:**

- Identificar los servicios de notificaciones push disponibles para iOS y Android.
- Configurar las claves y certificados necesarios para enviar notificaciones.
- Establecer una conexión segura con el servicio de notificaciones.

**Entregable:** Entorno configurado y listo para enviar notificaciones.

<details>
<summary>Pistas de conocimiento</summary>

- Recuerda que cada plataforma tiene sus propios requisitos para enviar notificaciones.
- La seguridad de la conexión es crítica para proteger la información del usuario.

</details>

### Fase 2: Envío de Notificaciones

**Objetivo:** Implementar la funcionalidad para enviar notificaciones push.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Desarrollar la lógica para enviar notificaciones push a dispositivos iOS y Android.
- Manejar los casos en que el dispositivo está sin conexión.
- Implementar la lógica para reintentar el envío de notificaciones en caso de fallo.

**Entregable:** Función que envía notificaciones push a dispositivos iOS y Android.

<details>
<summary>Pistas de conocimiento</summary>

- Considera utilizar una cola de mensajes para manejar los reintentos de envío.
- Evalúa diferentes estrategias para manejar la falta de conexión.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué son las notificaciones push y por qué son importantes en una aplicación móvil?
- **comoSeUsa**: ¿Cómo se configura el entorno para enviar notificaciones push en iOS y Android?
- **erroresComunes**: ¿Cuáles son los errores comunes al enviar notificaciones push y cómo los manejarías?

## Criterios de Evaluacion

- Configurar el entorno para enviar notificaciones push.
- Implementar la funcionalidad para enviar notificaciones push.
- Manejar los casos de dispositivos sin conexión y reintentos de envío.

---

*Reto generado automaticamente por Challenge Generator - Pragma*
