import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/Home/data/my_groups_model.dart';
import 'package:internet_application/group/data/create_group_model.dart';
import 'package:meta/meta.dart';

import '../../../core/network/DioHelper.dart';

part 'my_groups_state.dart';

class MyGroupsCubit extends Cubit<MyGroupsState> {
  MyGroupsCubit() : super(MyGroupsInitial());
  late CreateGroupModel createGroupModel;
  late MyGroupsModel myGroupsModel;
  static MyGroupsCubit get(context) => BlocProvider.of<MyGroupsCubit>(context);
  Future<void> getMyGroups() async {
    emit(MyGroupsLoadingState());
    await DioHelper.getData(url: "group/my-groups")
        .then((value) {
      myGroupsModel=MyGroupsModel.fromJson(value.data);
      print(value.data);
      emit(MyGroupsSuccessState(myGroupsModel));
    }).catchError((onError) {
      emit(MyGroupsErrorState(onError.toString()));
    });
  }
  Future<void> createGroup(
      {required String name}) async {
    emit(CreateGroupLoadingState());
    try {
      final response = await DioHelper.postData(
        url: 'group/create',
        data: {'name': name},
      );
      print('Response status code: ${response?.statusCode}');
      print('Response data: ${response?.data}');

      if (response != null) {
        createGroupModel = CreateGroupModel.fromJson(response.data);
        print(createGroupModel.message);
        emit(CreateGroupSuccessState(createGroupModel));
      } else {
        emit(CreateGroupErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      print('Error: $onError');
      emit(CreateGroupErrorState(onError.toString()));
    }
  }


  Future<void> deleteGroup(
      {required int id}) async {
    emit(CreateGroupLoadingState());
    try {
      final response = await DioHelper.deleteData(
        url: 'group/delete/$id',
      );
      print('Response status code: ${response?.statusCode}');
      print('Response data: ${response?.data}');

      if (response != null) {
        print(response.data);
        emit(DeleteGroupSuccessState());
      } else {
        emit(DeleteGroupErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      print('Error: $onError');
      emit(DeleteGroupErrorState(onError.toString()));
    }
  }
}
