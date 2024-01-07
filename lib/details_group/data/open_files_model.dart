// class OpenFilesToEditModel {
//   List<MyData>? data;
//
//   OpenFilesToEditModel({this.data});
//
//   OpenFilesToEditModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <MyData>[];
//       json['data'].forEach((v) {
//         data!.add(new MyData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class MyData {
  String data;
  int id;

  MyData({required this.data, required this.id});

  factory MyData.fromJson(Map<String, dynamic> json) {
    return MyData(
      data: json['data'] as String,
      id: json['id'] as int,
    );
  }
}