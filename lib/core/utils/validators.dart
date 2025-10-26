class FieldValidators {
  FieldValidators._();

  static String? notEmptyEmailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required field, please enter a valid value';
    }
    if (!isValidEmail(value.trim())) {
      return 'Invalid email format';
    }
    // Return null if the value is valid
    return null;
  }

  static bool isValidEmail(String email) {
    // Define a regex pattern to match email format
    final regExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z]+)+$",
    );
    return regExp.hasMatch(email);
  }

  static String? notEmptyStringValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required field, please enter a valid value';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required field, please enter a valid value';
    }
    if (value.length < 6) {
      return 'Invalid password';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? password, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required field, please enter a valid value';
    }
    if (value.length < 6) {
      return 'Invalid password';
    }
    if (password != value) {
      return "Password didn't match";
    }
    return null;
  }
}
