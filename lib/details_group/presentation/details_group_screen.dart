import 'dart:html';
import 'dart:typed_data';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/core/network/DioHelper.dart';
import 'package:internet_application/details_group/presentation/bloc/details_group_cubit.dart';
import 'package:internet_application/details_group/presentation/edit_file_screen.dart';
import 'package:internet_application/details_group/presentation/open_file_screen.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import '../../core/widgets/snake_bar_widget.dart';
import '../../monitoring_files/presentation/monitoring_files_screen.dart';
import '../../utils/default_button.dart';
import '../data/details_group_model.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'multi_file_edit_screen.dart';

class DetailsGroupScreen extends StatefulWidget {
  final int id;
  final int is_admin;
  const DetailsGroupScreen({Key? key, required this.id, required this.is_admin})
      : super(key: key);
  @override
  State<DetailsGroupScreen> createState() => _DetailsGroupScreenState();
}

class _DetailsGroupScreenState extends State<DetailsGroupScreen> {
  late DetailsGroupCubit detailsGroupCubit;
  final TextEditingController _MaxSizeFilesController = TextEditingController();
  double defaultMaxSize = 6144;
  DetailsGroup? detailsGroup;
  List<int> selectedFileIds = [];
  List<String> selectedFileName = [];
  bool select = false;
  @override
  void initState() {
    super.initState();
    detailsGroupCubit = DetailsGroupCubit();
    _MaxSizeFilesController.text = defaultMaxSize.toString();
    print(widget.id);
    detailsGroupCubit.getFilesOfGroup(widget.id);
  }

