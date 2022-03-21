import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DashBoardTotalInfoSum {

  String code;
  String msg;
  List<TotalOs> totalOS;
  List<TotalYearMembers> totalYearMembers;
  List<TotalOrders> totalOrders;
  List<TotalCancel> totalCancel;

  // factory OrderAccountMenuD.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  // Map<String, dynamic> toJson() => _$ModelToJson(this);

  DashBoardTotalInfoSum({this.code, this.msg, this.totalOS, this.totalYearMembers, this.totalOrders, this.totalCancel});

  DashBoardTotalInfoSum.fromJson(Map<String, dynamic> json){
    code = json['code'] as String;
    msg = json['msg'] as String;

    if (json['totalOS'] != null){
      totalOS = new List<TotalOs>();
      json['totalOS'].forEach((v){
        totalOS.add(new TotalOs.fromJson(v));
      });
    }

    if (json['totalOrders'] != null) {
      totalOrders = new List<TotalOrders>();
      json['totalOrders'].forEach((v) {
        totalOrders.add(new TotalOrders.fromJson(v));
      });
    }

    if (json['totalOrders'] != null) {
      totalOrders = new List<TotalOrders>();
      json['totalOrders'].forEach((v) {
        totalOrders.add(new TotalOrders.fromJson(v));
      });
    }

    if (json['totalCancel'] != null) {
      totalCancel = new List<TotalCancel>();
      json['totalCancel'].forEach((v) {
        totalCancel.add(new TotalCancel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;

    if (this.totalOS != null) {
      data['totalOS'] = this.totalOS.map((v) => v.toJson()).toList();
    }

    if (this.totalYearMembers != null) {
      data['totalYearMembers'] = this.totalYearMembers.map((v) => v.toJson()).toList();
    }

    if (this.totalOrders != null) {
      data['totalOrders'] = this.totalOrders.map((v) => v.toJson()).toList();
    }

    if (this.totalCancel != null) {
      data['totalCancel'] = this.totalCancel.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class TotalOs{
  String device_gbn;
  String count;

  TotalOs({this.device_gbn, this.count});

  TotalOs.fromJson(Map<String, dynamic> json){
    device_gbn = json['DEVICE_GBN'] as String;
    count = json['COUNT'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DEVICE_GBN'] = this.device_gbn;
    data['COUNT'] = this.count;
    return data;
  }
}

class TotalYearMembers{
  String year;
  String count;

  TotalYearMembers({this.year, this.count});

  TotalYearMembers.fromJson(Map<String, dynamic> json){
    year = json['YEAR'] as String;
    count = json['COUNT'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['YEAR'] = this.year;
    data['COUNT'] = this.count;
    return data;
  }
}

class TotalOrders{
  String status;
  String count;

  TotalOrders({this.status, this.count});

  TotalOrders.fromJson(Map<String, dynamic> json){
    status = json['STATUS'] as String;
    count = json['COUNT'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATUS'] = this.status;
    data['COUNT'] = this.count;
    return data;
  }
}

class TotalCancel{
  String cancel_code;
  String count;

  TotalCancel({this.cancel_code, this.count});

  TotalCancel.fromJson(Map<String, dynamic> json){
    cancel_code = json['CANCEL_CODE'] as String;
    count = json['COUNT'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CANCEL_CODE'] = this.cancel_code;
    data['COUNT'] = this.count;
    return data;
  }
}
