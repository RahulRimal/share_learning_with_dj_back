import 'dart:developer';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/categories.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/wishlists.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:share_learning/templates/screens/signup_screen.dart';
import 'package:share_learning/templates/screens/user_interests_screen.dart';
import 'package:share_learning/templates/widgets/beizer_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/carts.dart';
import '../../providers/users.dart';
import '../managers/assets_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, this.title}) : super(key: key);

  static const routeName = '/login';

  final String? title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // SharedPrefrencesHelper _sharedPrefrencesHelper = SharedPrefrencesHelper();

  final _form = GlobalKey<FormState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  FocusNode _passwordFocusNode = FocusNode();

  // var _user = User(
  //     id: '',
  //     firstName: '',
  //     lastName: '',
  //     userName: '',
  //     password: '',
  //     image: '');

  var usernameOrEmail;
  var userpassword;
  bool visible = false;
  var showSpinner = false;

  String _loginErrorText = '';

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  _googleSignIn() async {
    // setState(() {
    //   showSpinner = true;
    // });
    // final users = Provider.of<Users>(context, listen: false);
    // final sessions = Provider.of<SessionProvider>(context, listen: false);
    // var response = await users.googleSignIn();

    // if (response is Success) {
    //   sessions.setSession((response.response as Map)['session']);

    //   SharedPreferences prefs = await _prefs;

    //   Users users = Provider.of<Users>(context, listen: false);
    //   users.getUserByToken(sessions.session!.accessToken);

    //   prefs.setString('accessToken', sessions.session!.accessToken);
    //   prefs.setString('refreshToken', sessions.session!.refreshToken);

    //   if (!prefs.containsKey('cartId')) {
    //     if (await Provider.of<Carts>(context, listen: false)
    //         .createCart(sessions.session as Session)) {
    //       prefs.setString('cartId',
    //           Provider.of<Carts>(context, listen: false).cart!.id.toString());
    //     } else {
    //       print('here');
    //     }
    //   } else {
    //     print('here');
    //   }

    //   setState(() {
    //     showSpinner = false;
    //   });
    //   if (prefs.containsKey('isFirstTime') &&
    //       prefs.getBool('isFirstTime') == false) {
    //     Navigator.of(context)

    //         .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
    //       'authSession': sessions.session,
    //     });
    //   } else {
    //     Navigator.of(context)
    //         .pushReplacementNamed(UserInterestsScreen.routeName);
    //   }

    // }
  }

  void _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      setState(() {
        showSpinner = true;
      });

      // showSpinner = true;
      _form.currentState!.save();
      // SessionProvider userSession = new SessionProvider();
      SessionProvider userSession = Provider.of(context, listen: false);
      if (await userSession.createSession(usernameOrEmail, userpassword)) {
        if (mounted) {
          setState(() {
            showSpinner = false;
          });
          SharedPreferences prefs = await _prefs;

          Users users = Provider.of<Users>(context, listen: false);

          prefs.setString('accessToken', userSession.session!.accessToken);
          prefs.setString('refreshToken', userSession.session!.refreshToken);

          await users.getUserByToken(userSession.session!.accessToken);

          if (!prefs.containsKey('cartId')) {
            if (await Provider.of<Carts>(context, listen: false)
                .createCart(userSession.session as Session)) {
              prefs.setString(
                  'cartId',
                  Provider.of<Carts>(context, listen: false)
                      .cart!
                      .id
                      .toString());
            } else {
              // print('here');
              Provider.of<Carts>(context, listen: false)
                  .getCartInfo(prefs.getString('cartId') as String);
            }
          } else {
            print('here');
          }

          Wishlists wishlists = Provider.of<Wishlists>(context, listen: false);
          Categories categories =
              Provider.of<Categories>(context, listen: false);

          wishlists.getWishlistedBooks(userSession.session as Session);
          categories.getCategories(userSession.session as Session);

          if (prefs.containsKey('isFirstTime') &&
              prefs.getBool('isFirstTime') == false) {
            Navigator.of(context)
                // .pushReplacementNamed(HomeScreen.routeName, arguments: {
                .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
              'authSession': userSession.session,
            });
          } else {
            if (await users.haveProvidedData(users.user!.id)) {
              prefs.setBool('isFirstTime', false);
              Navigator.of(context)
                  // .pushReplacementNamed(HomeScreen.routeName, arguments: {
                  .pushReplacementNamed(HomeScreenNew.routeName, arguments: {
                'authSession': userSession.session,
              });
            } else {
              Navigator.of(context).pushReplacementNamed(
                  UserInterestsScreen.routeName,
                  arguments: {
                    'authSession': userSession.session,
                  });
            }
          }

          // Navigator.of(context)
          //     .pushReplacementNamed(HomeScreen.routeName, arguments: {
          //   'authSession': userSession.session,
          // });
        }
      } else {
        setState(() {
          showSpinner = false;
        });
        if (userSession.sessionError != null) {
          List<String> data = [];
          if (userSession.sessionError!.message is String) {
            data.add(userSession.sessionError!.message.toString());
          } else {
            (userSession.sessionError!.message as Map).forEach((key, value) {
              if (value is List) {
                value.forEach((item) => {data.add(item.toString())});
              } else {
                data.add(value.toString());
              }
            });
          }

          // print(data);

          // Show notifications one by one with a delay
          int delay = 0;
          for (String element in data) {
            Future.delayed(Duration(milliseconds: delay), () {
              BotToast.showSimpleNotification(
                title: element,
                duration: Duration(seconds: 3),
                backgroundColor: ColorManager.primary,
                titleStyle: getBoldStyle(color: ColorManager.white),
                align: Alignment(1, 1),
              );
              BotToast.showCustomNotification(
                duration: Duration(seconds: 3),
                toastBuilder: (cancelFunc) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      element,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              );
            });
            delay += 1500; // increase delay for next notification
          }
        } else {
          BotToast.showSimpleNotification(
            title: "Something went wrong, please try again",
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            align: Alignment(1, 1),
          );
        }
      }
    }
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
                  obscureText: isPassword ? !visible : false,
                  focusNode: isPassword ? _passwordFocusNode : null,
                  textInputAction:
                      isPassword ? TextInputAction.done : TextInputAction.next,
                  keyboardType:
                      isPassword ? TextInputType.number : TextInputType.text,
                  // suffix: isPassword
                  //     ? IconButton(
                  //         icon: Icon(visible
                  //             ? Icons.visibility
                  //             : Icons.visibility_off),
                  //         onPressed: () {
                  //           setState(() {
                  //             visible = !visible;
                  //           });
                  //         })
                  //     : null,
                  suffix: isPassword
                      ? CupertinoButton(
                          child: Icon(visible
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                          onPressed: () {
                            setState(() {
                              visible = !visible;
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
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    } else
                      _saveForm();
                  },
                  onChanged: (value) {
                    if (isPassword) {
                      setState(() {
                        userpassword = value;
                      });
                    } else {
                      setState(() {
                        usernameOrEmail = value;
                      });
                    }
                  },
                )
              : TextFormField(
                  obscureText: isPassword ? !visible : false,
                  focusNode: isPassword ? _passwordFocusNode : null,
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
                  textInputAction:
                      isPassword ? TextInputAction.done : TextInputAction.next,
                  // keyboardType:
                  //     isPassword ? TextInputType.number : TextInputType.text,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    suffix: isPassword
                        ? IconButton(
                            icon: Icon(visible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                visible = !visible;
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
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    else {
                      _saveForm();
                    }
                  },
                  onSaved: (value) {
                    if (isPassword) {
                      userpassword = value;
                    } else {
                      usernameOrEmail = value;
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: _saveForm,
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
      onTap: _googleSignIn,
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
    return ElevatedButton(
      onPressed: _googleSignIn,
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
                          showSpinner
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
                            _loginErrorText,
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
                          // _facebookButton(),
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
        : Scaffold(
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
                          showSpinner
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
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
                          // _facebookButton(),
                          // showSpinner
                          //     ? CircularProgressIndicator()
                          //     : _googleButton(),
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
          );
  }
}
