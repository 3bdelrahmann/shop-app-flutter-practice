import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/cart/cart_screen.dart';
import 'package:shop_app/modules/favourite/favourite_screen.dart';
import 'package:shop_app/modules/home/home_screen.dart';
import 'package:shop_app/modules/profile/profile_screen.dart';
import 'package:shop_app/shared/components/components.dart';
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
    FavouriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  HomeModel? homeModel;
  Map<int, bool> favourites = {};
  void getHomeData() {
    emit(AppOnLoadingHomeState());
    DioHelper.getData(
      path: HOME,
      token: token,
    ).then(
      (value) {
        homeModel = HomeModel.fromJson(value.data);

        // print(homeModel?.data?.products?.length);

        homeModel?.data?.products?.forEach((element) {
          favourites.addAll({element.id!: element.inFavourites!});
        });

        // print(favourites.toString());

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

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int? productId) {
    favourites[productId!] = !favourites[productId]!;
    emit(AppChangeFavoriteState());

    DioHelper.postData(
      path: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then(
      (value) {
        changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
        if (!changeFavoritesModel!.status!) {
          favourites[productId] = !favourites[productId]!;
          showToast(
            text: changeFavoritesModel!.message!,
            states: ToastStates.ERROR,
          );
        }

        emit(AppOnSuccessChangeFavoriteState());
      },
    ).catchError(
      (error) {
        favourites[productId] = !favourites[productId]!;
        showToast(
          text: changeFavoritesModel!.message!,
          states: ToastStates.ERROR,
        );
        emit(AppOnFailedChangeFavoriteState());
      },
    );
  }
}
