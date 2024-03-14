import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/modules/drawer/drawer.dart';
import 'package:my_cab/modules/home/MapPinSelectionView.dart';
import 'package:my_cab/modules/home/addressSelctionView.dart';
import 'package:my_cab/modules/home/requset_view.dart';
import 'package:provider/provider.dart';
import '../../providers/mappro.dart';
int mapSize = 1;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late GoogleMapController _mapController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchMode = false;
  bool isUp = true;
  late BitmapDescriptor carMapBitmapDescriptor;
  late BitmapDescriptor startMapBitmapDescriptor;
  late BitmapDescriptor endMapBitmapDescriptor;
  late BitmapDescriptor stopMapBitmapDescriptor;
  late BuildContext currentcontext;
  TextEditingController serachController = TextEditingController();
  ProsseType prosseType = ProsseType.dropOff;

  int carOneIndex = 0, carTwoIndex = 0, carThreeIndex = 0, carFourIndex = 0, carFiveIndex = 0;
  List<LatLng> carPointOne = [], carPointTwo = [], carPointThree = [], carPointFour = [], carPointFive = [];

  void setMakerPinSize(BuildContext context) async {
    currentcontext = context;
    final ImageConfiguration imagesStartConfiguration = createLocalImageConfiguration(currentcontext);
    carMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(imagesStartConfiguration, ConstanceData.mapCar);
    final ImageConfiguration startStartConfiguration = createLocalImageConfiguration(currentcontext);
    startMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(startStartConfiguration, ConstanceData.startmapPin);
    final ImageConfiguration endStartConfiguration = createLocalImageConfiguration(currentcontext);
    endMapBitmapDescriptor = await BitmapDescriptor.fromAssetImage(endStartConfiguration, ConstanceData.endmapPin);
    stopMapBitmapDescriptor = BitmapDescriptor.defaultMarkerWithHue(3);
  }
  @override
  void initState() {
    serachController.text = AppLocalizations.of('Set your pickup point');
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));
    animationController.animateTo(1);
    super.initState();
  }
  Map<MarkerId, Marker> getMarkerList(BuildContext context) {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    if (prosseType == ProsseType.requset) {
      const MarkerId markerId2 = MarkerId('start');
      final Marker marker2 = Marker(
        markerId: markerId2,
        position: Provider.of<MapPro>(context, listen: false).poliList.first,
        anchor: const Offset(0.5, 0.5),
        icon: startMapBitmapDescriptor,
      );
      markers.addAll({markerId2: marker2});
      for(int i=0;i< Provider.of<MapPro>(context, listen: false).stopsLatLongList.length;i++){
        final MarkerId markerId = MarkerId('stop$i');
        final Marker marker = Marker(
          markerId: markerId,
          position: Provider.of<MapPro>(context, listen: false).stopsLatLongList[i],
          anchor: const Offset(0.5, 1.0),
          icon: stopMapBitmapDescriptor,
        );
        markers.addAll({markerId: marker});
      }

      const MarkerId markerId = MarkerId('end');
      final Marker marker = Marker(
        markerId: markerId,
        position: Provider.of<MapPro>(context, listen: false).poliList.last,
        anchor: const Offset(0.5, 1.0),
        icon: endMapBitmapDescriptor,
      );
      markers.addAll({markerId: marker});
    }
    return markers;
  }

  Map<PolylineId, Polyline> getPolilineData() {
    Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
    if (Provider.of<MapPro>(context, listen: false).poliList.length > 2 && prosseType == ProsseType.requset) {
      const PolylineId polylineId = PolylineId('123');
      final Polyline polyline = Polyline(
        polylineId: polylineId,
        color: HexColor(globals.primaryRiderColorString),
        consumeTapEvents: false,
        points: Provider.of<MapPro>(context, listen: false).poliList,
        width: Platform.isAndroid ? 4 : 2,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
      polylines.addAll({polylineId: polyline});
      setMakerPinSize(context);
      _addPolylineToMap();
    }
    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    setMakerPinSize(context);
    return Consumer<MapPro>(
        builder: (context, mapPro, _) {
          LatLng londonLatLong = mapPro.londonLatLong;
          return Scaffold(
            key: _scaffoldKey,
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.72 : 350,
              child: const Drawer(
                child: AppDrawer(
                  selectItemName: 'Home',
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height / mapSize,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: londonLatLong,
                      tilt: 30.0,
                      zoom: 16,
                    ),
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    myLocationEnabled: false,
                    buildingsEnabled: false,
                    onCameraMoveStarted: () {},
                    mapType: MapType.normal,
                    markers: Set<Marker>.of(getMarkerList(context).values),
                    onCameraMove: (CameraPosition position) {},
                    polylines: Set<Polyline>.of(getPolilineData().values),
                    onCameraIdle: () {},
                    onMapCreated: (GoogleMapController controller) async {
                      _mapController = controller;
                      setMapStyle();
                    },
                  ),
                ),
                prosseType != ProsseType.mapPin &&
                    prosseType != ProsseType.requset
                    ? _getAppBarUI()
                    : const SizedBox(),
                prosseType == ProsseType.dropOff
                    ? Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: AddressSectionView(
                    callback: () {
                      setState(() {
                        mapSize = 2;
                        prosseType = ProsseType.requset;
                      });
                    },
                    animationController: animationController,
                    isSearchMode: isSearchMode,
                    isUp: isUp,
                    mapCallBack: () {
                      animationController.animateTo(
                          1, duration: const Duration(milliseconds: 480)).then((
                          f) {
                        setState(() {
                          mapSize = 1;
                          prosseType = ProsseType.mapPin;
                        });
                      });
                    },
                    onSearchMode: (onSearchMode) {
                      if (isSearchMode != onSearchMode) {
                        setState(() {
                          mapSize = 1;
                          isSearchMode = onSearchMode;
                        });
                      }
                    },
                    onUp: (onUp) {
                      if (isUp != onUp) {
                        setState(() {
                          mapSize = 1;
                          isUp = onUp;
                        });
                      }
                    },
                    searchController: serachController,
                    gpsClick: () async {
                      ConstanceData.handleLocationPermission(context);
                      _mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: londonLatLong,
                            zoom: 15.0,
                            tilt: 24.0,
                          ),
                        ),
                      );
                      // MyApp.changeTheme(context);
                      setMapStyle();
                    },
                  ),
                )
                    : prosseType == ProsseType.mapPin
                    ? MapPinSelectionView(
                  mapController: _mapController,
                  barText: AppLocalizations.of('Choose a point'),
                  onBackClick: () {
                    setState(() {
                      mapSize = 1;
                      prosseType = ProsseType.dropOff;
                    });
                  },
                  gpsClick: () async {
                    await ConstanceData.handleLocationPermission(context);
                    var pos = await Geolocator.getCurrentPosition();
                    print("Latitude  is : ${pos.latitude}");
                    print("Longitude is : ${pos.longitude}");
                    Provider.of<MapPro>(context, listen: false)
                        .londonLatLong = LatLng(pos.latitude, pos.longitude);
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: londonLatLong,
                          zoom: 16.0,
                          tilt: 24.0,
                        ),
                      ),
                    );
                    // MyApp.changeTheme(context);
                    setMapStyle();
                  },
                  callback: () {
                    setState(() {
                      mapSize = 1;
                      prosseType = ProsseType.requset;
                    });
                  },
                )
                    : RequestView(
                  onBack: () {
                    setState(() {
                      mapSize = 1;
                      prosseType = ProsseType.dropOff;
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  Widget _getAppBarUI() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
          child: Row(
            children: <Widget>[
              SizedBox(
                height: AppBar().preferredSize.height,
                width: AppBar().preferredSize.height,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(2),
                      child: InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: Image.asset(ConstanceData.userImage),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setMapStyle() async {
    if (globals.isLight) {
      _mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("assets/jsonFile/light_mapstyle.json"));
    } else {
      _mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("assets/jsonFile/dark_mapstyle.json"));
    }
  }
  LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
  void _addPolylineToMap() {
    LatLngBounds bounds = calculateBounds(Provider.of<MapPro>(context,listen: false).poliList);
    _mapController.moveCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }
}

enum ProsseType {
  dropOff,
  mapPin,
  requset,
}
