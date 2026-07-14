import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification.dart';

class NotificationHandler {
  void handleNotification(RemoteMessage message) {
    final notification = NotificationModel(title: message.notification?.title?? '', body: message.notification?.body?? '');
    // Aquí se puede manejar la lógica adicional para la notificación recibida
  }
}