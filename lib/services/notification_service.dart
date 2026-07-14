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