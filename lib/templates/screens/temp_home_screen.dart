import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';

class HomescreenWidget extends StatefulWidget {
  @override
  _HomescreenWidgetState createState() => _HomescreenWidgetState();
}

class _HomescreenWidgetState extends State<HomescreenWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator HomescreenWidget - FRAME

    return Scaffold(
      body: Container(
          width: 390,
          height: 844,
          decoration: BoxDecoration(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: ColorManager.white,
            
          ),
          child: Stack(children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                    width: 390,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: Color.fromRGBO(255, 118, 118, 1),
                    ))),
            Positioned(
                top: 29,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 34, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          width: 42,
                          height: 42,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(42, 42)),
                                    ))),
                            Positioned(
                                top: 15,
                                left: 10.79998779296875,
                                child: Container(
                                    width: 20.571428298950195,
                                    height: 12,
                                    child: Stack(children: <Widget>[
                                      Positioned(
                                          top: 5.142857074737549,
                                          left: 0,
                                          child: Container(
                                              width: 20.571428298950195,
                                              height: 1.7142857313156128,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40),
                                                  topRight: Radius.circular(40),
                                                  bottomLeft: Radius.circular(40),
                                                  bottomRight:
                                                      Radius.circular(40),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ))),
                                      Positioned(
                                          top: 10.285714149475098,
                                          left: 0,
                                          child: Container(
                                              width: 12.342857360839844,
                                              height: 1.7142857313156128,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40),
                                                  topRight: Radius.circular(40),
                                                  bottomLeft: Radius.circular(40),
                                                  bottomRight:
                                                      Radius.circular(40),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ))),
                                      Positioned(
                                          top: 0,
                                          left: 8.22860336303711,
                                          child: Container(
                                              width: 12.342857360839844,
                                              height: 1.7142857313156128,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40),
                                                  topRight: Radius.circular(40),
                                                  bottomLeft: Radius.circular(40),
                                                  bottomRight:
                                                      Radius.circular(40),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ))),
                                    ]))),
                          ])),
                      SizedBox(width: 0),
                      Container(
                          width: 60,
                          height: 60,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(221, 221, 221, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(60, 60)),
                                    ))),
                            Positioned(
                                top: 2,
                                left: 1,
                                child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Rectangle97.png'),
                                          fit: BoxFit.fitWidth),
                                    ))),
                          ])),
                    ],
                  ),
                )),
            Positioned(
                top: 125,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4)
                          ],
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: 20.028644561767578,
                                height: 20,
                                child: Stack(children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    //   child: SvgPicture.asset(
                                    //   'assets/images/vector.svg',
                                    //   semanticsLabel: 'vector'
                                    // );
                                    child:
                                        SvgPicture.asset(ImageAssets.noProfile),
                                  ),
                                ])),
                            SizedBox(width: 5),
                            Text(
                              'Search',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color:
                                      Color.fromRGBO(0, 0, 0, 0.5299999713897705),
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 11),
                      Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: 50,
                                height: 50,
                                child: Stack(children: <Widget>[
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.elliptical(50, 50)),
                                          ))),
                                  Positioned(
                                      top: 17,
                                      left: 16,
                                      child: Container(
                                          width: 18.000150680541992,
                                          height: 16,
                                          child: Stack(children: <Widget>[
                                            Positioned(
                                              top: 11.661358833312988,
                                              left: 0,
                                              //   child: SvgPicture.asset(
                                              //   'assets/images/vector.svg',
                                              //   semanticsLabel: 'vector'
                                              // );
                                              child: SvgPicture.asset(
                                                  ImageAssets.noProfile),
                                            ),
                                            Positioned(
                                              top: 1.708598256111145,
                                              left: 9.36905574798584,
                                              //   child: SvgPicture.asset(
                                              //   'assets/images/vector.svg',
                                              //   semanticsLabel: 'vector'
                                              // );
                                              child: SvgPicture.asset(
                                                  ImageAssets.noProfile),
                                            ),
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              //   child: SvgPicture.asset(
                                              //   'assets/images/vector.svg',
                                              //   semanticsLabel: 'vector'
                                              // );
                                              child: SvgPicture.asset(
                                                  ImageAssets.noProfile),
                                            ),
                                            Positioned(
                                              top: 9.917604446411133,
                                              left: 11.810113906860352,
                                              //   child: SvgPicture.asset(
                                              //   'assets/images/vector.svg',
                                              //   semanticsLabel: 'vector'
                                              // );
                                              child: SvgPicture.asset(
                                                  ImageAssets.noProfile),
                                            ),
                                          ]))),
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 203,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(255, 118, 118, 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Adventure',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4285714285714286),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 17),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Drama',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(58, 58, 58, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4285714285714286),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 17),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Comic',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(58, 58, 58, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4285714285714286),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 17),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          border: Border.all(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Scientific',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Color.fromRGBO(58, 58, 58, 1),
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  letterSpacing:
                                      0 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.normal,
                                  height: 1.4285714285714286),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 267,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 174,
                                      height: 227,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(219, 219, 219, 1),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Image.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 4,
                                            left: 143,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(100),
                                                  topRight: Radius.circular(100),
                                                  bottomLeft:
                                                      Radius.circular(100),
                                                  bottomRight:
                                                      Radius.circular(100),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                      ),
                                                      child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                                top:
                                                                    2.2783257961273193,
                                                                left:
                                                                    0.7030847072601318,
                                                                //   child: SvgPicture.asset(
                                                                //   'assets/images/vector.svg',
                                                                //   semanticsLabel: 'vector'
                                                                // );
                                                                child: SvgPicture
                                                                    .asset(ImageAssets
                                                                        .noProfile)),
                                                          ])),
                                                ],
                                              ),
                                            )),
                                      ])),
                                  SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(193, 211, 229, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 255, 255, 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'C Programming Fundamentals',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.75),
                                                    fontFamily: 'Lora',
                                                    fontSize: 20,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height:
                                                        1.5 /*PERCENT not supported*/
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          'Rs. 265',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.75),
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height:
                                                  1.5 /*PERCENT not supported*/
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 34),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 174,
                                      height: 263,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(219, 219, 219, 1),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Image.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 4,
                                            left: 143,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(100),
                                                  topRight: Radius.circular(100),
                                                  bottomLeft:
                                                      Radius.circular(100),
                                                  bottomRight:
                                                      Radius.circular(100),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                      ),
                                                      child: Stack(children: <
                                                          Widget>[
                                                        Positioned(
                                                          top: 2.2783257961273193,
                                                          left:
                                                              0.7030847072601318,
                                                          //   child: SvgPicture.asset(
                                                          //   'assets/images/vector.svg',
                                                          //   semanticsLabel: 'vector'
                                                          // );
                                                          child: SvgPicture.asset(
                                                              ImageAssets
                                                                  .noProfile),
                                                        ),
                                                      ])),
                                                ],
                                              ),
                                            )),
                                      ])),
                                  SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(193, 211, 229, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 255, 255, 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'C Programming Fundamentals',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.75),
                                                    fontFamily: 'Lora',
                                                    fontSize: 20,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height:
                                                        1.5 /*PERCENT not supported*/
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Rs. 265',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.75),
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height:
                                                  1.5 /*PERCENT not supported*/
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 174,
                                      height: 362,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(219, 219, 219, 1),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Image.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 4,
                                            left: 143,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(100),
                                                  topRight: Radius.circular(100),
                                                  bottomLeft:
                                                      Radius.circular(100),
                                                  bottomRight:
                                                      Radius.circular(100),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                      ),
                                                      child: Stack(children: <
                                                          Widget>[
                                                        Positioned(
                                                          top: 2.2783257961273193,
                                                          left:
                                                              0.7030847072601318,
                                                          //   child: SvgPicture.asset(
                                                          //   'assets/images/vector.svg',
                                                          //   semanticsLabel: 'vector'
                                                          // );
                                                          child: SvgPicture.asset(
                                                              ImageAssets
                                                                  .noProfile),
                                                        ),
                                                      ])),
                                                ],
                                              ),
                                            )),
                                      ])),
                                  SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(193, 211, 229, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 255, 255, 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'Test Book',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.75),
                                                    fontFamily: 'Lora',
                                                    fontSize: 20,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height:
                                                        1.5 /*PERCENT not supported*/
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 7),
                                        Text(
                                          'Rs. 265',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.75),
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height:
                                                  1.5 /*PERCENT not supported*/
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 34),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 174,
                                      height: 263,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(219, 219, 219, 1),
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/Image.png'),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 4,
                                            left: 143,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(100),
                                                  topRight: Radius.circular(100),
                                                  bottomLeft:
                                                      Radius.circular(100),
                                                  bottomRight:
                                                      Radius.circular(100),
                                                ),
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0, vertical: 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                      ),
                                                      child: Stack(children: <
                                                          Widget>[
                                                        Positioned(
                                                          top: 2.2783257961273193,
                                                          left:
                                                              0.7030847072601318,
                                                          //   child: SvgPicture.asset(
                                                          //   'assets/images/vector.svg',
                                                          //   semanticsLabel: 'vector'
                                                          // );
                                                          child: SvgPicture.asset(
                                                              ImageAssets
                                                                  .noProfile),
                                                        ),
                                                      ])),
                                                ],
                                              ),
                                            )),
                                      ])),
                                  SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(193, 211, 229, 1),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(255, 255, 255, 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text(
                                                'C Programming Fundamentals',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 0.75),
                                                    fontFamily: 'Lora',
                                                    fontSize: 20,
                                                    letterSpacing:
                                                        0 /*percentages not used in flutter. defaulting to zero*/,
                                                    fontWeight: FontWeight.normal,
                                                    height:
                                                        1.5 /*PERCENT not supported*/
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Rs. 265',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.75),
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height:
                                                  1.5 /*PERCENT not supported*/
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: 776,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(
                          color: Color.fromRGBO(210, 211, 211, 1), thickness: 1),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 3.5714285373687744,
                                            left: 0.7142856121063232,
                                            child: Container(
                                                width: 18.571430206298828,
                                                height: 15.714285850524902,
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: Container(
                                                          width:
                                                              18.571430206298828,
                                                          height:
                                                              15.714285850524902,
                                                          child: Stack(
                                                              children: <Widget>[
                                                                Positioned(
                                                                    top:
                                                                        0.5952961444854736,
                                                                    left:
                                                                        2.6190185546875,
                                                                    //   child: SvgPicture.asset(
                                                                    //   'assets/images/vector1.svg',
                                                                    //   semanticsLabel: 'vector1'
                                                                    // );
                                                                    child: SvgPicture.asset(
                                                                        ImageAssets
                                                                            .noProfile)),
                                                                Positioned(
                                                                    top: 0,
                                                                    left: 0,
                                                                    //   child: SvgPicture.asset(
                                                                    //   'assets/images/vector.svg',
                                                                    //   semanticsLabel: 'vector'
                                                                    // );
                                                                    child: SvgPicture.asset(
                                                                        ImageAssets
                                                                            .noProfile)),
                                                                Positioned(
                                                                  top:
                                                                      6.428571701049805,
                                                                  left:
                                                                      2.857142925262451,
                                                                  //   child: SvgPicture.asset(
                                                                  //   'assets/images/vector.svg',
                                                                  //   semanticsLabel: 'vector'
                                                                  // );
                                                                  child: SvgPicture
                                                                      .asset(ImageAssets
                                                                          .noProfile),
                                                                ),
                                                              ]))),
                                                  Positioned(
                                                    top: 10.000000953674316,
                                                    left: 9.285715103149414,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                ]))),
                                      ])),
                                  SizedBox(height: 8),
                                  Text(
                                    'Home',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(31, 34, 35, 1),
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5 /*PERCENT not supported*/
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 44),
                            Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 2.2783257961273193,
                                            left: 0.7030847072601318,
                                            //   child: SvgPicture.asset(
                                            //   'assets/images/vector.svg',
                                            //   semanticsLabel: 'vector'
                                            // );
                                            child: SvgPicture.asset(
                                                ImageAssets.noProfile)),
                                      ])),
                                ],
                              ),
                            ),
                            SizedBox(width: 44),
                            Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0.7142856121063232,
                                            left: 0.7142856121063232,
                                            child: Container(
                                                width: 18.571430206298828,
                                                height: 18.571430206298828,
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                    top: 3.5714285373687744,
                                                    left: 5.714285850524902,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                  Positioned(
                                                      top: 12.859092712402344,
                                                      left: 3.1857142448425293,
                                                      //   child: SvgPicture.asset(
                                                      //   'assets/images/vector.svg',
                                                      //   semanticsLabel: 'vector'
                                                      // );
                                                      child: SvgPicture.asset(
                                                          ImageAssets.noProfile)),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                ]))),
                                      ])),
                                ],
                              ),
                            ),
                            SizedBox(width: 44),
                            Container(
                              decoration: BoxDecoration(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0.7142856121063232,
                                            left: 0.6424300074577332,
                                            child: Container(
                                                width: 18.64328384399414,
                                                height: 18.571430206298828,
                                                child: Stack(children: <Widget>[
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                  Positioned(
                                                    top: 17.14285659790039,
                                                    left: 2.9289984703063965,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                  Positioned(
                                                    top: 17.14285659790039,
                                                    left: 12.214713096618652,
                                                    //   child: SvgPicture.asset(
                                                    //   'assets/images/vector.svg',
                                                    //   semanticsLabel: 'vector'
                                                    // );
                                                    child: SvgPicture.asset(
                                                        ImageAssets.noProfile),
                                                  ),
                                                ]))),
                                      ])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ])),
    );
  }
}
