import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_cab/constance/constance.dart';

import '../../models/all_booking_model.dart';

class CardWidget extends StatelessWidget {
  final String price;
  final String status;
  final Color statusColor;
  final List<Stop> stopsList;
  const CardWidget(
      {
        super.key,
        required this.price,
        required this.status,
        required this.statusColor,
        required this.stopsList
      });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: stopsList.length,
            itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        index ==0?ConstanceData.startmapPin: ConstanceData.endPin,
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        stopsList[index].bdLocation,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).textTheme.titleLarge!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 22,
                  ),
                  child: Container(
                    height: 16,
                    width: 2,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ],
            );
          },),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 8, bottom: 8),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Theme.of(context).disabledColor,
                  child: Icon(
                    FontAwesomeIcons.poundSign,
                    color: Theme.of(context).colorScheme.background,
                    size: 16,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  price,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).textTheme.titleLarge!.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).disabledColor,
                  size: 16,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
