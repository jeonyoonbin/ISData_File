import 'dart:convert';

import 'package:flutter/material.dart';

class PageModel {
  String id;
  String name;
  String url;
  Widget widget;

  PageModel({
    this.id,
    this.name,
    this.url,
    this.widget,
  });

  PageModel copyWith({
    String id,
    String name,
    String nameEn,
    String url,
    Widget widget,
  }) {
    return PageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      widget: widget ?? this.widget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'widget': widget.toStringShort(),
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PageModel(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      // widget: Widget.fromMap(map['widget']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PageModel.fromJson(String source) => PageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Page(id: $id, name: $name, url: $url, widget: $widget)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PageModel && o.id == id && o.name == name && o.url == url && o.widget == widget;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ url.hashCode ^ widget.hashCode;
  }
}
