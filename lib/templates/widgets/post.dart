import 'package:flutter/material.dart';
import 'package:khalti/khalti.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/screens/single_post_screen.dart';

import '../managers/routes_manager.dart';

// ignore: must_be_immutable
class Post extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final String description;
  final NepaliDateTime boughtTime;
  final double price;
  final int bookCount;
  final bool selling;
  final Session loggedInUserSession;

  Post({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.boughtTime,
    required this.price,
    required this.bookCount,
    required this.selling,
    required this.loggedInUserSession,
  });

  bool flexAuthorName = false;

  bool _shouldFlex(String testString) {
    if (testString.length > 11) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Duration timeDifference = NepaliDateTime.now().difference(this.boughtTime);
    double duration =
        double.parse((timeDifference.inDays / 365).toStringAsFixed(1));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            // height: 250,
            // height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                RoutesManager.singlePostScreenRoute,
                arguments: {
                  'id': this.id,
                  'loggedInUserSession': this.loggedInUserSession
                },
              ),
              child: Platform.isIOS
                  ? Material(
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                          top: 17,
                          bottom: 10,
                          // bottom: MediaQuery.of(context).size.height * 0.3,
                          left: 10,
                          right: 10,
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    this.title,
                                    style: TextStyle(
                                      color: ColorManager.primary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      this.bookCount == 1
                                          ? '${this.bookCount.toString()} Book'
                                          : '${this.bookCount.toString()} Books',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _shouldFlex(this.author)
                                    ? Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.03,
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(Icons.person),
                                              Text('Author'),
                                              Text(
                                                this.author,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.person),
                                            Text('Author'),
                                            Text(
                                              this.author,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                Container(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.history),
                                      Text('Bought time'),
                                      Text(
                                        duration > 1.0
                                            ? '$duration Years ago'
                                            : duration == 1.0
                                                ? '$duration Year ago'
                                                : duration == 0.1
                                                    ? '1 Month ago'
                                                    : '${((duration % 1) * 10).floor()} Months ago',
                                        style: TextStyle(
                                          color: Colors.yellow[700],
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.monetization_on),
                                      Text('Price'),
                                      Text(
                                        'Rs.$price',
                                        style: TextStyle(
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    // padding: EdgeInsets.all(10),
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shop,
                                          color: ColorManager.primary,
                                        ),
                                        Text(
                                          'Add to Wishlist',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorManager.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        subtitle: Text(
                          // 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          '$description',
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.only(
                        top: 17,
                        bottom: 10,
                        // bottom: MediaQuery.of(context).size.height * 0.3,
                        left: 10,
                        right: 10,
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  this.title,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                children: [
                                  Text(
                                    'Available',
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    this.bookCount == 1
                                        ? '${this.bookCount.toString()} Book'
                                        : '${this.bookCount.toString()} Books',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _shouldFlex(this.author)
                                  ? Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.person),
                                            Text('Author'),
                                            Text(
                                              this.author,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.person),
                                          Text('Author'),
                                          Text(
                                            this.author,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              Container(
                                padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.history),
                                    Text('Bought time'),
                                    Text(
                                      duration > 1.0
                                          ? '$duration Years ago'
                                          : duration == 1.0
                                              ? '$duration Year ago'
                                              : duration == 0.1
                                                  ? '1 Month ago'
                                                  : '${((duration % 1) * 10).floor()} Months ago',
                                      style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.monetization_on),
                                    Text('Price'),
                                    Text(
                                      'Rs.$price',
                                      style: TextStyle(
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  // padding: EdgeInsets.all(10),
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shop,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Text(
                                        'Add to Wishlist',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      subtitle: Text(
                        '$description',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
            ),
          ),
          Positioned(
            top: -10,
            right: 100,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: selling
                    ? Theme.of(context).primaryColor
                    : Colors.green[700],
              ),
              child: Text(
                selling ? 'Selling' : 'Buying',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
