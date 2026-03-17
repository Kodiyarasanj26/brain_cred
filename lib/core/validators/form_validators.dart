/// Reusable form validators for the app.
class FormValidators {
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^[+]?[\d\s\-]{10,16}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', '')) ||
        value.replaceAll(RegExp(r'[\s\-]'), '').length < 10) {
      return 'Enter a valid phone number (at least 10 digits)';
    }
    return null;
  }

  static String? minLength(String? value, int min, [String fieldName = 'Field']) {
    if (value == null) return '$fieldName is required';
    if (value.trim().length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) return 'Address is required';
    if (value.trim().length < 10) return 'Enter a valid address (at least 10 characters)';
    return null;
  }

  static String? institution(String? value) {
    if (value == null || value.trim().isEmpty) return 'Institution name is required';
    return null;
  }
}
