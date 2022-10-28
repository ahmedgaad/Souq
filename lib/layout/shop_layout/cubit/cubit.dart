// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout/cubit/states.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/setting/setting_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/categories_model.dart';
import '../../../models/change_favorites_model.dart';

class ShopCubit extends Cubit<ShopStates> {
  // constructor from ShopCubit:
  ShopCubit() : super(ShopInitialState());

  // create object from cubit as following:
  static ShopCubit get(context) => BlocProvider.of(context);

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'Categories',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];
  int currentIndex = 0;

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};
  void getHomeData() {
    emit(ShopLoadingDataModelState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // print(homeModel?.data.banners[0].image.toString());
      // print(homeModel?.status);

      homeModel!.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });

      print(favorites.toString());
      emit(ShopSuccessDataModelState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorDataModelState());
    });
  }



  CategoryModel? categoryModel;
  void getCategoryData() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }



  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      token: token,
      data: {
        'product_id': productId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      }else{
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
    });
  }



  FavoritesModel? favoritesModel;
  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  late ShopLoginModel userDataModel;
  void getUserData()
  {
    emit(ShopLoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userDataModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessGetUserDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetUserDataState());
    });
  }

  void updateUserData({
  required String name,
    required String email,
    required String phone,
})
  {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userDataModel = ShopLoginModel.fromJson(value.data);

      emit(ShopSuccessUpdateUserState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }
}
