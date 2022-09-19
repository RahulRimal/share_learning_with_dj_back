import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/screens/login_screen.dart';
import 'package:share_learning/templates/widgets/beizer_container.dart';

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
    image: null,
    description: 'This is a temp user',
    userClass: 'tempClass',
    followers: '',
    createdDate: NepaliDateTime.now(),
  );

  void _saveForm() async {
    final isValid = _form.currentState!.validate();

    if (isValid) {
      _form.currentState!.save();
      print(_newUser.email);
      print(_newUser.username);
      print(userpassword);
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

      if (await users.createNewUser(_newUser, userpassword) == true) {
        setState(() {
          if (mounted) {
            showSpinner = false;
          }
        });

        // Navigator.of(context)
        //     .pushReplacementNamed(HomeScreen.routeName, arguments: {
        //   'authSession': userSession.session,
        // });
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        setState(() {
          showSpinner = true;
        });
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
            // obscureText: isPassword,
            obscureText: isPassword ? !visible : false,
            focusNode: isPassword
                ? _passwordFocusNode
                : (isEmail ? _emailFocusNode : null),
            textInputAction:
                isPassword ? TextInputAction.done : TextInputAction.next,
            keyboardType:
                isPassword ? TextInputType.number : TextInputType.text,
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
