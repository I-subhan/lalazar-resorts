class AppNotification {
  final String title;
  final String body;
  final String? bookingId;

  AppNotification({
    required this.title,
    required this.body,
    this.bookingId,
  });
}
