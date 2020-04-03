bool isValidEmail(String email) {
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  RegExp passwordRegex = RegExp(r"^.+");
  return passwordRegex.hasMatch(password);
}
