class CertificateModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userName;
  final String courseId;
  final String courseTitle;
  final String lessonTitle;
  final int scorePercent;
  final String grade;
  final DateTime issuedAt;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.courseId,
    required this.courseTitle,
    required this.lessonTitle,
    required this.scorePercent,
    required this.grade,
    required this.issuedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userEmail': userEmail,
        'userName': userName,
        'courseId': courseId,
        'courseTitle': courseTitle,
        'lessonTitle': lessonTitle,
        'scorePercent': scorePercent,
        'grade': grade,
        'issuedAt': issuedAt.toIso8601String(),
      };

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      CertificateModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userEmail: json['userEmail'] as String,
        userName: json['userName'] as String,
        courseId: json['courseId'] as String,
        courseTitle: json['courseTitle'] as String,
        lessonTitle: json['lessonTitle'] as String,
        scorePercent: json['scorePercent'] as int,
        grade: json['grade'] as String,
        issuedAt: DateTime.parse(json['issuedAt'] as String),
      );
}
