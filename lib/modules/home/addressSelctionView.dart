import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart'as ft;
import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';
import '../../providers/mappro.dart';
List<String> notes = [
  AppLocalizations.of('University of Washington'),
  AppLocalizations.of('Woodland Park'),
  AppLocalizations.of('Husky Stadium'),
  AppLocalizations.of('Ravenna Park'),
  AppLocalizations.of('Henev Art Gallery'),
];

class AddressSectionView extends StatefulWidget {
  final AnimationController animationController;
  final bool isUp, isSerchMode;
  final Function(bool) onUp, onSerchMode;
  final TextEditingController serachController;
  final VoidCallback mapCallBack, gpsClick;

  const AddressSectionView({super.key,
    required this.animationController,
    required this.isUp,
    required this.onUp,
    required this.isSerchMode,
    required this.onSerchMode,
    required this.serachController,
    required this.mapCallBack,
    required this.gpsClick});
  @override
  State<AddressSectionView> createState() => _AddressSectionViewState();
}
class _AddressSectionViewState extends State<AddressSectionView> {

  Future<void> getLocationCoordinates(String location,{bool isPickup=true}) async {
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
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  List<String> pickupSuggestion = [];
  List<String> dropSuggestion = [];
  List<List<String>> stopSuggestion = [[], [], [], [], [],];
  List<DropdownMenuItem<int>> get items =>
      [
        const DropdownMenuItem<int>(
          value: 1,
          child: Text('Cash'),
        ),
        const DropdownMenuItem<int>(
          value: 2,
          child: Text('Account'),
        ),
      ];
  List<TextEditingController> stopsListController = [];
  Future<List<String>> getLocationSuggestions(String query) async {
    const apiKey = 'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4&libraries=places&callback=initializeMaps';
    const components = 'country:GB';
    final placesUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&components=$components';
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

  void _onTextChanged(String query, TextEditingController controller,
      List<String> suggestions) {
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

  Future<void> onPickupChanged(String query) async {
    _onTextChanged(query, _pickupController, pickupSuggestion);
  }

  void onDropOffChanged(String query) {
    _onTextChanged(query, _dropController, dropSuggestion);
  }

  void onStopChanged(String query, int index) {
    _onTextChanged(query, stopsListController[index], stopSuggestion[index]);
  }

  Widget buildSuggestionsList(List<String> suggestions,
      TextEditingController controller) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion,style: const TextStyle(fontSize: 10),),
          onTap: () {
            controller.text = suggestion;
            setState(() {
              suggestions.clear();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            const Expanded(
              child: SizedBox(),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 340 ? 54 : 48,
                height: MediaQuery.of(context).size.width > 340 ? 54 : 48,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(54.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.gps_fixed,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      size: MediaQuery.of(context).size.width > 340 ? 28 : 26,
                    ),
                    onPressed: () async {
                      try {
                        widget.gpsClick();
                      } catch (e) {

                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(
                  0.0,410*((AlwaysStoppedAnimation(
                              Tween(begin: 0.0, end: 1.0).animate(
                                  CurvedAnimation(
                                      parent: widget.animationController,
                                      curve: Curves.fastOutSlowIn)))
                              .value)
                              .value),
                  0.0),
              child: Card(
                elevation: 16,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onVerticalDragUpdate: (DragUpdateDetails gragEndDetails) {
                        if (gragEndDetails.delta.dy > 0) {
                          widget.onUp(false);
                        } else if (gragEndDetails.delta.dy < 0) {
                          widget.onUp(true);
                        }
                        final position = gragEndDetails.globalPosition.dy
                            .clamp(0, (MediaQuery
                            .of(context)
                            .size
                            .height - 220) + MediaQuery
                            .of(context)
                            .padding
                            .bottom) +
                            36 +
                            gragEndDetails.delta.dy;
                        final animatedPostion =
                            (position - 100) / ((MediaQuery
                                .of(context)
                                .size
                                .height - 220) + MediaQuery
                                .of(context)
                                .padding
                                .bottom);
                        widget.animationController.animateTo(
                            animatedPostion, duration: const Duration(
                            milliseconds: 0));
                      },
                      onVerticalDragEnd: (DragEndDetails gragEndDetails) {
                        if (widget.isUp) {
                          widget.onSerchMode(true);
                          widget.animationController.animateTo(0,
                              duration: Duration(milliseconds: 240));
                        } else {
                          widget.onSerchMode(false);
                          widget.animationController.animateTo(1,
                              duration: Duration(milliseconds: 240));
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Theme
                                .of(context)
                                .cardColor,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .disabledColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  child: const SizedBox(
                                    height: 4,
                                    width: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 24, height: 24, child: Image.asset(ConstanceData.startPin)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text('Pickup',style: Theme.of(context).textTheme.bodySmall),
                                              const Spacer(),
                                              Text(AppLocalizations.of('Current Location'), style: Theme.of(context).textTheme.bodySmall),
                                            ],
                                          ),
                                          TextFormField(
                                            onChanged: onPickupChanged,
                                            maxLines: 1,
                                            style: Theme.of(context).textTheme.titleSmall,
                                            controller: _pickupController,
                                            cursorColor: Theme.of(context).primaryColor,
                                            decoration: InputDecoration(
                                              hintText: 'Your Location',

                                              errorText: null,
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                            ),
                                          ),
                                          if (pickupSuggestion.isNotEmpty)
                                            buildSuggestionsList(pickupSuggestion, _pickupController),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          if (widget.isSerchMode) {
                                            widget.onSerchMode(false);
                                            widget.animationController.animateTo(1, duration: Duration(milliseconds: 240));
                                          } else {
                                            widget.onSerchMode(true);
                                            widget.animationController.animateTo(0, duration: Duration(milliseconds: 240));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            widget.isSerchMode ? Icons.close : Icons.search,
                                            color: Theme.of(context).textTheme.titleLarge!.color,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          widget.mapCallBack();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.map,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            endIndent: 8,
                            indent: 8,
                            height: 1,
                          ),
                        ],
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: stopsListController.length,
                      itemBuilder: (context, index) {
                        var item = stopsListController[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 24, height: 24, child: Image.asset(ConstanceData.endPin)),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(AppLocalizations.of('${index+1} Stop'), style: Theme.of(context).textTheme.bodySmall),
                                      const SizedBox(height: 15,),
                                      SizedBox(
                                        height: 24,
                                        child: TextFormField(
                                          onChanged: (value){
                                            onStopChanged(value, index);
                                          },
                                          maxLines: 1,
                                          style: Theme.of(context).textTheme.titleSmall,
                                          controller: item,
                                          cursorColor: Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            hintText: 'Enter Stop Address',
                                            errorText: null,
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                          ),
                                        ),
                                      ),
                                      if (stopSuggestion[index].isNotEmpty)
                                        buildSuggestionsList(stopSuggestion[index], item),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        stopsListController.removeAt(index);
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.close,
                                          color: Theme.of(context).textTheme.titleLarge!.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 24, height: 24, child: Image.asset(ConstanceData.endPin)),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(AppLocalizations.of('Drop-off'), style: Theme.of(context).textTheme.bodySmall),
                                  SizedBox(height: 15,),
                                  SizedBox(
                                    height: 24,
                                    child: TextFormField(
                                      onChanged: onDropOffChanged,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.titleSmall,
                                      controller: _dropController,
                                      cursorColor: Theme.of(context).primaryColor,
                                        decoration: InputDecoration(
                                          hintText: 'Your destination',
                                          errorText: null,
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                        ),
                                    ),
                                  ),
                                  if (dropSuggestion.isNotEmpty)
                                    buildSuggestionsList(dropSuggestion, _dropController),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (!widget.isSerchMode) {
                                      print('abc');
                                      widget.onSerchMode(true);
                                      widget.animationController.animateTo(0, duration: Duration(milliseconds: 240));
                                    } else {
                                      print('xyz');
                                    }
                                    if(stopsListController.length<5){
                                      stopsListController.add(TextEditingController());
                                    }else{
                                      ft.Fluttertoast.showToast(
                                        msg: "Can't add more than 5 Stops",
                                        toastLength: ft.Toast.LENGTH_LONG,
                                      );
                                    }
                                    print("${stopsListController.length}Controller Added");
                                    setState(() {

                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.add_location_alt_sharp,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      endIndent: 8,
                      indent: 8,
                      height: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16),),
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                if(_pickupController.text.isEmpty || _dropController.text.isEmpty){
                                  ft.Fluttertoast.showToast(
                                    msg: "Pickup and Destination is Required!",
                                    toastLength: ft.Toast.LENGTH_LONG,
                                  );
                                }else{
                                  Provider.of<MapPro>(context, listen: false).pickup = _pickupController.text;
                                  Provider.of<MapPro>(context, listen: false).dropoff = _dropController.text;
                                  await getLocationCoordinates(Provider.of<MapPro>(context, listen: false).pickup);
                                  await getLocationCoordinates(Provider.of<MapPro>(context, listen: false).dropoff, isPickup: false);
                                  widget.mapCallBack();
                                }
                              },
                              child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      AppLocalizations.of('Check Price'),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.bottom,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}