import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';

import '../../providers/mappro.dart';
class MapPinSelectionView extends StatefulWidget {
  final String barText;
  final GoogleMapController mapController;
  final VoidCallback callback, gpsClick, onBackClick;
  const MapPinSelectionView({super.key,
    required this.mapController,
    required this.callback,
    required this.gpsClick,
    required this.barText,
    required this.onBackClick});


  @override
  State<MapPinSelectionView> createState() => _MapPinSelectionViewState();
}

class _MapPinSelectionViewState extends State<MapPinSelectionView> {
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(ConstanceData.endPin),
              ),
              const SizedBox(
                width: 80,
                height: 80,
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32),
                  ),
                ),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          widget.onBackClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
                          child: Text(
                            widget.barText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Column(
              children: <Widget>[
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
                          widget.gpsClick();
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 16,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          LatLngBounds visibleRegion = await widget.mapController.getVisibleRegion();
                          LatLng centerLatLng = LatLng(
                            (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
                            (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) / 2,
                          );
                          print(centerLatLng.latitude);
                          print(centerLatLng.longitude);
                          if(Provider.of<MapPro>(context,listen:false).isPickup){
                            Provider.of<MapPro>(context, listen: false).pickupController.text = await getAddressFromLatLng(centerLatLng.latitude, centerLatLng.longitude);
                          }else{
                            Provider.of<MapPro>(context, listen: false).dropController.text = await getAddressFromLatLng(centerLatLng.latitude, centerLatLng.longitude);
                          }
                          widget.onBackClick();
                        },
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of('Apply'),
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
              ],
            ),
          ],
        ),
      ],
    );
  }
}
