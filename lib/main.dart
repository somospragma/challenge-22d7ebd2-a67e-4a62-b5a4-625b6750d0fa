import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/notification_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotificationService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones Push',
      home: Scaffold(
        appBar: AppBar(title: const Text('Notificaciones Push')),
        body: const Center(child: Text('Presiona para enviar una notificación')),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final service = Provider.of<NotificationService>(context, listen: false);
            await service.initialize();
            await service.sendNotification();
          },
          child: const Icon(Icons.notifications),
        ),
      ),
    );
  }
}
