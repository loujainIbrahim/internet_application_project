import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/Home/data/my_groups_model.dart';
import 'package:internet_application/SingUp/data/register_model.dart';
import 'package:internet_application/details_group/data/details_group_model.dart';
import 'package:internet_application/details_group/presentation/details_group_screen.dart';
import 'package:internet_application/monitoring_group/presentation/monitoring_group_screen.dart';
import 'package:internet_application/users_in_group/presentation/user_in_group.dart';
import '../../SingUp/data/user_model.dart';
import '../../SingUp/presentation/bloc/bloc.dart';
import '../../core/widgets/snake_bar_widget.dart';
import '../../group/presentation/group_screen.dart';
import '../../users/presentation/users_screen.dart';
import '../../utils/default_button.dart';
import 'bloc/my_groups_cubit.dart';

class Home extends StatefulWidget {
  final User? user;
  Home({super.key, this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _groupNameController = TextEditingController();
  late MyGroupsCubit myGroupsCubit;
  MyGroupsModel? myGroupsModel;
  @override
  void initState() {
    super.initState();
    myGroupsCubit = MyGroupsCubit();
    myGroupsCubit.getMyGroups();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyGroupsCubit>(
      create: (context) => myGroupsCubit,
      child: BlocConsumer<MyGroupsCubit, MyGroupsState>(
        listener: (context, state) {
          if (state is MyGroupsSuccessState) {
            print("ffffff");

            // ErrorSnackBar.show(context, state.createGroupModel.message!);
            // Navigator.pop(context);
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: ( context)=>Home()));
          }
          if (state is DeleteGroupSuccessState) {
            myGroupsCubit.getMyGroups();
            myGroupsModel = myGroupsCubit.myGroupsModel;
            ErrorSnackBar.show(context, "Group deleted successfully");
          }
          if (state is CreateGroupSuccessState) {
            myGroupsCubit.getMyGroups();
            myGroupsModel = myGroupsCubit.myGroupsModel;
            ErrorSnackBar.show(context, "Group add successfully");
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Group Name'),
                      content: TextField(
                        controller: _groupNameController,
                        decoration:
                            InputDecoration(labelText: 'Enter Group Name'),
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
                            String groupName = _groupNameController.text;
                            print('Group Name: $groupName');
                            myGroupsCubit.createGroup(name: groupName);
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              centerTitle: true,
              title: Text('My groups'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'name :${widget.user!.name}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'email :${widget.user!.email}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      )),
                  ListTile(
                    tileColor: Colors.grey[200],
                    leading: Icon(Icons.home),
                    title: Text('My groups'),
                    onTap: () {
                      // Add your navigation logic or any other action
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    tileColor: Colors.grey[200],
                    leading: Icon(Icons.person_3),
                    title: Text('Users'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsersScreen()));
                      // Add your navigation logic or any other action
                      //Navigator.pop(context); // Close the drawer
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    tileColor: Colors.grey[200],
                    leading: Icon(Icons.logout),
                    title: Text('logout'),
                    onTap: () {
                      // Add your navigation logic or any other action
                      //Navigator.pop(context); // Close the drawer
                    },
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
                condition: state is! MyGroupsLoadingState,
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
                builder: (context) {
                  final myGroupsmodel =
                      MyGroupsCubit.get(context).myGroupsModel;
                  return Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  4, // Number of columns in the grid
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                              mainAxisExtent: 220),
                      itemCount: myGroupsmodel
                          .data!.length, // Number of items in the grid
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsGroupScreen(
                                            id: myGroupsmodel.data![index].id!,
                                            is_admin: myGroupsmodel!
                                                .data![index].pivot!.isAdmin!,
                                          )));
                            },
                            child: Container(
                              height: 150,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(
                                  color: Colors
                                      .black, // Set the color of the border
                                  width: 1.0, // Set the width of the border
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                      10.0), // Set the radius of the corners
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        (myGroupsmodel!.data![index].pivot!
                                                    .isAdmin ==
                                                1)
                                            ? IconButton(
                                                onPressed: () {
                                                  void _showGroupOptions(
                                                      int index) {
                                                    // final fileDetails =
                                                    // detailsGroup!
                                                    //     .data![index];
                                                    showMenu(
                                                      context: context,
                                                      position:
                                                          RelativeRect.fromLTRB(
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
                                                                'monitoring'),
                                                            onTap: () {
                                                              // Handle Read File action
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => MonitoringGroupScreen(
                                                                          group_id: myGroupsmodel!
                                                                              .data![index]
                                                                              .id!)));
                                                              // detailsGroupCubit
                                                              //     .OpenFile(
                                                              //     fileDetails
                                                              //         .id!);
                                                              //  _readFile(fileDetails);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                      elevation: 8.0,
                                                    );
                                                  }

                                                  _showGroupOptions(index);
                                                },
                                                icon: Icon(Icons.more_vert))
                                            : Container(),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          myGroupsmodel!.data![index].name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                        ),
                                        Text(
                                          myGroupsmodel!
                                              .data![index].ownerName!,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          myGroupsmodel!
                                              .data![index].ownerEmail!,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UsersInGroup(
                                                            group_id:
                                                                myGroupsmodel!
                                                                    .data![
                                                                        index]
                                                                    .id!,
                                                          )));
                                            },
                                            child: Text("users")),
                                        defaultbutton(
                                            width: 100,
                                            height: 30,
                                            backround: Colors.orange,
                                            text: 'delete',
                                            function: () {
                                              MyGroupsCubit.get(context)
                                                  .deleteGroup(
                                                      id: myGroupsmodel!
                                                          .data![index].id!);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
