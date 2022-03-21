
import 'package:daeguro_admin_app/ISWidget/is_button.dart';
import 'package:flutter/material.dart';

class ISButtons {
  ISButtons._();

  static add(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '추가' : null, iconData: Icons.add, onPressed: onPressed);

  static delete(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '삭제' : null, iconData: Icons.delete, onPressed: onPressed);

  static edit(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '수정' : null, iconData: Icons.edit, onPressed: onPressed);

  static query(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? 'Query' : null, iconData: Icons.search, onPressed: onPressed);

  static reset(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '리셋' : null, iconData: Icons.refresh, onPressed: onPressed);

  static save(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '저장' : null, iconData: Icons.save, onPressed: onPressed);

  static cancel(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '취소' : null, iconData: Icons.cancel, onPressed: onPressed);

  static commit(context, onPressed, {showLabel: true}) => ISButton(label: showLabel ? '완료' : null, iconData: Icons.done, onPressed: onPressed);
}
