class MonitoringModel {
  int? status;
  String? message;
  List<Data>? data;

  MonitoringModel({this.status, this.message, this.data});

  MonitoringModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = List<Data>.from(json['data'].map((data) => Data.fromJson(data)));
    }
  }
}

class Data {
  int? id;
  int? userId;
  String? name;
  String? action;
  int? target;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.name,
    this.action,
    this.target,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    action = json['do'];
    target = json['on'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
