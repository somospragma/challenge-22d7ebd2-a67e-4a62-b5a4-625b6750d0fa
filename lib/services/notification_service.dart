import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging? _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final int _maxRetries;
  final Duration _retryDelay;
  late final Future<void> Function(NotificationModel notification) _sendHandler;

  final List<NotificationModel> _pendingNotifications = [];
  bool _initialized = false;

  NotificationService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
    int maxRetries = 3,
    Duration? retryDelay,
    Future<void> Function(NotificationModel notification)? dispatcher,
  })  : _firebaseMessaging = firebaseMessaging,
        _flutterLocalNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
        _maxRetries = maxRetries,
        _retryDelay = retryDelay ?? const Duration(seconds: 2) {
    _sendHandler = dispatcher ?? _defaultSendHandler;
  }

  bool get initialized => _initialized;
  List<NotificationModel> get pendingNotifications => List.unmodifiable(_pendingNotifications);

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    if (kIsWeb) {
      _initialized = true;
      notifyListeners();
      return;
    }

    try {
      final firebaseMessaging = _firebaseMessaging ?? FirebaseMessaging.instance;

      const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInitializationSettings = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const androidChannel = AndroidNotificationChannel(
        'push_channel',
        'Promociones',
        description: 'Canal para promociones y pedidos',
        importance: Importance.max,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      await firebaseMessaging.requestPermission();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final notification = NotificationModel(
          title: message.notification?.title ?? 'Nueva actualización',
          body: message.notification?.body ?? 'Tienes un nuevo mensaje.',
          payload: message.data['payload'],
          platform: message.data['platform'] ?? 'mobile',
        );
        await _showNotification(notification);
      });
    } catch (error) {
      debugPrint('No se pudo inicializar el servicio nativo: $error');
      _initialized = true;
      notifyListeners();
      return;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<NotificationModel> sendNotification({NotificationModel? notification, int? maxRetries}) async {
    final model = notification ??
        NotificationModel(
          title: 'Oferta',
          body: '¡Nueva oferta disponible!',
          payload: 'offer-001',
        );

    await _dispatchWithRetry(model, maxRetries: maxRetries ?? _maxRetries);
    return model;
  }

  Future<void> _dispatchWithRetry(NotificationModel notification, {required int maxRetries, int attempt = 1}) async {
    try {
      await _sendHandler(notification);
      _pendingNotifications.remove(notification);
      notifyListeners();
    } catch (error) {
      if (attempt < maxRetries) {
        _pendingNotifications.add(notification);
        await Future<void>.delayed(Duration(milliseconds: _retryDelay.inMilliseconds * attempt));
        await _dispatchWithRetry(notification, maxRetries: maxRetries, attempt: attempt + 1);
      } else {
        _pendingNotifications.add(notification);
        notifyListeners();
        throw Exception('No se pudo enviar la notificación después de $maxRetries intentos: $error');
      }
    }
  }

  Future<void> _defaultSendHandler(NotificationModel notification) async {
    if (!_initialized) {
      await initialize();
    }

    if (kIsWeb) {
      debugPrint('Notificación web simulada: ${notification.title} - ${notification.body}');
      return;
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'push_channel',
      'Promociones',
      channelDescription: 'Notificaciones para ofertas y pedidos',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: notification.payload ?? 'default-payload',
      );
    } catch (error) {
      debugPrint('No se pudo mostrar la notificación nativa: $error');
    }
  }

  Future<void> _showNotification(NotificationModel notification) async {
    await _defaultSendHandler(notification);
  }
}