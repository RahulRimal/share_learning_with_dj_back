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
import 'package:share_learning/templates/screens/user_profile_edit_screen.dart';
import 'package:share_learning/templates/utils/user_helper.dart';
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
    Provider.of<Users>(context, listen: false).logoutUser(session.id);
    Provider.of<Comments>(context, listen: false).setComments([]);
    prefs.remove('accessToken');
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
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
    // print(user.firstName);
    // print(user.image);
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
          // child: Text(
          //   userSession.sessionError!.message.toString(),
          // ),
        ),
      );
    }

    Session? userSessionData = userSession.session;

    return Container(
      padding: EdgeInsets.only(top: AppPadding.p12),
      // child: Column(
      //   children: [
      //     ListTile(
      //       horizontalTitleGap: AppHeight.h8,
      //       contentPadding: EdgeInsets.zero,
      //       leading: CircleAvatar(
      //         // radius: AppPadding.p16,
      //         // radius: AppRadius.r100,
      //         radius: 70,
      //         backgroundImage: user.image != null
      //             ? NetworkImage(
      //                 UserHelper.userProfileImage(user),
      //               )
      //             : Image.asset(
      //                 ImageAssets.noProfile,
      //               ) as ImageProvider,
      //         // foregroundImage: NetworkImage(
      //         //   UserHelper.userProfileImage(user),
      //         // ),
      //       ),
      //       // title: Text(user.firstName),
      //       title: Text(
      //         UserHelper.userDisplayName(user),
      //         textAlign: TextAlign.center,
      //         style: getBoldStyle(
      //           fontSize: FontSize.s20,
      //           color: ColorManager.black,
      //         ),
      //       ),
      //       subtitle: Text(
      //         user.description.toString(),
      //         // 'kfdjlfdkflsd djfkjfioa kd fdojfka kdfklafj jklkkljljklkk ll',
      //         // textAlign: TextAlign.justify,
      //         overflow: TextOverflow.ellipsis,
      //         maxLines: 2,
      //         style: getRegularStyle(
      //           fontSize: FontSize.s12,
      //           color: ColorManager.black,
      //         ),
      //       ),
      //     ),
      //     // Container(
      //     //   // height: AppHeight.h100,
      //     //   child: Row(
      //     //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     //     children: [
      //     //       CircleAvatar(
      //     //         radius: AppRadius.r50,
      //     //         backgroundImage: NetworkImage(
      //     //           UserHelper.userProfileImage(user),
      //     //         ),
      //     //       ),
      //     //       // Text(user.firstName + user.lastName),
      //     //       Column(
      //     //         children: [
      //     //           Text(
      //     //             UserHelper.userDisplayName(user),
      //     //             style: getBoldStyle(
      //     //               fontSize: FontSize.s20,
      //     //               color: ColorManager.black,
      //     //             ),
      //     //           ),
      //     //           Text(
      //     //             // user.description.toString(),
      //     //             'kfdjlfdkflsd djfkjfioa kd fdojfka kdfklafj jklkkljljklkk llllllll',
      //     //             textAlign: TextAlign.left,
      //     //             overflow: TextOverflow.ellipsis,
      //     //             maxLines: 2,
      //     //             style: getRegularStyle(
      //     //               fontSize: FontSize.s12,
      //     //               color: ColorManager.black,
      //     //             ),
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //     // Text(userSessionData!.accessToken),
      //     // Text(userSessionData.accessTokenExpiry.toString()),
      //   ],
      // ),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 360,
              decoration: BoxDecoration(
                // color: ColorManager.darkPrimary,
                color: ColorManager.white,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color: ColorManager.primary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                              child: Container(
                                width: 80,
                                height: 80,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  ImageAssets.noProfile,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: ColorManager.primary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: ColorManager.darkPrimary,
                                      width: 2,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: ColorManager.white,
                                      size: AppSize.s24,
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 0, 0),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: ColorManager.primary,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ColorManager.darkPrimary,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.login_rounded,
                                        color: ColorManager.white,
                                        size: 24,
                                      ),
                                      onPressed: () async {
                                        _logOut(userSession.session as Session);
                                        // SharedPreferences prefs = await _prefs;
                                        // Provider.of<Books>(context,
                                        //         listen: false)
                                        //     .setBooks([]);
                                        // Provider.of<Users>(context,
                                        //         listen: false)
                                        //     .logoutUser(
                                        //         userSession.session!.id);
                                        // Provider.of<Comments>(context,
                                        //         listen: false)
                                        //     .setComments([]);
                                        // prefs.remove('accessToken');
                                        // Navigator.pushReplacementNamed(
                                        //     context, LoginScreen.routeName);
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            // 'Rahul Rimal',
                            UserHelper.userDisplayName(user),
                            style: getBoldStyle(
                                fontSize: FontSize.s12,
                                color: ColorManager.primary),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                            child: Text(
                              // profilePageUsersRecord.age.toString(),
                              "89",
                              style: getBoldStyle(
                                color: ColorManager.black,
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          child: Text(
                              // profilePageUsersRecord.email,
                              'mail@mail.com',
                              style:
                                  getRegularStyle(color: ColorManager.primary)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Ailments',
                              textAlign: TextAlign.start,
                              style: getBoldStyle(color: ColorManager.primary)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(),
                            // child: AutoSizeText(
                            //   profilePageUsersRecord.ailments,
                            //   style:
                            //       FlutterFlowTheme.of(context).title3,
                            // ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Next Appointment',
                                  textAlign: TextAlign.start,
                                  style: getRegularStyle(
                                      color: ColorManager.primary)),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                child: Text(
                                  'Aug 20, 2021',
                                  style: getRegularStyle(
                                    color: ColorManager.primary,
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
        Column(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Past Appointments',
                  style: getBoldStyle(
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    Session loggedInUserSession = args['loggedInUserSession'] as Session;

    User user = args['user'] as User;

    // Session userSession = args['session'] as Session;

    SessionProvider userSession = (context).watch<SessionProvider>();
    userSession.setSession(loggedInUserSession);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(
                UserProfileEditScreen.routeName,
                arguments: {
                  // 'loggedInUserSession': userSession.session,
                  'loggedInUserSession': loggedInUserSession,
                  'user': user,
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _profilePageUI(userSession, user),
      ),
    );
  }
}
