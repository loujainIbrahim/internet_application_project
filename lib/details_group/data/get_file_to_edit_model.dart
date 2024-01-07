class GetFileToEditModel {
  String? data;
  int? id;

  GetFileToEditModel({this.data, this.id});

  GetFileToEditModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['id'] = this.id;
    return data;
  }
}