  void uploadFile() async {
    var picked;
    try {
      picked = await FilePicker.platform.pickFiles(type: FileType.any);
    } catch (e) {
      print(e);
    }

    if (picked != null) {
      try {
        Uint8List uploadfile = picked.files.single.bytes;
        String filename = basename(picked.files.single.name);
        detailsGroupCubit.addFile(
          groupId: widget.id,
          file: uploadfile,
          filename: filename,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailsGroupCubit>(
        create: (context) => detailsGroupCubit,
        child: BlocConsumer<DetailsGroupCubit, DetailsGroupState>(
            listener: (context, state) {
          if (state is AddFileToGroupSuccessState) {
            detailsGroupCubit.getFilesOfGroup(widget.id);
            detailsGroup = detailsGroupCubit.detailsGroup;
            ErrorSnackBar.show(context, "Add file successfully");
          } else if (state is AddFileToGroupErrorState) {
            ErrorSnackBar.show(context, state.error);
          }
          if (state is OpenFileSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OpenFileScreen(text: state.response)));
          }
          if (state is GetFileToEditSuccessState) {
            ErrorSnackBar.show(
                context, "The file has been reserved successfully");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditFileScreen(
                        getFileToEditModel: state.response,
                        File_id: state.File_id,
                        file_name: state.file_name)));
          }
          if (state is OpenFilesSuccessState) {
            print("ggggggggggggg");
            // print(state.openFilesToEditModel.map((e) => e.data));
            // List<String> listOfStrings = state.openFilesToEditModel
            //     .map((model) => model.data?.map((data) => data?.data ?? '') ?? [])
            //     .expand((dataList) => dataList)
            //     .toList();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiFileEditScreen(
                          fileContents: state.openFilesToEditModel!,
                          selectedFileName: state.selectedFileName,
                        )));
          }
          if (state is DeleteFilesSuccessState) {
            detailsGroupCubit.getFilesOfGroup(widget.id);
            detailsGroup = detailsGroupCubit.detailsGroup;
            ErrorSnackBar.show(context, "delete file successfully");
          }
          if (state is EditSizeFilesSuccessState) {
            ErrorSnackBar.show(context, state.message);
          }
        }, builder: (context, state) {
          return Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Max size files'),
                            content: TextField(
                              controller: _MaxSizeFilesController,
                              decoration: InputDecoration(
                                  labelText: 'Enter Max Size Files'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Save group name logic here (you can customize)
                                  String maxSize = _MaxSizeFilesController.text;
                                  // print('Group Name: $groupName');
                                  double ss = double.parse(maxSize);
                                  defaultMaxSize = ss;
                                  detailsGroupCubit.EditSizeFile(
                                      max_size: ss, group_id: widget.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.file_open),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      print(selectedFileIds);
                      uploadFile();
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              centerTitle: true,
              title: Text('My groups'),
            ),
            body: ConditionalBuilder(
                condition: state is! DetailsGroupLoadingState,
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
                builder: (context) {
                  print("dddddd");
                  final detailsGroup =
                      DetailsGroupCubit.get(context).detailsGroup;
                  print("rrrrrrrrr");
                  return Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: defaultbutton(
                                      backround: (selectedFileIds.length > 0)
                                          ? Colors.deepOrange
                                          : Colors.deepOrange[200]!,
                                      width: 170,
                                      text: "Edit files",
                                      textColor: (selectedFileIds.length > 0)
                                          ? Colors.black
                                          : Colors.black12!,
                                      function: () {
                                        detailsGroupCubit.openFiles(
                                            selectedFileIds, selectedFileName);
                                        selectedFileIds = [];
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        4, // Number of columns in the grid
                                    crossAxisSpacing:
                                        10.0, // Spacing between columns
                                    mainAxisSpacing:
                                        10.0, // Spacing between rows
                                    mainAxisExtent: 100),
                            itemCount: detailsGroup!
                                .data!.length, // Number of items in the grid
                            itemBuilder: (context, index) {
                              String fileName = path
                                  .basename(detailsGroup!.data![index].file!);
                              int fileId = detailsGroup!.data![index].id!;
                              bool isChecked = selectedFileIds.contains(fileId);

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             DetailsGroupScreen(
                                    //                 id: detailsGroup!
                                    //                     .data![index].id!)));
                                  },
                                  child: Container(
                                    height: 150,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      border: Border.all(
                                        color: Colors
                                            .black, // Set the color of the border
                                        width:
                                            1.0, // Set the width of the border
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            10.0), // Set the radius of the corners
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value!) {
                                                      selectedFileIds
                                                          .add(fileId);
                                                      selectedFileName
                                                          .add(fileName);
                                                    } else {
                                                      selectedFileIds
                                                          .remove(fileId);
                                                      selectedFileName
                                                          .remove(fileName);
                                                    }
                                                  });
                                                },
                                                // Change checkbox color based on its state
                                                activeColor: isChecked
                                                    ? Colors.green
                                                    : Colors.blue,
                                              ),
                                              Text(
                                                fileName,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                void _showFileOptions(
                                                    int index) {
                                                  final fileDetails =
                                                      detailsGroup!
                                                          .data![index];
                                                  (widget.is_admin == 1)
                                                      ? showMenu(
                                                          context: context,
                                                          position: RelativeRect
                                                              .fromLTRB(
                                                                  0,
                                                                  100,
                                                                  0,
                                                                  0), // Adjust the position as needed
                                                          items: [
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(Icons
                                                                    .visibility),
                                                                title: Text(
                                                                    'Open'),
                                                                onTap: () {
                                                                  // Handle Read File action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit
                                                                      .OpenFile(
                                                                          fileDetails
                                                                              .id!);
                                                                  //  _readFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    Icons.edit),
                                                                title: Text(
                                                                    'Edit'),
                                                                onTap: () {
                                                                  // Handle Update action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit.GetFileToEdit(
                                                                      fileDetails
                                                                          .id!,
                                                                      fileName);
                                                                  // _updateFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    Icons
                                                                        .delete),
                                                                title: Text(
                                                                    'Delete'),
                                                                onTap: () {
                                                                  // Handle Read File action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit
                                                                      .DeleteFile(
                                                                          File_id:
                                                                              fileDetails.id!);
                                                                  //  _readFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(Icons
                                                                    .remove_red_eye),
                                                                title: Text(
                                                                    'Monitoring'),
                                                                onTap: () {
                                                                  // Handle Update action
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => MonitoringFilesScreen(
                                                                                file_id: fileDetails.id!,
                                                                                group_id: fileDetails.groupId!,
                                                                              )));
                                                                  // _updateFile(fileDetails);
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                          elevation: 8.0,
                                                        )
                                                      : showMenu(
                                                          context: context,
                                                          position: RelativeRect
                                                              .fromLTRB(
                                                                  0,
                                                                  100,
                                                                  0,
                                                                  0), // Adjust the position as needed
                                                          items: [
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(Icons
                                                                    .visibility),
                                                                title: Text(
                                                                    'Open'),
                                                                onTap: () {
                                                                  // Handle Read File action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit
                                                                      .OpenFile(
                                                                          fileDetails
                                                                              .id!);
                                                                  //  _readFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    Icons.edit),
                                                                title: Text(
                                                                    'Edit'),
                                                                onTap: () {
                                                                  // Handle Update action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit.GetFileToEdit(
                                                                      fileDetails
                                                                          .id!,
                                                                      fileName);
                                                                  // _updateFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              child: ListTile(
                                                                leading: Icon(
                                                                    Icons
                                                                        .delete),
                                                                title: Text(
                                                                    'Delete'),
                                                                onTap: () {
                                                                  // Handle Read File action
                                                                  Navigator.pop(
                                                                      context);
                                                                  detailsGroupCubit
                                                                      .DeleteFile(
                                                                          File_id:
                                                                              fileDetails.id!);
                                                                  //  _readFile(fileDetails);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                          elevation: 8.0,
                                                        );
                                                }

                                                _showFileOptions(index);
                                              },
                                              icon: Icon(Icons.more_vert)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        }));
  }
}
