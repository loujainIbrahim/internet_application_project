import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/users/data/response_model.dart';
import 'package:internet_application/users/data/users_model.dart';
import 'package:meta/meta.dart';

import '../../../core/network/DioHelper.dart';
import '../../../users_in_group/data/users_in_group_model.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());
  static UsersCubit get(context)=>BlocProvider.of(context);
 late List<UserModel>usersInGroupModel ;
  Future<void> getUsers() async {
    emit(UsersLoadingState());
    await DioHelper.getData(url: "users").then((value) {
      List<Map<String, dynamic>> jsonData = List<Map<String, dynamic>>.from(value.data);

      // Convert each map in the list to a UsersInGroupModel
      List<UserModel> userList = jsonData.map((map) => UserModel.fromJson(map)).toList();

      // Assign the list to the usersInGroupModel property
      usersInGroupModel = userList;

      print(value.data);
      emit(UsersSuccessState());
    }).catchError((onError) {
      emit(UsersErrorState(onError.toString()));
    });
  }
  late ResponseModel responseModel;
  Future<void> AddUserToGroup(
      {required int user_id, required int group_id}) async {
    emit(AddUsersLoadingState());
    try {
      final response = await DioHelper.postData(
        url: 'group/add/$user_id/to/$group_id', data: null,
      );

      print('Response status code: ${response?.statusCode}');
      print('Response data: ${response?.data}');

      if (response != null) {
        // loginModel = LoginModel.fromJson(response.data);
        // token = loginModel.token;
        // print(loginModel.token);
        print(response.data);
        responseModel=ResponseModel.fromJson(response.data);
        // Handle the response here
        emit(AddUsersSuccessState(responseModel));
      } else {
        emit(AddUsersErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      print('Error: $onError');
      emit(AddUsersErrorState(onError.toString()));
    }
  }
}
