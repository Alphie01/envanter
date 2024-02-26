import 'dart:io';

import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerAndUploaderWidget extends StatefulWidget {
  const ImagePickerAndUploaderWidget(
      {super.key, required this.selectImagesFunction});

  @override
  _ImagePickerAndUploaderWidgetState createState() =>
      _ImagePickerAndUploaderWidgetState();

  final Function(List<File>) selectImagesFunction;
}

class _ImagePickerAndUploaderWidgetState
    extends State<ImagePickerAndUploaderWidget> {
  bool isGridview = false;
  ImagePicker picker = ImagePicker();

  List<File> _selectedImages = [];

  void deleteShopTable(File deletedImage) {
    int indexOfDeletedPhoto = _selectedImages.indexWhere(
      (image) => image == deletedImage,
    );

    if (indexOfDeletedPhoto != -1) {
      setState(() {
        _selectedImages.removeAt(indexOfDeletedPhoto);
      });
      widget.selectImagesFunction(_selectedImages);
    }
  }

  //TODO İmageEditör Ekle !

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (pickedFiles.isNotEmpty) {
      setState(() {
        if (_selectedImages.isEmpty) {
          _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
        } else {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        }
      });
    }
    widget.selectImagesFunction(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLargeText(
              text: 'Ürününüzün Fotoğrafları',
            ),
          ],
        ),
        _selectedImages.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedImagesGridView(
                    deleteImage: (deletedIamge) {
                      deleteShopTable(deletedIamge);
                    },
                    selectedImages: _selectedImages,
                    isGridView: isGridview,
                  ),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: paddingHorizontal / 2),
                      padding: EdgeInsets.all(paddingHorizontal),
                      decoration: BoxDecoration(
                          color: AppTheme.contrastColor1,
                          borderRadius: defaultRadius),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Yeni Fotoğraf Ekle',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          const FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : GestureDetector(
                onTap: _pickImages,
                child: Container(
                  margin: EdgeInsets.only(top: paddingHorizontal),
                  decoration: BoxDecoration(
                      color: AppTheme.background.withOpacity(.6),
                      borderRadius: defaultRadius),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * .1),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(paddingHorizontal),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1,
                            shape: BoxShape.circle),
                        child: FaIcon(
                          FontAwesomeIcons.upload,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: paddingHorizontal),
                        child:
                            AppText(text: 'Fotoğraf Eklemek İçin Tıklayınız!'),
                      ),
                    ],
                  ),
                ),
              ),
        /* Row(
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ) */
      ],
    );
  }
}

// ignore: must_be_immutable
class SelectedImagesGridView extends StatelessWidget {
  SelectedImagesGridView(
      {super.key,
      required this.selectedImages,
      required this.isGridView,
      required this.deleteImage});

  final Function(File deletedImage) deleteImage;
  bool isGridView;
  final List<File> selectedImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
      child: isGridView
          ? GridView.builder(
              padding: paddingZero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: selectedImages.length < 4 ? 2 : 3,
                crossAxisSpacing: paddingHorizontal,
                mainAxisSpacing: paddingHorizontal,
              ),
              itemCount: selectedImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        selectedImages[index],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  /* child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(.4),
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.expand,
                        color: Colors.white,
                      ),
                    ),
                  ), */
                );
              },
            )
          : Container(
              height: MediaQuery.of(context).size.height * .4,
              child: ListView.builder(
                padding: paddingZero,
                itemCount: selectedImages.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return Container(
                    width: MediaQuery.of(context).size.height * .4,
                    height: MediaQuery.of(context).size.height * .4,
                    margin: EdgeInsets.only(right: paddingHorizontal),
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      image: DecorationImage(
                        image: FileImage(
                          selectedImages[index],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                deleteImage(selectedImages[index]);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: paddingHorizontal / 2,
                                    top: paddingHorizontal / 2),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(.6),
                                ),
                                child: const FaIcon(
                                  FontAwesomeIcons.x,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        /* Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(.6),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.expand,
                            size: 15,
                            color: Colors.white,
                          ),
                        ), */
                        Container(),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
