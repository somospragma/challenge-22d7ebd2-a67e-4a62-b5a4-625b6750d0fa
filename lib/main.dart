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
    return const MaterialApp(
      title: 'Notificaciones Push',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones Push')),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Configuración de entorno para notificaciones push',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'En Android/iOS, esta app solicitará permisos y mostrará notificaciones en primer plano. En web se usa un flujo de respaldo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final service = Provider.of<NotificationService>(context, listen: false);
          await service.initialize();
          await service.sendNotification();

          if (!context.mounted) {
            return;
          }

          final message = service.lastSendSucceeded
              ? 'Notificación enviada correctamente.'
              : service.lastError ?? 'No se pudo enviar la notificación.';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
