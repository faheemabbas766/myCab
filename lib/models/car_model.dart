class CarModel {
  final String carId;
  final String carName;
  final String carPrize;
  final String istPrizeAfterWhether;
  final String secondPrizeAfterWhether;
  final String thirdPrizeAfterWhether;
  final String fourthPrizeAfterWhether;
  final String averageSpeed;
  final String carStatus;
  final String sysDate;
  final String carImg;

  CarModel({
    required this.carId,
    required this.carName,
    required this.carPrize,
    required this.istPrizeAfterWhether,
    required this.secondPrizeAfterWhether,
    required this.thirdPrizeAfterWhether,
    required this.fourthPrizeAfterWhether,
    required this.averageSpeed,
    required this.carStatus,
    required this.sysDate,
    required this.carImg,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carId: json['CAR_ID'],
      carName: json['CAR_NAME'],
      carPrize: json['CAR_PRIZE'],
      istPrizeAfterWhether: json['IST_PRIZE_AFTER_WHETHER'],
      secondPrizeAfterWhether: json['2ND_PRIZE_AFTER_WHETHER'],
      thirdPrizeAfterWhether: json['3RD_PRIZE_AFTER_WHETHER'],
      fourthPrizeAfterWhether: json['4TH_PRIZE_AFTER_WHETHER'],
      averageSpeed: json['AVARAGE_SPEED'],
      carStatus: json['CAR_STATUS'],
      sysDate: json['SYS_DATE'],
      carImg: json['car_img'],
    );
  }

  static List<CarModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => CarModel.fromJson(json)).toList();
  }
}
