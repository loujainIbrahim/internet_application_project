import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/users_in_group/data/users_in_group_model.dart';

import '../../users/presentation/all_users_to_add_group.dart';
import '../../utils/default_button.dart';
import 'bloc/users_in_group_cubit.dart';

class UsersInGroup extends StatelessWidget {
  final int group_id;
  const UsersInGroup({Key? key, required this.group_id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersInGroupCubit()..getUsersInGroup(group_id),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          title: Text('My groups'),
        ),
        body: BlocBuilder<UsersInGroupCubit, UsersInGroupState>(
          builder: (context, state) {
            if (state is UsersInGroupLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UsersInGroupSuccessState) {
              UsersInGroupModel usersInGroup = state.usersInGroupModel;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: defaultbutton(
                          backround: Colors.deepOrange,
                          width: 150,
                          height: 40,
                          text: 'Add user',
                          function: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UsersToAddGroupScreen(group_id: group_id),
                              ),
                            );

                            // Refresh data after navigation
                            UsersInGroupCubit.get(context).getUsersInGroup(group_id);
                          },
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: 500.0,
                      child: DataTable(
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                        columns: [
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                              ),
                            ),
                            numeric: true,
                            tooltip: 'User ID',
                          ),
                          DataColumn(
                            label: Text('Name',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                )),
                            tooltip: 'User Name',
                          ),
                          DataColumn(
                            label: Text('Email',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                )),
                            tooltip: 'User Email',
                          ),
                          DataColumn(
                            label: Text('Created At',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.deepOrange,
                                )),
                            tooltip: 'User Created At',
                          )
                        ],
                        rows: UsersInGroupCubit.get(context).usersInGroupModel!.data?.map((user) {
                          return DataRow(cells: [
                            DataCell(
                              Text(user.pivot?.userId?.toString() ?? '',
                                  style: TextStyle(fontSize: 16)),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(Text(user.name ?? '', style: TextStyle(fontSize: 16))),
                            DataCell(Text(user.email ?? '', style: TextStyle(fontSize: 16))),
                            DataCell(Text(user.createdAt ?? '', style: TextStyle(fontSize: 16))),
                          ]);
                        }).toList() ?? [],

                      ),
                    ),
                  ),
                ],
              );
            } else if (state is UsersInGroupErrorState) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
