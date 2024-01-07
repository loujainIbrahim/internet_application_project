part of 'my_groups_cubit.dart';

@immutable
abstract class MyGroupsState {}

class MyGroupsInitial extends MyGroupsState {}
class MyGroupsLoadingState extends MyGroupsState {}
class MyGroupsSuccessState extends MyGroupsState {
final MyGroupsModel myGroupsModel;
  MyGroupsSuccessState(this.myGroupsModel);
}
class MyGroupsErrorState extends MyGroupsState {
  String error;
  MyGroupsErrorState(this.error);
}


class CreateGroupLoadingState extends MyGroupsState {}
class CreateGroupSuccessState extends MyGroupsState {
final CreateGroupModel createGroupModel;
  CreateGroupSuccessState(this.createGroupModel);
}
class CreateGroupErrorState extends MyGroupsState {
  String error;
  CreateGroupErrorState(this.error);
}


class DeleteGroupLoadingState extends MyGroupsState {}
class DeleteGroupSuccessState extends MyGroupsState {
  DeleteGroupSuccessState();
}
class DeleteGroupErrorState extends MyGroupsState {
  String error;
  DeleteGroupErrorState(this.error);
}