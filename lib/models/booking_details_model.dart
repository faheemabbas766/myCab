class BookingDetails {
  String status;
  BookingData data;
  String message;

  BookingDetails({
    required this.status,
    required this.data,
    required this.message,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      status: json['status'],
      data: BookingData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class BookingData {
  String? bmSN;
  String? bmJobNo;
  String? bmCustomerRef;
  String? bmPassenger;
  String? bmLuggage;
  String? extraNotes;
  String? totalAmount;
  String? bmDistance;
  String? bmDistanceTime;
  String? bmMLuggage;
  String? bmDate;
  String? cusName;
  String? cusPhone;
  String? driverId;
  String? driverName;
  String? bsStatus;
  String? vehicleUvColor;
  String? vehicleUvRegNum;
  String? vehicleUvMake;
  String? vehicleUvModel;
  String? employeePhvBadge;
  String? employeePhoneNumber;
  String? employeeImage;
  List<Stop>? stops;

  BookingData({
    this.bmSN,
    this.bmJobNo,
    this.bmCustomerRef,
    this.bmPassenger,
    this.bmLuggage,
    this.extraNotes,
    this.totalAmount,
    this.bmDistance,
    this.bmDistanceTime,
    this.bmMLuggage,
    this.bmDate,
    this.cusName,
    this.cusPhone,
    this.driverId,
    this.driverName,
    this.bsStatus,
    this.vehicleUvColor,
    this.vehicleUvRegNum,
    this.vehicleUvMake,
    this.vehicleUvModel,
    this.employeePhvBadge,
    this.employeePhoneNumber,
    this.employeeImage,
    this.stops,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
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
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      bsStatus: json['BS_STATUS'],
      vehicleUvColor: json['vehicle_uv_color'],
      vehicleUvRegNum: json['vehicle_uv_reg_num'],
      vehicleUvMake: json['vehicle_uv_make'],
      vehicleUvModel: json['vehicle_uv_model'],
      employeePhvBadge: json['_employee_phv_badge'],
      employeePhoneNumber: json['_employee_phone_number'],
      employeeImage: json['employee_image'],
      stops: json['stops'] != null
          ? List<Stop>.from(json['stops'].map((x) => Stop.fromJson(x)))
          : null,
    );
  }
}

class Stop {
  String? bdID;
  String? bmRef;
  String? bdLocation;
  String? bdType;
  String? bdLat;
  String? bdLang;
  String? bdIsDeleted;

  Stop({
    this.bdID,
    this.bmRef,
    this.bdLocation,
    this.bdType,
    this.bdLat,
    this.bdLang,
    this.bdIsDeleted,
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
