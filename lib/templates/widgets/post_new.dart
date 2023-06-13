import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/wishlist.dart';
import 'package:share_learning/view_models/wishlist_provider.dart';
import 'package:share_learning/templates/screens/post_details_screen.dart';

import '../../models/session.dart';
import '../../view_models/book_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';

class PostNew extends StatefulWidget {
  const PostNew({
    required this.book,
    Key? key,
  }) : super(key: key);

  @override
  State<PostNew> createState() => _PostNewState();

  final Book book;
}

class _PostNewState extends State<PostNew> {
  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false)
        .bindPostNewWidget(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BookProvider>(context, listen: false)
        .didChangeDependencyPostNewWidget(context);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<BookProvider>(context, listen: false).unBindPostNewWidget();
  }

  @override
  Widget build(BuildContext context) {
    Book post = widget.book;
    BookProvider _bookProvider = context.watch<BookProvider>();

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: post.images!.isEmpty
                    ? Container()
                    : SizedBox(
                        height: AppHeight.h150,
                        child: PhotoView(
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
                            _bookProvider.wishlistProvider.toggleWishlistBook(
                                _bookProvider.authSession, post);
                          },
                          icon:
                              _bookProvider.wishlistProvider.isWishlisted(post)
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
          onTap: () {
            _bookProvider.setSelectedBook(post);
            Navigator.of(context).pushNamed(PostDetailsScreen.routeName
                // arguments: {
                //   'post': post,
                // },
                );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              // color: ColorManager.white,
              color: ColorManager.lightestGrey,
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
