import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:my_cab/constance/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';
import '../models/car_price_model.dart';
import '../models/company_model.dart';
import '../providers/homepro.dart';
class API {
  static String? devid;
  static showLoading(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: SizedBox(
                  width: Routes.width,
                  height: Routes.height,
                ),
              ),
              Center(
                child: SizedBox(
                  width: Routes.width / 2,
                  height: Routes.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Routes.width / 7,
                        height: Routes.width / 7,
                        child: const CircularProgressIndicator(),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: Routes.width / 20),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<bool> logIn(String username, String pwd, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://minicab.imdispatch.co.uk/api/cuslogin"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    if (kDebugMode) {
      print("DEV ID  IS : : : : : : : :${API.devid}");
    }
    request.fields.addAll({
      'email': username,
      'password': pwd,
      'device_id': API.devid!,
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
            throw "TimeOut";
          });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        Provider.of<HomePro>(context, listen: false).username = username;
        Provider.of<HomePro>(context, listen: false).userid = res["data"]["customer_id"];
        Provider.of<HomePro>(context, listen: false).token = res["token"];
        print("RESPONSE IS : : : : : :${responsed.body}");
        print("TOKEN SAVED IS : : : : : :${Provider.of<HomePro>(context, listen: false).token}");
        return true;
      }
      if (response.statusCode == 400) {
        var res = jsonDecode(responsed.body);
        if (res["status"] != null) {
          ft.Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: ft.Toast.LENGTH_LONG,
          );
          return false;
        }
        throw Exception();
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "Sign In Unsuccessful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
            return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      ft.Fluttertoast.showToast(
        msg: "Sign In Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
  static Future<bool> signUp({required String CUS_NAME, required String CUS_EMAIL, required String CUS_PASSWORD, required String CUS_GENDER, required String CUS_ADRESS, required String CUS_PHONE, required BuildContext context}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://minicab.imdispatch.co.uk/api/cusregister"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    if (kDebugMode) {
      print("DEV ID  IS : : : : : : : :${API.devid}");
    }
    request.fields.addAll({
      'CUS_NAME': CUS_NAME,
      'CUS_EMAIL': CUS_EMAIL,
      'CUS_PASSWORD': CUS_PASSWORD,
      'CUS_DEVICE_ID': API.devid!,
      'CUS_GENDER': CUS_GENDER,
      'CUS_ADRESS': CUS_ADRESS,
      'CUS_PHONE': CUS_PHONE,
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
            throw "TimeOut";
          });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        ft.Fluttertoast.showToast(
          msg: "Account Created Successfully!!!!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        var res = jsonDecode(responsed.body);
        Provider.of<HomePro>(context, listen: false).username = CUS_EMAIL;
        Provider.of<HomePro>(context, listen: false).userid = res["data"]["CUS_SN"]?? 0;
        Provider.of<HomePro>(context, listen: false).otp = res["otp"].toString();
        print("RESPONSE IS : : : : : :${responsed.body}");
        return true;
      }else if(response.statusCode == 400){
        var res = jsonDecode(responsed.body);
        ft.Fluttertoast.showToast(
          msg: res['message'],
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
      else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        // Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Sign up Failed!!!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Sign In Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
  static Future<bool> updatePassword({required String password, required BuildContext context}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://minicab.imdispatch.co.uk/api/updatepass"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    request.fields.addAll({
      'customer_id':Provider.of<HomePro>(context, listen: false).userid.toString(),
      'password': password,
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
            throw "TimeOut";
          });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        print("RESPONSE IS : : : : : :${responsed.body}");
        return true;
      }
      else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "Failed to Update Password!!!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Failed to Update Password!!!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
  static Future<bool> sendOTP({required String email, required BuildContext context}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://minicab.imdispatch.co.uk/api/forgetpass"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    if (kDebugMode) {
      print("DEV ID  IS : : : : : : : :${API.devid}");
    }
    request.fields.addAll({
      'email': email,
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
            throw "TimeOut";
          });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        ft.Fluttertoast.showToast(
          msg: "OTP Send on your email Successfully!!!!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        var res = jsonDecode(responsed.body);
        Provider.of<HomePro>(context, listen: false).otp = res['otp'].toString();
        Provider.of<HomePro>(context, listen: false).userid = res['customer']['CUS_SN'];
        print("RESPONSE IS : : : : : :${responsed.body}");
        return true;
      }
      else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        // Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Failed to send OTP!!!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Failed to send OTP!!!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
  static Future<bool> updateAccountStatus({required BuildContext context}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://minicab.imdispatch.co.uk/api/cus_status_change"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    request.fields.addAll({
      'customer_id': Provider.of<HomePro>(context, listen: false).userid.toString()
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
            throw "TimeOut";
          });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        ft.Fluttertoast.showToast(
          msg: "Account Successfully Activated",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        var res = jsonDecode(responsed.body);
        print("RESPONSE IS : : : : : :${responsed.body}");
        return true;
      }
      else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "Account Activation Failed!",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      ft.Fluttertoast.showToast(
        msg: "Account Activation Failed!",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> addBooking(BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://minicab.imdispatch.co.uk/api/customeraddjob"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'ac_customer': Provider.of<HomePro>(context, listen: false).userid.toString(),
      'bm_date': DateTime.now().toString(),
      'price': '239',
      'bm_pickup': 'fiazabad',
      'bm_drop': 'saddar',
      'bm_pickup_note': 'testing',
      'bm_drop_note': 'testing',
      'bm_driver_note': 'testing note',
      'payment': '1',
      'passenger': '1',
      'flight_number': '324',
      'distance': '538',
      'time': '3 hours 30 minute',
      'extra_notes': 'testing',
      'plat': '1.324213452345',
      'plang': '2.235432453',
      'dlat': '3.34546456',
      'dlang': '3.346545675687',
      'bm_stop_1': 'rehamanadbad',
      'bm_stop_lat_1': '3.54645645',
      'bm_stop_lang_1': '3.34564645',
      'bm_stop_2': 'chandni chowk',
      'bm_stop_lat_2': '3.45677548',
      'bm_stop_lang_2': '3.5464567547',
      'stop_count': '2'
    });
    http.StreamedResponse response;
    try {
      response =
      await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false,);
      }
      if (response.statusCode == 200) {
        print("RESPONSE IS : : : : : :${responsed.body}");
        print(
            "AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "failed",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      ft.Fluttertoast.showToast(
        msg: "Booking failed",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }
  static Future<List<CarPriceModel>> getAllCarsPrice(double plat, double plong, double dlat, double dlong, BuildContext context) async {
    var request = http.MultipartRequest('POST', Uri.parse('https://minicab.imdispatch.co.uk/api/getallcarprice'));
    request.fields.addAll({
      'plat': '$plat',
      'plang': '$plong',
      'dlat': '$dlat',
      'dlang': '$dlong'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print(responseBody);
      var list = (json.decode(responseBody) as List)
          .map((data) => CarPriceModel.fromJson(data))
          .toList();
      for (int i = 0; i < list.length; i++) {
        if (i == 0) {
          list[i].car_info = "4\n2";
        } else if (i == 1) {
          list[i].car_info = "6/5/4\n2/4/5";
        } else if (i == 2) {
          list[i].car_info = "8/7/6\n4/6/8";
        } else if (i == 3) {
          list[i].car_info = "4\n2";
        }
      }
      return list;
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List<CompanyModel>> getAllCompanies() async {
    final response = await http.get(
      Uri.parse('https://minicab.imdispatch.co.uk/api/getallcompanies'),
    );
    if (response.statusCode == 200) {
      return CompanyModel.fromJsonArray(json.decode(response.body)['data']);
    } else {
      return [];
    }
  }
}
