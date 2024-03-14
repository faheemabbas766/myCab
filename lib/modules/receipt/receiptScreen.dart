import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_cab/models/all_booking_model.dart';
import 'package:my_cab/modules/receipt/booking_ticket.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  Future<void> _showTicketReceipt(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Screenshot(
                controller: screenshotController,
                child: BookingTicketContainer(movieTitle: "movieTitle", date: "date", time: "time", seat: "seat", userId: "userId", userName: "userName"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x26BE16FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.58),
                          ),
                        ),
                        onPressed: () async {
                          var capturedImage = await screenshotController.capture();
                          if (capturedImage != null) {
                            final directory = await getTemporaryDirectory();
                            final filePath = '${directory.path}/screenshot.png';
                            final file = File(filePath);
                            await file.writeAsBytes(capturedImage);
                            Share.shareFiles([filePath]);
                          }
                        },
                        child: const Text(
                          'Share',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 0.15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x26BE16FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.58),
                          ),
                        ),
                        onPressed: () async {
                          var capturedImage = await screenshotController.capture();
                          await ImageGallerySaver.saveImage(capturedImage!);
                          ft.Fluttertoast.showToast(
                            msg: "Image Saved in Gallery!",
                            toastLength: ft.Toast.LENGTH_LONG,);
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 0.15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x26BE16FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.58),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: 0.15),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
