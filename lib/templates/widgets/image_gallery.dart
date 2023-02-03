import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/templates/widgets/custom_image.dart';

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
        ? Provider.of<Books>(context).getBookById(widget.bookId!)
        : null;

    return // Image Gallery Starts Here
        Container(
      height: 150,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: selectedPost != null
          ? selectedPost.pictures != null
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedPost.pictures!.length,
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
                        imageUrl: widget.isNetwork
                            ? selectedPost.pictures![index]
                            : selectedPost.pictures![index].name,
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
                )
          // : widget.images != null
          : widget.images!.isNotEmpty
              ? ListView.builder(
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
                        // imageUrl: widget.images![index]['image'] != null? widget.images![index]['image']: widget.images![index],
                        imageUrl: widget.images![index] is String ? widget.images![index]: widget.images![index]['image'],
                        // imageUrl: widget.images![index],
                        // imageUrl: widget.images![index]['image'],
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
