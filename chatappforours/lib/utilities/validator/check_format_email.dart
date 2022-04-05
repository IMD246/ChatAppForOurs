String checkFormatEmail(String val, RegExp regExp) {
  return val.isEmpty
      ? 'Enter Your Email'
      : (val.split('@gmail.com')[0].length > 30 ||
              val.split('@gmail.com')[0].length < 6)
          ? "Your email addres length >=6 and <=30"
          : (!regExp.hasMatch(val.toString())
              ? "Check Format Your Email Address"
              : '');
}
