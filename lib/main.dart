import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/onBoarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import 'modules/login/cubit/cubit.dart';
import 'shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      LoginCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  String token = CacheHelper.getData(key: 'token') ?? 'null';
  runApp(
    ShopApp(
      onBoarding: onBoarding!,
      token: token,
    ),
  );
}

class ShopApp extends StatelessWidget {
  final bool onBoarding;
  final String token;

  ShopApp({required this.onBoarding, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: ConditionalBuilder(
          condition: onBoarding,
          builder: (BuildContext context) => ConditionalBuilder(
              condition: token != 'null',
              builder: (BuildContext context) => HomeLayout(),
              fallback: (BuildContext context) => LoginScreen()),
          fallback: (BuildContext context) => OnBoardingScreen()),
    );
  }
}
