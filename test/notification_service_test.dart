import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../lib/models/notification.dart';
import '../lib/services/notification_service.dart';

class FakeFirebaseMessaging extends Fake implements FirebaseMessaging {
  @override
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
    bool providesAppNotificationSettings = false,
  }) async {
    return const NotificationSettings(
      authorizationStatus: AuthorizationStatus.authorized,
      alert: AppleNotificationSetting.enabled,
      announcement: AppleNotificationSetting.enabled,
      badge: AppleNotificationSetting.enabled,
      carPlay: AppleNotificationSetting.enabled,
      lockScreen: AppleNotificationSetting.enabled,
      notificationCenter: AppleNotificationSetting.enabled,
      showPreviews: AppleShowPreviewSetting.always,
      timeSensitive: AppleNotificationSetting.enabled,
      criticalAlert: AppleNotificationSetting.disabled,
      sound: AppleNotificationSetting.enabled,
      providesAppNotificationSettings: AppleNotificationSetting.disabled,
    );
  }
}

class FakeLocalNotificationsPlugin extends Fake implements FlutterLocalNotificationsPlugin {
  int callCount = 0;
  NotificationDetails? lastDetails;
  String? lastPayload;

  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    return true;
  }

  @override
  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {
    callCount += 1;
    lastDetails = notificationDetails;
    lastPayload = payload;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #resolvePlatformSpecificImplementation) {
      return null;
    }
    return super.noSuchMethod(invocation);
  }
}

class FailingLocalNotificationsPlugin extends Fake implements FlutterLocalNotificationsPlugin {
  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    throw Exception('No disponible en esta plataforma');
  }
}

void main() {
  group('NotificationService', () {
    test('envía una notificación local y la marca como entregada', () async {
      final localPlugin = FakeLocalNotificationsPlugin();
      final service = NotificationService(
        firebaseMessaging: FakeFirebaseMessaging(),
        localNotificationsPlugin: localPlugin,
        maxRetries: 1,
        retryDelay: const Duration(milliseconds: 1),
      );

      await service.initialize();
      final notification = await service.sendNotification(
        notification: NotificationModel(
          title: 'Oferta',
          body: '¡Nueva oferta disponible!',
          payload: 'offer-001',
        ),
        maxRetries: 1,
      );

      expect(notification.title, 'Oferta');
      expect(localPlugin.callCount, 1);
      expect(localPlugin.lastPayload, 'offer-001');
      expect(service.pendingNotifications, isEmpty);
    });

    test('reintenta cuando el envío falla', () async {
      var attempts = 0;
      final service = NotificationService(
        firebaseMessaging: FakeFirebaseMessaging(),
        localNotificationsPlugin: FakeLocalNotificationsPlugin(),
        maxRetries: 3,
        retryDelay: const Duration(milliseconds: 1),
        dispatcher: (notification) async {
          attempts += 1;
          if (attempts < 3) {
            throw Exception('fallo temporal');
          }
        },
      );

      await service.initialize();
      await expectLater(
        service.sendNotification(
          notification: NotificationModel(
            title: 'Pedido',
            body: 'Tu pedido está en camino',
            payload: 'order-001',
          ),
          maxRetries: 3,
        ),
        completes,
      );

      expect(attempts, 3);
    });

    test('no falla cuando la inicialización nativa no está disponible', () async {
      final service = NotificationService(
        firebaseMessaging: FakeFirebaseMessaging(),
        localNotificationsPlugin: FailingLocalNotificationsPlugin(),
        maxRetries: 1,
        retryDelay: const Duration(milliseconds: 1),
      );

      await expectLater(service.initialize(), completes);
      await expectLater(
        service.sendNotification(
          notification: NotificationModel(
            title: 'Pedido',
            body: 'Tu pedido está en camino',
            payload: 'order-002',
          ),
          maxRetries: 1,
        ),
        completes,
      );
      expect(service.initialized, isTrue);
    });
  });
}