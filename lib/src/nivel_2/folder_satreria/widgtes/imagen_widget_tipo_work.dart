import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyWidgetImagen extends StatelessWidget {
  const MyWidgetImagen(
      {super.key, required this.imageUrl, this.height = 150, this.width = 150});
  final String imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
        height: height,
        width: width,
      ),
    );
  }
}





