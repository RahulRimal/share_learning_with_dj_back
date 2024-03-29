import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
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
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false)
        .bindUserProfileEditScreenViewModel(context);
  }

  @override
  void dispose() {
    Provider.of<UserProvider>(context, listen: false)
        .unbindUserProfileEditScreenViewModel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = context.watch<UserProvider>();
    ThemeData _theme = Theme.of(context);

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
                    backgroundImage: _userProvider
                            .userProfileEditScreenImageAdded
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
                  _userProvider.userProfileEditScreenGetPicture();
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
                                    .userProfileEditScreenEdittedUser.firstName,
                                cursorColor: Theme.of(context).primaryColor,
                                focusNode: _userProvider
                                    .userProfileEditScreenFirstNameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  focusColor: Colors.redAccent,
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.always,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_userProvider
                                      .userProfileEditScreenLastNameFocusNode);
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide the first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userProvider
                                          .userProfileEditScreenEdittedUser =
                                      User.withProperty(
                                          _userProvider
                                              .userProfileEditScreenEdittedUser,
                                          {'firstName': value});
                                }),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              initialValue: _userProvider
                                  .userProfileEditScreenEdittedUser.lastName,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.always,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_userProvider
                                    .userProfileEditScreenDescriptionFocusNode);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide the last name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userProvider.userProfileEditScreenEdittedUser =
                                    User.withProperty(
                                        _userProvider
                                            .userProfileEditScreenEdittedUser,
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
                              .userProfileEditScreenEdittedUser.userClass,
                          focusNode:
                              _userProvider.userProfileEditScreenClassFocusNode,
                          keyboardType: TextInputType.text,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Academic level',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_userProvider
                                .userProfileEditScreenDescriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide the academic level';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _userProvider.userProfileEditScreenEdittedUser =
                                User.withProperty(
                                    _userProvider
                                        .userProfileEditScreenEdittedUser,
                                    {'userClass': value});
                            // print(_edittedUser);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: _userProvider
                            .userProfileEditScreenEdittedUser.description,
                        focusNode: _userProvider
                            .userProfileEditScreenDescriptionFocusNode,
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
                          _userProvider.userProfileEditScreenEdittedUser =
                              User.withProperty(
                                  _userProvider
                                      .userProfileEditScreenEdittedUser,
                                  {'description': value});
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ColorManager.primary,),
                        ),
                        onPressed: () async {
                          
                          _userProvider
                                      .userProfileEditScreenSetShowLoading(true);

                          if (_userProvider.userProfileEditScreenShowLoading) {
                            AlertHelper.showLoading();
                          }

                          if (await _userProvider
                              .userProfileEditScreenUpdateProfile(_form))
                            
                                  // _userProvider
                                  //     .userProfileEditScreenShowLoading = false;
                                  _userProvider
                                      .userProfileEditScreenSetShowLoading(false);
                                
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.userProfileScreenRoute,
                          );
                        },
                        child: Text(
                          'Update Profile',
                          // style: TextStyle(
                          //   color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          // ),
                          style: _theme.textTheme.headlineSmall,
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
