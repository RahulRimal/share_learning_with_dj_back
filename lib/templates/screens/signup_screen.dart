import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/widgets/beizer_container.dart';

import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.title}) : super(key: key);

  static const routeName = '/signup';

  final String? title;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  // var usernameOrEmail;
  var userpassword;
  bool visible = false;
  var showSpinner = false;

  var _newUser = User(
    id: 'tempUser',
    firstName: 'tempFirstName',
    lastName: 'tempLastName',
    username: 'tempUsername',
    email: 'temp@mail.com',
    phone: 'tempPhone',
    image: null,
    description: 'This is a temp user',
    userClass: 'tempClass',
    followers: '',
    createdDate: NepaliDateTime.now(),
  );

  void _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      setState(() {
        showSpinner = true;
      });
      _form.currentState!.save();
      // print(_newUser.email);
      // print(_newUser.username);
      // print(userpassword);
      // User logginedUser = new User(
      //     id: 'tempUser',
      //     firstName: 'temp',
      //     lastName: 'Name',
      //     username: 'tempN',
      //     email: 'temp@mail.com',
      //     description: 'This is a temp user',
      //     userClass: 'tempClass',
      //     followers: '',
      //     createdDate: NepaliDateTime.now());
      // Users loggedInUser = Users();
      SessionProvider userSession = new SessionProvider();

      Users users = Users(null);
      // Provider.of<Users>(context, listen: false)
      //     .createNewUser(_newUser, userpassword);
      // users.

      if (await users.createNewUser(_newUser, userpassword)) {
        setState(() {
          if (mounted) {
            showSpinner = false;
          }
          bool userConfirmed = false;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Welcome!'),
              content: Text(
                'You have been registered, please log in to continue',
                style: getRegularStyle(
                  fontSize: FontSize.s16,
                  color: ColorManager.black,
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Go to login',
                    style: getBoldStyle(
                      fontSize: FontSize.s16,
                      // color: ColorManager.primary,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                  },
                ),
              ],
            ),
          );
        });
      } else {
        setState(() {
          
            showSpinner = false;
        });
        if (users.userError != null) {
          List<String> data = [];
          (users.userError!.message as Map).forEach((key, value) {
            if (value is List) {
              value.forEach((item) => {data.add(item.toString())});
            } else {
              data.add(value.toString());
            }
          });

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
        }

        else{
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

  // Widget _entryField(String title, {bool isPassword = false}) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           title,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         TextField(
  //           obscureText: isPassword,
  //           decoration: new InputDecoration(
  //             enabledBorder: const OutlineInputBorder(
  //               borderSide: const BorderSide(color: Colors.black, width: 1.0),
  //             ),
  //             border: const OutlineInputBorder(),
  //             labelStyle: new TextStyle(color: Colors.green),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _entryField(String title,
      {bool isPassword = false, bool isEmail = false}) {
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
          TextFormField(
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
            },
            // obscureText: isPassword,
            obscureText: isPassword ? !visible : false,
            focusNode: isPassword
                ? _passwordFocusNode
                : (isEmail ? _emailFocusNode : null),
            textInputAction:
                isPassword ? TextInputAction.done : TextInputAction.next,
            keyboardType:
                // isPassword ? TextInputType.number : TextInputType.text,
                TextInputType.text,
            decoration: new InputDecoration(
              suffix: isPassword
                  ? IconButton(
                      icon: Icon(
                          visible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          visible = !visible;
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
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              if (isPassword)
                _saveForm();
              else {
                // _saveForm();
                FocusScope.of(context).requestFocus(_emailFocusNode);
              }
            },
            onSaved: (value) {
              if (isPassword) {
                userpassword = value;
              } else {
                // usernameOrEmail = value;
                isEmail
                    ? _newUser = new User(
                        id: _newUser.id,
                        firstName: _newUser.firstName,
                        lastName: _newUser.lastName,
                        username: _newUser.username,
                        email: value,
                        phone: _newUser.phone,
                        image: _newUser.image,
                        description: _newUser.description,
                        userClass: _newUser.userClass,
                        followers: _newUser.followers,
                        createdDate: _newUser.createdDate,
                      )
                    : _newUser = new User(
                        id: _newUser.id,
                        firstName: _newUser.firstName,
                        lastName: _newUser.lastName,
                        username: value,
                        email: _newUser.email,
                        phone: _newUser.phone,
                        image: _newUser.image,
                        description: _newUser.description,
                        userClass: _newUser.userClass,
                        followers: _newUser.followers,
                        createdDate: _newUser.createdDate,
                      );
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
          Navigator.pushNamed(context, LoginScreen.routeName);
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
                      //                   .requestFocus(_emailFocusNode);
                      //             },
                      //             onSaved: (value) {
                      //               _newUser = new User(
                      //                 id: _newUser.id,
                      //                 firstName: _newUser.firstName,
                      //                 lastName: _newUser.lastName,
                      //                 username: value,
                      //                 email: _newUser.email,
                      //                 image: _newUser.image,
                      //                 description: _newUser.description,
                      //                 userClass: _newUser.userClass,
                      //                 followers: _newUser.followers,
                      //                 createdDate: _newUser.createdDate,
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
                      //                   .requestFocus(_passwordFocusNode);
                      //             },
                      //             onSaved: (value) {
                      //               _newUser = new User(
                      //                 id: _newUser.id,
                      //                 firstName: _newUser.firstName,
                      //                 lastName: _newUser.lastName,
                      //                 username: _newUser.username,
                      //                 email: value,
                      //                 image: _newUser.image,
                      //                 description: _newUser.description,
                      //                 userClass: _newUser.userClass,
                      //                 followers: _newUser.followers,
                      //                 createdDate: _newUser.createdDate,
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
                      //               userpassword = value;
                      //               // _newUser = new User(
                      //               //   id: _newUser.id,
                      //               //   firstName: _newUser.firstName,
                      //               //   lastName: _newUser.lastName,
                      //               //   username: value,
                      //               //   email: _newUser.email,
                      //               //   image: _newUser.image,
                      //               //   description: _newUser.description,
                      //               //   userClass: _newUser.userClass,
                      //               //   followers: _newUser.followers,
                      //               //   createdDate: _newUser.createdDate,
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
                    showSpinner
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
                    SizedBox(height: height * .14),
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
