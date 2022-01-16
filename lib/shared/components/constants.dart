import 'package:flutter/cupertino.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'components.dart';

void logout(BuildContext context) {
  CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    navigateTo(
      context: context,
      newRoute: LoginScreen(),
      backRoute: false,
    );
  });
}

String token = ' ';
