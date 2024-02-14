import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../drawer/drawer.dart';
class AddBookingScreen extends StatefulWidget {
  const AddBookingScreen({super.key});

  @override
  State<AddBookingScreen> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<AddBookingScreen> {
  bool isSelectingPickup = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _passengerController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _flightController = TextEditingController();
  final TextEditingController _luggageMediumController = TextEditingController();
  final TextEditingController _luggageLargeController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  final List<String> _pickupSuggestions = [];
  final List<String> _dropSuggestions = [];
  double pickupLatitude = 0;
  double pickupLongitude = 0;
  double dropLatitude = 0;
  double dropLongitude = 0;
  String carId = '1';
  String paymentMethod = '1';

  Future<List<String>> getLocationSuggestions(String query) async {
    const apiKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4&libraries=places&callback=initializeMaps';
    final placesUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey';

    final response = await http.get(Uri.parse(placesUrl));

    if (response.statusCode == 200) {
      final suggestions = <String>[];
      final data = json.decode(response.body);

      if (data['predictions'] != null) {
        for (final prediction in data['predictions']) {
          final description = prediction['description'];
          suggestions.add(description);
        }
      }

      return suggestions;
    } else {
      throw Exception('Failed to load place suggestions');
    }
  }
  Future<void> getLocationCoordinates(String location, TextEditingController controller) async {
    const apiKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4&libraries=places&callback=initializeMaps';
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
        print(latitude.toString());
        print(longitude.toString());
        if (controller == _pickupController) {
          pickupLatitude = latitude;
          pickupLongitude = longitude;
          print('PickUp Lat:::::::::::::::::::::::::::$pickupLatitude');
          print('PickUp Long:::::::::::::::::::::::::::$pickupLongitude');

        } else if (controller == _dropController) {
          dropLatitude = latitude;
          dropLongitude = longitude;
          print('Drop Lat:::::::::::::::::::::::::::$dropLatitude');
          print('Drop Long:::::::::::::::::::::::::::$dropLongitude');
        }
      }
    } else {
      throw Exception('Failed to load location coordinates');
    }
  }
  Future<void> sendBookingData(Map<String, dynamic> bookingData) async {
    final apiUrl = Uri.parse(
        'https://minicab.imdispatch.co.uk/api/customeraddjob');

    try {
      final response = await http.post(
        apiUrl,
        body: bookingData,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Booking successful!');
        }
      } else {
        // Handle errors, e.g., show an error message
        if (kDebugMode) {
          print('Booking failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      // Handle network or other exceptions
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }
  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime),);
      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = selectedDateTime;
          _dateTimeController.text =
              DateFormat("yyyy-MM-dd HH:mm").format(selectedDateTime);
        });
      }
    }
  }
  Future<void> _confirmBooking() async {
    try{
      await getLocationCoordinates(_pickupController.text, _pickupController);
      await getLocationCoordinates(_dropController.text, _dropController);
    }catch(e){
      print(e.toString());
    }
    final Map<String, dynamic> bookingData = {
      'car_id': carId,
      'Phone': _phoneController.text,
      'Name': _nameController.text,
      'DateTime': _selectedDateTime.toString(),
      'pickup': _pickupController.text,
      'destination': _dropController.text,
      'plat': pickupLatitude.toString(),
      'plang': pickupLongitude.toString(),
      'dlat': dropLatitude.toString(),
      'dlang': dropLongitude.toString(),
      'passenger': _passengerController.text,
      'flight': _flightController.text,
      'medium_lugg': _luggageMediumController.text,
      'payment_method': paymentMethod,
      'driver_id':"driverId",
      'large_lugg': _luggageLargeController.text,
    };

    await sendBookingData(bookingData);
  }
  void _onTextChanged(String query, TextEditingController controller, List<String> suggestions) {
    if (query.isNotEmpty) {
      getLocationSuggestions(query).then((results) {
        setState(() {
          suggestions.clear();
          suggestions.addAll(results);
        });
      });
    } else {
      setState(() {
        suggestions.clear();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    void onPickupChanged(String query) {
      _onTextChanged(query, _pickupController, _pickupSuggestions);
    }
    void onDropChanged(String query) {
      _onTextChanged(query, _dropController, _dropSuggestions);
    }
    Widget buildSuggestionsList(List<String> suggestions, TextEditingController controller) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ListTile(
              title: Text(suggestion),
              onTap: () {
                controller.text = suggestion;
                setState(() {
                  suggestions.clear();
                });
              },
            );
          },
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
          child: const Drawer(
            child: AppDrawer(
              selectItemName: 'Add Job',
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height + 40,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Icon(
                        Icons.dehaze,
                        color: Theme.of(context).textTheme.titleLarge!.color,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text('Add Booking',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height + 40,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pickup:",
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 15, fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _pickupController,
                  onChanged: onPickupChanged,
                  decoration: InputDecoration(
                      hintText: "Enter Your Pickup location",
                      filled: true,
                      fillColor: Theme.of(context).secondaryHeaderColor),
                ),
              ),
              if (_pickupSuggestions.isNotEmpty)
                buildSuggestionsList(_pickupSuggestions, _pickupController),
              const SizedBox(height: 10.0),
              Text(
                "Destination:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _dropController,
                  onChanged: onDropChanged,
                  decoration: InputDecoration(
                      hintText: "Enter Your Pickup location",
                      filled: true,
                      fillColor: Theme.of(context).secondaryHeaderColor),
                ),
              ),
              if (_dropSuggestions.isNotEmpty)
                buildSuggestionsList(_dropSuggestions, _dropController),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    "Cars",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Payment by:",
                    style: TextStyle(fontSize: 16,color: Theme.of(context).secondaryHeaderColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: DropdownButton<String>(
                      value: carId,
                      dropdownColor: Theme.of(context).secondaryHeaderColor,
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                      onChanged: (String? newValue) {
                        setState(() {
                          carId = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: "Select",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Select",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "1",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Saloon",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "2",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Executive",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "3",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "6 Seater",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "4",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "8 Seater",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: DropdownButton<String>(
                      value: paymentMethod,
                      style: TextStyle(color: Colors.red),
                      onChanged: (String? newValue) {
                        setState(() {
                          paymentMethod = newValue!;
                        });
                      },
                      dropdownColor: Theme.of(context).secondaryHeaderColor,
                      items: [
                        DropdownMenuItem<String>(
                          value: "select",
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              "Payment Method",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400,color: Theme.of(context).secondaryHeaderColor),
                            ),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: "1",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Cash",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        const DropdownMenuItem<String>(
                          value: "2",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Credit",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),

                        DropdownMenuItem<String>(
                          value: "3",
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              "Account",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Text(
                "Name:",
                style: TextStyle(fontSize: 18, color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    filled: true,
                    fillColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Phone Number:",
                style: TextStyle(fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: "Telephone",
                    filled: true,
                    fillColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Date & Time",
                style: TextStyle(fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _dateTimeController,
                decoration: InputDecoration(
                  labelText: "Select Date and Time",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  await _selectDateAndTime(context);
                },
              ),
              const SizedBox(height: 10.0),
              Text(
                "Passenger:",
                style: TextStyle(fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _passengerController,
                  decoration: InputDecoration(
                    hintText: "Enter Passenger",
                    filled: true,
                    fillColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                "Flight Number:",
                style: TextStyle(fontSize: 18,color: Theme.of(context).secondaryHeaderColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _flightController,
                  decoration: InputDecoration(
                    hintText: "Flight Number",
                    filled: true,
                    fillColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Large Luggage",
                    style: TextStyle(fontSize: 16,color: Theme.of(context).secondaryHeaderColor),
                  ),
                  Text(
                    "Medium Luggage",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).secondaryHeaderColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _luggageLargeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _luggageMediumController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Clear Booking",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _confirmBooking,
                      child: Text(
                        "Confirm Booking",
                        style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}