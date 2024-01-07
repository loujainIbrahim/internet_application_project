import 'dart:html' as html;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../../core/network/DioHelper.dart';
import '../../data/details_group_model.dart';
import '../../data/get_file_to_edit_model.dart';
import '../../data/open_files_model.dart';

part 'details_group_state.dart';

class DetailsGroupCubit extends Cubit<DetailsGroupState> {
  DetailsGroupCubit() : super(DetailsGroupInitial());
  static DetailsGroupCubit get(context) => BlocProvider.of(context);
  late DetailsGroup detailsGroup;
  late GetFileToEditModel getFileToEditModel;
  Future<void> getFilesOfGroup(int id) async {
    emit(DetailsGroupLoadingState());
    await DioHelper.getData(url: "group/files-on-group/$id").then((value) {
      detailsGroup = DetailsGroup.fromJson(value.data);
      print(value.data);
      emit(DetailsGroupSuccessState());
    }).catchError((onError) {
      emit(DetailsGroupErrorState(onError.toString()));
    });
  }

  Future<void> addFile(
      {required int groupId,
      required Uint8List file,
      required String filename,int maxSizeInMB = 10}) async {
    double fileSizeInMB = file.lengthInBytes / (1024 * 1024);
    if (fileSizeInMB > maxSizeInMB) {
      // File size exceeds the allowed limit
      emit(AddFileToGroupErrorState('File size exceeds the maximum limit of $maxSizeInMB MB'));
      return;
    }
    emit(AddFileToGroupLoadingState());

    try {
      // Create a FormData object to send the file
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromBytes(file, filename: filename),
      });

      final response = await DioHelper.postData(
        url: "group/$groupId/addFile",
        data: formData,
      );

      if (response != null) {
        emit(AddFileToGroupSuccessState());
      } else {
        emit(AddFileToGroupErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      emit(AddFileToGroupErrorState(onError.toString()));
    }
  }

  Future<void> OpenFile(int File_id) async {
    emit(OpenFileLoadingState());
    await DioHelper.getData(url: "group/read-file/$File_id").then((value) {
      // print(value.data);
      emit(OpenFileSuccessState(value.data));
    }).catchError((onError) {
      emit(OpenFileErrorState(onError.toString()));
    });
  }
  Future<void> DeleteFile(
      {required int File_id,
        }) async {
    emit(DeleteFilesLoadingState());
    try {
      // Create a FormData object to send the file


      final response = await DioHelper.deleteData(
        url: "group/delete-file/$File_id",
      );

      if (response != null) {
        emit(DeleteFilesSuccessState());
      } else {
        emit(DeleteFilesErrorState('Unexpected null value in response'));
      }
    } catch (onError) {
      emit(DeleteFilesErrorState(onError.toString()));
    }
  }
  Future<void> GetFileToEdit(int File_id, String file_name) async {
    emit(GetFileToEditLoadingState());
    await DioHelper.getData(url: "group/edit-file/$File_id").then((value) {
      print(value.data);
      getFileToEditModel = GetFileToEditModel.fromJson(value.data);
      emit(GetFileToEditSuccessState(getFileToEditModel, File_id, file_name));
    }).catchError((onError) {
      emit(GetFileToEditErrorState(onError.toString()));
    });
  }

  Future<void> createAndSendFileToBackend(
      Uint8List data, int File_id, String file_name) async {
    final blob = html.Blob([data]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = 'example.txt';
    emit(EditFileLoadingState());
    // Trigger a click on the anchor element to download the file
    // html.document.body!.append(anchor);
    // anchor.click();
    //
    // // Remove the anchor element after triggering the download
    // anchor.remove();

    // Send the file to the backend using Dio

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          data,
          filename: file_name,
        ),
      });

      // Replace 'YOUR_BACKEND_UPLOAD_API_ENDPOINT' with your actual API endpoint
      print(File_id);
      DioHelper.postData(
          url: 'group/update-file/$File_id', data: formData).then((value) {
        emit(EditFileSuccessState());
        print(value!.data);
        print('File uploaded successfully');
      }).catchError((onError) {
        emit(EditFileErrorState("Failed to upload file"));
        emit(EditFileErrorState(onError.toString()));
        print('Error: $onError');
      });
      // print('Dio Response: ${response?.data}');
      // print('Dio Response Status Code: ${response?.statusCode}');


  }

  Future<void> openFiles(List<int> selectedFileIds,List<String>selectedFileName) async {
    emit(OpenFilesLoadingState());
    final List<int> fileIds = selectedFileIds.toList();
    print(fileIds);
    FormData formData = FormData();
    for (int i = 0; i < fileIds.length; i++) {
      formData.fields.add(MapEntry('file[$i]', fileIds[i].toString()));
    }
    // Make the API call using Dio
    DioHelper.postData(
      url: 'group/edit-files', // Replace with your actual API endpoint
      data: formData,
    ).then((value) {
      print("this is my modle");
      print(value!.data["data"]);
      List<dynamic> jsonResponse=value!.data["data"];
      List<MyData> dataList = jsonResponse.map((item) => MyData.fromJson(item)).toList();
      // final List<dynamic> dataList = value.data;
     // List<OpenFilesToEditModel> openFilesList = [];
     //  List? listOfStrings = (value.data as List<dynamic>?)
     //      ?.map((model) => (model as Map<String, dynamic>)['data']?.map((data) => data['data'] ?? '') ?? [])
     //      .expand((dataList) => dataList)
     //      .toList();
      // for (var dataObject in dataList) {
      //   final Map<String, dynamic> dataMap = dataObject;
      //   openFilesList.add(OpenFilesToEditModel.fromJson(dataMap));
      // }
      for (var data in dataList) {
        print('ID: ${data.id}');
        print('Data: ${data.data}');
        print('----------------');
      }
      print(selectedFileName);
      emit(OpenFilesSuccessState(dataList!,selectedFileName));

      // Now, you can use 'openFilesList' for further processing
      // for (var openFilesModel in openFilesList) {
      //   for (var dataItem in openFilesModel.data!) {
      //     print('ID: ${dataItem.id}');
      //     print('Data: ${dataItem.data}');
      //   }
      // }
      // print(value.statusCode);
    }).catchError((onError) {
      emit(OpenFilesErrorState(onError.toString()));
      print(onError.toString());
    });
  }
}
