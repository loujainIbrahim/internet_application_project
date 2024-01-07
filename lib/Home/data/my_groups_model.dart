class MyGroupsModel {
  int? status;
  String? message;
  List<Data>? data;

  MyGroupsModel({this.status, this.message, this.data});

  MyGroupsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? ownerName;
  String? ownerEmail;
  Pivot? pivot;

  Data(
      {this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.ownerName,
        this.ownerEmail,
        this.pivot});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ownerName = json['owner_name'];
    ownerEmail = json['owner_email'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['owner_name'] = this.ownerName;
    data['owner_email'] = this.ownerEmail;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? groupId;
  int? isAdmin;

  Pivot({this.userId, this.groupId, this.isAdmin});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    groupId = json['group_id'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['group_id'] = this.groupId;
    data['is_admin'] = this.isAdmin;
    return data;
  }
}