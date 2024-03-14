import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/modules/auth/phone_verification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart'as ft;
import '../../Api & Routes/api.dart';
import '../../constance/constance.dart';
import '../../constance/routes.dart';
import '../../constance/themes.dart';
import '../../providers/homepro.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  TextEditingController CUS_PASSWORD = TextEditingController();
  TextEditingController CUS_NAME = TextEditingController();
  TextEditingController CUS_EMAIL = TextEditingController();
  TextEditingController CUS_ADRESS = TextEditingController();
  TextEditingController CUS_PHONE = TextEditingController();
  late AnimationController animationController;
  bool isSignUp = false;
  int CUS_GENDER = 1;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: MediaQuery.of(context).size.width),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ClipRect(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget? child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(Tween(begin: 0.4, end: 1.0)
                                                    .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                                    .value)
                                                    .value) -
                                            16,
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: HexColor("#FF8B8B"),
                                    ),
                                  ),
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(Tween(begin: 0.8, end: 1.0)
                                                    .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                                    .value)
                                                    .value),
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImage,
                                      color: HexColor("#FFB8B8"),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: (MediaQuery.of(context).size.height / 8),
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: AnimatedBuilder(
                                          animation: animationController,
                                          builder: (BuildContext context, Widget? child) {
                                            return Transform(
                                              transform: new Matrix4.translationValues(
                                                  0.0,
                                                  80 *
                                                      (1.0 -
                                                          (AlwaysStoppedAnimation(
                                                            Tween(begin: 0.0, end: 1.0).animate(
                                                              CurvedAnimation(
                                                                parent: animationController,
                                                                curve: Curves.fastOutSlowIn,
                                                              ),
                                                            ),
                                                          ).value)
                                                              .value),
                                                  0.0),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(36.0),
                                                ),
                                                elevation: 12,
                                                child: Image.asset(ConstanceData.appIcon),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 8,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                isSignUp = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        4.0),
                                    child: Text(
                                      AppLocalizations.of('Sign In'),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !isSignUp ? Theme
                                            .of(context)
                                            .textTheme
                                            .titleLarge!
                                            .color : Theme
                                            .of(context)
                                            .disabledColor,
                                      ),
                                    ),
                                  ),
                                  !isSignUp
                                      ? Padding(
                                    padding: const EdgeInsets.all(
                                        0.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      child: SizedBox(
                                        height: 6,
                                        width: 48,
                                      ),
                                    ),
                                  )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Theme
                                .of(context)
                                .primaryColor
                                .withOpacity(0.2),
                            onTap: () {
                              setState(() {
                                isSignUp = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        4.0),
                                    child: Text(
                                      AppLocalizations.of('Sign Up'),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSignUp ? Theme
                                            .of(context)
                                            .textTheme
                                            .titleLarge!
                                            .color : Theme
                                            .of(context)
                                            .disabledColor,
                                      ),
                                    ),
                                  ),
                                  isSignUp
                                      ? Padding(
                                    padding: const EdgeInsets.all(
                                        0.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      child: SizedBox(
                                        height: 6,
                                        width: 48,
                                      ),
                                    ),
                                  )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 1,
                    ),
                    AnimatedCrossFade(
                      alignment: Alignment.bottomCenter,
                      reverseDuration: Duration(milliseconds: 420),
                      duration: Duration(milliseconds: 420),
                      crossFadeState: !isSignUp ? CrossFadeState
                          .showSecond : CrossFadeState.showFirst,
                      firstCurve: Curves.fastOutSlowIn,
                      secondCurve: Curves.fastOutSlowIn,
                      sizeCurve: Curves.fastOutSlowIn,
                      firstChild: IgnorePointer(
                        ignoring: !isSignUp,
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: [
                                Text("Male"),
                                Radio(
                                  value: 1,
                                  groupValue: CUS_GENDER,
                                  onChanged: (value) {
                                    CUS_GENDER = value!;
                                    setState(() {});
                                  },
                                ),
                                Text("Female"),
                                Radio(
                                  value: 2,
                                  groupValue: CUS_GENDER,
                                  onChanged: (value) {
                                    CUS_GENDER = value!;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            _myInputField('Name', CUS_NAME),
                            _myInputField('Email', CUS_EMAIL),
                            _myInputFieldP('Password', CUS_PASSWORD),
                            _myInputField('Phone', CUS_PHONE),
                            _myInputField('Address', CUS_ADRESS),
                            _getSignUpButtonUI(),
                          ],
                        ),
                      ),
                      secondChild: IgnorePointer(
                        ignoring: isSignUp,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            _myInputField('Email', CUS_EMAIL),
                            SizedBox(height: 10,),
                            _myInputFieldP('Password', CUS_PASSWORD),
                            SizedBox(height: 10,),
                            TextButton(
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            _myInputField('Email', CUS_EMAIL),
                                            SizedBox(height: 16.0),
                                            ElevatedButton(
                                              onPressed: () async {
                                                if(CUS_EMAIL.text!=''){

                                                  API.showLoading('Sending OTP...!!!', context);
                                                  bool a = await API.sendOTP(email: CUS_EMAIL.text, context: context);
                                                  Navigator.pop(context); // Close loading dialog
                                                  if (a) {
                                                    print("OTP Send Successfully!");
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhoneVerification()));
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Email Not Found!!!"),
                                                          content: Text("There was an error with your provided email."),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(); // Close the error dialog
                                                              },
                                                              child: Text("Close"),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                }else{
                                                  ft.Fluttertoast.showToast(
                                                    msg: "Email Required!",
                                                    toastLength: ft.Toast.LENGTH_LONG,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).primaryColor, // Change button color
                                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                              ),
                                              child: Text(
                                                AppLocalizations.of('SEND OTP'),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }, child: Text('Forget password?')),
                            _getSignUpButtonUI(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myInputField(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .background,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 48,
            child: Center(
              child: TextField(
                controller: controller,
                maxLines: 1,
                onChanged: (String txt) {},
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Theme
                      .of(context)
                      .disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _myInputFieldP(String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .background,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 48,
            child: Center(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                maxLines: 1,
                onChanged: (String txt) {},
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: hintText,
                  suffixIcon: InkWell(
                      onTap: (){
                        obscure =!obscure;
                        setState(() {
                        });
                      },
                      child: obscure? Icon(Icons.visibility_off):Icon(Icons.visibility)),
                  hintStyle: TextStyle(color: Theme
                      .of(context)
                      .disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSignUpButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () async {
              if (isSignUp) {
                API.showLoading('Creating Account!!!', context);
                bool a = await API.signUp(
                  CUS_NAME: CUS_NAME.text,
                  CUS_EMAIL: CUS_EMAIL.text,
                  CUS_PASSWORD: CUS_PASSWORD.text,
                  CUS_GENDER: CUS_GENDER.toString(),
                  CUS_ADRESS: CUS_ADRESS.text,
                  CUS_PHONE: CUS_PHONE.text,
                  context: context,
                );
                if(a) {
                  print("Moving to Home Screen");
                  Navigator.of(context).pushNamedAndRemoveUntil(Routes.OTP_VERIFY, (route) => false,);

                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Sign Up Failed"),
                        content: Text("There was an error creating your account."),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                if (CUS_EMAIL.text == "" || CUS_PASSWORD.text == "") {
                  ft.Fluttertoast.showToast(
                    msg: "Please Fill all Fields",
                    toastLength: ft.Toast.LENGTH_LONG,
                  );
                  return;
                }
                API.showLoading('Signing In', context);
                API.logIn(CUS_EMAIL.text, CUS_PASSWORD.text, context).then((
                    value) {
                  if (value) {
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.clear();
                      prefs.setString('username', CUS_EMAIL.text).then((value) {
                        prefs.setString('userid',
                          Provider
                              .of<HomePro>(context, listen: false)
                              .userid
                              .toString(),).then(
                              (value) {
                            prefs.setString('token', Provider
                                .of<HomePro>(context, listen: false)
                                .token).then(
                                  (value) async {
                                print(
                                    "SHARED PREFERENCES SAVEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
                                Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME, (route) => false,);
                              },
                            );
                          },
                        );
                      },
                      );
                    },
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true)
                        .pop();
                  }
                });
                print(
                    "AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
                return;
              }
            },
            child: Center(
              child: Text(
                isSignUp ? AppLocalizations.of('Sign Up') : AppLocalizations.of(
                    'Next'),
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}