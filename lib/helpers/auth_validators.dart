class AuthValidators{
  static String? emailValidator(String email){
    if(email.isEmpty || !email.contains("@") || email.length<5 || !email.contains(".")){
      return "Enter a valid e-mail";
    }
    else{
      return null;
    }
  }
  static String? passwordValidator(String password){
    if(password.isEmpty || password.length<8){
      return "Password is too short or empty";
    }
    else{
      return null;
    }
  }
  static String? confirmPasswordValidator(String password, String confirmPassword){
    if(password.isEmpty || confirmPassword.isEmpty|| password.length<8){
      return "Password is too short or empty";
    }
    else if(!password.contains(RegExp(r'[A-Z]'))){
      return "Atleast one Uppercase letter is required";

    }
    else if(password.contains( RegExp(r'[!@#$%^&*(),.?":{}|<>]'))){
      return "Atleast one special character is required";
    }
    else if(password != confirmPassword){
      return "Passwords doesn't match";
    }
    else{
      return null;
    }
  }
}