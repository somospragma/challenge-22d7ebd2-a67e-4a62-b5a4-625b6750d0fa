# Configuración de entorno para notificaciones push

## Requisitos
- Flutter SDK instalado
- Firebase project creado
- Android y/o iOS configurados para Firebase

## Pasos recomendados

### 1. Firebase
1. Crear un proyecto en Firebase Console.
2. Añadir Android y/o iOS al proyecto.
3. Descargar google-services.json (Android) y GoogleService-Info.plist (iOS).
4. Colocar los archivos en las rutas correspondientes del proyecto.

### 2. Permisos
- Android: el permiso de notificaciones se gestiona por el sistema y Firebase Messaging.
- iOS: se solicita permiso al usuario mediante Firebase Messaging.

### 3. Envío de notificaciones
- El servicio ya está preparado para recibir mensajes en primer plano y para disparar notificaciones locales.
- Para enviar mensajes reales, se necesita un backend o la consola de Firebase.

## Nota
- En web, esta app usa un modo de respaldo porque no existe una configuración nativa real de Firebase en ese entorno.
