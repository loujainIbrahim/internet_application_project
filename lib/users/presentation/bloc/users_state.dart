part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}
class UsersLoadingState extends UsersState {}
class UsersSuccessState extends UsersState {}
class UsersErrorState extends UsersState {
  final String error;
  UsersErrorState(this.error);
}
class AddUsersLoadingState extends UsersState {}
class AddUsersSuccessState extends UsersState {
  final ResponseModel responseModel;
  AddUsersSuccessState(this.responseModel);
}
class AddUsersErrorState extends UsersState {
  final String error;
  AddUsersErrorState(this.error);
}