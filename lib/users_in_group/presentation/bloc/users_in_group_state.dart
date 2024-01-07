part of 'users_in_group_cubit.dart';

@immutable
abstract class UsersInGroupState {}

class UsersInGroupInitial extends UsersInGroupState {}
class UsersInGroupSuccessState extends UsersInGroupState {
  final UsersInGroupModel usersInGroupModel;
  UsersInGroupSuccessState(this.usersInGroupModel);
}
class UsersInGroupLoadingState extends UsersInGroupState {}
class UsersInGroupErrorState extends UsersInGroupState {
  final String error;
  UsersInGroupErrorState(this.error);
}
