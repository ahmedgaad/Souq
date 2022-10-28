import 'package:shop_app/models/change_favorites_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingDataModelState extends ShopStates{}
class ShopSuccessDataModelState extends ShopStates{}

class ShopErrorDataModelState extends ShopStates{}
class ShopSuccessCategoriesState extends ShopStates{}
class ShopErrorCategoriesState extends ShopStates{}

class ShopChangeFavoritesState extends ShopStates{}
class ShopSuccessChangeFavoritesState extends ShopStates{
  final ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}
class ShopErrorChangeFavoritesState extends ShopStates{}


class ShopLoadingGetFavoritesState extends ShopStates{}
class ShopSuccessGetFavoritesState extends ShopStates{}
class ShopErrorGetFavoritesState extends ShopStates{}


class ShopLoadingGetUserDataState extends ShopStates{}
class ShopSuccessGetUserDataState extends ShopStates{}
class ShopErrorGetUserDataState extends ShopStates{}




class ShopLoadingUpdateUserState extends ShopStates{}
class ShopSuccessUpdateUserState extends ShopStates{}
class ShopErrorUpdateUserState extends ShopStates{}
