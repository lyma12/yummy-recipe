import 'dart:io';

import 'package:base_code_template_flutter/components/richtext/app_rich_text.dart';
import 'package:base_code_template_flutter/resources/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType {
  gallery,
  camera,
}

class ImageFromGalleryEx extends StatefulWidget {
  const ImageFromGalleryEx({
    super.key,
    required this.onSaved,
  });

  final void Function(File? data) onSaved;

  @override
  State<StatefulWidget> createState() => _ImageFromGalleryExState();
}

class _ImageFromGalleryExState extends State<ImageFromGalleryEx> {
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
        preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      widget.onSaved(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {
                    await takeImage();
                  },
                  child: Container(
                    width: 260,
                    height: 260,
                    color: ColorName.orange0DEE6723,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    child: _image != null
                        ? Image.file(_image!)
                        : AppRichText.richTextTextIconTextIcon(
                            mainText: AppLocalizations.of(context)?.take_photo,
                            firstIcon: IconButton(
                              onPressed: () async {
                                setState(() {
                                  type = ImageSourceType.camera;
                                });
                                await takeImage();
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                            textBetween: ' or ',
                            secondIcon: IconButton(
                              onPressed: () async {
                                setState(() {
                                  type = ImageSourceType.gallery;
                                });
                                await takeImage();
                              },
                              icon: const Icon(Icons.folder),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: () {
                      // clear image
                      setState(() {
                        _image = null;
                      });
                      widget.onSaved(_image);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
