import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ISMenu<T> extends StatefulWidget {
  final Widget child;
  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuCanceled onCanceled;

  const ISMenu({
    Key key,
    this.child,
    this.itemBuilder,
    this.onCanceled,
    this.onSelected,
  }) : super(key: key);

  @override
  _ISMenuState<T> createState() => _ISMenuState<T>();
}

class _ISMenuState<T> extends State<ISMenu<T>> {
  Offset position;
  RenderBox overlay;

  @override
  Widget build(BuildContext context) {
    var result = GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        position = details.globalPosition;
      },
      onLongPress: () {
        overlay = Overlay.of(context).context.findRenderObject();
        showISMenu();
      },
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (event.buttons == 2) {
            position = event.position;
            overlay = Overlay.of(context).context.findRenderObject();
            showISMenu();
          }
        },
        child: widget.child,
      ),
    );
    return result;
  }

  showISMenu() {
    var items = widget.itemBuilder(context);
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & Size.zero,
        Offset.zero & overlay.size,
      ),
      items: items,
    ).then<void>((T newValue) {
      if (!mounted) return null;
      if (newValue == null) {
        if (widget.onCanceled != null) widget.onCanceled();
        return null;
      }
      if (widget.onSelected != null) widget.onSelected(newValue);
    });
  }
}
