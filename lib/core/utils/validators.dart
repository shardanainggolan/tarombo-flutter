class Validators {
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }

    return null;
  }

  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.trim().isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }

    if (value.length < minLength) {
      return 'Kata sandi minimal $minLength karakter';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }

    if (value != password) {
      return 'Kata sandi tidak cocok';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final phoneRegExp = RegExp(r'^[0-9]{9,15}$');
    if (!phoneRegExp.hasMatch(value.replaceAll(RegExp(r'[^0-9]'), ''))) {
      return 'Masukkan nomor telepon yang valid';
    }

    return null;
  }

  static String? validateNumber(String? value,
      {String? fieldName, int? min, int? max}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} tidak boleh kosong';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Masukkan angka yang valid';
    }

    if (min != null && number < min) {
      return '${fieldName ?? 'Field'} minimal $min';
    }

    if (max != null && number > max) {
      return '${fieldName ?? 'Field'} maksimal $max';
    }

    return null;
  }

  static String? validateDate(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Tanggal'} tidak boleh kosong';
    }

    try {
      final date = DateTime.parse(value);
      final now = DateTime.now();

      if (date.isAfter(now)) {
        return '${fieldName ?? 'Tanggal'} tidak boleh di masa depan';
      }

      return null;
    } catch (e) {
      return 'Format ${fieldName ?? 'tanggal'} tidak valid';
    }
  }
}
