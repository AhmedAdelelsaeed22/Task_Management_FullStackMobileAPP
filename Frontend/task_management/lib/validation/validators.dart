class Validators {
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!regex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }

  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a task title';
    }

    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }

    return null;
  }

  static String? estimateHours(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter estimated hours';
    }

    final double? hours = double.tryParse(value.trim());

    if (hours == null) {
      return 'Enter a valid number';
    }

    if (hours <= 0) {
      return 'Hours must be greater than 0';
    }

    return null;
  }

  static String? fullName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your full name';
    }

    if (text.length < 3) {
      return 'Full name must be at least 3 characters';
    }

    return null;
  }

  static String? userName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your username';
    }

    if (text.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (text.contains(' ')) {
      return 'Username cannot contain spaces';
    }

    return null;
  }
}
