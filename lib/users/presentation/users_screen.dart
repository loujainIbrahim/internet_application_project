import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/users/data/users_model.dart';

import '../../users_in_group/data/users_in_group_model.dart';
import 'bloc/users_cubit.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

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
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
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
                        ],
                        rows: usersInGroupModel.map((user) {
                          return DataRow(cells: [
                            DataCell(
                              Text(user.id?.toString() ?? '',
                                  style: TextStyle(fontSize: 16)),
                              showEditIcon: false,
                              placeholder: false,
                            ),
                            DataCell(
                                Text(user.name ?? '', style: TextStyle(fontSize: 16))),
                            DataCell(
                                Text(user.email ?? '', style: TextStyle(fontSize: 16))),
                            DataCell(
                                Text(user.createdAt ?? '', style: TextStyle(fontSize: 16))),
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
        listener: (context, state) {},
      ),
    );
  }
}
