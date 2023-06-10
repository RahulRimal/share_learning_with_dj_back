import 'package:flutter/material.dart';

import '../managers/assets_manager.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';

class TempScreen extends StatelessWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lighterGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ---------------------- User top section starts here ----------------------------
          Container(
            padding: EdgeInsets.only(top: AppPadding.p12),
            decoration: BoxDecoration(
              color: ColorManager.grey,
            ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: ColorManager.primary,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                        AppPadding.p8,
                                      ),
                                      child: Container(
                                          // width: 80,
                                          // height: 80,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          // child: user.image == null
                                          //     ?
                                          child: Image.asset(
                                            ImageAssets.noProfile,
                                          )
                                          // : CircleAvatar(
                                          //     radius: 70,
                                          //     backgroundImage: NetworkImage(
                                          //       UserHelper.userProfileImage(user),
                                          //     ),
                                          //   ),
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                      AppPadding.p8,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          // width: 44,
                                          // height: 44,
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
                                              // Navigator.of(context).pushNamed(
                                              // UserProfileEditScreen.routeName,
                                              // arguments: {
                                              //   // 'loggedInUserSession': userSession.session,
                                              //   'loggedInUserSession':
                                              //       userSession.session,
                                              //   'user': user,
                                              // },
                                              // );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                            AppPadding.p12,
                                          ),
                                          child: Container(
                                            // width: 44,
                                            // height: 44,
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
                                                // _logOut(userSession.session as Session);
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
                              padding: EdgeInsets.symmetric(
                                vertical: AppPadding.p8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Rahul Rimal',
                                    // UserHelper.userDisplayName(user),
                                    style: getBoldStyle(
                                        fontSize: FontSize.s12,
                                        color: ColorManager.primary),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppPadding.p14,
                                    ),
                                    child: Text(
                                      'CSIT',
                                      // UserHelper.userClass(user),
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
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppPadding.p4,
                                  ),
                                  child: Text('mail@rahul.com',
                                      // user.email as String,
                                      style: getRegularStyle(
                                          color: ColorManager.primary)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppPadding.p8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: AppPadding.p8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Description',
                                          textAlign: TextAlign.start,
                                          style: getRegularStyle(
                                              color: ColorManager.primary)),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: AppPadding.p4,
                                        ),
                                        child: Text(
                                          'I am a student and future billionair',
                                          // UserHelper.userDescription(user),
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
        ],
      ),
    );
  }
}
