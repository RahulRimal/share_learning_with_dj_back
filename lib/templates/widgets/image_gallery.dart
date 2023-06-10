import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/view_models/book_provider.dart';
import 'package:share_learning/view_models/session_provider.dart';
import 'package:share_learning/templates/widgets/custom_image.dart';

import '../../view_models/user_provider.dart';
import '../screens/edit_post_screen.dart';

// ignore: must_be_immutable
class ImageGallery extends StatefulWidget {
  var bookId;
  List<dynamic>? images;
  final bool isNetwork;
  final bool isErasable;
  final Function? eraseImage;

  // ImageGallery({bookId = null, images = null});
  ImageGallery(this.isNetwork,
      {this.bookId, this.images, required this.isErasable, this.eraseImage});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  @override
  Widget build(BuildContext context) {
    Book? selectedPost = widget.bookId != null
        ? Provider.of<BookProvider>(context).getBookById(widget.bookId!)
        : null;

    return // Image Gallery Starts Here
        Container(
      // height: widget.bookId is String ? 150 : 1,
      height: 280,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: selectedPost != null
          ? selectedPost.images != null
              ? Column(
                  children: [
                    Container(
                      height: 150,
                      // height: 320,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedPost.images!.length,
                        itemBuilder: (context, index) =>
                            // Post Image Starts Here
                            Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 150,
                            height: 75,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: CustomImage(
                              image: widget.isNetwork
                                  ? selectedPost.images![index]
                                  : selectedPost.images![index].name,
                              isNetwork: widget.isNetwork,
                              isErasable: widget.isErasable,
                              eraseImage: this.widget.eraseImage,
                            ),
                          ),
                        ),
                        // Post Image ends Here,
                      ),
                    ),
                    // Edit images starts here
                    (selectedPost.userId ==
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .id)
                        ? Container(
                            height: 50,
                            child: Column(
                              children: [
                                // Text(
                                //   'Edit',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      child: Text('Add or remove images'),
                                      style: ButtonStyle(),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                            EditPostScreen.routeName,
                                            arguments: {
                                              'bookId': widget.bookId,
                                              'loggedInUserSession':
                                                  Provider.of<SessionProvider>(
                                                          context,
                                                          listen: false)
                                                      .session,
                                            });
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    // ElevatedButton(
                                    //   child: Text('From Camera'),
                                    //   style: ButtonStyle(),
                                    //   onPressed: () {
                                    //     _takePicture();
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    // Edit images ends here
                  ],
                )
              : Center(
                  child: Text(
                    'No Images found',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
          : widget.images!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images!.length,
                  itemBuilder: (context, index) =>
                      // Post Image Starts Here
                      Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 150,
                      height: 150,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: CustomImage(
                        // image: widget.images![index] is BookImage
                        //     ? widget.images![index]
                        // : widget.images![index],
                        image: widget.images![index],
                        isNetwork: widget.isNetwork,
                        isErasable: widget.isErasable,
                        eraseImage: this.widget.eraseImage,
                      ),
                    ),
                  ),
                  // Post Image ends Here,
                )
              : Center(
                  child: Text(
                    'No Images found',
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
    );

    // Image Gallery Ends Here
  }
}
