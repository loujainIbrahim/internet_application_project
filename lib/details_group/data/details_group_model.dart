class DetailsGroup {
  int? status;
  String? message;
  List<Data>? data;

  DetailsGroup({this.status, this.message, this.data});

  DetailsGroup.fromJson(Map<String, dynamic> json) {
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
  String? file;
  int? bookingBy;
  int? groupId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.file,
        this.bookingBy,
        this.groupId,
        this.userId,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    bookingBy = json['booking_by'];
    groupId = json['group_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    data['booking_by'] = this.bookingBy;
    data['group_id'] = this.groupId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}