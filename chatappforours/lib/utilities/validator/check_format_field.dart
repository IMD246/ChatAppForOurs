String checkFormatEmail(String val) {
  String pattern = r'(^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$)';
  RegExp regExp = RegExp(pattern);
  return val.isEmpty
      ? 'Enter Your Email'
      : (val.split('@')[0].length > 30 || val.split('@')[0].length < 6)
          ? "Your email addres length >=6 and <=30"
          : (!regExp.hasMatch(val.toString()) ? "Check Format Your Email" : '');
}

String checkPassword(String val) {
  return val.isEmpty ? "Enter Your Password" : '';
}

String checkFirstName(String val) {
  return val.isEmpty
      ? "Enter Your First Name"
      : (val.length < 3 ? "Your First Name Length Need To > 3" : '');
}
String checkLastName(String val) {
  return val.isEmpty
      ? "Enter Your Last Name"
      : (val.length < 3 ? "Your Last Name Length Need To > 3" : '');
}
