import 'dart:convert';

import 'package:daeguro_admin_app/Model/page_model.dart';
import 'package:daeguro_admin_app/Util/tree_vo.dart';




class Menu extends TreeData {
  bool selected = false;
  String id;
  String pid;
  String menuDepth;
  String name;
  //String tab_name;
  String icon;
  String url;
  //String sideBarYn;
  //String pname;
  bool visible = true;

  toPage() {
    return PageModel(
      id: id,
      //name: tab_name==null ? name : tab_name, //name,
      url: url,
    );
  }

  Menu({
    this.id,
    this.pid,
    this.menuDepth,
    this.name,
    //this.tab_name,
    this.icon,
    this.url,
    //this.sideBarYn,
    //this.pname,
    this.visible
  }) : super(id, pid);

  Menu copyWith({
    String id,
    String pid,
    String menuDepth,
    String name,
    String tab_name,
    String icon,
    String url,
    //String sideBarYn,
    //String pname,
    bool visible
  }) {
    return Menu(
      id: id ?? this.id,
      pid: pid ?? this.pid,
      menuDepth: menuDepth ?? this.menuDepth,
      name: name ?? this.name,
      //tab_name: tab_name ?? this.tab_name,
      icon: icon ?? this.icon,
      url: url ?? this.url,
      //sideBarYn: sideBarYn ?? this.sideBarYn,
      //pname: pname ?? this.pname,
      visible: visible ?? this.visible,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pid': pid,
      'menuDepth': menuDepth,
      'name': name,
      //'tab_name': tab_name,
      'icon': icon,
      'url': url,
      //'sideBarYn': sideBarYn,
      //'pname': pname,
      'visible': visible,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Menu(
      id: map['id'],
      pid: map['pid'],
      menuDepth: map['menuDepth'],
      name: map['name'],
      //tab_name: map['tab_name'],
      icon: map['icon'],
      url: map['url'],
      //sideBarYn: map['sideBarYn'],
      //pname: map['pname'],
      visible: map['visible'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Menu.fromJson(String source) => Menu.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Menu(id: $id, pid: $pid, menuDepth: $menuDepth, checked: $checked, name: $name, icon: $icon, url: $url, visible: $visible)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Menu &&
        o.id == id &&
        o.pid == pid &&
        o.menuDepth == menuDepth &&
        o.name == name &&
        //o.tab_name == tab_name &&
        o.icon == icon &&
        o.url == url &&
        //o.sideBarYn == sideBarYn &&
        //o.pname == pname &&
        o.visible == visible;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    pid.hashCode ^
    menuDepth.hashCode ^
    name.hashCode ^
    //tab_name.hashCode ^
    icon.hashCode ^
    url.hashCode ^
    //sideBarYn.hashCode ^
    //pname.hashCode ^
    visible.hashCode;
  }
}
