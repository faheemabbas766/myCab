import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/models/all_booking_model.dart';
import 'package:my_cab/models/booking_details_model.dart';
import 'package:provider/provider.dart';
import '../../Api & Routes/api.dart';
import '../../Language/appLocalizations.dart';
import '../../constance/themes.dart';
import '../../providers/bookingpro.dart';
import '../../providers/mappro.dart';
import '../chat/chat_Screen.dart';
class BookingDetailsScreen extends StatefulWidget {
  final String id;

  const BookingDetailsScreen({required this.id,super.key});
  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool isLoading = true;
  Map<MarkerId, Marker> getMarkerList(BuildContext context) {
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    const MarkerId markerId2 = MarkerId('start');
    final Marker marker2 = Marker(
      markerId: markerId2,
      position: Provider.of<MapPro>(context,listen: false).londonLatLong,
      anchor: const Offset(0.5, 0.5),
      icon: BitmapDescriptor.defaultMarker, // Use named constructor
    );
    markers.addAll({markerId2: marker2});
    return markers;
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {
    BookingDetails a = await API.getBookingById(widget.id);
    Provider.of<BookingPro>(context,listen: false).currentBooking = a.data;
    setState(() {
    isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: isLoading?Center(child: CircularProgressIndicator(),):
    Column(
      children: [
        Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: Provider.of<MapPro>(context,listen: false).londonLatLong,
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
              onCameraIdle: () {},
            )
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: globals.isLight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 0,
                left: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: globals.isLight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: globals.isLight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).dividerColor.withOpacity(0.03),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  Provider.of<BookingPro>(context,listen: false).currentBooking.employeeImage?? "",
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.driverName??""),
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.employeePhvBadge??""),
                                        style: Theme.of(context).textTheme.button!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).dividerColor.withOpacity(0.4),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: HexColor("#4353FB"),
                                      child: const Center(
                                        child: Icon(
                                          FontAwesomeIcons.facebookMessenger,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: const Center(
                                      child: Icon(
                                        FontAwesomeIcons.phoneAlt,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 0.5,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                FontAwesomeIcons.car,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('VEHICLE'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.vehicleUvMake??""),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('REG NO'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.vehicleUvRegNum??""),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('COLOR'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.vehicleUvColor??""),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('DISTANCE'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of("${Provider.of<BookingPro>(context,listen: false).currentBooking.bmDistance?.substring(0,6)} miles"),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('TIME'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(Provider.of<BookingPro>(context,listen: false).currentBooking.bmDistanceTime??""),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('PRICE'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of("${Provider.of<BookingPro>(context,listen: false).currentBooking.totalAmount??""}£"),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.titleLarge!.color,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50,right: 50),
                          child: Row(
                            children: <Widget>[
                              const Text('Trace driver on map',),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  print('pickup');
                                },
                                child: Icon(
                                  Icons.my_location_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(24.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.of(context).dividerColor,
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              size: 80,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            Text(
                                              AppLocalizations.of('Are you sure want \nto cancel Booking?'),
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                color: Theme.of(context).textTheme.titleMedium!.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
                                              child: Text(
                                                AppLocalizations.of('Your booking has been confirmed. Driver will pickup you in 2 minutes.'),
                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                  color: Theme.of(context).disabledColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Divider(
                                              height: 0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16, left: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of('Cancel'),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        color: Theme.of(context).disabledColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Theme.of(context).dividerColor,
                                                    width: 0.5,
                                                    height: 48,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Text(
                                                      AppLocalizations.of('Done'),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.only(top: 16),
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                  child:  Text(
                                    AppLocalizations.of('Cancel Request'),
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );
  }
}
