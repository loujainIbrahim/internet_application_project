import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/users_in_group/data/users_in_group_model.dart';
import 'package:meta/meta.dart';

import '../../../core/network/DioHelper.dart';

part 'users_in_group_state.dart';

class UsersInGroupCubit extends Cubit<UsersInGroupState> {
  UsersInGroupCubit() : super(UsersInGroupInitial());
  static UsersInGroupCubit get(context)=>BlocProvider.of(context);
   UsersInGroupModel? usersInGroupModel ;
  Future<void> getUsersInGroup(int id) async {
    emit(UsersInGroupLoadingState());
    await DioHelper.getData(url: "group/users/$id")
        .then((value) {
      usersInGroupModel=UsersInGroupModel.fromJson(value.data);
      print(value.data);
      emit(UsersInGroupSuccessState(usersInGroupModel!));
    }).catchError((onError) {
      emit(UsersInGroupErrorState(onError.toString()));
    });
  }

}
