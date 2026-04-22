import 'package:dezole/common/utils/text_utils.dart';

class FormValidator {
  static const int minPasswordLength = 8;
  static const int maxFieldLength = 255;
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 1000;
  static const int maxAmount = 1000000;

  static String? validatePhoneNumber(String? val) {
    final RegExp regExp = RegExp(r'([9][678][0-6][0-9]{7})');
    if (val == null || val.isEmpty) {
      return "Enter a valid Number";
    } else if (val.length != 10 || !regExp.hasMatch(val)) {
      return "Enter a valid Number";
    }
    return null;
  }

  static String? validateFieldNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty.";
    }
    if (value.length > maxFieldLength) {
      return "$fieldName is too long.";
    }
    return null;
  }

  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty.";
    }
    if (value.length > maxNameLength) {
      return "$fieldName must be less than $maxNameLength characters.";
    }
    if (RegExp(r'[0-9_\-\!\@\#\$\%\^\&\*\(\)\+\=\[\]\{\}\|\\:\;"\<\>\,\.\?]').hasMatch(value)) {
      return "$fieldName contains invalid characters.";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    }
    if (value.length < minPasswordLength) {
      return "Password must be at least $minPasswordLength characters.";
    }
    if (value.length > maxFieldLength) {
      return "Password is too long.";
    }
    bool hasUpper = false;
    bool hasLower = false;
    bool hasDigit = false;
    bool hasSpecial = false;
    for (int i = 0; i < value.length; i++) {
      final c = value[i];
      if (RegExp(r'[A-Z]').hasMatch(c)) {
        hasUpper = true;
      } else if (RegExp(r'[a-z]').hasMatch(c)) {
        hasLower = true;
      } else if (RegExp(r'[0-9]').hasMatch(c)) {
        hasDigit = true;
      } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(c)) {
        hasSpecial = true;
      }
    }
    if (!hasUpper) {
      return "Password must contain at least one uppercase letter.";
    }
    if (!hasLower) {
      return "Password must contain at least one lowercase letter.";
    }
    if (!hasDigit) {
      return "Password must contain at least one number.";
    }
    if (!hasSpecial) {
      return "Password must contain at least one special character.";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password.";
    }
    if (value != originalPassword) {
      return "Passwords do not match.";
    }
    return null;
  }

  static String? validateDateOfBirth(String? val) {
    if (val == null || val.isEmpty) {
      return "Date of birth field cannot be empty";
    }
    try {
      final dateTime = DateTime.parse(val);
      final maxDate = DateTime.now().year - 21;
      if (dateTime.year < maxDate) {
        return null;
      } else {
        return "Date of birth must be at least 21 years old";
      }
    } catch (e) {
      return "Invalid date format";
    }
  }

  static String? validateAmount({
    required String val,
    double minAmount = 10,
    double maxAmount = 1000000,
  }) {
    if (val.isEmpty) {
      return "Amount field cannot be empty";
    }
    double? amount = double.tryParse(val);
    if (amount == null) {
      return "Invalid amount";
    }
    if (amount >= minAmount && amount <= maxAmount) {
      return null;
    }
    return "Amount must be between $minAmount and $maxAmount";
  }

  static String? validateEmail(String? val, [bool supportEmpty = false]) {
    if (supportEmpty && (val == null || val.isEmpty)) {
      return null;
    }
    if (val == null || val.isEmpty) {
      return "Email Cannot be empty";
    }
    if (val.length > maxFieldLength) {
      return "Email is too long.";
    }
    if (!TextUtils.validateEmail(val)) {
      return "Please Enter a valid Email";
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLen, String fieldName) {
    if (value == null) return null;
    if (value.length > maxLen) {
      return "$fieldName must be less than $maxLen characters.";
    }
    return null;
  }

  static String? validateDescription(String? value) {
    return validateMaxLength(value, maxDescriptionLength, "Description");
  }

  static String? validateSecureUrl(String? val) {
    if (val == null || val.isEmpty) {
      return "URL cannot be empty";
    }
    if (!val.startsWith('https://')) {
      return "URL must use HTTPS";
    }
    final uri = Uri.tryParse(val);
    if (uri == null || uri.host.isEmpty) {
      return "Invalid URL format";
    }
    return null;
  }

  static String sanitizeInput(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'javascript:'), '')
        .replaceAll(RegExp(r'on\w+='), '')
        .replaceAll(RegExp(r'on\w+="'), '')
        .trim();
  }
}