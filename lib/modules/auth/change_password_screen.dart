import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'as ft;
import 'package:my_cab/Api%20&%20Routes/api.dart';
import '../../Language/appLocalizations.dart';
import '../../constance/routes.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController pass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: MediaQuery.of(context).size.width),
        child: Padding(
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
                                  AppLocalizations.of('Change Password'),
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color,
                                  ),
                                ),
                              ),
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
                  crossFadeState: CrossFadeState.showFirst,
                  firstCurve: Curves.fastOutSlowIn,
                  secondCurve: Curves.fastOutSlowIn,
                  sizeCurve: Curves.fastOutSlowIn,
                  firstChild: IgnorePointer(
                    ignoring: false,
                    child: Column(
                      children: <Widget>[
                        _myInputField('Enter New Password', pass,hide: hidePass),
                        _myInputField('Confirm Password', newPass,hide: hidePass),
                        _getSignUpButtonUI(),
                      ],
                    ),
                  ),
                  secondChild: IgnorePointer(
                    ignoring: false,
                    child: Column(
                      children: <Widget>[
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
      ),
    );
  }
  Widget _myInputField(String hintText, TextEditingController controller, {bool hide=true}) {
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
                obscureText: hidePass,
                maxLines: 1,
                cursorColor: Theme
                    .of(context)
                    .primaryColor,
                decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                      onTap: (){
                        hidePass =!hidePass;
                        setState(() {
                        });
                      },
                      child: hidePass? Icon(Icons.visibility_off):Icon(Icons.visibility)),
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
              if(pass.text == newPass.text && pass.text !=''){
                API.showLoading("Updating...", context);
                bool res = await API.updatePassword(password: pass.text, context: context);
                if(res){
                  ft.Fluttertoast.showToast(
                    msg: "Password Successfully changed!",
                    toastLength: ft.Toast.LENGTH_LONG,
                  );
                  Navigator.pushNamedAndRemoveUntil(context, Routes.LOGIN, (Route<dynamic> route) => false);
                }else{
                  ft.Fluttertoast.showToast(
                    msg: "Failed to change Password!",
                    toastLength: ft.Toast.LENGTH_LONG,
                  );
                }
              }else{
                ft.Fluttertoast.showToast(
                  msg: "Invalid Password!",
                  toastLength: ft.Toast.LENGTH_LONG,
                );
              }
            },
            child: Center(
              child: Text(
                AppLocalizations.of('Save'),
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
