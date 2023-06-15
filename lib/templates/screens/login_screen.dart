import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/category_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/view_models/providers/wishlist_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:share_learning/templates/screens/signup_screen.dart';
import 'package:share_learning/templates/screens/user_interests_screen.dart';
import 'package:share_learning/templates/widgets/beizer_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/providers/cart_provider.dart';
import '../../view_models/providers/order_request_provider.dart';
import '../../view_models/providers/user_provider.dart';
import '../managers/assets_manager.dart';
import '../utils/alert_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.title}) : super(key: key);

  static const routeName = '/login';

  final String? title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.bindLoginScreenViewModel(context);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    userProvider.unbindLoginScreenViewModel();
  }

  Widget _backButton() {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                    child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                  ),
                  Text('Back',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                    child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                  ),
                  Text('Back',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
                ],
              ),
            ),
          );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    UserProvider _userProvider = context.watch<UserProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Platform.isIOS
              ? CupertinoTextField(
                  obscureText:
                      isPassword ? !_userProvider.loginScreenVisible : false,
                  focusNode: isPassword
                      ? _userProvider.loginScreenPasswordFocusNode
                      : null,
                  textInputAction:
                      isPassword ? TextInputAction.done : TextInputAction.next,
                  keyboardType:
                      isPassword ? TextInputType.number : TextInputType.text,
                  suffix: isPassword
                      ? CupertinoButton(
                          child: Icon(_userProvider.loginScreenVisible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                          onPressed: () {
                            setState(() {
                              _userProvider.loginScreenVisible =
                                  !_userProvider.loginScreenVisible;
                            });
                          },
                        )
                      : null,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: ColorManager.primary,
                        width: 1,
                      ),
                      right: BorderSide(
                        color: ColorManager.primary,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: ColorManager.primary,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: ColorManager.primary,
                        width: 1,
                      ),
                    ),
                  ),
                  onEditingComplete: () {
                    if (isPassword) {
                      FocusScope.of(context).requestFocus(
                          _userProvider.loginScreenPasswordFocusNode);
                    } else
                      _userProvider.loginScreenSaveForm(
                          context, _form, mounted);
                  },
                  onChanged: (value) {
                    if (isPassword) {
                      setState(() {
                        _userProvider.loginScreenUserpassword = value;
                      });
                    } else {
                      setState(() {
                        _userProvider.loginScreenUsernameOrEmail = value;
                      });
                    }
                  },
                )
              : Container(
                  // height: _form.currentState!.validate() ? 55 : 50,
                  child: TextFormField(
                    obscureText:
                        isPassword ? !_userProvider.loginScreenVisible : false,
                    focusNode: isPassword
                        ? _userProvider.loginScreenPasswordFocusNode
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (isPassword) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        if (value.trim().length < 8) {
                          return 'Password must be at least 8 characters in length';
                        }
                        // Return null if the entered password is valid
                        return null;
                      } else {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Check if the entered email has the right format
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        // Return null if the entered email is valid
                        return null;
                      }
                    },
                    textInputAction: isPassword
                        ? TextInputAction.done
                        : TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                      // contentPadding: EdgeInsets.symmetric(
                      //   horizontal: AppPadding.p12,
                      //   vertical: AppPadding.p2,
                      // ),
                      // contentPadding: EdgeInsets.only(
                      //   top: 0,
                      //   left: AppPadding.p12,
                      //   bottom: AppPadding.p12,
                      // ),
                      suffix: isPassword
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                _userProvider.loginScreenVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _userProvider.loginScreenVisible =
                                      !_userProvider.loginScreenVisible;
                                });
                              })
                          : null,
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                      ),
                      border: const OutlineInputBorder(),
                      labelStyle: new TextStyle(color: Colors.green),
                    ),
                    onFieldSubmitted: (_) {
                      if (!isPassword)
                        FocusScope.of(context).requestFocus(
                            _userProvider.loginScreenPasswordFocusNode);
                      else {
                        _userProvider.loginScreenSaveForm(
                            context, _form, mounted);
                      }
                    },
                    onSaved: (value) {
                      if (isPassword) {
                        _userProvider.loginScreenUserpassword = value;
                      } else {
                        _userProvider.loginScreenUsernameOrEmail = value;
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    UserProvider _userProvider = context.watch<UserProvider>();
    return GestureDetector(
      onTap: () => _userProvider.loginScreenSaveForm(context, _form, mounted),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              // colors: [Color(0xfffbb448), Color(0xfff7892b)],
              colors: [
                Theme.of(context).primaryColor.withAlpha(200),
                Theme.of(context).primaryColorDark.withAlpha(200),
              ]),
        ),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text(
            'OR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return GestureDetector(
      // onTap: _googleSignIn,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff1959a9),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('f',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: Text('Log in with Facebook',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleButton() {
    UserProvider _userProvider = context.watch<UserProvider>();
    return ElevatedButton(
      onPressed: () => _userProvider.loginScreenGoogleSignIn(context),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              ImageAssets.googleLogo,
              height: 35,
              width: 35,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Sign in with Google",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );

    // return ElevatedButton(
    //   onPressed: _googleSignIn,
    //   style: ButtonStyle(
    //     backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //         side: BorderSide(color: Colors.grey),
    //       ),
    //     ),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       SvgPicture.asset(ImageAssets.googleLogo),
    //       SizedBox(width: 10),
    //       Text(
    //         "Sign in with Google",
    //         style: TextStyle(
    //           color: Colors.black87,
    //           fontSize: 16,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _createAccountLabel() {
    return Platform.isIOS
        ? GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
              Navigator.pushNamed(context, SignUpScreen.routeName);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.all(15),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                        // color: Color(0xfff79c4f),
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            splashColor: ColorManager.primary,
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
              Navigator.pushNamed(context, SignUpScreen.routeName);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.all(15),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                        // color: Color(0xfff79c4f),
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
          text: 'Sabaiko',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 30),
        ),
        TextSpan(
          text: 'Books',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 30),
        ),
      ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      // return ListView(
      children: <Widget>[
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    UserProvider _userProvider = context.watch<UserProvider>();

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: Container(
              height: height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .2),
                          _title(),
                          // _emailPasswordWidget(),
                          Form(
                            key: _form,
                            child: _emailPasswordWidget(),
                          ),
                          SizedBox(height: 20),
                          _userProvider.loginScreenShowSpinner
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: CircularProgressIndicator(
                                    color: ColorManager.primary,
                                  ),
                                )
                              // : SizedBox(height: 1),
                              : Container(),
                          Text(
                            // '$_loginErrorText',
                            _userProvider.loginScreenLoginErrorText,
                            style: getBoldStyle(color: ColorManager.primary),
                          ),
                          _submitButton(),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          _divider(),
                          _facebookButton(),
                          _googleButton(),
                          SizedBox(height: height * .055),
                          _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              body: Container(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -height * .15,
                        right: -MediaQuery.of(context).size.width * .4,
                        child: BezierContainer()),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: height * .2),
                            _title(),
                            // _emailPasswordWidget(),
                            Form(
                              key: _form,
                              child: _emailPasswordWidget(),
                            ),
                            SizedBox(height: 20),
                            _userProvider.loginScreenShowSpinner
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: CircularProgressIndicator(
                                      color: ColorManager.primary,
                                    ),
                                  )
                                // : SizedBox(height: 1),
                                : Container(),
                            _submitButton(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            _divider(),
                            _facebookButton(),

                            _googleButton(),
                            SizedBox(height: height * .055),
                            _createAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                    Positioned(top: 40, left: 0, child: _backButton()),
                  ],
                ),
              ),
            ),
          );
  }
}
