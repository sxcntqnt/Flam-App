import 'package:flutter/services.dart';

class SecurityUtils {
  static const int maxInputLength = 255;
  static const int maxNameLength = 100;
  static const int maxMessageLength = 1000;
  static const int maxCommentLength = 500;

  static final List<TextInputFormatter> textOnlyFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\-]')),
  ];

  static final List<TextInputFormatter> nameFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\-]')),
    LengthLimitingTextInputFormatter(maxNameLength),
  ];

  static final List<TextInputFormatter> numberOnlyFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  static final List<TextInputFormatter> emailFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.\-_]')),
    LengthLimitingTextInputFormatter(maxInputLength),
  ];

  static final List<TextInputFormatter> passwordFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@#$%^&*()\-=_+]')),
    LengthLimitingTextInputFormatter(maxInputLength),
  ];

  static final List<TextInputFormatter> decimalFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    LengthLimitingTextInputFormatter(10),
  ];

  static final List<TextInputFormatter> phoneFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
    LengthLimitingTextInputFormatter(10),
  ];

  static final List<TextInputFormatter> messageFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s!@#$%^&*()\-=_+.,?':;/]")),
    LengthLimitingTextInputFormatter(maxMessageLength),
  ];

  static String sanitizeHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  static String sanitizeSql(String input) {
    return input
        .replaceAll(RegExp(r'(\b|\s)(OR|AND|SELECT|DROP|INSERT|UPDATE|DELETE|FROM|WHERE)', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'(--|#|\/\*)'), ' ')
        .trim();
  }

  static String sanitizeJavascript(String input) {
    return input
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '')
        .replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '')
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false, multiLine: true), '')
        .trim();
  }

  static String sanitizeInput(String input) {
    return sanitizeHtml(sanitizeJavascript(input));
  }

  static bool isValidPhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) return false;
    if (phone.length != 10) return false;
    return RegExp(r'^[678][0-9]{9}$').hasMatch(phone);
  }

  static bool isStrongPassword(String? password) {
    if (password == null || password.length < 8) return false;
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r"[!@#$%^&*()\-=_+.,?'":;/]"));
    return hasUpper && hasLower && hasDigit && hasSpecial;
  }

  static String maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) {
      return '**@$domain';
    }
    return '${username.substring(0, 2)}***@$domain';
  }

  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    return '***${phone.substring(phone.length - 4)}';
  }

  static bool containsInjection(String input) {
    final injectionPatterns = [
      RegExp(r'<\s*script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
      RegExp(r'<embed', caseSensitive: false),
      RegExp(r'<object', caseSensitive: false),
      RegExp(r"'\s*OR\s*'1'\s*=\s*'1", caseSensitive: false),
      RegExp(r'--', multiLine: true),
      RegExp(r'/\*.*\*/', multiLine: true),
      RegExp(r'xp_', caseSensitive: false),
      RegExp(r'sp_', caseSensitive: false),
    ];
    return injectionPatterns.any((pattern) => pattern.hasMatch(input));
  }
}