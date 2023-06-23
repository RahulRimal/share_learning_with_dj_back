import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/view_models/providers/theme_provider.dart';

import '../../models/session.dart';
import '../../view_models/providers/book_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/routes_manager.dart';
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

class _PostNewState extends State<PostNew> with WidgetsBindingObserver {
  

  BookProvider? bookProvider;

  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);

    bookProvider!.bindPostNewWidget(context);

    // Register this object as an observer
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addObserver(this);
    
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Added this line to save the reference of provider so it doesn't throw an exception on dispose
    bookProvider = Provider.of<BookProvider>(context, listen: false);
  }

  @override
  void dispose() {
    bookProvider!.unBindPostNewWidget();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                                _bookProvider.sessionProvider.session
                                    as Session,
                                post);
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
            _bookProvider.postDetailsScreenSetSelectedBook(post);
            Navigator.of(context)
                .pushNamed(RoutesManager.postDetailsScreenRoute);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              
              color: Provider.of<ThemeProvider>(context).isDarkMode ? ColorManager.grey : ColorManager.lightestGrey,
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
                    color:  ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(
                  height: AppHeight.h2,
                ),
                Text(
                  'Rs. ${post.price}',
                  style: getBoldStyle(
                    color: Provider.of<ThemeProvider>(context).isDarkMode ? ColorManager.lighterGrey: ColorManager.grey,
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
