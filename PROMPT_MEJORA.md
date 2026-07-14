# Prompt para Mejorar el Codigo Base

Copia y pega el siguiente contenido completo en un asistente de IA (Claude, ChatGPT, etc.)
para obtener un ZIP con el proyecto corregido y listo para compilar.

---

```
Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Exportación en ZIP
Empaqueta todos los archivos en un único archivo ZIP descargable respetando exactamente
la estructura de rutas indicada por los marcadores.
El ZIP debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: El ZIP debe estar listo para descargar al finalizar. No preguntes si el usuario
quiere generarlo. Simplemente genera el archivo y proporciona el enlace de descarga; No debes desplegar en el chat el resumen de lo que arreglaste al Zip, solo entregalo.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación o descripciones sin código, genera los archivos
correspondientes sin aplicar análisis de compilación
No agregues texto después del enlace de descarga del ZIP
No preguntes si el usuario quiere el ZIP: simplemente generalo siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'models/notification.dart';
import 'services/notification_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Notificaciones Push')),
        body: Center(child: Text('Presiona para enviar una notificación')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<NotificationService>(context, listen: false).sendNotification();
          },
          child: Icon(Icons.notifications),
        ),
      ),
    );
  }
}
// === ARCHIVO: lib/models/notification.dart ===
class NotificationModel {
  final String title;
  final String body;
  NotificationModel({required this.title, required this.body});
}
// === ARCHIVO: lib/services/notification_service.dart ===
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification.dart';

class NotificationService with ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  void _init() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification?.title?? '', message.notification?.body?? '');
    });
  }

  void sendNotification() {
    final notification = NotificationModel(title: 'Oferta', body: '¡Nueva oferta disponible!');
    _showLocalNotification(notification);
  }

  void _showLocalNotification(NotificationModel notification) {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'item id here',
    );
  }

  void _showNotification(String title, String body) {
    final notification = NotificationModel(title: title, body: body);
    _showLocalNotification(notification);
  }
}
// === ARCHIVO: lib/notifications/notification_handler.dart ===
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification.dart';

class NotificationHandler {
  void handleNotification(RemoteMessage message) {
    final notification = NotificationModel(title: message.notification?.title?? '', body: message.notification?.body?? '');
    // Aquí se puede manejar la lógica adicional para la notificación recibida
  }
}
// === ARCHIVO: test/notification_service_test.dart ===
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../lib/services/notification_service.dart';
import '../lib/models/notification.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}
class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

@GenerateMocks([FirebaseMessaging, FlutterLocalNotificationsPlugin])
void main() {
  group('NotificationServiceTest', () {
    late NotificationService notificationService;
    late MockFirebaseMessaging mockFirebaseMessaging;
    late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

    setUp(() {
      mockFirebaseMessaging = MockFirebaseMessaging();
      mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
      notificationService = NotificationService();
    });

    test('sendNotification should call show on FlutterLocalNotificationsPlugin', () async {
      when(mockFirebaseMessaging.requestPermission()).thenAnswer((_) async {});
      when(mockFlutterLocalNotificationsPlugin.show(
        any,
        any,
        any,
        any,
        payload: anyNamed('payload'),
      )).thenAnswer((_) async {});
      await notificationService.sendNotification();
      verify(mockFlutterLocalNotificationsPlugin.show(
        any,
        'Oferta',
        '¡Nueva oferta disponible!',
        any,
        payload: anyNamed('payload'),
      )).called(1);
    });
  });
}

```
