abstract final class PasswordPolicy {
  static const minLength = 8;
  static const maxLength = 128;
  static final pattern = RegExp(r'^(?=.*\p{L})(?=.*\d).+$', unicode: true);

  static bool accepts(String value) =>
      value.length >= minLength &&
      value.length <= maxLength &&
      pattern.hasMatch(value);
}
