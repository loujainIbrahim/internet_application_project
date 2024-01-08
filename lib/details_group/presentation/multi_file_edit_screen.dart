import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_view/split_view.dart';

import '../../core/widgets/snake_bar_widget.dart';
import '../../utils/default_button.dart';
import '../data/open_files_model.dart';
import 'bloc/details_group_cubit.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:split_view/split_view.dart';

import '../../utils/default_button.dart';
import '../data/open_files_model.dart';
import 'bloc/details_group_cubit.dart';

class MultiFileEditScreen extends StatefulWidget {
  final List<MyData> fileContents;
  final List<String> selectedFileName;

  MultiFileEditScreen(
      {required this.fileContents, required this.selectedFileName});

  @override
  State<MultiFileEditScreen> createState() => _MultiFileEditScreenState();
}

class _MultiFileEditScreenState extends State<MultiFileEditScreen> {
  late List<TextEditingController> controllers;
  @override
  void initState() {
    super.initState();
    controllers = widget.fileContents
        .map((content) => TextEditingController(text: content.data))
        .toList();
  }

  @override
  void dispose() {
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Files'),
      ),
      body: BlocProvider(
        create: (context) => DetailsGroupCubit(),
        child: BlocConsumer<DetailsGroupCubit, DetailsGroupState>(
          listener: (context, state) {
            if (state is EditFileSuccessState) {
              ErrorSnackBar.show(context, "Update successfully");
            }
            // TODO: implement listener
          },
          builder: (context, state) {
            return SplitView(
              children: widget.fileContents.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller =
                    controllers[index]; // Use pre-created controller
                String fileName = widget.selectedFileName.elementAt(index);

                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        // height:200,
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          maxLines: null,
                          expands: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'File Content',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultbutton(
                        backround: Colors.deepOrange,
                        width: 200,
                        text: 'Save changes',
                        function: () async {
                          String updatedData = controller.text;
                          Uint8List fileContent =
                              Uint8List.fromList(utf8.encode(updatedData));
                          print("this is id for update");
                          print(widget.fileContents[index].id);
                          // Call the function to create and send the file to the backend
                          DetailsGroupCubit()
                              .createAndSendFileToBackend(
                            fileContent,
                            widget.fileContents[index].id,
                            fileName,
                          );
                        },
                      ),
                    )
                  ],
                );
              }).toList(),
              viewMode: SplitViewMode.Horizontal,
              gripColor: Colors.blueGrey,
              gripSize: 8,
            );
          },
        ),
      ),
    );
  }
}
