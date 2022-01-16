import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  late LoginModel loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterOnLoadingState());

    DioHelper.postData(path: REGISTER, data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      emit(RegisterOnSuccessState(loginModel));
    }).catchError((error) {
      emit(RegisterOnFailedState(error.toString()));
    });
  }

  IconData visibility = Icons.visibility_outlined;
  bool secured = true;

  void changePasswordVisibility() {
    secured = !secured;
    visibility =
        secured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterOnChangePasswordState());
  }
}
