class AllBooking {
  String status;
  List<BookingModel> data;
  int bookingCount;
  String message;

  AllBooking({
    required this.status,
    required this.data,
    required this.bookingCount,
    required this.message,
  });

  factory AllBooking.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'];
    List<BookingModel> bookings = dataList.map((item) => BookingModel.fromJson(item)).toList();

    return AllBooking(
      status: json['status'],
      data: bookings,
      bookingCount: json['booking_count'],
      message: json['message'],
    );
  }
}

class BookingModel {
  String bmSN;
  String bmJobNo;
  String bmCustomerRef;
  String bmPassenger;
  String? bmLuggage;
  String? extraNotes;
  String totalAmount;
  String bmDistance;
  String bmDistanceTime;
  String? bmMLuggage;
  String bmDate;
  String cusName;
  String cusPhone;
  String bmStatus;
  String bsStatus;
  List<Stop>? stops;

  BookingModel({
    required this.bmSN,
    required this.bmJobNo,
    required this.bmCustomerRef,
    required this.bmPassenger,
    this.bmLuggage,
    this.extraNotes,
    required this.totalAmount,
    required this.bmDistance,
    required this.bmDistanceTime,
    this.bmMLuggage,
    required this.bmDate,
    required this.cusName,
    required this.cusPhone,
    required this.bmStatus,
    required this.bsStatus,
    this.stops,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> stopsList = json['stops'];
    List<Stop> stops = stopsList.map((item) => Stop.fromJson(item)).toList();

    return BookingModel(
      bmSN: json['BM_SN'],
      bmJobNo: json['BM_JOB_NO'],
      bmCustomerRef: json['BM_CUSTOMER_REF'],
      bmPassenger: json['BM_PASSENGER'],
      bmLuggage: json['BM_LAGGAGE'],
      extraNotes: json['EXTRA_NOTES'],
      totalAmount: json['total_amount'],
      bmDistance: json['BM_DISTANCE'],
      bmDistanceTime: json['BM_DISTANCE_TIME'],
      bmMLuggage: json['BM_M_LUGGAE'],
      bmDate: json['BM_DATE'],
      cusName: json['CUS_NAME'],
      cusPhone: json['CUS_PHONE'],
      bmStatus: json['BM_STATUS'],
      bsStatus: json['BS_STATUS'],
      stops: stops,
    );
  }
}

class Stop {
  String bdID;
  String bmRef;
  String bdLocation;
  String bdType;
  String bdLat;
  String bdLang;
  String bdIsDeleted;

  Stop({
    required this.bdID,
    required this.bmRef,
    required this.bdLocation,
    required this.bdType,
    required this.bdLat,
    required this.bdLang,
    required this.bdIsDeleted,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      bdID: json['BD_ID'],
      bmRef: json['BM_REF'],
      bdLocation: json['BD_LOCATION'],
      bdType: json['BD_TYPE'],
      bdLat: json['BD_LAT'],
      bdLang: json['BD_LANG'],
      bdIsDeleted: json['BD_IS_DELETED'],
    );
  }
}
