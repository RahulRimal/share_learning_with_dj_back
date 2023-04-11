import 'package:flutter/material.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/templates/screens/single_post_screen_new.dart';

import '../../models/session.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';

class PostNew extends StatefulWidget {
  const PostNew({
    Key? key,
    required this.book,
    required this.authSession,
  }) : super(key: key);

  @override
  State<PostNew> createState() => _PostNewState();

  final Book book;
  final Session authSession;
}

class _PostNewState extends State<PostNew> {
  @override
  Widget build(BuildContext context) {
    Book post = widget.book;
    Session loggedInUserSession = widget.authSession;

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(
                post.images![0].image,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  right: 8,
                ),
                child: CircleAvatar(
                  backgroundColor: ColorManager.black,
                  radius: 14,
                  child: Stack(
                    children: [
                      Positioned(
                        // Position the IconButton in the center of the CircleAvatar
                        top: -9,
                        left: -10,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border,
                            size: 24,
                          ),
                          color: ColorManager.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            SinglePostScreenNew.routeName,
            arguments: {
              'post': post,
              'authSession': loggedInUserSession,
            },
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.bookName,
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(
                  height: AppHeight.h2,
                ),
                Text(
                  'Rs. ${post.price}',
                  style: getBoldStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
