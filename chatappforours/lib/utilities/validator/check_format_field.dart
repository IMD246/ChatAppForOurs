String? checkFormatEmail(String val) {
  String pattern = r'(^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})$)';
  RegExp regExp = RegExp(pattern);
  return val.isEmpty
      ? 'Enter Your Email'
      : (val.split('@')[0].length > 30 || val.split('@')[0].length < 6)
          ? "Your email addres length >=6 and <=30"
          : (!regExp.hasMatch(val.toString())
              ? "Check Format Your Email Address"
              : null);
}

String? checkPassword(String val) {
  return val.isEmpty ? "Enter Your Password" : null; 
}

String? checkName(String val) {
  return val.isEmpty
      ? "Enter Your First Name"
      : (val.length < 3 ? "Your Last Name Length Need To > 3" : null);
}
