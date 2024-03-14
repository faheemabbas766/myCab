import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/constance.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/models/company_model.dart';
import 'package:my_cab/modules/chat/chat_Screen.dart';
import 'package:my_cab/constance/global.dart' as globals;
import 'package:my_cab/providers/bookingpro.dart';
import 'package:provider/provider.dart';
import '../../Api & Routes/api.dart';
import '../../models/car_price_model.dart';
import '../../providers/homepro.dart';
import '../../providers/mappro.dart';
import '../history/history_Screen.dart';
class RequestView extends StatefulWidget {
  final VoidCallback onBack;
  const RequestView({super.key, required this.onBack,});
  @override
  RequestViewState createState() => RequestViewState();
}

class RequestViewState extends State<RequestView> {

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: Provider.of<MapPro>(context, listen: false).selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(Provider.of<MapPro>(context, listen: false).selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          Provider.of<MapPro>(context, listen: false).selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
  List<PopupMenuEntry<int>> get items => [
    const PopupMenuItem<int>(
      value: 1,
      child: Text('Cash'),
    ),
    const PopupMenuItem<int>(
      value: 2,
      child: Text('Card'),
    ),
    const PopupMenuItem<int>(
      value: 3,
      child: Text('Account'),
    ),
  ];
  bool isVehicleSelected = false;
  List<CarPriceModel> carList = [];
  Future<void> loadData() async {
    carList = await API.getAllCarsPrice(
        Provider.of<MapPro>(context, listen: false).plat,
        Provider.of<MapPro>(context, listen: false).plong,
        Provider.of<MapPro>(context, listen: false).dlat,
        Provider.of<MapPro>(context, listen: false).dlong,
        context);
    Provider.of<MapPro>(context, listen: false).selectedCar = carList[0];
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    if(Provider.of<MapPro>(context, listen: false).selectedCompany.title=='faheem'){
      Provider.of<MapPro>(context, listen: false).selectedCompany = Provider.of<MapPro>(context, listen: false).companyList[0];
    }
    loadData();
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
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          height: AppBar().preferredSize.height,
                          width: AppBar().preferredSize.height,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              child: InkWell(
                                  onTap: () {
                                    if(isVehicleSelected){
                                      isVehicleSelected= false;
                                    }else{
                                      widget.onBack();
                                    }
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).textTheme.titleLarge!.color,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Expanded(
                child: SizedBox(),
              ),
              !isConfrimDriver
                  ? isVehicleSelected?Container(
                color: Theme.of(context).primaryColorLight,
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                    Container(
                      color: Theme.of(context).dividerColor.withOpacity(0.03),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            const Icon(FontAwesomeIcons.car),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(Provider.of<MapPro>(context, listen: false).selectedCar.car_name),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(AppLocalizations.of('Near by you'), style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text('£ ${Provider.of<MapPro>(context, listen: false).selectedCar.price}',
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(AppLocalizations.of(Provider.of<MapPro>(context, listen: false).selectedCar.formattedTime
                                ), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        children: [
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Theme.of(context).dividerColor,
                                  blurRadius: 8,
                                  offset: const Offset(1, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await _selectDateTime(context);
                              },
                              child: Center(
                                child: Text(
                                  AppLocalizations.of('Date & Time'),
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(DateFormat('dd-MM-yyyy\nhh:mm a').format(Provider.of<MapPro>(context, listen: false).selectedDateTime),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color:Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                final RelativeRect position = RelativeRect.fromRect(
                                  Rect.fromPoints(
                                    Offset(0, overlay.size.height/2.5), // Adjust the starting point slightly below (0, 0)
                                    Offset(overlay.size.width, overlay.size.height),
                                  ),
                                  Offset.zero & overlay.size,
                                ).shift(const Offset(0, 250)); // Adjust the shift to move the menu down by 20 pixels

                                int? selectedItem = await showMenu<int>(
                                  context: context,
                                  position: position,
                                  items: items,
                                  elevation: 8,
                                );
                                if (selectedItem != null) {
                                  setState(() {
                                    Provider.of<MapPro>(context, listen: false).selectedPaymentMethod = selectedItem;
                                  });
                                  // Handle the selected item here
                                  print('Selected item: $selectedItem');
                                }
                              },
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Payment'),
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(Provider.of<MapPro>(context, listen: false).selectedPaymentMethod==1?"Cash":"Account"),
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                            height: 48,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Flight No'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            controller: Provider.of<MapPro>(context, listen: false).flightNoController,
                                            decoration: const InputDecoration(
                                              hintText: 'Input Flight No',
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Enter'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Flight No',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  Text(Provider.of<MapPro>(context, listen: false).flightNoController.text==''? "Enter here":Provider.of<MapPro>(context, listen: false).flightNoController.text,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).disabledColor,)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                            height: 48,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Luggage'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            controller: Provider.of<MapPro>(context, listen: false).luggageController,
                                            keyboardType: const TextInputType.numberWithOptions(),
                                            decoration: const InputDecoration(
                                              hintText: 'Input Luggage',
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Enter'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Luggage',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  Text(Provider.of<MapPro>(context, listen: false).luggageController.text==''? "Enter here":Provider.of<MapPro>(context, listen: false).luggageController.text,
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).disabledColor,)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: PopupMenuButton<CompanyModel>(
                            onSelected: (CompanyModel selectedItem) {
                              setState(() {
                                Provider.of<MapPro>(context, listen: false).selectedCompany = selectedItem;
                              });
                              // Handle the selected item here
                              print('Selected item: $selectedItem');
                            },
                            itemBuilder: (BuildContext context) {
                              return Provider.of<MapPro>(context, listen: false).companyList.map((CompanyModel e) {
                                return PopupMenuItem<CompanyModel>(
                                  value: e,
                                  child: Text(e.title),
                                );
                              }).toList();
                            },
                            child: Column(
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of('Company'),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(Provider.of<MapPro>(context, listen: false).selectedCompany.title),
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Extra Note'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        TextField(
                                          controller: Provider.of<MapPro>(context, listen: false).noteController,
                                          decoration: const InputDecoration(
                                            hintText: 'Input Note',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Enter'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Extra Note',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                Text(Provider.of<MapPro>(context, listen: false).noteController.text==''? "Enter here":Provider.of<MapPro>(context, listen: false).noteController.text,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).disabledColor,)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context).dividerColor,
                              blurRadius: 8,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              API.showLoading("Booking...", context);
                              if(await API.addBooking(context)) {
                                Navigator.of(context).pop();
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.check_circle,
                                            size: 80,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            AppLocalizations.of('Booking Successful'),
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
                                              AppLocalizations.of(' Your booking is confirmed.\n'
                                                  'Click below to increase the amount for a quicker response from our top-rated drivers.'),
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                color: Theme.of(context).disabledColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          // Text("Current Rate:${Provider.of<MapPro>(context,listen: false).selectedCar.price}£"),
                                          Padding(
                                            padding: const EdgeInsets.only(left:30,right:30,top:10,bottom:10),
                                            child: Container(
                                              height: 38,
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
                                                  },
                                                  child: Center(
                                                    child: Text(AppLocalizations.of('Increase by 5£'), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                                    )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                          ),
                                          SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    isConfirm = true;
                                                  });
                                                },
                                                child: Container(
                                                  child: Text(
                                                    AppLocalizations.of('Done'),
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                      color: Theme.of(context).primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      contentPadding: EdgeInsets.only(top: 16),
                                    );
                                  },
                                );
                                print("ID:${Provider.of<HomePro>(context,listen: false).userid}");
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryScreen(),));
                              }else{
                                Navigator.of(context).pop();
                                setState(() {
                                  isConfrimDriver = true;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.check_circle,
                                            size: 80,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            AppLocalizations.of('Booking Unsuccessful'),
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
                                              AppLocalizations.of('Something is wrong!!!. Please try again.'),
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
                                                      isConfirm = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      AppLocalizations.of('Done'),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        color: Theme.of(context).primaryColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
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
                              }
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of('Request'),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ):Card(
                elevation: 16,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 320,
                      child: ListView.builder(
                        itemCount: carList.length,
                        itemBuilder: (context, index) {
                          final car = carList[index];
                          return InkWell(
                            onTap: (){
                              Provider.of<MapPro>(context, listen: false).selectedCar = car;
                              setState(() {
                              });
                            },
                            child: Card(
                              color: Provider.of<MapPro>(context, listen: false).selectedCar.carId == car.carId ? Theme.of(context).primaryColor : null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              car.carImage
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('£${car.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                                          Text(car.car_name),
                                          Text('${car.distance.substring(0,5)} miles'),

                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          car.formattedTime,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(car.car_info.split('\n')[0]),
                                            Icon(Icons.person),
                                          ],
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Text(car.car_info.split('\n')[1]),
                                            Icon(Icons.luggage),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Theme.of(context).dividerColor,
                              blurRadius: 8,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                isVehicleSelected = true;
                              });
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of('Next'),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : confirmDriverBox(context),
            ],
          ),
        )
      ],
    );
  }

  bool isConfrimDriver = false;

  Widget confirmBookingBox(context) {
    return Padding(
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
                            child: Image.asset(
                              ConstanceData.userImage,
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
                                AppLocalizations.of('Gregory Smith'),
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
                                    AppLocalizations.of('4.9'),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user1,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user2,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              ConstanceData.user3,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            AppLocalizations.of('25 Recommended'),
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: Theme.of(context).disabledColor,
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
                                AppLocalizations.of('DISTANCE'),
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).dividerColor.withOpacity(0.4),
                                ),
                              ),
                              Text(
                                AppLocalizations.of('0.2 km'),
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
                                AppLocalizations.of('0.2 km'),
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
                                AppLocalizations.of('PRICE'),
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).dividerColor.withOpacity(0.4),
                                ),
                              ),
                              Text(
                                AppLocalizations.of('\$25.00'),
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
                            },
                            child: Center(
                              child: !isConfirm
                                  ? Text(
                                AppLocalizations.of('Confirm'),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              )
                                  : Text(
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
    );
  }
  Widget confirmDriverBox(context) {
    return Padding(
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
                                          Icons.check_circle,
                                          size: 80,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          AppLocalizations.of('Booking Successful'),
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
                                                    isConfirm = true;
                                                  });
                                                },
                                                child: Container(
                                                  child: Text(
                                                    AppLocalizations.of('Done'),
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                      color: Theme.of(context).primaryColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
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
                              child: !isConfirm
                                  ? Text(
                                AppLocalizations.of('Confirm'),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              )
                                  : Text(
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
    );
  }

  bool isConfirm = false;
}
