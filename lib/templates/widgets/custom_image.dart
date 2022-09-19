import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  // final DynamicLibrary imageUrl;
  // final bool isNetwork;
  bool isNetwork;
  final bool isErasable;
  final Function? eraseImage;

  CustomImage({
    required this.imageUrl,
    required this.isNetwork,
    required this.isErasable,
    required this.eraseImage,
  });

  @override
  Widget build(BuildContext context) {
    return isErasable
        ? Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewRouteWrapper(
                        imageProvider: isNetwork
                            ? NetworkImage(
                                this.imageUrl,
                              )
                            : FileImage(File(this.imageUrl)) as ImageProvider,

                        // imageProvider: (imageUrl is String)
                        //     ? NetworkImage(this.imageUrl as String)
                        //     : FileImage(File(this.imageUrl.toString()))
                        //         as ImageProvider,
                      ),
                    ),
                  );
                },
                child: PhotoView(
                  // imageProvider: isNetwork
                  //     ? NetworkImage(this.imageUrl) as ImageProvider
                  //     : FileImage(File(this.imageUrl)),

                  imageProvider: !imageUrl.contains('/data/user')
                      ? NetworkImage(this.imageUrl) as ImageProvider
                      : FileImage(File(this.imageUrl)),

                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ),
              Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: ColorManager.primary,
                    ),
                    onPressed: () {
                      eraseImage!(imageUrl);
                    },
                  )
                  // child: isErasable
                  //     ? IconButton(
                  //         icon: Icon(
                  //           Icons.delete,
                  //           color: Colors.white,
                  //         ),
                  //         onPressed: () {
                  //           print('Delete Button Pressed');
                  //         },
                  //       )
                  //     : Container(),
                  ),
            ],
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewRouteWrapper(
                    imageProvider: isNetwork
                        ? NetworkImage(
                            this.imageUrl,
                          )
                        : FileImage(File(this.imageUrl)) as ImageProvider,

                    // imageProvider: (imageUrl is String)
                    //     ? NetworkImage(this.imageUrl as String)
                    //     : FileImage(File(this.imageUrl.toString()))
                    //         as ImageProvider,
                  ),
                ),
              );
            },
            child: PhotoView(
              // imageProvider: isNetwork
              //     ? NetworkImage(this.imageUrl) as ImageProvider
              //     : FileImage(File(this.imageUrl)),
              imageProvider: !imageUrl.contains('/data/user')
                  ? NetworkImage(this.imageUrl) as ImageProvider
                  : FileImage(File(this.imageUrl)),

              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          );
  }
}

class PhotoViewRouteWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  const PhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        loadingBuilder: (context, progress) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      num.parse(
                          (progress.expectedTotalBytes as int).toString()),
            ),
          ),
        ),
      ),

      // child: PhotoView(
      //   imageProvider: imageProvider,
      //   backgroundDecoration: backgroundDecoration,
      //   minScale: minScale,
      //   maxScale: maxScale,
      //   loadingBuilder: (context, progress) => Center(
      //     child: Container(
      //       width: 20.0,
      //       height: 20.0,
      //       child: CircularProgressIndicator(
      //         value: progress == null
      //             ? null
      //             : progress.cumulativeBytesLoaded /
      //                 num.parse(
      //                     (progress.expectedTotalBytes as int).toString()),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
