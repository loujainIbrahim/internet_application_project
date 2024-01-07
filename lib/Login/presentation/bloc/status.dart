

import 'package:internet_application/Login/data/login_model.dart';

abstract class LoginScreenStatus {}

class LoginScreenInitializeState extends LoginScreenStatus {}

class LoginScreenLoadingState extends LoginScreenStatus {}

class LoginScreenSuccessState extends LoginScreenStatus {
  final LoginModel loginModel;
  LoginScreenSuccessState(this.loginModel);
}

class LoginScreenErrorState extends LoginScreenStatus {
  String error;
  LoginScreenErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginScreenStatus {}
