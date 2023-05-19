import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/wishlist.dart';
import 'package:share_learning/providers/wishlists.dart';
import 'package:share_learning/templates/screens/post_details_screen.dart';

import '../../models/session.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import 'custom_image.dart';

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
  _isWishlisted(List<Wishlist> wishlists, Book book) {
    Wishlist? match = wishlists.firstWhereOrNull(
        (Wishlist wishlist) => wishlist.post == int.parse(book.id));
    if (match != null) {
      return true;
    }
    // if (wishlistBooks.contains(book)) {
    //   return true;
    // }
    return false;
  }

  // _getWishlistedBooks(Session authSession, Wishlists wishlist) async {
  //   await wishlist.getWishlistedBooks(authSession);
  // }

  @override
  Widget build(BuildContext context) {
    Book post = widget.book;
    Session loggedInUserSession = widget.authSession;

    Wishlists _wishlists = Provider.of<Wishlists>(context);
    // if (_wishlists.wishlistedBooks.isEmpty) {
    //   _getWishlistedBooks(loggedInUserSession, _wishlists);
    // }

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                // child: post.images!.isEmpty
                //     ? Container()
                //     : post.images.runtimeType is List<XFile>
                //         // ? Image.asset(post.images![0])
                //         // ? FileImage(File(post.images![0].name))

                //         : Image.network(
                //             post.images![0].image,
                //           ),
                child: post.images!.isEmpty
                    ? Container()
                    : SizedBox(
                        height: AppHeight.h150,
                        // width: 100,
                        child: PhotoView(
                          // imageProvider: post.images.runtimeType is List<XFile>

                          imageProvider: post.images is List<XFile>
                              ? FileImage(File(post.images![0].path))
                              : NetworkImage(post.images![0].image)
                                  as ImageProvider,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 2,
                        ),
                      )),
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
                          onPressed: () {
                            _wishlists.toggleWishlistBook(
                                loggedInUserSession, post);
                          },
                          icon: _isWishlisted(_wishlists.wishlists, post)
                              ? Icon(
                                  Icons.favorite,
                                  size: 24,
                                  color: ColorManager.primary,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 24,
                                  color: ColorManager.white,
                                ),
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
            PostDetailsScreen.routeName,
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
