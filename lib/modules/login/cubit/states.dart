import 'package:shop_app/models/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginOnLoadingState extends LoginStates {}

class LoginOnSuccessState extends LoginStates {
  final LoginModel loginModel;

  LoginOnSuccessState(this.loginModel);
}

class LoginOnFailedState extends LoginStates {
  final String error;

  LoginOnFailedState(this.error);
}

class LoginOnChangePasswordState extends LoginStates {}
