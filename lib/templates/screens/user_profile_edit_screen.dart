import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/user_profile_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/utils/system_helper.dart';
import 'package:share_learning/templates/utils/user_helper.dart';

import '../managers/assets_manager.dart';
import '../managers/routes_manager.dart';

class UserProfileEditScreen extends StatefulWidget {
  const UserProfileEditScreen({Key? key}) : super(key: key);

  // static const String routeName = '/user-profile-edit';

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              _userProvider.user!.image =
                  _userProvider.userProfileScreenAddedImage?.path;
              // users.updatePicture(loggedInUserSession, user);
              if (await _userProvider.updatePicture(
                  _userProvider.sessionProvider.session as Session,
                  _userProvider.user as User)) {
                Navigator.pop(context);
              }

              Center(
                child: CircularProgressIndicator(),
              );
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
                    backgroundImage: _userProvider.userProfileScreenImageAdded
                        ? FileImage(File(
                            _userProvider.userProfileScreenAddedImage!.path))
                        // : NetworkImage(
                        //     UserHelper.userProfileImage(user),
                        //   ),
                        : _userProvider.user!.image != null
                            ? NetworkImage(
                                UserHelper.userProfileImage(
                                    _userProvider.user!),
                              ) as ImageProvider
                            : AssetImage(
                                ImageAssets.noProfile,
                              )),
              ),
              ElevatedButton(
                child: Text('From Gallery'),
                style: ButtonStyle(),
                onPressed: () {
                  _userProvider.userProfileScreenGetPicture();
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
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                initialValue: _userProvider
                                    .userProfileScreenEdittedUser.firstName,
                                cursorColor: Theme.of(context).primaryColor,
                                focusNode: _userProvider
                                    .userProfileScreenFirstNameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  focusColor: Colors.redAccent,
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(
                                      _userProvider
                                          .userProfileScreenLastNameFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide the first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userProvider.userProfileScreenEdittedUser =
                                      User.withProperty(
                                          _userProvider
                                              .userProfileScreenEdittedUser,
                                          {'firstName': value});
                                }),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              initialValue: _userProvider
                                  .userProfileScreenEdittedUser.lastName,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.always,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(
                                    _userProvider
                                        .userProfileScreenDescriptionFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide the last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userProvider.userProfileScreenEdittedUser =
                                    User.withProperty(
                                        _userProvider
                                            .userProfileScreenEdittedUser,
                                        {'lastName': value});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          initialValue: _userProvider
                              .userProfileScreenEdittedUser.userClass,
                          focusNode:
                              _userProvider.userProfileScreenClassFocusNode,
                          keyboardType: TextInputType.text,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Academic level',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_userProvider
                                .userProfileScreenDescriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide the academic level';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userProvider.userProfileScreenEdittedUser =
                                User.withProperty(
                                    _userProvider.userProfileScreenEdittedUser,
                                    {'userClass': value});
                            // print(_edittedUser);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _userProvider
                            .userProfileScreenEdittedUser.description,
                        focusNode:
                            _userProvider.userProfileScreenDescriptionFocusNode,
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
                          _userProvider.userProfileScreenEdittedUser =
                              User.withProperty(
                                  _userProvider.userProfileScreenEdittedUser,
                                  {'description': value});
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
                          setState(() => _userProvider
                              .userProfileScreenShowLoading = true);

                          if (_userProvider.userProfileScreenShowLoading) {
                            AlertHelper.showLoading();
                          }

                          if (await _userProvider
                              .userProfileScreenUpdateProfile(_form))
                            setState(() => {
                                  _userProvider.userProfileScreenShowLoading =
                                      false
                                });
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.userProfileScreenRoute,
                          );
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
