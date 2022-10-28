class ShopRegisterModel {
  bool? status;
  String? message;
  Data? data;

  ShopRegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

}

class Data {
  String? name;
  String? email;
  String? phone;
  int? id;
  String? image;
  String? token;

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    id = json['id'];
    image = json['image'];
    token = json['token'];
  }
}
