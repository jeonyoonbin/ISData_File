import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class OrderAccountMenuD {

  String menuCode;
  int cost;
  int menuCost;
  int saleCost;
  int count;
  String menuName;
  String eventYn;
  String listOption;
  List<OrderUnitOptions> orderUnitOptions;

  // factory OrderAccountMenuD.fromJson(Map<String,dynamic> json) => _$ModelFromJson(json);
  // Map<String, dynamic> toJson() => _$ModelToJson(this);

  OrderAccountMenuD({this.menuCode, this.cost, this.menuCost, this.saleCost, this.count, this.menuName, this.eventYn, this.orderUnitOptions});

  OrderAccountMenuD.fromJson(Map<String, dynamic> json){
    menuCode = json['menuCode'] as String;
    cost = json['cost'] as int;
    menuCost = json['menuCost'] as int;
    saleCost = json['saleCost'] as int;
    count = json['count'] as int;
    menuName = json['menuName'] as String;
    eventYn = json['eventYn'] as String;
    if (json['orderUnitOptions'] != null){
      orderUnitOptions = new List<OrderUnitOptions>();
      json['orderUnitOptions'].forEach((v){
        orderUnitOptions.add(new OrderUnitOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuCode'] = this.menuCode;
    data['cost'] = this.cost;
    data['menuCost'] = this.menuCost;
    data['saleCost'] = this.saleCost;
    data['count'] = this.count;
    data['menuName'] = this.menuName;
    data['eventYn'] = this.eventYn;
    if (this.orderUnitOptions != null) {
      data['orderUnitOptions'] = this.orderUnitOptions.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class OrderUnitOptions{
  String optionCode;
  int cost;
  String name;

  OrderUnitOptions({this.optionCode, this.cost, this.name});

  OrderUnitOptions.fromJson(Map<String, dynamic> json){
    optionCode = json['optionCode'] as String;
    cost = json['cost'] as int;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionCode'] = this.optionCode;
    data['cost'] = this.cost;
    data['name'] = this.name;
    return data;
  }
}
