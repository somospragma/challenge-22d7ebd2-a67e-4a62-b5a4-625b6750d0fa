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