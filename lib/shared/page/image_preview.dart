import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewer extends StatelessWidget {
  const ImagePreviewer({this.imgUrl});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context).settings.arguments;

    return Container(
        child: PhotoView(
      imageProvider: CachedNetworkImageProvider(url),
    ),);
  }
}
