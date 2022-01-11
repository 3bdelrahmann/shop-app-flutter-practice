import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop App',
        ),
      ),
      body: Center(
        child: TextButton(
          child: Text('Logout'),
          onPressed: () {
            CacheHelper.removeData(
              key: 'token',
            ).then((value) {
              navigateTo(
                context: context,
                newRoute: LoginScreen(),
                backRoute: false,
              );
            });
          },
        ),
      ),
    );
  }
}
