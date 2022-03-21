import 'package:flutter/material.dart';

class ISBSFormCard extends StatelessWidget {
  final Widget child;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final bool forceNarrow;
  final EdgeInsets padding;

  const ISBSFormCard({
    Key key,
    this.forceNarrow = false,
    this.children,
    this.child,
    this.crossAxisAlignment,
    this.padding,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (child == null && (children == null || children.isEmpty)){
      return SizedBox();
    }

    return Padding(
      padding: padding ??
          (forceNarrow
              ? EdgeInsets.symmetric(vertical: 12, horizontal: (MediaQuery.of(context).size.width -400) / 2)
              : const EdgeInsets.only(left: 12, top: 12, right: 12)
          ),
      child: Card(
        elevation: 4.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 2, color: Colors.black)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );

  }

}