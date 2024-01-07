import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/Login/presentation/login_screen.dart';
import 'package:internet_application/group/presentation/group_screen.dart';

import '../../Home/presentation/home.dart';
import '../../core/shared.dart';
import '../../core/widgets/alert.dart';
import '../../core/widgets/snake_bar_widget.dart';
import '../../utils/default_button.dart';
import 'bloc/bloc.dart';
import 'bloc/status.dart';
import 'dart:html' as html;

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var NameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignInScreenStatesTeacher>(
        listener: (context, state) {
          if (state is SignInErrorStateTeacher) {
            print(state.error);
          } else if (state is SignInSuccessStateTeacher) {
            print("success");
            if (state.RegisterModel!.token! != null) {
              html.window.localStorage['auth_token'] =
                  state.RegisterModel!.token!;
              token = state.RegisterModel!.token!;
              ErrorSnackBar.show(context, "register successfully");
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home(user:state.RegisterModel!.user!)));
            } else {
              showAlertDialog(context, "email or password not correct");
            }
          } else if (state is SignInErrorStateTeacher) {
            showAlertDialog(context, "email or password not correct");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Set the color of the border
                          width: 1.0, // Set the width of the border
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                              10.0), // Set the radius of the corners
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: const Text(
                                    ' Sign Up ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: NameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your first name',
                                labelText: 'first name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                labelText: 'email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText:
                                  SignUpCubit.get(context).isPasswordShow,
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                labelText: 'password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    SignUpCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                  icon: Icon(SignUpCubit.get(context).suffix),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 16.0),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              // height: 50.h,
                              // width: double.infinity,
                              child: ConditionalBuilder(
                                  condition:
                                      state is! SignInLoadingStateTeacher,
                                  fallback: (context) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  builder: (context) => defaultbutton(
                                      backround: Colors.deepOrange,
                                      text: 'Sing up',
                                      function: () {
                                        if (formKey!.currentState!.validate()) {
                                          print(NameController.text);
                                          print(emailController.text);
                                          print(passwordController.text);
                                          SignUpCubit.get(context).userRegister(
                                            name: NameController.text,
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        }
                                      })),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("have account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Text('Login'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
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
