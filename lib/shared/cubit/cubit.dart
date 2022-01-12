import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favourite/favourite_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/profile/profile_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    HomeScreen(),
    CategoriesScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  HomeModel? homeModel;
  void getHomeData() {
    emit(AppOnLoadingHomeState());
    DioHelper.getData(
      path: HOME,
      token: token,
    ).then(
      (value) {
        homeModel = HomeModel.fromJson(value.data);

        print(homeModel?.data?.banners?.length);

        emit(AppOnSuccessHomeState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(AppOnFailedHomeState());
      },
    );
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    DioHelper.getData(
      path: GET_CATEGORIES,
      token: token,
    ).then(
      (value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(AppOnSuccessCategoriesState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(AppOnFailedCategoriesState());
      },
    );
  }
}
