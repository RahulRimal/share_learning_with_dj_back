import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/comment_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/view_models/providers/theme_provider.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/screens/user_profile_edit_screen.dart';
import 'package:share_learning/templates/screens/wishlisted_books_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../managers/routes_manager.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
  }) : super(key: key);

  // static const String routeName = '/user-profile';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<UserProvider>(context, listen: false)
        .bindUserProfileScreenViewModel(context);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Added this line to save the reference of provider so it doesn't throw an exception on dispose
  //   bookProvider = Provider.of<BookProvider>(context, listen: false);
  // }

  @override
  void dispose() {
    Provider.of<UserProvider>(context, listen: false)
        .unbindUserProfileScreenViewModel();
    super.dispose();
  }

  _profilePageUI(UserProvider userProvider) {
    ThemeData _theme = Theme.of(context);
    // if (userSession.loading) {
    if (userProvider.sessionProvider.loading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (userProvider.sessionProvider.sessionError != null) {
      return Container(
        child: Center(
          child: Text('Error fetching user data'),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ---------------------- User top section starts here ----------------------------
        Container(
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: AppMargin.m4,
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: _theme.colorScheme.secondaryContainer,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p18,
                        // vertical: AppPadding.p2,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: AppPadding.p30,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.r100,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          AppPadding.p4,
                                        ),
                                        child: userProvider.user!.image == null
                                            ? Image.asset(
                                                ImageAssets.noProfile,
                                              )
                                            : CircleAvatar(
                                                radius: AppRadius.r70,
                                                backgroundImage: NetworkImage(
                                                  UserHelper.userProfileImage(
                                                      userProvider.user!),
                                                ),
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: AppPadding.p8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            // 'Rahul Rimal',
                                            UserHelper.userDisplayName(
                                                userProvider.user!),

                                            style:
                                                _theme.textTheme.displayMedium,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: AppPadding.p14,
                                            ),
                                            child: Text(
                                              // 'CSIT',
                                              UserHelper.userClass(
                                                  userProvider.user!),
                                              // style: getBoldStyle(
                                              //   color: ColorManager.black,
                                              //   fontSize: FontSize.s14,
                                              // ),
                                              style: _theme
                                                  .textTheme.headlineSmall,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: AppPadding.p2,
                                          ),
                                          child: Text(
                                              userProvider.user!.email
                                                  as String,
                                              style:
                                                  _theme.textTheme.titleSmall),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                    AppPadding.p8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: ColorManager.darkPrimary,
                                            width: 2,
                                          ),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: ColorManager.white,
                                            size: AppSize.s30,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              RoutesManager
                                                  .userProfileEditScreenRoute,
                                              arguments: {
                                                // 'loggedInUserSession': userSession.session,
                                                'loggedInUserSession':
                                                    userProvider.sessionProvider
                                                        .session,
                                                'user': userProvider.user!,
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                          AppPadding.p12,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorManager.primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: ColorManager.darkPrimary,
                                              width: 2,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.logout_rounded,
                                              color: ColorManager.white,
                                              size: AppSize.s30,
                                            ),
                                            onPressed: () async {
                                              userProvider
                                                  .userProfileScreenLogOut(
                                                      context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: AppHeight.h14,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: AppPadding.p8),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Description',
                                      textAlign: TextAlign.start,
                                      style: _theme.textTheme.headlineSmall,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Text(
                                        // 'I am a student and future billionair',
                                        UserHelper.userDescription(
                                            userProvider.user!),
                                        softWrap: true,

                                        style: _theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ---------------------- User top section ends here ----------------------------

        // ---------------------- User content section starts here ----------------------------
        Container(
          // color: _theme.colorScheme.background,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p8,
                  horizontal: AppPadding.p18,
                ),
                child: Text(
                  'Content',
                  // style: getBoldStyle(
                  //   color: ColorManager.primary,
                  //   fontSize: FontSize.s14,
                  // ),
                  style: _theme.textTheme.displaySmall,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RoutesManager.wishlistedBooksScreenRoute);
                },
                leading: Icon(
                  Icons.favorite_border,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Wishlisted',
                  // style: getBoldStyle(
                  //   color: ColorManager.black,
                  //   fontSize: FontSize.s16,
                  // ),
                  style: _theme.textTheme.headlineMedium,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: AppSize.s30,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(RoutesManager.userPostsScreenRoute);
                },
                leading: Icon(
                  Icons.book_rounded,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Your Posts',
                  // style: getBoldStyle(
                  //   color: ColorManager.black,
                  //   fontSize: FontSize.s16,
                  // ),
                  style: _theme.textTheme.headlineMedium,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: AppSize.s30,
                ),
              ),
            ],
          ),
        ),
        // ---------------------- User content section ends here ----------------------------
        // ---------------------- User preferences section starts here ----------------------------
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // padding: EdgeInsets.zero,
            // shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p8,
                  horizontal: AppPadding.p18,
                ),
                child: Text(
                  'Preferences',
                  // style: getBoldStyle(
                  //   color: ColorManager.primary,
                  //   fontSize: FontSize.s14,
                  // ),
                  style: _theme.textTheme.displaySmall,
                ),
              ),
              ListTile(
                onTap: () {
                  // Define a list of options
                  List<String> languages = [
                    'English',
                    'Nepali',
                    'Hindi',
                    'Chinese',
                  ];

                  String selectedLanguage = 'English';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text('Select an option'),
                        contentPadding: EdgeInsets.zero,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: languages
                              .map(
                                (option) => ListTile(
                                  tileColor: selectedLanguage == option
                                      ? ColorManager.primary
                                      : null,
                                  title: Text(
                                    option,
                                    // style: getBoldStyle(
                                    //   color: ColorManager.black,
                                    //   fontSize: FontSize.s16,
                                    // ),
                                    style: _theme.textTheme.headlineSmall,
                                  ),
                                  onTap: () {
                                    // Do something when the option is tapped
                                    selectedLanguage = option;
                                    Navigator.of(context).pop(option);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  );
                },
                leading: Icon(
                  Icons.language,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Language',
                  // style: getBoldStyle(
                  //   color: ColorManager.black,
                  //   fontSize: FontSize.s16,
                  // ),
                  style: _theme.textTheme.headlineMedium,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: AppSize.s30,
                ),
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) => ListTile(
                  onTap: () {
                    // Define a list of options
                    // List<String> appThemes = [
                    //   'Light',
                    //   'Dark',
                    // ];
                    Map<ThemeMode, String> appThemes = {
                      ThemeMode.light: 'Light',
                      ThemeMode.dark: 'Dark',
                    };

                    // String selectedMode = 'Light';
                    // ThemeProvider themeProvider =
                    //     Provider.of<ThemeProvider>(context, listen: false);
                    // ThemeMode selectedMode = themeProvider.themeMode;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // title: Text('Select an option'),
                          contentPadding: EdgeInsets.zero,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: appThemes.entries
                                .map(
                                  (entry) => ListTile(
                                    tileColor:
                                        themeProvider.themeMode == entry.key
                                            ? ColorManager.primary
                                            : null,
                                    title: Text(
                                      entry.value,
                                      // style: getBoldStyle(
                                      //   color: ColorManager.black,
                                      //   fontSize: FontSize.s16,
                                      // ),
                                      style: _theme.textTheme.headlineSmall,
                                    ),
                                    onTap: () {
                                      // Do something when the option is tapped
                                      themeProvider.setTheme(entry.key);
                                      // print('here');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  leading: Icon(
                    Icons.dark_mode_outlined,
                    size: FontSize.s24,
                  ),
                  title: Text(
                    'Darkmode',
                    // style: getBoldStyle(
                    //   color: ColorManager.black,
                    //   fontSize: FontSize.s16,
                    // ),
                    style: _theme.textTheme.headlineMedium,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    size: AppSize.s30,
                  ),
                ),
              ),
            ],
          ),
        ),
        // ---------------------- User preferences section ends here ----------------------------
        // ---------------------- More section starts here ----------------------------
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // padding: EdgeInsets.zero,
            // shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPadding.p8,
                  horizontal: AppPadding.p18,
                ),
                child: Text(
                  'More options',
                  style: _theme.textTheme.displaySmall,
                ),
              ),
              ListTile(
                onTap: () {
                  String password = "";
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Are you sure?',
                        style: _theme.textTheme.titleMedium,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You won't be able to recover your account",
                            // style: getRegularStyle(
                            //   fontSize: FontSize.s16,
                            //   color: ColorManager.black,
                            // ),
                            style: _theme.textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: AppHeight.h12,
                          ),
                          TextFormField(
                            cursorColor: _theme.primaryColor,
                            decoration: InputDecoration(
                              labelText: 'Enter your password to confirm',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                                userProvider
                                        .userProfileScreenShowConfirmButton =
                                    password.isNotEmpty;
                              });
                              // print(showConfirmButton);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password to confirm';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        if (userProvider.userProfileScreenShowConfirmButton)
                          TextButton(
                            child: Text(
                              'Confirm delete',
                              // style: getBoldStyle(
                              //   fontSize: FontSize.s16,
                              //   color: ColorManager.primary,
                              // ),
                              style: _theme.textTheme.headlineMedium,
                            ),
                            // onPressed: showConfirmButton
                            //     ? null
                            onPressed: () {
                              userProvider
                                      .userProfileScreenUserDeletionConfirmed =
                                  true;
                              Navigator.of(context).pop();
                            },
                          ),
                        // TextButton(
                        //   child: Text(
                        //     'No',
                        //     style: getBoldStyle(
                        //       fontSize: FontSize.s16,
                        //       color: Colors.green,
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                      ],
                    ),
                  ).then((_) {
                    if (userProvider.userProfileScreenUserDeletionConfirmed) {
                      userProvider.userProfileScreenDeleteUserAccount(password);
                    }
                  });
                },
                leading: Icon(
                  Icons.delete_forever,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Delete Account',
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: AppSize.s30,
                ),
              ),
            ],
          ),
        ),
        // ---------------------- MOre preferences section ends here ----------------------------
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = context.watch<UserProvider>();
    return Scaffold(
      // backgroundColor: ColorManager.lightestGrey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                RoutesManager.userProfileEditScreenRoute,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _profilePageUI(_userProvider),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 2,
      ),
    );
  }
}
