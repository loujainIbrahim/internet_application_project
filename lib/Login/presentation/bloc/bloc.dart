import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/Login/presentation/bloc/status.dart';

import '../../../core/network/DioHelper.dart';
import '../../../core/shared.dart';
import '../../data/login_model.dart';


class LoginScreenCubit extends Cubit<LoginScreenStatus> {
  LoginScreenCubit() : super(LoginScreenInitializeState());

  static LoginScreenCubit get(context) => BlocProvider.of(context);
  late LoginModel loginModel;
  Future<void> userlogin(
      {required String email, required String password}) async {
    emit(LoginScreenLoadingState());
    try {
      final response = await DioHelper.postData(
        url: 'login',
        data: {'email': email, 'password': password},
      );

      print('Response status code: ${response?.statusCode}');
      print('Response data: ${response?.data}');

      if (response != null) {
        loginModel = LoginModel.fromJson(response.data);
        token = loginModel.token;
        print(loginModel.token);
        // Handle the response here
        emit(LoginScreenSuccessState(loginModel));
      } else {
        emit(LoginScreenErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      print('Error: $onError');
      emit(LoginScreenErrorState(onError.toString()));
    }
  }

  IconData suffix = Icons.visibility;
  bool isPasswordShow = true;
  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;

    suffix = isPasswordShow ? Icons.visibility : Icons.visibility_off;
    emit(LoginChangePasswordVisibilityState());
  }
}
