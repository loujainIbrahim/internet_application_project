import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/details_group/data/details_group_model.dart';
import 'package:internet_application/details_group/data/get_file_to_edit_model.dart';

import '../../core/widgets/snake_bar_widget.dart';
import '../../utils/default_button.dart';
import 'bloc/details_group_cubit.dart';

class EditFileScreen extends StatefulWidget {
  final int File_id;
  String file_name;
  final GetFileToEditModel getFileToEditModel;
  EditFileScreen(
      {Key? key,
      required this.getFileToEditModel,
      required this.File_id,
      required this.file_name})
      : super(key: key);

  @override
  State<EditFileScreen> createState() => _EditFileScreenState();
}

class _EditFileScreenState extends State<EditFileScreen> {
  late DetailsGroupCubit detailsGroupCubit;
  var formKey = GlobalKey<FormState>();
  TextEditingController text = TextEditingController();
  TextEditingController file_name = TextEditingController();

  @override
  void initState() {
    super.initState();
    text.text = widget.getFileToEditModel!.data!;
    file_name.text = widget.file_name;
    print(widget.file_name);
    detailsGroupCubit = DetailsGroupCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => detailsGroupCubit,
      child: BlocConsumer<DetailsGroupCubit, DetailsGroupState>(
        listener: (context, state) {
          if (state is EditFileSuccessState) {
            ErrorSnackBar.show(context, "Edit file Successfully");
            //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>()));
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TextFormField(
                      //   controller: file_name,
                      //   style: TextStyle(fontSize: 16.0),
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     contentPadding: EdgeInsets.all(16.0),
                      //   ),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextFormField(
                          controller: text,
                          maxLines: null, // Allow multiple lines
                          style: TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ConditionalBuilder(
                        condition: state is! EditFileLoadingState,
                        builder: (context) => defaultbutton(
                            backround: Colors.deepOrange,
                            text: 'Save changes',
                            function: () async {
                              if (formKey!.currentState!.validate()) {
                                Uint8List fileContent =
                                    Uint8List.fromList(utf8.encode(text.text));

                                // Call the function to create and send the file to the backend
                                detailsGroupCubit.createAndSendFileToBackend(
                                    fileContent,
                                    widget.File_id,
                                    widget.file_name);
                              }
                            }),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
