bool validatePhoneRegExp(String phone) {
  String pattern =
      r'(^(?:13\d|14[5-9]|15[0-35-9]|166|17[0-8]|18\d|19[8-9])\d{8}$)';
  RegExp regExp = RegExp(pattern);
  bool isValid = regExp.hasMatch(phone);
  return isValid;
}
