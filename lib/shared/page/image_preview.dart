import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String url = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return Container(
        child: PhotoView(
      imageProvider: CachedNetworkImageProvider(url),
    ));
  }
}
