import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/SingUp/presentation/bloc/status.dart';

import '../../../core/network/DioHelper.dart';
import '../../../core/shared.dart';
import '../../data/register_model.dart';

class SignUpCubit extends Cubit<SignInScreenStatesTeacher> {
  String? errorState;
  SignUpCubit() : super(SignInInitialStateTeacher());
  static SignUpCubit get(context) => BlocProvider.of(context);
   late registerModel signInModel;
  Future<void> userRegister({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingStateTeacher());

    final formData = {
      'email':email,
      'password':password,
      'name':name
    };
print("posst");
    try {
      final response = await DioHelper.postData(
        url: 'register',
        data: formData,
      );

      print('Response status code: ${response?.statusCode}');
      print('Response data: ${response?.data}');

      if (response != null) {
        signInModel = registerModel.fromJson(response.data);
        token=signInModel.token;
        print(signInModel.token);
        // Handle the response here
        emit(SignInSuccessStateTeacher(signInModel));
      } else {
        emit(SignInErrorStateTeacher('Unexpected null value in response'));
      }
    } catch (onError) {
      print('Error: $onError');
      emit(SignInErrorStateTeacher(onError.toString()));
    }

  }

  IconData suffix = Icons.visibility;
  bool isPasswordShow = true;
  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;

    suffix = isPasswordShow ? Icons.visibility : Icons.visibility_off;
    emit(SignInChangePasswordVisibilityStateTeacher());
  }
}
