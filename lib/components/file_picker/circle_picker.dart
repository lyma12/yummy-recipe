import 'dart:io';

import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/gen/assets.gen.dart';
import 'image_form_gallery_ex.dart';

class CirclePicker extends StatefulWidget {
  const CirclePicker({
    super.key,
    required this.onSaved,
    this.existingImageUrl,
  });

  final void Function(File? data) onSaved;
  final String? existingImageUrl;

  @override
  State<StatefulWidget> createState() => _ImageFromGalleryExState();
}

class _ImageFromGalleryExState extends State<CirclePicker> {
  File? _image;
  late ImagePicker imagePicker;
  var type = ImageSourceType.gallery;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  Future<void> takeImage() async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile? image = await imagePicker.pickImage(
      source: source,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      widget.onSaved(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.existingImageUrl;
    return Center(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black, // Border color
              width: 3, // Border width
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: ColorName.orange0DEE6723,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : (imageUrl != null
                    ? CachedNetworkImageProvider(imageUrl)
                    : AssetImage(Assets.images.avatarDefault.path)
                        as ImageProvider),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Make the border circular
              color: Colors.white, // Background color for the button
              border: Border.all(
                color: Theme.of(context).colorScheme.primary, // Border color
                width: 2.0, // Border width
              ),
            ),
            child: IconButton(
              onPressed: () async {
                await takeImage();
              },
              icon: const Icon(
                Icons.edit,
                size: 15,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
