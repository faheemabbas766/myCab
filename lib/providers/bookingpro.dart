import 'package:flutter/cupertino.dart';
import 'package:my_cab/models/booking_details_model.dart';

class BookingPro extends ChangeNotifier{
  String currentBookingId = '';
  late BookingData currentBooking;
  void notifyListnerz(){
    notifyListeners();
  }
}