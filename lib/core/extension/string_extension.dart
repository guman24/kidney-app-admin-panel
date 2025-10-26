extension StringX on String {
  String get fullNameAbbr {
    List<String> names = trim().split(' ');
    String initials = '';

    if (names.isNotEmpty) {
      initials += names[0].isNotEmpty ? names[0][0] : '';
    }
    if (names.length > 1) {
      initials += names.last.isNotEmpty ? names.last[0] : '';
    }

    return initials.toUpperCase();
  }

  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String get capitalizeEachWord {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}
