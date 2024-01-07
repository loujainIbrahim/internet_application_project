import 'dart:html' as html;

void saveToLocalStorage(String key, String value) {
  html.window.localStorage[key] = value;
}

String? readFromLocalStorage(String key) {
  return html.window.localStorage[key];
}