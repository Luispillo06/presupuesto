/// Utilidades para validación de datos
class ValidationUtils {
  /// Validar email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  /// Validar contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  /// Validar campo requerido
  static String? validateRequired(
    String? value, [
    String fieldName = 'Este campo',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Validar número positivo
  static String? validatePositiveNumber(
    String? value, [
    String fieldName = 'El valor',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingresa un número válido';
    }
    if (number <= 0) {
      return '$fieldName debe ser mayor a 0';
    }
    return null;
  }

  /// Validar entero positivo
  static String? validatePositiveInt(
    String? value, [
    String fieldName = 'El valor',
  ]) {
    if (value == null || value.isEmpty) {
      return '$fieldName es requerido';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Ingresa un número entero válido';
    }
    if (number < 0) {
      return '$fieldName no puede ser negativo';
    }
    return null;
  }

  /// Validar longitud máxima
  static String? validateMaxLength(
    String? value,
    int maxLength, [
    String fieldName = 'Este campo',
  ]) {
    if (value != null && value.length > maxLength) {
      return '$fieldName no puede exceder $maxLength caracteres';
    }
    return null;
  }

  /// Validar teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Teléfono es opcional
    }
    final phoneRegex = RegExp(r'^[+]?[\d\s-]{9,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    return null;
  }

  // Prevent instantiation
  ValidationUtils._();
}
