import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/main_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/onBoarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';

import 'modules/login/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  DioHelper.init();
  await CacheHelper.init();

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  token = CacheHelper.getData(key: 'token') ?? ' ';
  print(token);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavoritesData()
            ..getCartData(),
        )
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: ConditionalBuilder(
                condition: onBoarding,
                builder: (BuildContext context) => ConditionalBuilder(
                    condition: token != ' ',
                    builder: (BuildContext context) => MainLayout(),
                    fallback: (BuildContext context) => LoginScreen()),
                fallback: (BuildContext context) => OnBoardingScreen()),
          );
        },
      ),
    );
  }
}
