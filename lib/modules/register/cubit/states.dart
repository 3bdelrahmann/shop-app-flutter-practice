import 'package:shop_app/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterOnLoadingState extends RegisterStates {}

class RegisterOnSuccessState extends RegisterStates {
  final LoginModel loginModel;

  RegisterOnSuccessState(this.loginModel);
}

class RegisterOnFailedState extends RegisterStates {
  final String error;

  RegisterOnFailedState(this.error);
}

class RegisterOnChangePasswordState extends RegisterStates {}
