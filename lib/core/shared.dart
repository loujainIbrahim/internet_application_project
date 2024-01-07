
import 'network/cache_helper.dart';
import 'dart:convert';
import 'dart:html' as html;
String? token;
String? gettoken() {
  token = html.window.localStorage['auth_token'];
  print("*******the value toke is $token");
  return token;
}
const LOGIN="login";
const ALLCATEGORY="Allcategory";