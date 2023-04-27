import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'package:share_learning/templates/utils/system_helper.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

import '../managers/assets_manager.dart';
import '../managers/color_manager.dart';
import '../managers/style_manager.dart';

class UserProfileEditScreen extends StatefulWidget {
  const UserProfileEditScreen({Key? key}) : super(key: key);

  static const String routeName = '/user-profile-edit';

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  XFile? _addedImage;
  final _form = GlobalKey<FormState>();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _classFocusNode = FocusNode();
  // final _booksCountFocusNode = FocusNode();
  // final _descFocusNode = FocusNode();

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
    });
  }

  Widget _showWaiting() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  User _edittedUser = User(
    id: '',
    firstName: null,
    lastName: null,
    email: null,
    phone: null,
    image: null,
    description: null,
    userClass: null,
    username: null,
    followers: null,
    createdDate: null,
  );

  Future<bool> _updateProfile(
      Session loggedInUserSession, User unEdittedUser, User edittedUser) async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return false;
    }
    _form.currentState!.save();

    var oldUserMap = unEdittedUser.toMap();
    var edittedUserMap = _edittedUser.toMap();

    Map<String, dynamic> changedValues =
        SystemHelper.getChangedValues(oldUserMap, edittedUserMap);

    changedValues['id'] = _edittedUser.id;

    if (await Provider.of<Users>(context, listen: false)
        .updateUserInfo(loggedInUserSession, changedValues)) {
      if (_imageAdded) {
        if (!await Provider.of<Users>(context, listen: false)
            .updateProfilePicture(
                loggedInUserSession, _edittedUser.id, _addedImage as XFile)) {
          BotToast.showSimpleNotification(
            title: 'Something went worng, please try again',
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            align: Alignment(1, 1),
          );
        }
      }
      BotToast.showSimpleNotification(
        title: 'Profile has been successfully updated',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(1, 1),
      );
      return true;
    }

    if (Provider.of<Users>(context, listen: false).userError != null) {
      BotToast.showSimpleNotification(
        title: Provider.of<Users>(context, listen: false)
            .userError!
            .message
            .toString(),
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(1, 1),
      );
    }

    BotToast.showSimpleNotification(
      title: 'Something went wrong, please try again',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // Session loggedInUserSession = args['loggedInUserSession'] as Session;

    // User user = args['user'] as User;
    // Users _users = Provider.of<Users>(context);
    Session loggedInUserSession =
        Provider.of<SessionProvider>(context).session as Session;
    User _user = Provider.of<Users>(context).user as User;
    _edittedUser = _user as User;

    Users users = context.watch<Users>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              _user.image = _addedImage?.path;
              // users.updatePicture(loggedInUserSession, user);
              if (await users.updatePicture(loggedInUserSession, _user)) {
                Navigator.pop(context);
              }

              _showWaiting();

              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: AppPadding.p12),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageAdded
                        ? FileImage(File(_addedImage!.path)) as ImageProvider
                        // : NetworkImage(
                        //     UserHelper.userProfileImage(user),
                        //   ),
                        : _user.image != null
                            ? NetworkImage(
                                UserHelper.userProfileImage(_user),
                              ) as ImageProvider
                            : AssetImage(
                                ImageAssets.noProfile,
                              )),
              ),
              ElevatedButton(
                child: Text('From Gallery'),
                style: ButtonStyle(),
                onPressed: () {
                  _getPicture();
                },
              ),
              SizedBox(
                height: AppHeight.h14,
              ),
              Form(
                key: _form,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // TextFormField(
                    //     initialValue: _edittedUser.firstName,
                    //     cursorColor: Theme.of(context).primaryColor,
                    //     decoration: InputDecoration(
                    //       labelText: 'bookName',
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.redAccent,
                    //         ),
                    //       ),
                    //     ),
                    //     textInputAction: TextInputAction.next,
                    //     onFieldSubmitted: (_) {
                    //       FocusScope.of(context).requestFocus(_lastNameFocusNode);
                    //     },
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Please provide the bookName';
                    //       }
                    //       return null;
                    //     },
                    //     onSaved: (value) {

                    //     }),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                initialValue: _edittedUser.firstName,
                                cursorColor: Theme.of(context).primaryColor,
                                focusNode: _firstNameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  focusColor: Colors.redAccent,
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_lastNameFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide the first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _edittedUser = User.withProperty(
                                      _edittedUser, {'firstName': value});
                                }),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              initialValue: _edittedUser.lastName,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.always,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide the last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _edittedUser = User.withProperty(
                                    _edittedUser, {'lastName': value});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          initialValue: _edittedUser.userClass,
                          focusNode: _classFocusNode,
                          keyboardType: TextInputType.text,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Academic level',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide the academic level';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _edittedUser = User.withProperty(
                                _edittedUser, {'userClass': value});
                            // print(_edittedUser);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _edittedUser.description,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          labelText: 'User description',
                        ),
                        textInputAction: TextInputAction.newline,
                        autovalidateMode: AutovalidateMode.always,
                        minLines: 3,
                        maxLines: 7,
                        // onFieldSubmitted: (_) {
                        //   FocusScope.of(context)
                        //       .requestFocus(_classFocusNode);
                        // },
                        validator: (value) {
                          if (value!.length < 15) {
                            return 'Please provide a big description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _edittedUser = User.withProperty(
                              _edittedUser, {'description': value});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        onPressed: () async {
                          if (await _updateProfile(
                              loggedInUserSession, _user, _edittedUser))
                            Navigator.pushReplacementNamed(
                              context,
                              UserProfileScreen.routeName,
                            );
                          // _showUpdateSnackbar(context);
                          // BotToast.showSimpleNotification(
                          //   title: 'Posted Updated Successfully',
                          //   duration: Duration(seconds: 3),
                          //   backgroundColor: ColorManager.primary,
                          //   titleStyle:
                          //       getBoldStyle(color: ColorManager.white),
                          //   align: Alignment(1, 1),
                          // );
                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
