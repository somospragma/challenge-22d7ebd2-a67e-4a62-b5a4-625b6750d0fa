class NotificationModel {
  final String title;
  final String body;
  final String? payload;
  final String platform;

  NotificationModel({
    required this.title,
    required this.body,
    this.payload,
    this.platform = 'mobile',
  });
}
