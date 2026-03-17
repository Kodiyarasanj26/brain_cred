import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _initialized = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get initialized => _initialized;

  Future<void> init() async {
    await LocalStorageService.init();
    final email = LocalStorageService.currentUserEmail;
    if (email != null) {
      _currentUser = LocalStorageService.findUserByEmail(email);
    }
    _initialized = true;
    notifyListeners();
  }

  int get walletCredits {
    if (_currentUser == null) return 0;
    return LocalStorageService.getWalletCredits(_currentUser!.email);
  }

  Future<bool> login(String email, String password) async {
    final user = LocalStorageService.findUserByEmail(email);
    if (user == null) return false;
    if (user.passwordHash != password) return false;
    await LocalStorageService.setCurrentUserEmail(email);
    _currentUser = user;
    final giveWelcomeCredits = !LocalStorageService.wasFirstLoginCreditsGiven(email);
    if (giveWelcomeCredits) {
      await LocalStorageService.addWalletCredits(email, AppConstants.welcomeCredits);
      await LocalStorageService.addNotification(
        email,
        NotificationModel(
          id: const Uuid().v4(),
          title: 'Welcome back!',
          body: 'You received ${AppConstants.welcomeCredits} credits. Use them to unlock courses and take tests.',
          createdAt: DateTime.now(),
          type: 'welcome',
        ),
      );
      // Don't set firstLoginCreditsGiven here so user sees welcome popup on home; they mark shown on dismiss
    }
    notifyListeners();
    return true;
  }

  bool get shouldShowWelcomeCreditsPopup {
    if (_currentUser == null) return false;
    return !LocalStorageService.wasFirstLoginCreditsGiven(_currentUser!.email);
  }

  void markWelcomeCreditsShown() {
    if (_currentUser == null) return;
    LocalStorageService.setFirstLoginCreditsGiven(_currentUser!.email);
    notifyListeners();
  }

  /// Registers a new user only (does not log in). User must sign in on login screen; welcome credits & notification are given on first login.
  Future<void> register(UserModel user) async {
    await LocalStorageService.addUser(user);
    // Do not set current user – go to login screen; credits & notification given on first login
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updated) async {
    if (_currentUser == null) return;
    await LocalStorageService.updateUser(_currentUser!.email, updated);
    _currentUser = updated;
    await LocalStorageService.setCurrentUserEmail(updated.email);
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorageService.setCurrentUserEmail(null);
    _currentUser = null;
    notifyListeners();
  }

  void refreshUser() {
    final email = LocalStorageService.currentUserEmail;
    if (email != null) _currentUser = LocalStorageService.findUserByEmail(email);
    notifyListeners();
  }
}
