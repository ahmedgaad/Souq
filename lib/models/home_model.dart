//حولت الداتا من json الي dart عن طريق موقع webinovers
class HomeModel {
  late final bool status;
  late final HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  late final List<BannerModel> banners;
  late final List<ProductModel> products;
  late final String ad;

  HomeDataModel.fromJson(Map<String, dynamic> json){
    banners = List.from(json['banners']).map((e)=>BannerModel.fromJson(e)).toList();
    products = List.from(json['products']).map((e)=>ProductModel.fromJson(e)).toList();
    ad = json['ad'];
  }
}

class BannerModel {
  late final int id;
  late final String image;

  BannerModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image'];
  }
}

class ProductModel {
  late final int id;
  late final dynamic price;
  late final dynamic oldPrice;
  late final dynamic discount;
  late final String image;
  late final String name;
  late final List<String> images;
  late final bool inFavorites;
  late final bool inCart;

  ProductModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    images = List.castFrom<dynamic, String>(json['images']);
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }

}