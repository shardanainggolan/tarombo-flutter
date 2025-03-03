import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// String extensions
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeFirstOfEach => split(' ')
      .map((str) => str.trim().capitalize())
      .where((str) => str.isNotEmpty)
      .join(' ');

  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  bool get isValidPassword => length >= 8;

  bool get hasUppercase => contains(RegExp(r'[A-Z]'));

  bool get hasLowercase => contains(RegExp(r'[a-z]'));

  bool get hasNumber => contains(RegExp(r'[0-9]'));

  bool get hasSpecialCharacter => contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

// DateTime extensions
extension DateTimeExtensions on DateTime {
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  String get formatDate => DateFormat('dd MMMM yyyy').format(this);

  String get formatDateTime => DateFormat('dd MMMM yyyy, HH:mm').format(this);

  String get formatTime => DateFormat('HH:mm').format(this);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int get age {
    final now = DateTime.now();
    int years = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      years--;
    }
    return years;
  }
}

// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isSmallScreen => screenWidth < 600;

  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  bool get isLargeScreen => screenWidth >= 900;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<T?> showCustomDialog<T>({
    required Widget title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// List extensions
extension ListExtensions<T> on List<T> {
  List<T> sortedBy<R extends Comparable<R>>(R Function(T) selector) {
    final copy = [...this];
    copy.sort((a, b) => selector(a).compareTo(selector(b)));
    return copy;
  }

  List<T> sortedByDescending<R extends Comparable<R>>(R Function(T) selector) {
    final copy = [...this];
    copy.sort((a, b) => selector(b).compareTo(selector(a)));
    return copy;
  }

  List<R> mapIndexed<R>(R Function(int index, T item) transform) {
    final result = <R>[];
    for (var i = 0; i < length; i++) {
      result.add(transform(i, this[i]));
    }
    return result;
  }
}
