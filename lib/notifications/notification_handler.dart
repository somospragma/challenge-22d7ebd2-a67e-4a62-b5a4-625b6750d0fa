import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification.dart';

class NotificationHandler {
  NotificationModel buildNotification(RemoteMessage message) {
    return NotificationModel(
      title: message.notification?.title ?? 'Nueva actualización',
      body: message.notification?.body ?? 'Hay una actualización disponible.',
      payload: message.data['payload'],
      platform: message.data['platform'] ?? 'mobile',
    );
  }

  void handleNotification(RemoteMessage message) {
    final notification = buildNotification(message);
    if (notification.title.isEmpty && notification.body.isEmpty) {
      return;
    }
  }
}
