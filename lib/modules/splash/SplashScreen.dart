import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/LanguageData.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/constance/routes.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constance/constance.dart' as constance;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api & Routes/api.dart';
import '../../providers/homepro.dart';
import '../../providers/mappro.dart';
import 'package:http/http.dart'as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late BuildContext myContext;
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    String mapKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4';
    String host = 'https://maps.google.com/maps/api/geocode/json';
    final url = '$host?key=$mapKey&language=en&latlng=$lat,$lng';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      String formattedAddress = data["results"][0]["formatted_address"];
      print("response ==== $formattedAddress");
      return formattedAddress;
    } else {
      return "Not Found";
    }
  }

  @override
  void initState() {
    myContext = context;
    _loadNextScreen();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animationController.forward();
    super.initState();
  }

  _loadNextScreen() async {
    constance.allTextData = AllTextData.fromJson(json.decode(await DefaultAssetBundle.of(myContext).loadString("assets/jsonFile/languagetext.json")));
    await Future.delayed(const Duration(milliseconds: 1100));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('username') != null && prefs.getString('userid') != null
        && prefs.getString('token') != null){
      Provider.of<HomePro>(context, listen: false).token = prefs.getString('token')!;
      Provider.of<HomePro>(context, listen: false).userid = int.parse(prefs.getString('userid')!);
      Provider.of<HomePro>(context, listen: false).username = prefs.getString('username')!;
      while(true){
        if(await ConstanceData.handleLocationPermission(context)){
          break;
        }
      }
      var pos = await Geolocator.getCurrentPosition();
      print("Latitude  is : ${pos.latitude}");
      print("Longitude is : ${pos.longitude}");
      print("Device ID:::::::::::::::::::: ${API.devid}");
      Provider.of<MapPro>(context, listen: false).plat = pos.latitude;
      Provider.of<MapPro>(context, listen: false).plong = pos.longitude;
      Provider.of<MapPro>(context, listen: false).pickupController.text = await getAddressFromLatLng(pos.latitude,pos.longitude);
      Navigator.pushReplacementNamed(context, Routes.HOME);
    }
    else{
      while(true){
        if(await ConstanceData.handleLocationPermission(context)){
          break;
        }
      }
      var pos = await Geolocator.getCurrentPosition();
      print("Latitude  is : ${pos.latitude}");
      print("Longitude is : ${pos.longitude}");
      Provider.of<MapPro>(context, listen: false).londonLatLong = LatLng(pos.latitude, pos.longitude);
      Navigator.pushReplacementNamed(context, Routes.INTRODUCTION);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height, minWidth: MediaQuery.of(context).size.width),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: 150,
                height: 150,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform(
                      transform: new Matrix4.translationValues(
                          0.0,
                          80 *
                              (1.0 -
                                  (AlwaysStoppedAnimation(Tween(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                          .value)
                                      .value),
                          0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(38.0),
                        ),
                        elevation: 12,
                        child: Image.asset(ConstanceData.appIcon),
                      ),
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return Transform(
                    transform: Matrix4.translationValues(0.0, 120 * (1.0 -
                                (AlwaysStoppedAnimation(Tween(begin: 0.2, end: 1.0)
                                            .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                        .value)
                                    .value),
                        0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                        opacity: animationController.value,
                        child: Text(
                          AppLocalizations.of('My Cab'),
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: SizedBox(),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Transform(
                        transform: new Matrix4.translationValues(
                            0.0,
                            160 *
                                (1.0 -
                                    (AlwaysStoppedAnimation(Tween(begin: 0.4, end: 1.0)
                                                .animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn)))
                                            .value)
                                        .value),
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
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
