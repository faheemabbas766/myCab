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
];
class AddressSectionView extends StatefulWidget {
  final AnimationController animationController;
  final bool isUp, isSearchMode;
  final Function(bool) onUp, onSearchMode;
  final TextEditingController searchController;
  final VoidCallback mapCallBack, gpsClick,callback;
  const AddressSectionView({super.key,
    required this.callback,
    required this.animationController,
    required this.isUp,
    required this.onUp,
    required this.isSearchMode,
    required this.onSearchMode,
    required this.searchController,
    required this.mapCallBack,
    required this.gpsClick});
  @override
  State<AddressSectionView> createState() => _AddressSectionViewState();
}
class _AddressSectionViewState extends State<AddressSectionView> {
  Future<void> getLocationCoordinates(String location,{bool isPickup=true}) async {
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
  List<String> pickupSuggestion = [];
  List<String> dropSuggestion = [];
  List<List<String>> stopSuggestion = [[], [], [], [], [],];
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
  Future<void> onPickupChanged(String query) async {
    _onTextChanged(query, Provider.of<MapPro>(context, listen: false).pickupController, pickupSuggestion);
  }
  void onDropOffChanged(String query) {
    _onTextChanged(query, Provider.of<MapPro>(context, listen: false).dropController, dropSuggestion);
  }
  void onStopChanged(String query, int index) {
    _onTextChanged(query, Provider.of<MapPro>(context, listen: false).stopsListController[index], stopSuggestion[index]);
  }
  Widget buildSuggestionsList(List<String> suggestions, TextEditingController controller) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            const Text('Choose on Map',style: TextStyle(fontSize: 10)),
            InkWell(
              onTap: () {
                print('pickup');
                if(controller == Provider.of<MapPro>(context, listen: false).dropController){
                  Provider.of<MapPro>(context,listen:false).isPickup = false;
                  widget.mapCallBack();
                }else{
                  Provider.of<MapPro>(context,listen:false).isPickup = true;
                  widget.mapCallBack();
                }
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
        ListView.builder(
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
        ),
      ],
    );
  }
  void loadData(){
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget? child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 16,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
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
                          final animatedPosition =
                              (position - 100) / ((MediaQuery
                                  .of(context)
                                  .size
                                  .height - 220) + MediaQuery
                                  .of(context)
                                  .padding
                                  .bottom);
                          widget.animationController.animateTo(
                              animatedPosition, duration: const Duration(
                              milliseconds: 0));
                        },
                        onVerticalDragEnd: (DragEndDetails gragEndDetails) {
                          if (widget.isUp) {
                            widget.onSearchMode(true);
                            widget.animationController.animateTo(0,
                                duration: const Duration(milliseconds: 240));
                          } else {
                            widget.onSearchMode(false);
                            widget.animationController.animateTo(1,
                                duration: const Duration(milliseconds: 240));
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
                                              style: Theme.of(context).textTheme.labelMedium,
                                              controller: Provider.of<MapPro>(context, listen: false).pickupController,
                                              cursorColor: Theme.of(context).primaryColor,
                                              maxLines: 2,
                                              decoration: InputDecoration(
                                                hintText: 'Your Location',
                                                errorText: null,
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                              ),
                                            ),
                                            if (pickupSuggestion.isNotEmpty)
                                              buildSuggestionsList(pickupSuggestion, Provider.of<MapPro>(context, listen: false).pickupController),
                                          ],
                                        ),
                                      ),
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
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: Provider.of<MapPro>(context, listen: false).stopsListController.length,
                              itemBuilder: (context, index) {
                                var item = Provider.of<MapPro>(context, listen: false).stopsListController[index];
                                return Column(
                                  children: [
                                    Container(
                                      color:Theme.of(context).primaryColorLight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(width: 24, height: 24, child: Icon(Icons.stop_circle_sharp,color: Theme.of(context).primaryColor,)),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 8, left: 4, right: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: [
                                                        Text('Stop-${index+1}',style: Theme.of(context).textTheme.bodySmall),
                                                        const Spacer(),
                                                        Text(AppLocalizations.of('Optional'), style: Theme.of(context).textTheme.bodySmall),
                                                      ],
                                                    ),
                                                    TextFormField(
                                                      maxLines: 1,
                                                      onChanged: (value){
                                                        onStopChanged(value, index);
                                                      },
                                                      style: Theme.of(context).textTheme.labelMedium,
                                                      controller: item,
                                                      cursorColor: Theme.of(context).primaryColor,
                                                      decoration: InputDecoration(
                                                        hintText: 'Stop Address here',
                                                        errorText: null,
                                                        border: InputBorder.none,
                                                        hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                                      ),
                                                    ),
                                                    if (stopSuggestion[index].isNotEmpty)
                                                      buildSuggestionsList(stopSuggestion[index], item),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    Provider.of<MapPro>(context, listen: false).stopsListController.removeAt(index);
                                                    setState(() {
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.delete,
                                                      color: Theme.of(context).textTheme.titleLarge!.color,
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
                                );
                              },),
                            const SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 24, height: 24, child: Icon(Icons.pin_drop,color: Theme.of(context).primaryColor,)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8, left: 4, right: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text('Drop-off',style: Theme.of(context).textTheme.bodySmall),
                                              const Spacer(),
                                              Text(AppLocalizations.of('Destination'), style: Theme.of(context).textTheme.bodySmall),
                                            ],
                                          ),
                                          TextFormField(
                                            maxLines: 2,
                                            onChanged: onDropOffChanged,
                                            style: Theme.of(context).textTheme.labelMedium,
                                            controller: Provider.of<MapPro>(context, listen: false).dropController,
                                            cursorColor: Theme.of(context).primaryColor,
                                            decoration: InputDecoration(
                                              hintText: 'Your Destination',
                                              errorText: null,
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                            ),
                                          ),
                                          if (dropSuggestion.isNotEmpty)
                                            buildSuggestionsList(dropSuggestion, Provider.of<MapPro>(context, listen: false).dropController),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 24,
                                        width: 1,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if(Provider.of<MapPro>(context, listen: false).stopsListController.length<5){
                                            Provider.of<MapPro>(context, listen: false).stopsListController.add(TextEditingController());
                                          }else{
                                            ft.Fluttertoast.showToast(
                                              msg: "Can't add more than 5 Stops",
                                              toastLength: ft.Toast.LENGTH_LONG,
                                            );
                                          }
                                          print("${Provider.of<MapPro>(context, listen: false).stopsListController.length}Controller Added");
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
                                ],
                              ),
                            ),
                          ],
                        ),
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
                                  if(Provider.of<MapPro>(context, listen: false).pickupController.text.isEmpty || Provider.of<MapPro>(context, listen: false).dropController.text.isEmpty){
                                    ft.Fluttertoast.showToast(
                                      msg: "Pickup and Destination is Required!",
                                      toastLength: ft.Toast.LENGTH_LONG,
                                    );
                                  }else{
                                    await getLocationCoordinates(Provider.of<MapPro>(context, listen: false).pickupController.text);
                                    await getLocationCoordinates(Provider.of<MapPro>(context, listen: false).dropController.text, isPickup: false);
                                    Provider.of<MapPro>(context, listen: false).poliList = await ConstanceData.getRoutePolyLineList(context);
                                    Provider.of<MapPro>(context, listen: false).calculateCenter();
                                    Provider.of<MapPro>(context, listen: false).getStopsCoordinates();
                                    widget.gpsClick();
                                    widget.callback();
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
              ),
            );
          },
        ),
      ],
    );
  }
}