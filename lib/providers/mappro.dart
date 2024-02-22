import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/car_price_model.dart';

class MapPro with ChangeNotifier {
  double plat = 51.50470714600269;
  double plong = -0.09019766002893448;
  double dlat = 51.50973156404568;
  double dlong = -0.08060239255428314;
  List<LatLng> poliList = [];
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  bool isPickup = true;
  LatLng londonLatLong = const LatLng(51.505939, -0.088727);
  DateTime selectedDateTime = DateTime.now();
  int selectedPaymentMethod = 1;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController flightNoController = TextEditingController();
  final TextEditingController luggageController = TextEditingController();
  List<LatLng> stopsLatLongList = [];
  List<TextEditingController> stopsListController = [];
  Future<void> getStopsCoordinates() async {
    stopsLatLongList = [];
    const apiKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4';
    List<String> addresses = stopsListController.map((controller) => controller.text).toList();
    String joinedAddresses = addresses.join('|');
    final geocodeUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$joinedAddresses&key=$apiKey';
    final response = await http.get(Uri.parse(geocodeUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        List<dynamic> results = data['results'];
        for (var result in results) {
          final geometry = result['geometry'];
          final location = geometry['location'];
          final latitude = location['lat'];
          final longitude = location['lng'];
          LatLng latLng = LatLng(latitude, longitude);
          stopsLatLongList.add(latLng);
        }
      }
    } else {
      throw Exception('Failed to fetch coordinates for addresses');
    }
  }
  CarPriceModel selectedCar = CarPriceModel(
      carId: '0',
      carImage: '',
      distance: '0',
      price: '0',
      formattedTime: '',
      car_name: '');
  notifyListenerz() {
    notifyListeners();
  }
  void calculateCenter() {
    londonLatLong = LatLng(plat, plong);
    notifyListeners();
  }
}