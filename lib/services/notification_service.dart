import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/notification.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseMessaging? _firebaseMessaging;
  final Future<void> Function()? _firebaseInitializer;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final int _maxRetries;
  final Duration _retryDelay;
  late final Future<void> Function(NotificationModel notification) _sendHandler;

  final List<NotificationModel> _pendingNotifications = [];
  bool _initialized = false;
  bool _lastSendSucceeded = false;
  String? _lastError;

  NotificationService({
    FirebaseMessaging? firebaseMessaging,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
    Future<void> Function()? firebaseInitializer,
    int maxRetries = 3,
    Duration? retryDelay,
    Future<void> Function(NotificationModel notification)? dispatcher,
  })  : _firebaseMessaging = firebaseMessaging,
        _firebaseInitializer = firebaseInitializer,
        _flutterLocalNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
        _maxRetries = maxRetries,
        _retryDelay = retryDelay ?? const Duration(seconds: 2) {
    _sendHandler = dispatcher ?? _defaultSendHandler;
  }

  bool get initialized => _initialized;
  bool get lastSendSucceeded => _lastSendSucceeded;
  String? get lastError => _lastError;
  List<NotificationModel> get pendingNotifications =>
      List.unmodifiable(_pendingNotifications);

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
      final firebaseMessaging =
          _firebaseMessaging ?? FirebaseMessaging.instance;

      if (Firebase.apps.isEmpty) {
        await (_firebaseInitializer ?? Firebase.initializeApp)();
      }

      const androidInitializationSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInitializationSettings = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      final permissionGranted = await _requestNotificationPermission();
      if (!permissionGranted) {
        _lastError = 'No se concedieron permisos para mostrar notificaciones.';
      }

      const androidChannel = AndroidNotificationChannel(
        'push_channel',
        'Promociones',
        description: 'Canal para promociones y pedidos',
        importance: Importance.max,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);

      final settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          final notification = NotificationModel(
            title: message.notification?.title ?? 'Nueva actualización',
            body: message.notification?.body ?? 'Tienes un nuevo mensaje.',
            payload: message.data['payload'],
            platform: message.data['platform'] ?? 'mobile',
          );
          await _showNotification(notification);
        });
      }
    } catch (error) {
      _lastError = 'No se pudo inicializar el servicio nativo: $error';
      debugPrint(_lastError);
      _initialized = true;
      notifyListeners();
      return;
    }

    _initialized = true;
    notifyListeners();
  }

  Future<NotificationModel> sendNotification(
      {NotificationModel? notification, int? maxRetries}) async {
    final model = notification ??
        NotificationModel(
          title: 'Oferta',
          body: '¡Nueva oferta disponible!',
          payload: 'offer-001',
        );

    try {
      await _dispatchWithRetry(model, maxRetries: maxRetries ?? _maxRetries);
      _lastSendSucceeded = true;
      _lastError = null;
    } catch (error) {
      _lastSendSucceeded = false;
      _lastError = error.toString();
      debugPrint(_lastError);
    }

    return model;
  }

  Future<void> _dispatchWithRetry(NotificationModel notification,
      {required int maxRetries, int attempt = 1}) async {
    try {
      await _sendHandler(notification);
      _pendingNotifications.remove(notification);
      notifyListeners();
    } catch (error) {
      if (attempt < maxRetries) {
        _pendingNotifications.add(notification);
        await Future<void>.delayed(
            Duration(milliseconds: _retryDelay.inMilliseconds * attempt));
        await _dispatchWithRetry(notification,
            maxRetries: maxRetries, attempt: attempt + 1);
      } else {
        _pendingNotifications.add(notification);
        notifyListeners();
        throw Exception(
            'No se pudo enviar la notificación después de $maxRetries intentos: $error');
      }
    }
  }

  Future<void> _defaultSendHandler(NotificationModel notification) async {
    if (!_initialized) {
      await initialize();
    }

    if (kIsWeb) {
      debugPrint(
          'Notificación web simulada: ${notification.title} - ${notification.body}');
      return;
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'push_channel',
      'Promociones',
      channelDescription: 'Notificaciones para ofertas y pedidos',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
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
      _lastSendSucceeded = true;
      _lastError = null;
    } catch (error) {
      _lastSendSucceeded = false;
      _lastError = 'No se pudo mostrar la notificación nativa: $error';
      debugPrint(_lastError);
    }
  }

  Future<bool> _requestNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      return status.isGranted || status.isLimited || status.isProvisional;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await Permission.notification.request();
      return status.isGranted || status.isLimited || status.isProvisional;
    }

    return true;
  }

  Future<void> _showNotification(NotificationModel notification) async {
    await _defaultSendHandler(notification);
  }
}
