import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

class UserProfileEditScreen extends StatefulWidget {
  const UserProfileEditScreen({Key? key}) : super(key: key);

  static const String routeName = '/user-profile-edit';

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  XFile? _addedImage;

  ImagePicker imagePicker = ImagePicker();

  bool _imageAdded = false;

  Future<void> _getPicture() async {
    final imageFiles = await imagePicker.pickImage(
      maxWidth: 770,
      imageQuality: 100,
      source: ImageSource.gallery,
    );

    if (imageFiles == null) return;

    _addedImage = imageFiles;

    setState(() {
      _imageAdded = true;
      //   for (int i = 0; i < _storedImages!.length; i++) {
      //     actualImages.add(_storedImages![i].path);
      //   }
    });
  }

  Widget _showWaiting() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    Session loggedInUserSession = args['loggedInUserSession'] as Session;

    User user = args['user'] as User;

    Users users = context.watch<Users>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              user.image = _addedImage?.path;
              // users.updatePicture(loggedInUserSession, user);
              if (await users.updatePicture(loggedInUserSession, user)) {
                Navigator.pop(context);
              }

              _showWaiting();

              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: AppPadding.p12),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _imageAdded
                    ? FileImage(File(_addedImage!.path)) as ImageProvider
                    : NetworkImage(
                        UserHelper.userProfileImage(user),
                      ),
              ),
            ),
            ElevatedButton(
              child: Text('From Gallery'),
              style: ButtonStyle(),
              onPressed: () {
                _getPicture();
              },
            ),
          ],
        ),
      ),
    );
  }
}
