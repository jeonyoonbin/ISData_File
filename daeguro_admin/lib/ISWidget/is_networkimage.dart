
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ISNetworkImage extends StatelessWidget{
  final String imageUrl;

  const ISNetworkImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // https://github.com/flutter/flutter/issues/41563
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      imageUrl, (int viewId) => ImageElement()..src = imageUrl,
    );
    return HtmlElementView(viewType: imageUrl);
  }
}