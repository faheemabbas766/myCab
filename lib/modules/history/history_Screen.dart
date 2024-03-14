import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_cab/Language/appLocalizations.dart';
import 'package:my_cab/constance/themes.dart';
import 'package:my_cab/modules/history/bookingDetails_Screen.dart';
import 'package:my_cab/modules/home/home_screen.dart';
import 'package:my_cab/modules/home/requset_view.dart';
import 'package:my_cab/modules/rating/rating_screen.dart';
import 'package:my_cab/modules/widgets/cardWidget.dart';
import 'package:provider/provider.dart';
import '../../Api & Routes/api.dart';
import '../../models/all_booking_model.dart';
import '../../providers/homepro.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BookingModel> list= [];
  bool isLoading = true;
  Future<void> loadData() async {
    list = await API.getAllBookings(Provider.of<HomePro>(context, listen: false).userid.toString());
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading? const Center(child: CircularProgressIndicator(),)
          :Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            color: Theme.of(context).primaryColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top + 16,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('History'),
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                    AppLocalizations.of('Oct 15,2020'),
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if(list[index].bsStatus=="Accepted"){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingDetailsScreen(id:list[index].bmSN),));
                            }
                            if(list[index].bsStatus=="Completed"){
                              gotorating();
                            }
                            if(list[index].bsStatus=="Pending"){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingDetailsScreen(id:list[index].bmSN),));
                            }
                          },
                          child: CardWidget(
                            price: "${list[index].totalAmount}£",
                            status: AppLocalizations.of(list[index].bsStatus),
                            statusColor: list[index].bsStatus == "Pending"
                                ? HexColor("#3638FE")
                                : list[index].bsStatus == "Not Assigned"
                                ? Colors.black54
                                : Colors.green,
                            stopsList: list[index].stops!,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  gotorating() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(),
      ),
    );
  }
}

