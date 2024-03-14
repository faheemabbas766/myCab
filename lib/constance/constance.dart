import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_cab/Language/LanguageData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:provider/provider.dart';
import '../providers/mappro.dart';
import 'package:http/http.dart'as http;

class ConstanceData {
  static const IOS_AppId = "id1474463719";
  static const IOS_APP_Link = "https://apps.apple.com/app//$IOS_AppId";
  static const LOCATION_MODE = "Location_Mode";
  static const THEME_MODE = 'theme_Mode';
  static const User_Login_Time = 'User_Login_Time';
  static const LAST_PDF_Time = 'LAST_PDF_TIME';
  static const IsFirstTime = 'IsFirstTime';
  static const IsMapType = "IsMapType";
  static const PreviousSearch = 'Previous_Search';

  static const NoInternet = 'No internet connection !!!\nPlease, try again later.';
  static const SuccsessfullRiderProfile = 'Your Profile create Successfully';
  static const BaseImageUrl = 'assets/images/';
  static final appIcon = BaseImageUrl + "app_icon.png";
  static final buildingImageBack = BaseImageUrl + "building_image_back.png";
  static final buildingImage = BaseImageUrl + "building_image.png";
  static final mapImage2 = BaseImageUrl + "map_image2.jpg";
  static final mapImage3 = BaseImageUrl + "map_image3.jpg";
  static final carImage = BaseImageUrl + "car_image.png";
  static final userImage = BaseImageUrl + "userImage.png";
  static final startPin = BaseImageUrl + "map_pin_start_image.png";
  static final endPin = BaseImageUrl + "map_pin_end_image.png";
  static final user1 = BaseImageUrl + "1.jpg";
  static final user2 = BaseImageUrl + "2.jpg";
  static final user3 = BaseImageUrl + "3.jpg";
  static final user4 = BaseImageUrl + "4.jpg";
  static const user5 = "${BaseImageUrl}5.jpg";
  static final user6 = BaseImageUrl + "6.jpg";
  static final user7 = BaseImageUrl + "7.jpg";
  static final user8 = BaseImageUrl + "8.jpg";
  static final user9 = BaseImageUrl + "9.jpg";
  static final star = BaseImageUrl + "star.png";
  static final gift = BaseImageUrl + "gift.png";
  static final coin = BaseImageUrl + "coin.png";
  static const mapCar = "${BaseImageUrl}top_car.png";
  static final startmapPin = BaseImageUrl + "start_pin.png";
  static final endmapPin = BaseImageUrl + "end_pin.png";

  static double metersToLongitudeDegrees(distance, latitude) {
    var earthEqRadius = 6378137.0;
    var e2 = 0.00669447819799;
    var epsilon = 1e-12;
    var radians = degreesToRadians(latitude);
    var number = math.cos(radians) * earthEqRadius * math.pi / 180;
    var denom = 1 / math.sqrt(1 - e2 * math.sin(radians) * math.sin(radians));
    var deltaDeg = number * denom;
    if (deltaDeg < epsilon) {
      return distance > 0 ? 360 : 0;
    }
    return math.min(360, distance / deltaDeg);
  }

  static Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    print(':::::::::::::::::::::::::::::::Location Access gained Successfully!!!');
    return true;
  }

  static double wrapLongitude(double longitude) {
    if (longitude <= 180 && longitude >= -180) {
      return longitude;
    }
    var adjusted = longitude + 180;
    if (adjusted > 0) {
      return (adjusted % 360) - 180;
    }
    return 180 - (-adjusted % 360);
  }

  static double degreesToRadians(double number) {
    return number * math.pi / 180;
  }

  static String getDriverToUserDistance(int distanceInMeter) {
    if (distanceInMeter < 600) {
      return '~$distanceInMeter ${AppLocalizations.of('meter')}';
    } else {
      return '~ ${(distanceInMeter / 1000).toStringAsFixed(2)} ${AppLocalizations.of('Km')}';
    }
  }

  static double getCarAngle(LatLng startPoint, LatLng lastPoint) {
    var spoint = math.Point(startPoint.latitude, startPoint.longitude);
    var epoint = math.Point(lastPoint.latitude, lastPoint.longitude);
    var newpoint = math.Point(epoint.x - spoint.x, epoint.y - spoint.y);
    double angle = -math.atan2(newpoint.x, newpoint.y);
    var bearingDegrees = (angle * (180.0 / math.pi)) - 90; // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees));
    return bearingDegrees;
    }

  static Future<void> getLocationCoordinates(String location,BuildContext context,{bool isPickup=true}) async {
    const apiKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4';
    final geocodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey';
    final response = await http.get(Uri.parse(geocodeUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final geometry = result['geometry'];
        final location = geometry['location'];
        final latitude = location['lat'];
        final longitude = location['lng'];
        if(isPickup){
          Provider.of<MapPro>(context, listen: false).plat = latitude;
          Provider.of<MapPro>(context, listen: false).plong = longitude;
        }else{
          Provider.of<MapPro>(context, listen: false).dlat = latitude;
          Provider.of<MapPro>(context, listen: false).dlong = longitude;
        }
      }
    } else {
      throw Exception('Failed to load location coordinates');
    }
    return;
  }

  static Future<List<LatLng>> getRoutePolyLineList(BuildContext context) async {
    List<List<double>> list = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4',
      PointLatLng(
          Provider.of<MapPro>(context, listen: false).plat,
          Provider.of<MapPro>(context, listen: false).plong
      ),
      PointLatLng(
          Provider.of<MapPro>(context, listen: false).dlat,
          Provider.of<MapPro>(context, listen: false).dlong
      ),
      travelMode: TravelMode.driving,
      wayPoints: Provider.of<MapPro>(context, listen: false)
          .stopsLatLongList.map((e) => PolylineWayPoint(location: "${e.latitude},${e.longitude}", stopOver: true)).toList());
    if (result.points.isNotEmpty) {
      list.clear();
      for (var point in result.points) {
        list.add([point.latitude, point.longitude]);
      }
    }
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }

  static List<LatLng> getCarFivePolyLineList() {
    List<List<double>> list = [
      [51.51236636049556, -0.09356249123811722],
      [51.51229896402191, -0.09328354150056839],
    ];
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }

  static List<LatLng> getCarFourPolyLineList() {
    List<List<double>> list = [
      [51.51087380781165, -0.09328722953796387],
      [51.510777822042726, -0.09271189570426941],
    ];
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }

  static List<LatLng> getCarThreePolyLineList() {
    List<List<double>> list = [
      [51.50405810696251, -0.08155558258295059],
      [51.50408795043946, -0.08163772523403168],
    ];
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }

  static List<LatLng> getCarTwoPolyLineList() {
    List<List<double>> list = [
      [51.50145434488205, -0.09303979575634003],
      [51.501525305423016, -0.09297776967287064],
    ];
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }

  static List<LatLng> getCarOnePolyLineList() {
    List<List<double>> list = [
      [51.50970923637943, -0.08697733283042908],
      [51.50963286315794, -0.08636679500341415],
    ];
    return list.map((f) => LatLng(f[0], f[1])).toList();
  }
}

// Locale locale;
String locale = "en";
AllTextData allTextData = AllTextData(allText: []);
