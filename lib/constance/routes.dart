import 'package:flutter/cupertino.dart';
import 'package:my_cab/modules/auth/login_screen.dart';
import 'package:my_cab/modules/auth/phone_verification.dart';
import '../modules/auth/change_password_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/jobs/add_booking.dart';
import '../modules/splash/SplashScreen.dart';
import '../modules/splash/introductionScreen.dart';
class Routes {
  static BuildContext? context;
  static var width;
  static var height;
  static const String SPLASH = "/";
  static const String INTRODUCTION = "/splash/introduction_screen";
  static const String HOME = "/home/home_screen";
  static const String ADD_JOB = "/jobs/add_booking";
  static const String LOGIN = "/auth/login_screen";
  static const String CHANGE_PASSWORD = "/auth/change_password_screen";
  static const String OTP_VERIFY = "/auth/phone_verification";
}
var routes = <String, WidgetBuilder>{
  Routes.ADD_JOB: (context) => const AddBookingScreen(),
  Routes.SPLASH: (context) => SplashScreen(),
  Routes.INTRODUCTION: (context) => IntroductionScreen(),
  Routes.HOME: (context) => HomeScreen(),
  Routes.LOGIN: (context) => LoginScreen(),
  Routes.CHANGE_PASSWORD: (context) => const ChangePasswordScreen(),
  Routes.OTP_VERIFY: (context) => PhoneVerification(isCreate: true),
};
