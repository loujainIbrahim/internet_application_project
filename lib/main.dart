import 'package:flutter/material.dart';
import 'package:internet_application/Home/presentation/home.dart';
import 'Login/presentation/login_screen.dart';
import 'SingUp/presentation/signup_screen.dart';
import 'core/network/DioHelper.dart';
import 'core/shared.dart';
import 'group/presentation/group_screen.dart';
import 'dart:html' as html;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  token = html.window.localStorage['auth_token'];
  print(token);
  Widget widget = Container();
  if (token != null)
    widget = LoginScreen();
  else
    widget = SignUpScreen();
  runApp( MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({Key? key,required this.startWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: startWidget,
    );
  }
}

