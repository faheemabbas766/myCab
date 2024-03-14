import 'package:flutter/material.dart';
import 'package:my_cab/constance/constance.dart';
class BookingTicketContainer extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final String seat;
  final String userId;
  final String userName;

  const BookingTicketContainer({super.key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seat,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.black,
          style: BorderStyle.none, // Remove this line to see the actual border
        ),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children:[
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 150,
                        child: Image.asset(
                          ConstanceData.appIcon, // Replace with your QR code image
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Booking Receipt',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User ID:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userId,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Movie Title:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          movieTitle,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Date:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Seats:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          seat,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    SizedBox(height: 12.0),
                    const Text(
                      'Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text('- Present this e-ticket at the theater entrance.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    Text('- Keep this ticket in a safe place.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    Text('- No refunds or exchanges.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

