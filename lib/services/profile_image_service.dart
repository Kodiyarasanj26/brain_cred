import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../core/constants/app_constants.dart';
import 'local_storage_service.dart';

class ProfileImageService {
  static const String _fileNamePrefix = 'profile_';

  static String? getProfileImagePath(String userEmail) {
    if (userEmail.isEmpty) return null;
    final key = '${AppConstants.keyProfileImagePath}_$userEmail';
    return LocalStorageService.prefs.getString(key);
  }

  static Future<void> _setProfileImagePath(String userEmail, String? path) async {
    final key = '${AppConstants.keyProfileImagePath}_$userEmail';
    if (path == null) {
      await LocalStorageService.prefs.remove(key);
    } else {
      await LocalStorageService.prefs.setString(key, path);
    }
  }

  /// Picks image from gallery, removes previous profile image, saves new one. Returns new path or null on cancel/failure.
  static Future<String?> pickAndSaveProfileImage(String userEmail) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final oldPath = getProfileImagePath(userEmail);
    if (oldPath != null) {
      try {
        final oldFile = File(oldPath);
        if (oldFile.existsSync()) await oldFile.delete();
      } catch (_) {}
    }

    final dir = await getApplicationDocumentsDirectory();
    final sanitized = userEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final fileName = '${_fileNamePrefix}$sanitized.jpg';
    final newFile = File('${dir.path}/$fileName');
    final bytes = await picked.readAsBytes();
    await newFile.writeAsBytes(bytes);
    await _setProfileImagePath(userEmail, newFile.path);
    return newFile.path;
  }

  /// Removes current profile image file and clears stored path.
  static Future<void> removeProfileImage(String userEmail) async {
    final path = getProfileImagePath(userEmail);
    if (path != null) {
      try {
        final file = File(path);
        if (file.existsSync()) await file.delete();
      } catch (_) {}
    }
    await _setProfileImagePath(userEmail, null);
  }
}
