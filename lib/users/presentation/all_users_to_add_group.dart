import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/users/data/users_model.dart';

import '../../core/widgets/snake_bar_widget.dart';
import '../../users_in_group/data/users_in_group_model.dart';
import '../../utils/default_button.dart';
import 'bloc/users_cubit.dart';

class UsersToAddGroupScreen extends StatelessWidget {
  final int group_id;
  const UsersToAddGroupScreen({Key? key, required this.group_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit()..getUsers(),
      child: BlocConsumer<UsersCubit, UsersState>(
        builder: (context, state) {
          return ConditionalBuilder(
            condition: state is! UsersLoadingState,
            builder: (context) {
              List<UserModel> usersInGroupModel =
                  UsersCubit.get(context).usersInGroupModel;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.grey[200],
                  centerTitle: true,
                  title: Text('Users'),
                ),
                body: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      //height: 500.0,
                      child: DataTable(
                        headingTextStyle:
                            TextStyle(fontWeight: FontWeight.bold),
                        columns: [
                          DataColumn(
                            label: Text('ID',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.deepOrange)),
                            numeric: true,
                            tooltip: 'User ID',
                          ),
                          DataColumn(
                            label: Text('Name',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.deepOrange)),
                            tooltip: 'User Name',
                          ),
                          DataColumn(
                            label: Text('Email',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.deepOrange)),
                            tooltip: 'User Email',
                          ),
                          DataColumn(
                            label: Text('Created At',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.deepOrange)),
                            tooltip: 'User Created At',
                          ),
                          DataColumn(
                            label: Text('Operation',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.deepOrange)),
                            tooltip: 'Operation',
                          ),
                        ],
                        rows: usersInGroupModel.map((user) {
                          return DataRow(cells: [
                            DataCell(
                              Text(user.id?.toString() ?? '',
                                  style: TextStyle(fontSize: 16)),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(Text(user.name ?? '',
                                style: TextStyle(fontSize: 16))),
                            DataCell(Text(user.email ?? '',
                                style: TextStyle(fontSize: 16))),
                            DataCell(Text(user.createdAt ?? '',
                                style: TextStyle(fontSize: 16))),
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: defaultbutton(
                                    backround: Colors.deepOrange,
                                    width: 100,
                                    height: 40,
                                    text: 'Add',
                                    function: () {
                                      print(user.id);
                                      print(group_id);
                                      UsersCubit.get(context).AddUserToGroup(
                                          user_id: user.id!,
                                          group_id: group_id);
                                    }),
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        listener: (context, state) {
          if (state is AddUsersSuccessState) {
            ErrorSnackBar.show(context, state.responseModel.message!);

          }
        },
      ),
    );
  }
}
