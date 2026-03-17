import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/certificate_model.dart';
import '../models/notification_model.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) throw StateError('LocalStorageService not initialized');
    return _prefs!;
  }

  // Users
  static List<UserModel> getUsers() {
    final json = prefs.getString(AppConstants.keyUsers);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> saveUsers(List<UserModel> users) async {
    final list = users.map((e) => e.toJson()).toList();
    await prefs.setString(AppConstants.keyUsers, jsonEncode(list));
  }

  static Future<void> addUser(UserModel user) async {
    final users = getUsers();
    if (users.any((u) => u.email.toLowerCase() == user.email.toLowerCase())) {
      throw Exception('Email already registered');
    }
    users.add(user);
    await saveUsers(users);
  }

  static UserModel? findUserByEmail(String email) {
    final users = getUsers();
    try {
      return users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static Future<void> updateUser(String email, UserModel updated) async {
    final users = getUsers();
    final i = users.indexWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    if (i >= 0) {
      users[i] = updated;
      await saveUsers(users);
    }
  }

  // Current user (login)
  static String? get currentUserEmail => prefs.getString(AppConstants.keyCurrentUserEmail);
  static Future<void> setCurrentUserEmail(String? email) async {
    if (email == null) {
      await prefs.remove(AppConstants.keyCurrentUserEmail);
    } else {
      await prefs.setString(AppConstants.keyCurrentUserEmail, email);
    }
  }

  // Wallet credits (per user, keyed by email)
  static int getWalletCredits(String userEmail) {
    final key = '${AppConstants.keyWalletCredits}_$userEmail';
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> setWalletCredits(String userEmail, int credits) async {
    final key = '${AppConstants.keyWalletCredits}_$userEmail';
    await prefs.setInt(key, credits);
  }

  static Future<void> addWalletCredits(String userEmail, int amount) async {
    final current = getWalletCredits(userEmail);
    await setWalletCredits(userEmail, current + amount);
  }

  static Future<bool> deductWalletCredits(String userEmail, int amount) async {
    final current = getWalletCredits(userEmail);
    if (current < amount) return false;
    await setWalletCredits(userEmail, current - amount);
    return true;
  }

  // First login credits given (per user)
  static bool wasFirstLoginCreditsGiven(String userEmail) {
    final key = '${AppConstants.keyFirstLoginCreditsGiven}_$userEmail';
    return prefs.getBool(key) ?? false;
  }

  static Future<void> setFirstLoginCreditsGiven(String userEmail) async {
    final key = '${AppConstants.keyFirstLoginCreditsGiven}_$userEmail';
    await prefs.setBool(key, true);
  }

  // Lesson progress: "email_courseId_lessonIndex" -> true when completed
  static String _progressKey(String email, String courseId, int lessonIndex) =>
      '${AppConstants.keyLessonProgress}_${email}_${courseId}_$lessonIndex';

  static bool isLessonCompleted(String userEmail, String courseId, int lessonIndex) {
    return prefs.getBool(_progressKey(userEmail, courseId, lessonIndex)) ?? false;
  }

  static Future<void> setLessonCompleted(String userEmail, String courseId, int lessonIndex) async {
    await prefs.setBool(_progressKey(userEmail, courseId, lessonIndex), true);
  }

  // Test attempts: one per lesson. Store attempt count and best score.
  static String _attemptKey(String email, String courseId, int lessonIndex) =>
      '${AppConstants.keyTestAttempts}_${email}_${courseId}_$lessonIndex';

  static int getTestAttemptCount(String userEmail, String courseId, int lessonIndex) {
    return prefs.getInt(_attemptKey(userEmail, courseId, lessonIndex)) ?? 0;
  }

  static Future<void> incrementTestAttempt(String userEmail, String courseId, int lessonIndex) async {
    final key = _attemptKey(userEmail, courseId, lessonIndex);
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);
  }

  static String _scoreKey(String email, String courseId, int lessonIndex) =>
      '${AppConstants.keyTestAttempts}_score_${email}_${courseId}_$lessonIndex';

  static int? getBestScore(String userEmail, String courseId, int lessonIndex) {
    return prefs.getInt(_scoreKey(userEmail, courseId, lessonIndex));
  }

  static Future<void> setBestScore(String userEmail, String courseId, int lessonIndex, int score) async {
    await prefs.setInt(_scoreKey(userEmail, courseId, lessonIndex), score);
  }

  // Unlocked courses (user has paid credits): list of courseIds per user
  static List<String> getUnlockedCourseIds(String userEmail) {
    final key = '${AppConstants.keyUnlockedCourses}_$userEmail';
    final json = prefs.getString(key);
    if (json == null) return [];
    return List<String>.from(jsonDecode(json) as List);
  }

  static Future<void> addUnlockedCourse(String userEmail, String courseId) async {
    final list = getUnlockedCourseIds(userEmail);
    if (list.contains(courseId)) return;
    list.add(courseId);
    final key = '${AppConstants.keyUnlockedCourses}_$userEmail';
    await prefs.setString(key, jsonEncode(list));
  }

  // Certificates (per user)
  static String _certKey(String userEmail) => '${AppConstants.keyCertificates}_$userEmail';

  static List<CertificateModel> getCertificates(String userEmail) {
    final json = prefs.getString(_certKey(userEmail));
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> addCertificate(CertificateModel cert) async {
    final list = getCertificates(cert.userEmail);
    list.add(cert);
    await prefs.setString(_certKey(cert.userEmail), jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  // Notifications (per user)
  static String _notifKey(String userEmail) => '${AppConstants.keyNotifications}_$userEmail';

  static List<NotificationModel> getNotifications(String userEmail) {
    final json = prefs.getString(_notifKey(userEmail));
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> addNotification(String userEmail, NotificationModel notification) async {
    final list = getNotifications(userEmail);
    list.insert(0, notification);
    await prefs.setString(_notifKey(userEmail), jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  static Future<void> markNotificationRead(String userEmail, String notificationId) async {
    final list = getNotifications(userEmail);
    final i = list.indexWhere((n) => n.id == notificationId);
    if (i >= 0) {
      list[i] = list[i].copyWith(read: true);
      await prefs.setString(_notifKey(userEmail), jsonEncode(list.map((e) => e.toJson()).toList()));
    }
  }

  static Future<void> markAllNotificationsRead(String userEmail) async {
    final list = getNotifications(userEmail);
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(read: true);
    }
    await prefs.setString(_notifKey(userEmail), jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  static Future<void> clearAllNotifications(String userEmail) async {
    await prefs.remove(_notifKey(userEmail));
  }

  static int getUnreadNotificationCount(String userEmail) {
    return getNotifications(userEmail).where((n) => !n.read).length;
  }
}
