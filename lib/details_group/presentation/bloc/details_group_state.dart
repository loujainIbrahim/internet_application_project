part of 'details_group_cubit.dart';

@immutable
abstract class DetailsGroupState {}

class DetailsGroupInitial extends DetailsGroupState {}
class DetailsGroupLoadingState extends DetailsGroupState {}
class DetailsGroupSuccessState extends DetailsGroupState {}
class DetailsGroupErrorState extends DetailsGroupState {
  final String error;
  DetailsGroupErrorState(this.error);
}

class AddFileToGroupLoadingState extends DetailsGroupState {}
class AddFileToGroupSuccessState extends DetailsGroupState {}
class AddFileToGroupErrorState extends DetailsGroupState {
  final String error;
  AddFileToGroupErrorState(this.error);
}

class OpenFileLoadingState extends DetailsGroupState {}
class OpenFileSuccessState extends DetailsGroupState {
 final String response;
 OpenFileSuccessState(this.response);
}
class OpenFileErrorState extends DetailsGroupState {
  final String error;
  OpenFileErrorState(this.error);
}

class GetFileToEditLoadingState extends DetailsGroupState {}
class GetFileToEditSuccessState extends DetailsGroupState {
  final GetFileToEditModel response;
  final String file_name;
  final int File_id;
  GetFileToEditSuccessState(this.response,this.File_id,this.file_name);
}
class GetFileToEditErrorState extends DetailsGroupState {
  final String error;
  GetFileToEditErrorState(this.error);
}

class EditFileLoadingState extends DetailsGroupState {}
class EditFileSuccessState extends DetailsGroupState {
  EditFileSuccessState();
}
class EditFileErrorState extends DetailsGroupState {
  final String error;
  EditFileErrorState(this.error);
}
class OpenFilesLoadingState extends DetailsGroupState {}
class OpenFilesSuccessState extends DetailsGroupState {
  final List<MyData> openFilesToEditModel;
  final List<String>selectedFileName;
  OpenFilesSuccessState(this.openFilesToEditModel,this.selectedFileName);
}
class OpenFilesErrorState extends DetailsGroupState {
  final String error;
  OpenFilesErrorState(this.error);
}

class DeleteFilesLoadingState extends DetailsGroupState {}
class DeleteFilesSuccessState extends DetailsGroupState {
  DeleteFilesSuccessState();
}
class DeleteFilesErrorState extends DetailsGroupState {
  final String error;
  DeleteFilesErrorState(this.error);
}