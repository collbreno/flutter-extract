class NotNullValidator {
  static String? validate<T>(T? item) {
    if (item == null) {
      return 'Campo não pode ser vazio';
    } else {
      return null;
    }
  }
}
