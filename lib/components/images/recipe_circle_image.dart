import 'package:base_code_template_flutter/components/loading_view_with_animation/shimmer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../resources/gen/assets.gen.dart';

class RecipeCircleImage extends StatelessWidget {
  const RecipeCircleImage(
      {super.key,
      required this.url,
      required this.width,
      required this.height});

  final String url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          Assets.images.signinBackGround.image(
        fit: BoxFit.fitHeight,
        width: width,
        height: height,
      ),
      progressIndicatorBuilder: (context, url, error) =>
          ShimmerWidget(height: height, width: width),
    ));
  }
}
