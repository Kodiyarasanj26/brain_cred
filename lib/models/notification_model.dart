class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final String type; // welcome, course_unlocked, test_passed, certificate, etc.

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
    this.type = 'general',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'read': read,
        'type': type,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        read: json['read'] as bool? ?? false,
        type: json['type'] as String? ?? 'general',
      );

  NotificationModel copyWith({bool? read}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        read: read ?? this.read,
        type: type,
      );
}
