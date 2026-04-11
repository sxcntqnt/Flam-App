import 'package:dezole/common/utils/text_utils.dart';

class FormValidator {
  static String? validatePhoneNumber(String? val) {
    final RegExp regExp = RegExp(r'([9][678][0-6][0-9]{7})');
    if (val == null) {
      return "Enter a valid Number";
    } else if (val.isEmpty) {
      return "Number cannot be empty.";
    } else if (val.length != 10 || !regExp.hasMatch(val)) {
      return "Enter a valid Number";
    } else {
      return null;
    }
  }

  static String? validateFieldNotEmpty(String? value, String fieldName) {
    if (value == null) {
      return "$fieldName cannot be empty.";
    } else if (value.isEmpty) {
      return "$fieldName cannot be empty.";
    } else {
      return null;
    }
  }

  static String? validateDateOfBirth(String? val) {
    if (val == null || val == "") {
      return "Date of birth field cannot be empty";
    } else if (val.isEmpty) {
      final DateTime dateTime = DateTime.parse(val);
      final maxDate = DateTime.now().year - 21;
      if (dateTime.year < maxDate) {
        return "Date of birth field cannot be empty";
      } else {
        return "Date of birth must be at least 21 years old";
      }
    } else {
      return null;
    }
  }

  static String? validateAmount({
    required String val,
    required double minAmount,
    required double maxAmount,
  }) {
    if (val.isEmpty) {
      return "Amount field cannot be empty";
    } else {
      double? amount = double.tryParse(val);
      if (amount == null) {
        return "Invalid amount";
      } else if (amount >= minAmount && amount <= maxAmount) {
        return null;
      } else {
        return "Amount must be between $minAmount and $maxAmount";
      }
    }
  }

  static String? validateEmail(String? val, [bool supportEmpty = false]) {
    if (supportEmpty && (val == null || val.isEmpty)) {
      return null;
    } else if (val == null) {
      return "Email Cannot be empty";
    } else if (val.isEmpty) {
      return "Email Cannot be empty";
    } else if (TextUtils.validateEmail(val)) {
      return null;
    } else {
      return "Please Enter a valid Email";
    }
  }
}
