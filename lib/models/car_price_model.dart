class CarPriceModel {
   String carId;
   String carImage;
   String distance;
   String price;
   String formattedTime;
   String car_name;
   String car_info;
  CarPriceModel({
    required this.carId,
    required this.carImage,
    required this.distance,
    required this.price,
    required this.formattedTime,
    required this.car_name,
    this.car_info = ''
  });

  factory CarPriceModel.fromJson(Map<String, dynamic> json) {
    return CarPriceModel(
      carId: json['car_id'],
      carImage: json['car_image'],
      distance: json['distance'].toString(),
      price: json['price'].toString(),
      formattedTime: json['formattedTime'],
      car_name: json['car_name']
    );
  }
}
