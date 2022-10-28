// ignore_for_file: avoid_print

import '../../modules/login/shop_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context){
  CacheHelper.removeData(key: 'token').then((value)
  {
    navigateAndFinish(context, ShopLoginScreen());
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match){
    print(match.group(0));
  });
}

String token = '';

