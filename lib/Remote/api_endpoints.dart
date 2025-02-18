class ApiEndPoints {
  ApiEndPoints._();

//^ ============================AUTH=====================================
  // static const String login = "auth/login";
  // static const String register = 'auth/register';
  //* sanju
  static const String login = "signIn";
  static const String register = 'signup';

//^ ============================VERIFICATION=============================
  static const String sendOTP = "otpSent";
  static const String verifyOTP = 'otpVerify';

//^ ==========================USER=======================================
  static const String getUser = 'getDetails';
  static const String updateUser = 'editProfile';
  static const String deletesUser = 'deleteUser';

//^ =========================Reset Password==============================
  static const String resetPassword = 'updatePassword';
  static const String forgetPassword = '';


//^ ===========================CORE======================================
  static const String scanProduct = 'food_ingredients';
  // static const String productScore = 'product-score';

//^ ===========================History===================================
  static const String getUserHistory = 'getfood_details';
  static const String deleteUserHistory = 'delete-history';
}
