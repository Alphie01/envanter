import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImagesPickers extends StatefulWidget {
  const ImagesPickers({
    super.key,
    required this.selectedUser,
  });
  final User selectedUser;

  @override
  State<ImagesPickers> createState() => _ImagesPickersState();
}

class _ImagesPickersState extends State<ImagesPickers> {
  Future<void> _pickImages(Map data) async {
    final picker = ImagePicker();
    XFile? pickedFiles = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
  }

  Map metaOfImage(String type) {
    return {
      'change_userInfo': 'ok',
      'image_type': type,
      'user_token': User.userProfile!.token
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: paddingHorizontal),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          GestureDetector(
            onTap: () => _pickImages(metaOfImage('')),
            child: Container(
              height: 200,
              child: NetworkContainer(
                imageUrl: widget.selectedUser.userPThumbNail,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.circular(paddingHorizontal)),
                  padding: EdgeInsets.all(paddingHorizontal),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(right: paddingHorizontal * .5),
                            child: AppLargeText(
                              text: 'Değiştir',
                              color: Colors.white,
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.camera,
                            color: Colors.white,
                            size: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => print('object'),
            child: Container(
              height: 100,
              margin: EdgeInsets.all(paddingHorizontal * .5),
              width: 100,
              child: NetworkContainer(
                imageUrl: widget.selectedUser.userProfilePhoto,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.6),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Container(
                      child: FaIcon(
                        FontAwesomeIcons.camera,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
