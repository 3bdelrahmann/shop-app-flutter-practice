import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/cart_model.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_cart_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/cart/cart_screen.dart';
import 'package:shop_app/modules/favorite/favorite_screen.dart';
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
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    getFavoritesData();
    getCartData();
    getProfileData();
    emit(AppChangeNavBarState());
  }

  HomeModel? homeModel;
  Map<int, bool> favourites = {};
  Map<int, bool> inCart = {};
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
          inCart.addAll({element.id!: element.inCart!});
        });

        // print(inCart.toString());

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
        } else {
          getFavoritesData();
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

  FavoritesModel? favoritesModel;
  void getFavoritesData() {
    emit(AppOnLoadingFavoritesState());
    DioHelper.getData(
      path: FAVORITES,
      token: token,
    ).then(
      (value) {
        favoritesModel = FavoritesModel.fromJson(value.data);
        emit(AppOnSuccessFavoritesState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(AppOnFailedFavoritesState());
      },
    );
  }

  int cartLength = 0;
  CartModel? cartModel;
  void getCartData() {
    emit(AppOnLoadingCartState());
    DioHelper.getData(
      path: CARTS,
      token: token,
    ).then(
      (value) {
        cartModel = CartModel.fromJson(value.data);
        cartLength = cartModel!.data!.cartItems!.length;
        emit(AppOnSuccessCartState());
        // print(value.toString());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(AppOnFailedCartState());
      },
    );
  }

  ChangeCartModel? changeCartModel;
  void changeCart(int? productId) {
    inCart[productId!] = !inCart[productId]!;
    getCartData();
    emit(AppChangeCartState());
    print(productId);

    DioHelper.postData(
      path: CARTS,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then(
      (value) {
        changeCartModel = ChangeCartModel.fromJson(value.data);
        if (!changeCartModel!.status!) {
          inCart[productId] = !inCart[productId]!;
          showToast(
            text: changeCartModel!.message!,
            states: ToastStates.ERROR,
          );
        } else {
          getCartData();
          showToast(
            text: changeCartModel?.message ?? 'Done',
            states: ToastStates.GREY,
          );
        }

        emit(AppOnSuccessChangeCartState());
      },
    ).catchError(
      (error) {
        inCart[productId] = !inCart[productId]!;
        showToast(
          text: changeCartModel?.message ?? 'error',
          states: ToastStates.ERROR,
        );
        emit(AppOnFailedChangeCartState());
      },
    );
  }

  LoginModel? profileModel;
  void getProfileData() {
    emit(AppOnLoadingProfileState());
    DioHelper.getData(
      path: PROFILE,
      token: token,
    ).then(
      (value) {
        profileModel = LoginModel.fromJson(value.data);
        emit(AppOnSuccessProfileState());
      },
    ).catchError(
      (error) {
        print(error.toString());
        emit(AppOnFailedProfileState());
      },
    );
  }

  void updateProfileData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(AppOnLoadingUpdateState());
    DioHelper.putData(
      path: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then(
      (value) {
        profileModel = LoginModel.fromJson(value.data);
        emit(AppOnSuccessUpdateState());
      },
    ).catchError(
      (error) {
        emit(AppOnFailedUpdateState(error));
      },
    );
  }

  bool nonEditableField = true;
  void changeUserManagementScreen() {
    nonEditableField = false;
    emit(AppChangeUpdateState());
  }

  SearchModel? searchModel;
  void search({
    required String text,
  }) {
    emit(AppOnLoadingSearchState());
    DioHelper.postData(
      path: SEARCH,
      token: token,
      data: {
        'text': text,
      },
    ).then(
      (value) {
        searchModel = SearchModel.fromJson(value.data);
        emit(AppOnSuccessSearchState());
      },
    ).catchError(
      (error) {
        print(error);
        emit(AppOnFailedSearchState());
      },
    );
  }
}
