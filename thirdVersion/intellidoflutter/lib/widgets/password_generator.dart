import 'dart:math';

class PasswordGenerator {
  static String generate() {
    const int length = 12; // You can adjust the length as needed
    const String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const String digits = '0123456789';
    const String allCharacters = '$upperCaseLetters$lowerCaseLetters$digits';

    final Random random = Random();

    String getRandomString(int length, String chars) => 
      String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))
      ));

    String password = getRandomString(1, upperCaseLetters) +
                      getRandomString(1, lowerCaseLetters) +
                      getRandomString(1, digits) +
                      getRandomString(length - 3, allCharacters);

    return String.fromCharCodes(password.runes.toList()..shuffle());
  }
}
