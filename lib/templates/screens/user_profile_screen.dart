import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/comment.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/screens/user_posts_screen.dart';
import 'package:share_learning/templates/screens/user_profile_edit_screen.dart';
import 'package:share_learning/templates/screens/wishlisted_books_screen.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
import 'package:share_learning/templates/widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
  }) : super(key: key);

  static const String routeName = '/user-profile';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _logOut(Session session) async {
    SharedPreferences prefs = await _prefs;
    Provider.of<Books>(context, listen: false).setBooks([]);
    // Provider.of<Users>(context, listen: false).logoutUser(session.id);
    Provider.of<Users>(context, listen: false).logoutUser('1');
    Provider.of<Comments>(context, listen: false).setComments([]);
    prefs.remove('accessToken');
    prefs.remove('refreshToken');
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  _deleteUserAccount(Session userSession, String password) async {
    bool value = await Provider.of<Users>(context, listen: false)
        .deleteUserAccount(userSession, password);
    if (value) {
      BotToast.showSimpleNotification(
        title: 'Account deleted successfully',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
    } else
      BotToast.showSimpleNotification(
        title: 'Something went wrong, Please try again!',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
  }

  // Future<void> _logout(Session session) async {
  //   SharedPreferences prefs = await _prefs;
  //   Provider.of<Books>(context, listen: false).setBooks([]);
  //   Provider.of<Users>(context, listen: false).logoutUser(session.id);
  //   Provider.of<Comments>(context, listen: false).setComments([]);
  //   prefs.remove('accessToken');
  //   Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  // }

  _profilePageUI(SessionProvider userSession, User user) {
    if (userSession.loading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (userSession.sessionError != null) {
      return Container(
        child: Center(
          child: Text('Error fetching user data'),
        ),
      );
    }

    Session? authSession = userSession.session;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // ---------------------- User top section starts here ----------------------------
        Container(
          // decoration: BoxDecoration(
          //   color: ColorManager.grey,
          // ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // color: ColorManager.darkPrimary,
                      color: ColorManager.white,
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
                                      color: ColorManager.primary,
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
                                        child: user.image == null
                                            ? Image.asset(
                                                ImageAssets.noProfile,
                                              )
                                            : CircleAvatar(
                                                radius: AppRadius.r70,
                                                backgroundImage: NetworkImage(
                                                  user.image!.contains('http')
                                                      ? user.image as String
                                                      : UserHelper
                                                          .userProfileImage(
                                                              user),
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
                                            UserHelper.userDisplayName(user),
                                            style: getBoldStyle(
                                                fontSize: FontSize.s18,
                                                color: ColorManager.primary),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: AppPadding.p14,
                                            ),
                                            child: Text(
                                              // 'CSIT',
                                              UserHelper.userClass(user),
                                              style: getBoldStyle(
                                                color: ColorManager.black,
                                                fontSize: FontSize.s14,
                                              ),
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
                                            // 'mail@rahul.com',
                                            user.email as String,
                                            style: getMediumStyle(
                                              color: ColorManager.black,
                                              fontSize: FontSize.s12,
                                            ),
                                          ),
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
                                              UserProfileEditScreen.routeName,
                                              arguments: {
                                                // 'loggedInUserSession': userSession.session,
                                                'loggedInUserSession':
                                                    userSession.session,
                                                'user': user,
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
                                              _logOut(userSession.session
                                                  as Session);
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
                                      style: getBoldStyle(
                                        color: ColorManager.black,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Expanded(
                                        child: Text(
                                          // 'I am a student and future billionair',
                                          UserHelper.userDescription(user),
                                          softWrap: true,
                                          style: getMediumStyle(
                                            color: ColorManager.black,
                                            fontSize: FontSize.s12,
                                          ),
                                        ),
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
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              ListTile(
                iconColor: ColorManager.black,
                textColor: ColorManager.black,
                tileColor: ColorManager.white,
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(WishlistedBooksScreen.routeName);
                },
                leading: Icon(
                  Icons.favorite_border,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Wishlisted',
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
              ListTile(
                iconColor: ColorManager.black,
                textColor: ColorManager.black,
                tileColor: ColorManager.white,
                onTap: () {
                  Navigator.of(context).pushNamed(UserPostsScreen.routeName);
                },
                leading: Icon(
                  Icons.book_rounded,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Your Posts',
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
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              ListTile(
                iconColor: ColorManager.black,
                textColor: ColorManager.black,
                tileColor: ColorManager.white,
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
                                      ? ColorManager.lightGrey
                                      : null,
                                  title: Text(
                                    option,
                                    style: getBoldStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s16,
                                    ),
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
              ListTile(
                iconColor: ColorManager.black,
                textColor: ColorManager.black,
                tileColor: ColorManager.white,
                onTap: () {
                  // Define a list of options
                  List<String> appThemes = [
                    'Light',
                    'Dark',
                  ];

                  String selectedMode = 'Light';

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        // title: Text('Select an option'),
                        contentPadding: EdgeInsets.zero,
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: appThemes
                              .map(
                                (option) => ListTile(
                                  tileColor: selectedMode == option
                                      ? ColorManager.lightGrey
                                      : null,
                                  title: Text(
                                    option,
                                    style: getBoldStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s16,
                                    ),
                                  ),
                                  onTap: () {
                                    // Do something when the option is tapped
                                    selectedMode = option;
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
                  Icons.dark_mode_outlined,
                  size: FontSize.s24,
                ),
                title: Text(
                  'Darkmode',
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
                  style: getBoldStyle(
                    color: ColorManager.primary,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
              ListTile(
                iconColor: ColorManager.black,
                textColor: ColorManager.black,
                tileColor: ColorManager.white,
                onTap: () {
                  bool userDeletionConfirmed = false;
                  bool showConfirmButton = false;
                  String password = "";
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Are you sure?'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "You won't be able to recover your account",
                            style: getRegularStyle(
                              fontSize: FontSize.s16,
                              color: ColorManager.black,
                            ),
                          ),
                          SizedBox(
                            height: AppHeight.h12,
                          ),
                          TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              labelText: 'Enter your password to confirm',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onChanged: (value) {
                              print(showConfirmButton);

                              setState(() {
                                password = value;
                                showConfirmButton = password.isNotEmpty;
                              });

                              print(showConfirmButton);
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
                        if (showConfirmButton)
                          TextButton(
                            child: Text(
                              'Confirm delete',
                              style: getBoldStyle(
                                fontSize: FontSize.s16,
                                color: ColorManager.primary,
                              ),
                            ),
                            // onPressed: showConfirmButton
                            //     ? null
                            onPressed: () {
                              print('hello');
                              userDeletionConfirmed = true;
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
                    if (userDeletionConfirmed) {
                      _deleteUserAccount(authSession as Session, password);
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
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // Session loggedInUserSession = args['loggedInUserSession'] as Session;

    Session loggedInUserSession =
        Provider.of<SessionProvider>(context).session as Session;

    User user = Provider.of<Users>(context, listen: false).user as User;

    SessionProvider userSession = (context).watch<SessionProvider>();
    userSession.setSession(loggedInUserSession);
    return Scaffold(
      backgroundColor: ColorManager.lightestGrey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                UserProfileEditScreen.routeName,
                // arguments: {

                //   'loggedInUserSession': loggedInUserSession,
                //   'user': user,
                // },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _profilePageUI(userSession, user),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 2,
      ),
    );
  }
}
