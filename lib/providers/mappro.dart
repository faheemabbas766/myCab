import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPro with ChangeNotifier {
  double plat = 51.50470714600269;
  double plong = -0.09019766002893448;
  double dlat = 51.50973156404568;
  double dlong = -0.08060239255428314;
  List<LatLng> poliList = [];
  String pickup = '';
  String dropoff = '';
  notifyListenerz() {
    notifyListeners();
  }
}