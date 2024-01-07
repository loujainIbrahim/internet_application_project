import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application/Home/presentation/home.dart';
import '../../SingUp/presentation/signup_screen.dart';
import '../../core/shared.dart';
import '../../core/widgets/alert.dart';
import '../../core/widgets/snake_bar_widget.dart';
import '../../utils/default_button.dart';
import '../presentation/bloc/bloc.dart';
import '../presentation/bloc/status.dart';
import 'dart:html' as html;
class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emilController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => LoginScreenCubit(),
      child: BlocConsumer<LoginScreenCubit, LoginScreenStatus>(
        listener: (context, state) {
          if (state is LoginScreenSuccessState) {
            if (state.loginModel.token != null) {
              html.window.localStorage['auth_token'] = state.loginModel.token!;
              token = state.loginModel.token!;
             // print(LoginScreenCubit.get(context).message);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home(user: state.loginModel!.user!,)));
              // print(LoginScreenCubit.get(context).message);

              ErrorSnackBar.show(context, "successfully login");

              // print("from model");
              // print(state.loginModel.token);
              // print("from cache");
              // print(token);
            } else {
              showAlertDialog(context, "email or password not correct");
            }
          } else if (state is LoginScreenErrorState) {
            showAlertDialog(context, "email or password not correct");
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Container(
                    height: 300,
                    width: 500,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0), // Set the radius of the corners
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
                                  ' Login ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: emilController,
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
                                LoginScreenCubit.get(context).isPasswordShow,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              labelText: 'password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  LoginScreenCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon:
                                    Icon(LoginScreenCubit.get(context).suffix),
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
                    ConditionalBuilder(
                      condition: state is! LoginScreenLoadingState,
                      builder: (context) =>    defaultbutton(
                          backround: Colors.deepOrange,
                          text: 'Login',
                          function: () {
                            if (formKey!.currentState!.validate()) {
                              LoginScreenCubit.get(context).userlogin(
                                  email: emilController.text,
                                  password: passwordController.text);
                            }
                          }),
                      fallback: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("do'nt have account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                                child: Text('Register'),
                              )
                            ],
                          )
                    ]),
                  ),
                ),
              ),
            ),
            ));
        },
      ),
    );
  }
}
