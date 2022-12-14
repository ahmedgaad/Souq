// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_void_to_null

class CategoryModel{
  bool? status;
  CategoryDataModel? data;

  CategoryModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = CategoryDataModel.fromJson(json['data']);
  }
}

class CategoryDataModel{
  late int currentPage;
  late List<DataModel> data = [];


  CategoryDataModel.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];
    json['data'].forEach((element){
      data.add(DataModel.fromJson(element));
    });
  }

}

class DataModel{
   late int id;
   late String name;
   late String image;

  DataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}