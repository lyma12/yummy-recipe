import 'package:base_code_template_flutter/components/loading_view_with_animation/shimmer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../resources/gen/assets.gen.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    this.width = 50,
    this.height = 50,
    this.radius = 45,
    required this.imageUrl,
    super.key,
  });

  final double width;

  final double height;

  final String? imageUrl;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: imageUrl != null && (imageUrl?.isNotEmpty ?? false)
          ? CachedNetworkImage(
              imageUrl: imageUrl ?? "",
              width: width,
              height: height,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  ShimmerWidget(height: height, width: width),
              errorWidget: (context, url, error) =>
                  Assets.images.avatarDefault.image(
                fit: BoxFit.fitHeight,
                width: width,
                height: height,
              ),
            )
          : Assets.images.avatarDefault.image(
              fit: BoxFit.fitHeight,
              width: width,
              height: height,
            ),
    );
  }
}
