import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/view_models/providers/user_provider.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/widgets/beizer_container.dart';

import '../managers/assets_manager.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/routes_manager.dart';
import '../managers/style_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.title}) : super(key: key);

  // static const routeName = '/signup';

  final String? title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.bindSignUpScreenViewModel(context);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  void dispose() {
    userProvider.unBindSignUpScreenViewModel();
    super.dispose();
  }

  Widget _backButton() {
    return InkWell(
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
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, bool isEmail = false}) {
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
          Container(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (isEmail) {
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
                if (!isEmail && !isPassword) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (value.trim().length < 4) {
                    return 'Username must be at least 4 characters in length';
                  }
                  // Return null if the entered username is valid
                  return null;
                }
                if (isPassword) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  if (value.trim().length < 8) {
                    return 'Password must be at least 8 characters in length';
                  }
                  // Return null if the entered password is valid
                  return null;
                }
                return null;
              },
              obscureText:
                  isPassword ? !_userProvider.signUpScreenVisible : false,
              focusNode: isPassword
                  ? _userProvider.signUpScreenPasswordFocusNode
                  : (isEmail ? _userProvider.signUpScreenEmailFocusNode : null),
              textInputAction:
                  isPassword ? TextInputAction.done : TextInputAction.next,
              keyboardType:
                  // isPassword ? TextInputType.number : TextInputType.text,
                  TextInputType.text,
              decoration: new InputDecoration(
                suffix: isPassword
                    ? IconButton(
                        icon: Icon(_userProvider.signUpScreenVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _userProvider.signUpScreenVisible =
                                !_userProvider.signUpScreenVisible;
                          });
                        })
                    : null,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.0),
                ),
                border: const OutlineInputBorder(),
                labelStyle: new TextStyle(color: Colors.green),
              ),
              onFieldSubmitted: (_) {
                if (isEmail)
                  FocusScope.of(context).requestFocus(
                      _userProvider.signUpScreenPasswordFocusNode);
                if (isPassword)
                  _userProvider.signUpScreenSaveForm(context, _form, mounted);
                else {
                  // _userProvider.signUpScreenSaveForm(context, _form, mounted);
                  FocusScope.of(context)
                      .requestFocus(_userProvider.signUpScreenEmailFocusNode);
                }
              },
              onSaved: (value) {
                if (isPassword) {
                  _userProvider.signUpScreenUserpassword = value;
                } else {
                  isEmail
                      ? _userProvider.signUpScreenNewUser = new User(
                          id: _userProvider.signUpScreenNewUser.id,
                          firstName:
                              _userProvider.signUpScreenNewUser.firstName,
                          lastName: _userProvider.signUpScreenNewUser.lastName,
                          username: _userProvider.signUpScreenNewUser.username,
                          email: value,
                          phone: _userProvider.signUpScreenNewUser.phone,
                          image: _userProvider.signUpScreenNewUser.image,
                          description:
                              _userProvider.signUpScreenNewUser.description,
                          userClass:
                              _userProvider.signUpScreenNewUser.userClass,
                          followers:
                              _userProvider.signUpScreenNewUser.followers,
                          createdDate:
                              _userProvider.signUpScreenNewUser.createdDate,
                        )
                      : _userProvider.signUpScreenNewUser = new User(
                          id: _userProvider.signUpScreenNewUser.id,
                          firstName:
                              _userProvider.signUpScreenNewUser.firstName,
                          lastName: _userProvider.signUpScreenNewUser.lastName,
                          username: value,
                          email: _userProvider.signUpScreenNewUser.email,
                          phone: _userProvider.signUpScreenNewUser.phone,
                          image: _userProvider.signUpScreenNewUser.image,
                          description:
                              _userProvider.signUpScreenNewUser.description,
                          userClass:
                              _userProvider.signUpScreenNewUser.userClass,
                          followers:
                              _userProvider.signUpScreenNewUser.followers,
                          createdDate:
                              _userProvider.signUpScreenNewUser.createdDate,
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    UserProvider _userProvider = context.watch<UserProvider>();
    return ElevatedButton(
      onPressed: _userProvider.signUpScreenGoogleSignIn,
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
              "Sign up with Google",
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
  }

  Widget _submitButton() {
    UserProvider _userProvider = context.watch<UserProvider>();
    return GestureDetector(
      onTap: () => _userProvider.signUpScreenSaveForm(context, _form, mounted),
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
                colors: [
                  Theme.of(context).primaryColor.withAlpha(200),
                  Theme.of(context).primaryColorDark.withAlpha(200),
                ])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesManager.loginScreenRoute);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.all(15),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already have an account ?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Login',
                style: TextStyle(
                    // color: Color(0xfff79c4f),
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
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

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id", isEmail: true),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    UserProvider _userProvider = context.watch<UserProvider>();
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _form,
                      child: _emailPasswordWidget(),
                      // child: Column(
                      //   children: [
                      //     Container(
                      //       width: MediaQuery.of(context).size.width,
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             'UserName',
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 15),
                      //           ),
                      //           SizedBox(
                      //             height: 10,
                      //           ),
                      //           TextFormField(
                      //             // obscureText: isPassword,
                      //             textInputAction: TextInputAction.next,
                      //             keyboardType: TextInputType.text,
                      //             decoration: new InputDecoration(
                      //               enabledBorder: const OutlineInputBorder(
                      //                 borderSide: const BorderSide(
                      //                     color: Colors.black, width: 1.0),
                      //               ),
                      //               border: const OutlineInputBorder(),
                      //               labelStyle:
                      //                   new TextStyle(color: Colors.green),
                      //             ),
                      //             onFieldSubmitted: (_) {
                      //               FocusScope.of(context)
                      //                   .requestFocus(_userProvider.signUpScreenEmailFocusNode);
                      //             },
                      //             onSaved: (value) {
                      //               _userProvider.signUpScreenNewUser = new User(
                      //                 id: _userProvider.signUpScreenNewUser.id,
                      //                 firstName: _userProvider.signUpScreenNewUser.firstName,
                      //                 lastName: _userProvider.signUpScreenNewUser.lastName,
                      //                 username: value,
                      //                 email: _userProvider.signUpScreenNewUser.email,
                      //                 image: _userProvider.signUpScreenNewUser.image,
                      //                 description: _userProvider.signUpScreenNewUser.description,
                      //                 userClass: _userProvider.signUpScreenNewUser.userClass,
                      //                 followers: _userProvider.signUpScreenNewUser.followers,
                      //                 createdDate: _userProvider.signUpScreenNewUser.createdDate,
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Container(
                      //       width: MediaQuery.of(context).size.width,
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             'Emain ID',
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 15),
                      //           ),
                      //           SizedBox(
                      //             height: 10,
                      //           ),
                      //           TextFormField(
                      //             // obscureText: isPassword,
                      //             textInputAction: TextInputAction.next,
                      //             keyboardType: TextInputType.text,
                      //             decoration: new InputDecoration(
                      //               enabledBorder: const OutlineInputBorder(
                      //                 borderSide: const BorderSide(
                      //                     color: Colors.black, width: 1.0),
                      //               ),
                      //               border: const OutlineInputBorder(),
                      //               labelStyle:
                      //                   new TextStyle(color: Colors.green),
                      //             ),
                      //             onFieldSubmitted: (_) {
                      //               FocusScope.of(context)
                      //                   .requestFocus(_userProvider.signUpScreenPasswordFocusNode);
                      //             },
                      //             onSaved: (value) {
                      //               _userProvider.signUpScreenNewUser = new User(
                      //                 id: _userProvider.signUpScreenNewUser.id,
                      //                 firstName: _userProvider.signUpScreenNewUser.firstName,
                      //                 lastName: _userProvider.signUpScreenNewUser.lastName,
                      //                 username: _userProvider.signUpScreenNewUser.username,
                      //                 email: value,
                      //                 image: _userProvider.signUpScreenNewUser.image,
                      //                 description: _userProvider.signUpScreenNewUser.description,
                      //                 userClass: _userProvider.signUpScreenNewUser.userClass,
                      //                 followers: _userProvider.signUpScreenNewUser.followers,
                      //                 createdDate: _userProvider.signUpScreenNewUser.createdDate,
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Container(
                      //       width: MediaQuery.of(context).size.width,
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             'Passowrd',
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 15),
                      //           ),
                      //           SizedBox(
                      //             height: 10,
                      //           ),
                      //           TextFormField(
                      //             // obscureText: isPassword,
                      //             textInputAction: TextInputAction.done,
                      //             keyboardType: TextInputType.text,
                      //             decoration: new InputDecoration(
                      //               enabledBorder: const OutlineInputBorder(
                      //                 borderSide: const BorderSide(
                      //                     color: Colors.black, width: 1.0),
                      //               ),
                      //               border: const OutlineInputBorder(),
                      //               labelStyle:
                      //                   new TextStyle(color: Colors.green),
                      //             ),
                      //             onSaved: (value) {
                      //               _userProvider.signUpScreenUserpassword = value;
                      //               // _userProvider.signUpScreenNewUser = new User(
                      //               //   id: _userProvider.signUpScreenNewUser.id,
                      //               //   firstName: _userProvider.signUpScreenNewUser.firstName,
                      //               //   lastName: _userProvider.signUpScreenNewUser.lastName,
                      //               //   username: value,
                      //               //   email: _userProvider.signUpScreenNewUser.email,
                      //               //   image: _userProvider.signUpScreenNewUser.image,
                      //               //   description: _userProvider.signUpScreenNewUser.description,
                      //               //   userClass: _userProvider.signUpScreenNewUser.userClass,
                      //               //   followers: _userProvider.signUpScreenNewUser.followers,
                      //               //   createdDate: _userProvider.signUpScreenNewUser.createdDate,
                      //               // );
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    _userProvider.signUpScreenShowSpinner
                        ? Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        : Container(),
                    _submitButton(),
                    _divider(),
                    // _facebookButton(),
                    _userProvider.signUpScreenShowSpinner
                        ? CircularProgressIndicator()
                        : Container(),
                    _googleButton(),
                    SizedBox(height: height * .055),
                    // SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
