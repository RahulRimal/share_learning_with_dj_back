import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/cart_screen.dart';
import 'package:share_learning/templates/screens/edit_post_screen.dart';
import 'package:share_learning/templates/screens/order_request_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/widgets/post_comments_new.dart';

import '../../models/book.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/carts.dart';
import '../../providers/order_request_provider.dart';
import '../../providers/sessions.dart';
import '../../providers/users.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../widgets/billing_info.dart';

class PostDetailsScreen extends StatefulWidget {
  static const routeName = '/post-details-screen';

  const PostDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
// class SinglePostScreenNew extends StatelessWidget {
  // int _selectedImage = 0;

  // NepaliDateTime? _buyerExpectedDeadline;

  Users users = new Users(
    null,
  );

  User loggedInUser = new User(
    id: '0',
    firstName: 'temp',
    lastName: 'Name',
    email: '',
    phone: null,
    image: null,
    username: 'temp',
    description: '',
    userClass: '',
    followers: '',
    createdDate: DateTime(2050),
  );

  // Book _buyerExpectedBook = new Book(
  //   id: '',
  //   author: 'Unknown',
  //   bookName: '',
  //   userId: '1',
  //   postType: 'B',
  //   category: null,
  //   boughtDate: DateTime.now().toNepaliDateTime(),
  //   description: '',
  //   // wishlisted: false,
  //   price: 0,
  //   bookCount: 1,
  //   images: [],
  //   postedOn: DateTime.now().toNepaliDateTime(),
  //   postRating: 0.0,
  // );

  Future<void> _getSessionUser(String accessToken) async {
    await users.getUserByToken(accessToken);
    if (users.user != null)
      loggedInUser = users.user!;
    else {
      await users.getUserByToken(accessToken);
      loggedInUser = users.user!;
    }
  }

  // int _itemCount = 1;

  // _decreaseItemCount() {
  //   setState(() {
  //     _itemCount--;
  //   });
  // }

  // _increaseItemCount() {
  //   setState(() {
  //     this._itemCount++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    Session authenticatedSession;
    if (args['authSession'] != null) {
      authenticatedSession = args['authSession'] as Session;
    } else {
      authenticatedSession =
          Provider.of<SessionProvider>(context).session as Session;
    }
    _getSessionUser(authenticatedSession.accessToken);
    if (users.user != null) {
      loggedInUser = users.user as User;
    } else {
      users.getUserByToken(authenticatedSession.accessToken);
    }
    Book post = args['post'];

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         expandedHeight: MediaQuery.of(context).size.height * 0.35,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.network(
    //             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Colors.blue,
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(AppPadding.p12),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 SizedBox(
    //                   height: AppHeight.h50,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: 5,
    //                     itemBuilder: (context, index) {
    //                       return Padding(
    //                         padding:
    //                             EdgeInsets.symmetric(horizontal: AppPadding.p2),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(10),
    //                           child: Image.network(
    //                             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           padding: EdgeInsets.only(top: AppPadding.p14),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'C Programming Fundamentals II ',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.black,
    //                                 fontSize: FontSize.s18,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.only(
    //                             top: AppPadding.p4,
    //                           ),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'Dr. Suresh Rana',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.grey,
    //                                 fontSize: FontSize.s14,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     // Itemcount counter
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: ColorManager.lighterGrey,
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       child: ButtonBar(
    //                         buttonPadding: EdgeInsets.zero,
    //                         children: [
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               padding: EdgeInsets.zero,
    //                               disabledColor: ColorManager.lightGrey,
    //                               onPressed: _itemCount > 1
    //                                   ? () {
    //                                       setState(() {
    //                                         _itemCount--;
    //                                       });
    //                                     }
    //                                   : null,
    //                               icon: Icon(Icons.remove),
    //                             ),
    //                           ),
    //                           Text(
    //                             // '1',
    //                             _itemCount.toString(),
    //                             textAlign: TextAlign.center,
    //                             style: getBoldStyle(
    //                               color: ColorManager.black,
    //                               fontSize: FontSize.s17,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             // height: AppSize.s20,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               // padding: EdgeInsets.all(2.0),
    //                               padding: EdgeInsets.zero,
    //                               onPressed: () {
    //                                 setState(() {
    //                                   _itemCount++;
    //                                 });
    //                               },
    //                               icon: Icon(Icons.add),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(),
    //                     Text(
    //                       'Available in stock',
    //                       softWrap: true,
    //                       style: getBoldStyle(
    //                         color: ColorManager.black,
    //                         fontSize: FontSize.s12,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: AppPadding.p14),
    //                   child: Text(
    //                     'Description',
    //                     softWrap: true,
    //                     style: getBoldStyle(
    //                       color: ColorManager.black,
    //                       fontSize: FontSize.s14,
    //                     ),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(
    //                     top: AppPadding.p4,
    //                   ),
    //                   child: Flexible(
    //                     child: Text(
    //                       'Aliquet dui porttitor sed velit praesent proin sed nec dictum. Justo ligula luctus ultrices nulla nibh varius amet. Pharetra vel sagittis vitae mattis dolor lacus.',
    //                       softWrap: true,
    //                       style: getMediumStyle(
    //                         color: ColorManager.grey,
    //                         fontSize: FontSize.s14,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Image.network(
    //         'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //         fit: BoxFit.cover,
    //         height: MediaQuery.of(context).size.height * 0.45,
    //         width: MediaQuery.of(context).size.width,
    //       ),
    //       // Overlapping container
    //       // Container(
    //       // height: MediaQuery.of(context).size.height,
    //       // width: MediaQuery.of(context).size.width,
    //       // decoration: BoxDecoration(
    //       //   gradient: LinearGradient(
    //       //     begin: Alignment.bottomCenter,
    //       //     end: Alignment.topCenter,
    //       //     colors: [
    //       //       Colors.black.withOpacity(0.5),
    //       //       Colors.transparent,
    //       //     ],
    //       //   ),
    //       // ),
    //       // ),
    //       // Your content here
    //       // ...
    //       Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: ColorManager.white,
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(20),
    //             ),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(AppPadding.p12),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 SizedBox(
    //                   height: AppHeight.h50,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: 5,
    //                     itemBuilder: (context, index) {
    //                       return Padding(
    //                         padding:
    //                             EdgeInsets.symmetric(horizontal: AppPadding.p2),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(10),
    //                           child: Image.network(
    //                             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           padding: EdgeInsets.only(top: AppPadding.p14),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'C Programming Fundamentals II ',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.black,
    // //                                 fontSize: FontSize.s18,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.only(
    //                             top: AppPadding.p4,
    //                           ),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'Dr. Suresh Rana',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.grey,
    //                                 fontSize: FontSize.s14,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     // Itemcount counter
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: ColorManager.lighterGrey,
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       child: ButtonBar(
    //                         buttonPadding: EdgeInsets.zero,
    //                         children: [
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               padding: EdgeInsets.zero,
    //                               disabledColor: ColorManager.lightGrey,
    //                               onPressed: _itemCount > 1
    //                                   ? () {
    //                                       setState(() {
    //                                         _itemCount--;
    //                                       });
    //                                     }
    //                                   : null,
    //                               icon: Icon(Icons.remove),
    //                             ),
    //                           ),
    //                           Text(
    //                             // '1',
    //                             _itemCount.toString(),
    //                             textAlign: TextAlign.center,
    //                             style: getBoldStyle(
    //                               color: ColorManager.black,
    //                               fontSize: FontSize.s17,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             // height: AppSize.s20,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               // padding: EdgeInsets.all(2.0),
    //                               padding: EdgeInsets.zero,
    //                               onPressed: () {
    //                                 setState(() {
    //                                   _itemCount++;
    //                                 });
    //                               },
    //                               icon: Icon(Icons.add),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(),
    //                     Text(
    //                       'Available in stock',
    //                       softWrap: true,
    //                       style: getBoldStyle(
    //                         color: ColorManager.black,
    //                         fontSize: FontSize.s12,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: AppPadding.p14),
    //                   child: Text(
    //                     'Description',
    //                     softWrap: true,
    //                     style: getBoldStyle(
    //                       color: ColorManager.black,
    //                       fontSize: FontSize.s14,
    //                     ),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(
    //                     top: AppPadding.p4,
    //                   ),
    //                   child: Flexible(
    //                     child: Text(
    //                       'Aliquet dui porttitor sed velit praesent proin sed nec dictum. Justo ligula luctus ultrices nulla nibh varius amet. Pharetra vel sagittis vitae mattis dolor lacus.',
    //                       softWrap: true,
    //                       style: getMediumStyle(
    //                         color: ColorManager.grey,
    //                         fontSize: FontSize.s14,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      backgroundColor: ColorManager.lighterGrey,
      body: Stack(
        children: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => PhotoViewRouteWrapper(
          //             imageProvider: NetworkImage(
          //           post.images![_selectedImage].image,
          //         )),
          //       ),
          //     );
          //   },
          //   child: PhotoView(
          //     imageProvider: NetworkImage(
          //       post.images![_selectedImage].image,
          //     ) as ImageProvider,
          //     minScale: PhotoViewComputedScale.contained * 0.8,
          //     maxScale: PhotoViewComputedScale.covered * 2,
          //   ),

          DetailsPageImageGallery(selectedPost: post),

          Positioned(
            bottom: AppHeight.h18,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              constraints: BoxConstraints(
                  // maxHeight: MediaQuery.of(context).size.height * 0.7,

                  ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppPadding.p45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SizedBox(
                        //   height: 50,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: post.images!.length,
                        //     itemBuilder: (context, index) {
                        //       return GestureDetector(
                        //         onTap: (() {
                        //           setState(() {
                        //             _selectedImage = index;
                        //           });
                        //         }),
                        //         child: Padding(
                        //           padding: EdgeInsets.symmetric(horizontal: 2),
                        //           child: Container(
                        //             padding: EdgeInsets.all(0),
                        //             decoration: _selectedImage == index
                        //                 ? BoxDecoration(
                        //                     border: Border.all(
                        //                       color: Colors.red,
                        //                       width: 2,
                        //                     ),
                        //                     borderRadius: BorderRadius.circular(
                        //                         AppRadius.r12),
                        //                   )
                        //                 : null,
                        //             child: ClipRRect(
                        //               borderRadius: BorderRadius.circular(10),
                        //               child: Image.network(
                        //                 // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        //                 post.images![index].image,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.9,
                                    width: 90.w,
                                    child: Text(
                                      post.bookName,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.1,
                                    width: 90.w,
                                    child: Text(
                                      post.author,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  // Flexible(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     padding: EdgeInsets.only(top: 4),
                                  //     child: Text(
                                  //       post.author,
                                  //       softWrap: true,
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         color: Colors.grey,
                                  //         fontSize: 14,
                                  //       ),
                                  //       textAlign: TextAlign.start,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // Itemcount counter
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey[200],
                              //     borderRadius: BorderRadius.circular(20),
                              //   ),
                              //   child: ButtonBar(
                              //     buttonPadding: EdgeInsets.zero,
                              //     children: [
                              //       SizedBox(
                              //         width: 40,
                              //         child: IconButton(
                              //           color: Colors.black,
                              //           padding: EdgeInsets.zero,
                              //           disabledColor: Colors.grey,
                              //           onPressed: _itemCount > 1
                              //               ? () {
                              //                   setState(() {
                              //                     _itemCount--;
                              //                   });
                              //                 }
                              //               : null,
                              //           icon: Icon(Icons.remove),
                              //         ),
                              //       ),
                              //       Text(
                              //         // '1',
                              //         _itemCount.toString(),
                              //         textAlign: TextAlign.center,
                              //         style: getBoldStyle(
                              //           color: ColorManager.black,
                              //           fontSize: FontSize.s17,
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: AppSize.s40,
                              //         // height: AppSize.s20,
                              //         child: IconButton(
                              //           color: Colors.black,
                              //           // padding: EdgeInsets.all(2.0),
                              //           padding: EdgeInsets.zero,
                              //           onPressed: () {
                              //             setState(() {
                              //               _itemCount++;
                              //             });
                              //           },
                              //           icon: Icon(Icons.add),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // ItemCounter(
                              //     // itemCount: _itemCount,
                              //     // increaseItemCount: _increaseItemCount,
                              //     // decreaseItemCount: _decreaseItemCount,
                              //     ),
                            ],
                          ),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   alignment: Alignment.centerRight,
                        //   margin: EdgeInsets.only(
                        //     top: AppMargin.m4,
                        //   ),
                        //   child: Text(
                        //     'Available in stock',
                        //     softWrap: true,
                        //     style: getBoldStyle(
                        //       color: ColorManager.black,
                        //       fontSize: FontSize.s12,
                        //     ),
                        //     textAlign: TextAlign.start,
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(top: AppPadding.p14),
                          child: Text(
                            'Description',
                            style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          // height: 200,
                          padding: EdgeInsets.only(
                            top: AppPadding.p4,
                          ),
                          child: Text(
                            post.description,
                            style: getMediumStyle(
                              color: ColorManager.grey,
                              fontSize: FontSize.s14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        // ! Comments Starts here
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Comments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  height: 5,
                                  indent: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // PostComments(loggedInUserSession, comments, this.bookId),
                        PostCommentsNew(
                          authenticatedSession,
                          loggedInUser,
                          post.id,
                        ),
                        // SinglePostCommenstSection(
                        //   authenticatedSession: authenticatedSession,
                        //   loggedInUser: loggedInUser,
                        //   postId: post.id,
                        // ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Recommendations for you',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: CartBottomSheet(
        selectedPost: post,
        loggedInUser: loggedInUser,
      ),
    );
  }
}

class SinglePostCommenstSection extends StatefulWidget {
  SinglePostCommenstSection(
      {Key? key,
      required this.authenticatedSession,
      required this.loggedInUser,
      required this.postId})
      : super(key: key);

  @override
  State<SinglePostCommenstSection> createState() =>
      _SinglePostCommenstSectionState();
  final Session authenticatedSession;
  final User loggedInUser;
  final String postId;
}

class _SinglePostCommenstSectionState extends State<SinglePostCommenstSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Comments Starts here
        Padding(
          padding: const EdgeInsets.only(
            top: AppPadding.p20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  height: 5,
                  indent: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        // PostComments(loggedInUserSession, comments, this.bookId),
        PostCommentsNew(
            widget.authenticatedSession, widget.loggedInUser, widget.postId),
      ],
    );
  }
}

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({
    Key? key,
    required this.selectedPost,
    required this.loggedInUser,

    // required this.buyerExpectedBook,
  }) : super(key: key);

  final Book selectedPost;
  final User loggedInUser;

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  final _form = GlobalKey<FormState>();
  NepaliDateTime initDate = NepaliDateTime.now();
  bool _isRequestLoading = false;
  bool _isCartLoading = false;
  bool _isOrderPlacementLoading = false;

  final _buyerDateFocusNode = FocusNode();
  final _buyerPriceFocusNode = FocusNode();
  final _buyerBooksCountFocusNode = FocusNode();

  // These focus nodes are for order request billing info fields
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _sideNoteFocusNode = FocusNode();

  int _itemCount = 1;
  double _expectedUnitPrice = 0;

  final _datePickercontroller = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
        NepaliDateTime.now().year,
        NepaliDateTime.now().month,
        NepaliDateTime.now().day + 1)),
  );

  NepaliDateTime? _buyerExpectedDeadline;
  // Book _buyerExpectedBook = new Book(
  //   id: '',
  //   author: 'Unknown',
  //   bookName: '',
  //   userId: '1',
  //   postType: 'B',
  //   category: null,
  //   boughtDate: DateTime.now().toNepaliDateTime(),
  //   description: '',
  //   // wishlisted: false,
  //   price: 0,
  //   bookCount: 1,
  //   images: [],
  //   postedOn: DateTime.now().toNepaliDateTime(),
  //   postRating: 0.0,
  // );

  NepaliDateTime _getTomorrowDate() {
    NepaliDateTime initDate = NepaliDateTime.now();
    NepaliDateTime tomorrow =
        NepaliDateTime(initDate.year, initDate.month, initDate.day + 1);
    return tomorrow;
  }

  Future<void> _showPicker(BuildContext context) async {
    _buyerExpectedDeadline = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: _getTomorrowDate(),
      firstDate: _getTomorrowDate(),
      lastDate: NepaliDateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );
    if (_buyerExpectedDeadline != null) {
      _datePickercontroller.text = DateFormat('yyyy-MM-dd')
          .format(_buyerExpectedDeadline as DateTime)
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Session authenticatedSession =
    //     Provider.of<SessionProvider>(context).session as Session;
    final _form = GlobalKey<FormState>();
    Book selectedPost = widget.selectedPost;
    Users users = context.watch<Users>();

    Carts carts = Provider.of<Carts>(context);
    OrderRequests orderRequests = Provider.of<OrderRequests>(context);
    // Orders orders = Provider.of<Orders>(context);

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    Book _buyerExpectedBook = args['post'];

    User _loggedInUser;
    if (users.user != null) {
      _loggedInUser = users.user as User;
    } else {
      _loggedInUser = widget.loggedInUser;
    }

    if (_loggedInUser.id == selectedPost.userId) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p4,
        ),
        child: ElevatedButton(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.center,
            child: Text(
              'Edit post',
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(EditPostScreen.routeName, arguments: {
              'bookId': selectedPost.id,
              'loggedInUserSession':
                  Provider.of<SessionProvider>(context, listen: false).session,
            });
          },
        ),
      );
    }
    if (carts.cartItemsContains(int.parse(selectedPost.id))) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              CartScreen.routeName,
            );
          },
          style: ElevatedButton.styleFrom(
            // primary: ColorManager.primaryColorWithOpacity,
            backgroundColor: ColorManager.primary,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          child: const Text(
            // "Already added to cart",
            "Go to cart",
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    if (orderRequests.orderRequestsByUserContains(int.parse(selectedPost.id))) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              OrderRequestScreen.routeName,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primary,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          child: const Text(
            "Check request status",
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p8,
        ),
        child: SizedBox(
          height: AppHeight.h40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Total price',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: FontSize.s12,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppPadding.p2,
                    ),
                    child: Text(
                      'Rs. ${selectedPost.price}',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: FontSize.s17,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              orderRequests.orderRequestsByUser.firstWhereOrNull(
                          (orderRequest) =>
                              orderRequest.product.id ==
                              int.parse(_buyerExpectedBook.id)) !=
                      null
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Check request progress',
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        _buyerExpectedBook = selectedPost;
                        showModalBottomSheet(
                          barrierColor: ColorManager.blackWithLowOpacity,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppRadius.r20),
                              topRight: Radius.circular(
                                AppRadius.r20,
                              ),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            ValueNotifier<bool> _shouldRequest =
                                ValueNotifier(false);
                            return Padding(
                              padding: EdgeInsets.only(
                                top: AppPadding.p8,
                                left: AppPadding.p8,
                                right: AppPadding.p8,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Form(
                                key: _form,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p18,
                                          horizontal: AppPadding.p12,
                                        ),
                                        child: TextFormField(
                                          controller: _datePickercontroller,
                                          focusNode: _buyerDateFocusNode,
                                          keyboardType: TextInputType.datetime,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            labelText: 'Your expected deadline',
                                            suffix: IconButton(
                                              icon: Icon(Icons.calendar_today),
                                              tooltip:
                                                  'Tap to open date picker',
                                              onPressed: () {
                                                _showPicker(context);
                                              },
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _buyerPriceFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide your expected deadline';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppPadding.p8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppPadding.p12,
                                              ),
                                              child: TextFormField(
                                                initialValue: _buyerExpectedBook
                                                    .price
                                                    .round()
                                                    .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                focusNode: _buyerPriceFocusNode,
                                                decoration: InputDecoration(
                                                  prefix: Text('Rs. '),
                                                  labelText:
                                                      'Expected price per piece',
                                                  focusColor: Colors.redAccent,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _buyerBooksCountFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Price can\'t be empty';
                                                  }
                                                  if (double.tryParse(value) ==
                                                      null) {
                                                    return 'Invalid number';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    _expectedUnitPrice =
                                                        double.parse(value);
                                                    print(_expectedUnitPrice);
                                                    print(_buyerExpectedBook
                                                        .price);
                                                    if (_expectedUnitPrice ==
                                                        _buyerExpectedBook
                                                            .price) {
                                                      _shouldRequest.value =
                                                          false;
                                                    } else {
                                                      _shouldRequest.value =
                                                          true;
                                                    }
                                                    print(_shouldRequest);
                                                  });
                                                },
                                                // onSaved: (value) {
                                                //   _expectedUnitPrice =
                                                //       double.parse(
                                                //           value
                                                //               as String);
                                                // },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppPadding.p12,
                                            ),
                                            // child:
                                            //     TextFormField(
                                            //   initialValue:
                                            //       _buyerExpectedBook
                                            //           .bookCount
                                            //           .toString(),
                                            //   focusNode:
                                            //       _buyerBooksCountFocusNode,
                                            //   keyboardType:
                                            //       TextInputType
                                            //           .number,
                                            //   cursorColor: Theme
                                            //           .of(context)
                                            //       .primaryColor,
                                            //   decoration:
                                            //       InputDecoration(
                                            //     labelText:
                                            //         'Number of Books you want',
                                            //   ),
                                            //   textInputAction:
                                            //       TextInputAction
                                            //           .next,
                                            //   autovalidateMode:
                                            //       AutovalidateMode
                                            //           .always,
                                            //   // onFieldSubmitted: (_) {
                                            //   //   FocusScope.of(context).requestFocus(_descFocusNode);
                                            //   // },
                                            //   validator:
                                            //       (value) {
                                            //     if (double.tryParse(
                                            //             value
                                            //                 as String) ==
                                            //         null) {
                                            //       return 'Invalid Number';
                                            //     }

                                            //     if (double.parse(
                                            //             value) <
                                            //         1) {
                                            //       return 'Book count must be at least 1';
                                            //     }
                                            //     return null;
                                            //   },
                                            //   onSaved: (value) {
                                            //     _buyerExpectedBook
                                            //             .bookCount =
                                            //         int.parse(value
                                            //             .toString());
                                            //     print(
                                            //         _buyerExpectedBook);
                                            //   },
                                            // ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              // child: ButtonBar(
                                              //   buttonPadding:
                                              //       EdgeInsets
                                              //           .zero,
                                              //   children: [
                                              //     IconButton(
                                              //       color: Colors
                                              //           .black,
                                              //       padding:
                                              //           EdgeInsets
                                              //               .zero,
                                              //       disabledColor:
                                              //           Colors
                                              //               .grey,
                                              //       splashRadius:
                                              //           AppRadius
                                              //               .r12,
                                              //       onPressed:
                                              //           _itemCount >
                                              //                   1
                                              //               ? () {
                                              //                   setState(() {
                                              //                     _itemCount--;
                                              //                   });
                                              //                 }
                                              //               : null,
                                              //       icon: Icon(Icons
                                              //           .remove),
                                              //     ),
                                              //     Text(
                                              //       _itemCount
                                              //           .toString(),
                                              //       textAlign:
                                              //           TextAlign
                                              //               .center,
                                              //       style:
                                              //           getBoldStyle(
                                              //         color: ColorManager
                                              //             .black,
                                              //         fontSize:
                                              //             FontSize
                                              //                 .s17,
                                              //       ),
                                              //     ),
                                              //     IconButton(
                                              //       color: Colors
                                              //           .black,
                                              //       padding:
                                              //           EdgeInsets
                                              //               .zero,
                                              //       disabledColor:
                                              //           Colors
                                              //               .grey,
                                              //       splashRadius:
                                              //           AppRadius
                                              //               .r12,
                                              //       onPressed:
                                              //           () {
                                              //         setState(
                                              //             () {
                                              //           _itemCount++;
                                              //         });
                                              //       },
                                              //       icon: Icon(
                                              //           Icons
                                              //               .add),
                                              //     ),
                                              //   ],
                                              // ),
                                              child: StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: _itemCount > 1
                                                          ? () {
                                                              setState(() {
                                                                _itemCount--;
                                                              });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.remove),
                                                    ),
                                                    AnimatedSwitcher(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        child: Text(
                                                          _itemCount.toString(),
                                                          key: ValueKey(
                                                              _itemCount),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: getBoldStyle(
                                                            color: ColorManager
                                                                .black,
                                                            fontSize:
                                                                FontSize.s17,
                                                          ),
                                                        ),
                                                        transitionBuilder:
                                                            (Widget child,
                                                                Animation<
                                                                        double>
                                                                    animation) {
                                                          return ScaleTransition(
                                                              scale: animation,
                                                              child: child);
                                                        }),
                                                    IconButton(
                                                      color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: selectedPost
                                                                  .bookCount >
                                                              _itemCount
                                                          ? () {
                                                              setState(() {
                                                                _itemCount++;
                                                              });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.add),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      spacing: AppHeight.h16,
                                      alignment: WrapAlignment.center,
                                      runSpacing: AppHeight.h4,
                                      children: [
                                        ValueListenableBuilder(
                                            valueListenable: _shouldRequest,
                                            builder: (BuildContext context,
                                                bool shouldRequest,
                                                Widget? child) {
                                              return ElevatedButton.icon(
                                                icon: _isRequestLoading
                                                    ? SizedBox(
                                                        height: AppHeight.h20,
                                                        width: AppHeight.h20,
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive(
                                                          strokeWidth: 3,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              ColorManager
                                                                  .primary,
                                                        ),
                                                      )
                                                    : Container(),
                                                label: Text(
                                                  'Request for this price',
                                                  style: getBoldStyle(
                                                    color: ColorManager.white,
                                                    fontSize: FontSize.s14,
                                                  ),
                                                ),
                                                onPressed: !shouldRequest
                                                    ? null
                                                    // : () async {
                                                    //     setState(() {
                                                    //       _isLoading = true;
                                                    //     });

                                                    //     if (carts.cart == null) {
                                                    //       await carts.createCart(Provider.of<SessionProvider>(context, listen: false).session as Session);
                                                    //       // print(carts.cart);
                                                    //     }
                                                    //     if (carts.cart != null) {
                                                    //       final isValid = _form.currentState!.validate();
                                                    //       if (!isValid) {
                                                    //         _showToastNotification('Something went wrong');
                                                    //       }
                                                    //       _form.currentState!.save();

                                                    //       CartItem edittedItem = new CartItem(
                                                    //         id: 0,
                                                    //         product: new Product(
                                                    //           id: int.parse(selectedPost.id),
                                                    //           bookName: selectedPost.bookName,
                                                    //           unitPrice: selectedPost.price.toString(),
                                                    //         ),
                                                    //         quantity: _itemCount,
                                                    //         expectedUnitPrice: _expectedUnitPrice,
                                                    //         totalPrice: 0,
                                                    //       );

                                                    //       if (await carts.addItemToCart(carts.cart as Cart, edittedItem)) {
                                                    //         // await carts.createCart(Provider.of<SessionProvider>(context, listen: false).session as Session);
                                                    //         Navigator.pop(context);
                                                    //         _showToastNotification('Book added to cart successfully');
                                                    //       }
                                                    //     } else {
                                                    //       _showToastNotification('Something went wrong');
                                                    //     }
                                                    //   },
                                                    : () async {
                                                        setState(() {
                                                          _isRequestLoading =
                                                              true;
                                                        });

                                                        final isValid = _form
                                                            .currentState!
                                                            .validate();
                                                        if (!isValid) {
                                                          AlertHelper
                                                              .showToastAlert(
                                                                  'Something went wrong');
                                                        }
                                                        _form.currentState!
                                                            .save();
                                                        Map<String, dynamic>
                                                            requestInfo = {
                                                          'product_id':
                                                              _buyerExpectedBook
                                                                  .id,
                                                          'quantity':
                                                              _itemCount,
                                                          'requested_price':
                                                              _expectedUnitPrice
                                                        };

                                                        _createOrderRequest(
                                                            requestInfo);
                                                        // if (await orderRequests
                                                        //     .createOrderRequest(
                                                        //         authenticatedSession,
                                                        //         requestInfo)) {
                                                        //   Navigator.pop(
                                                        //       context);
                                                        //   _showToastNotification(
                                                        //       'Request has been sent successfully');
                                                        // } else {
                                                        //   _showToastNotification(
                                                        //       'Something went wrong');
                                                        // }
                                                      },
                                              );
                                            }),
                                        ValueListenableBuilder(
                                            valueListenable: _shouldRequest,
                                            builder: (BuildContext context,
                                                bool shouldRequest,
                                                Widget? child) {
                                              return ElevatedButton.icon(
                                                icon: _isCartLoading
                                                    ? SizedBox(
                                                        height: AppHeight.h20,
                                                        width: AppHeight.h20,
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive(
                                                          strokeWidth: 3,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              ColorManager
                                                                  .primary,
                                                        ),
                                                      )
                                                    : Container(),
                                                label: Text(
                                                  'Add book to cart',
                                                  style: getBoldStyle(
                                                    color: ColorManager.white,
                                                    fontSize: FontSize.s14,
                                                  ),
                                                ),
                                                onPressed: shouldRequest
                                                    ? null
                                                    : () async {
                                                        // ----------------------Order without cart starts here ----------------------
                                                        // if (await orders.getUserOrder(
                                                        //     loggedInUserSession,
                                                        //     users.user as User)) {
                                                        //   final isValid = _form
                                                        //       .currentState!
                                                        //       .validate();
                                                        //   if (!isValid) {
                                                        //     _showToastNotification(
                                                        //         'Something went wrong');
                                                        //   }
                                                        //   _form.currentState!.save();
                                                        //   OrderItem item =
                                                        //       new OrderItem(
                                                        //           id: 0,
                                                        //           productId: int.parse(
                                                        //               selectedPost.id),
                                                        //           quantity:
                                                        //               _buyerExpectedBook
                                                        //                   .bookCount);
                                                        //   if (await orders.addOrderItem(
                                                        //       item,
                                                        //       orders.order as Order)) {
                                                        //     Navigator.pop(context);
                                                        //     _showToastNotification(
                                                        //         'Book has been ordered successfully');
                                                        //   }
                                                        // } else {
                                                        //   _showToastNotification(
                                                        //       'Something went wrong');
                                                        // }
                                                        // ----------------------Order without cart ends here ----------------------

                                                        setState(() {
                                                          _isCartLoading = true;
                                                        });

                                                        if (carts.cart ==
                                                            null) {
                                                          await carts.createCart(
                                                              Provider.of<SessionProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .session as Session);
                                                          // print(carts.cart);
                                                        }
                                                        if (carts.cart !=
                                                            null) {
                                                          final isValid = _form
                                                              .currentState!
                                                              .validate();
                                                          if (!isValid) {
                                                            AlertHelper
                                                                .showToastAlert(
                                                                    'Something went wrong');
                                                          }
                                                          _form.currentState!
                                                              .save();

                                                          CartItem edittedItem =
                                                              new CartItem(
                                                            id: 0,
                                                            product:
                                                                new Product(
                                                              id: int.parse(
                                                                  selectedPost
                                                                      .id),
                                                              bookName:
                                                                  selectedPost
                                                                      .bookName,
                                                              unitPrice:
                                                                  selectedPost
                                                                      .price
                                                                      .toString(),
                                                            ),
                                                            negotiatedPrice:
                                                                selectedPost
                                                                    .price,
                                                            quantity:
                                                                _itemCount,
                                                            totalPrice: 0,
                                                          );

                                                          if (await carts
                                                              .addItemToCart(
                                                                  carts.cart
                                                                      as Cart,
                                                                  edittedItem)) {
                                                            // await carts.createCart(Provider.of<SessionProvider>(context, listen: false).session as Session);
                                                            setState(() {
                                                              _isCartLoading =
                                                                  false;
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            AlertHelper
                                                                .showToastAlert(
                                                                    'Book added to cart successfully');
                                                          }
                                                        } else {
                                                          AlertHelper
                                                              .showToastAlert(
                                                                  'Something went wrong');
                                                        }
                                                      },
                                              );
                                            }),
                                        ValueListenableBuilder(
                                            valueListenable: _shouldRequest,
                                            builder: (BuildContext context,
                                                bool shouldRequest,
                                                Widget? child) {
                                              return ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size.fromHeight(
                                                          AppHeight.h36),
                                                ),
                                                icon: _isOrderPlacementLoading
                                                    ? SizedBox(
                                                        height: AppHeight.h20,
                                                        width: AppHeight.h20,
                                                        child:
                                                            CircularProgressIndicator
                                                                .adaptive(
                                                          strokeWidth: 3,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                          backgroundColor:
                                                              ColorManager
                                                                  .primary,
                                                        ),
                                                      )
                                                    : Container(),
                                                label: Text(
                                                  'Place direct order',
                                                  style: getBoldStyle(
                                                    color: ColorManager.white,
                                                    fontSize: FontSize.s14,
                                                  ),
                                                ),
                                                onPressed: shouldRequest
                                                    ? null
                                                    :
                                                    // _expectedUnitPrice ==
                                                    //             _buyerExpectedBook
                                                    //                 .price
                                                    //         ? null
                                                    //         :
                                                    () async {
                                                        setState(() {
                                                          _isOrderPlacementLoading =
                                                              true;
                                                        });
                                                        var tempCart = await carts
                                                            .createTemporaryCart(
                                                                Provider.of<SessionProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .session as Session);
                                                        if (tempCart
                                                            is CartError) {
                                                          AlertHelper
                                                              .showToastAlert(
                                                                  'Something went wrong');
                                                        }
                                                        if (tempCart is Cart) {
                                                          final isValid = _form
                                                              .currentState!
                                                              .validate();
                                                          if (!isValid) {
                                                            AlertHelper
                                                                .showToastAlert(
                                                                    'Something went wrong');
                                                          }
                                                          _form.currentState!
                                                              .save();

                                                          CartItem edittedItem =
                                                              new CartItem(
                                                            id: 0,
                                                            product:
                                                                new Product(
                                                              id: int.parse(
                                                                  selectedPost
                                                                      .id),
                                                              bookName:
                                                                  selectedPost
                                                                      .bookName,
                                                              unitPrice:
                                                                  selectedPost
                                                                      .price
                                                                      .toString(),
                                                            ),
                                                            quantity:
                                                                _itemCount,
                                                            negotiatedPrice:
                                                                selectedPost
                                                                    .price,
                                                            totalPrice: 0,
                                                          );

                                                          if (await carts
                                                              .addItemToTemporaryCart(
                                                                  tempCart,
                                                                  edittedItem)) {
                                                            return showModalBottomSheet(
                                                              barrierColor:
                                                                  ColorManager
                                                                      .blackWithLowOpacity,
                                                              isScrollControlled:
                                                                  true,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          AppRadius
                                                                              .r20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                    AppRadius
                                                                        .r20,
                                                                  ),
                                                                ),
                                                              ),
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.9,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        AppPadding
                                                                            .p20,
                                                                  ),
                                                                  child: BillingInfo(
                                                                      cartId:
                                                                          tempCart
                                                                              .id),
                                                                );
                                                              },
                                                            );

                                                            // Navigator.pop(
                                                            //     context);
                                                            // AlertHelper
                                                            //     .showToastAlert(
                                                            //         'Order has been placed successfully');
                                                          }
                                                        } else {
                                                          // print('here');
                                                          AlertHelper
                                                              .showToastAlert(
                                                                  'Something went wrong');
                                                        }
                                                      },
                                              );
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text(
                        // 'Add to cart',
                        'Get this book',
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Map _getBillingInfoForOrderRequest() {
  _createOrderRequest(Map<String, dynamic> requestInfo) {
    Map<String, String> _billingInfo = {};
    List<String> _locationOptions = [
      'Kathmandu',
      'Bhaktapur',
      'Lalitpur',
      'Nepalgunj',
    ];

    User user = Provider.of<Users>(context, listen: false).user as User;

    if (user.firstName!.isNotEmpty) {
      _billingInfo["first_name"] = user.firstName!;
    }
    if (user.lastName!.isNotEmpty) {
      _billingInfo["last_name"] = user.lastName!;
    }
    if (user.email!.isNotEmpty) {
      _billingInfo["email"] = user.email!;
    }
    if (user.phone != null) {
      if (user.phone!.isNotEmpty) {
        _billingInfo["phone"] = user.phone!;
      }
    }

    _billingInfo["convenient_location"] = _locationOptions[0];

    showModalBottomSheet(
      barrierColor: ColorManager.blackWithLowOpacity,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r20),
          topRight: Radius.circular(
            AppRadius.r20,
          ),
        ),
      ),
      context: context,
      builder: (context) {
        // double bottomPadding = ScreenUtil().bottomBarHeight;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            // padding: EdgeInsets.only(bottom: bottomPadding),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.9,
              // height: 60.h,
              padding: EdgeInsets.only(
                left: AppPadding.p20,
                right: AppPadding.p20,
                bottom: AppPadding.p12,
              ),
              child: Column(
                children: [
                  // ----------------------    Name section starts here -----------------------------------

                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billing Information',
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s18,
                          ),
                        ),
                        SizedBox(
                          height: AppHeight.h4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: Colors.grey,
                              //   width: 1.0,
                              //   style: BorderStyle.solid,
                              // ),
                              ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _form,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                                // initialValue: _edittedUser.firstName,
                                                initialValue: _billingInfo
                                                        .containsKey(
                                                            'first_name')
                                                    ? _billingInfo['first_name']
                                                    : null,
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                focusNode: _firstNameFocusNode,
                                                decoration: InputDecoration(
                                                  labelText: 'First Name',
                                                  focusColor: Colors.redAccent,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _lastNameFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please provide the first name';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _billingInfo['first_name'] =
                                                      value.toString();
                                                }),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              initialValue: _billingInfo
                                                      .containsKey('last_name')
                                                  ? _billingInfo['last_name']
                                                  : null,
                                              keyboardType: TextInputType.text,
                                              cursorColor: Theme.of(context)
                                                  .primaryColor,
                                              focusNode: _lastNameFocusNode,
                                              decoration: InputDecoration(
                                                labelText: 'Last Name',
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        _emailFocusNode);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please provide the last name';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _billingInfo['last_name'] =
                                                    value.toString();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          initialValue:
                                              _billingInfo.containsKey('email')
                                                  ? _billingInfo['email']
                                                  : null,
                                          focusNode: _emailFocusNode,
                                          keyboardType: TextInputType.text,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _phoneNumberFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide email to receive notifications';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _billingInfo['email'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          initialValue:
                                              _billingInfo.containsKey('phone')
                                                  ? _billingInfo['phone']
                                                  : null,
                                          focusNode: _phoneNumberFocusNode,
                                          keyboardType: TextInputType.number,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _sideNoteFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide the phone number to be contacted';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _billingInfo['phone'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        // initialValue: _edittedUser.description,
                                        focusNode: _sideNoteFocusNode,
                                        keyboardType: TextInputType.multiline,
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        decoration: InputDecoration(
                                          labelText: 'Side Note',
                                        ),
                                        textInputAction:
                                            TextInputAction.newline,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        minLines: 3,
                                        maxLines: 7,
                                        // onFieldSubmitted: (_) {
                                        //   FocusScope.of(context)
                                        //       .requestFocus(_classFocusNode);
                                        // },
                                        // validator: (value) {
                                        //   if (value!.length < 15) {
                                        //     return 'Please provide a big description';
                                        //   }
                                        //   return null;
                                        // },
                                        onSaved: (value) {
                                          _billingInfo['side_note'] =
                                              value.toString();
                                        },
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
                  // ----------------------    Name section ends here -----------------------------------
                  // ----------------------    Sort by locations section ends here -----------------------------------
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s18,
                          ),
                        ),
                        SizedBox(
                          height: AppHeight.h4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                isExpanded: true,
                                style: getBoldStyle(color: ColorManager.black),
                                value: _billingInfo['convenient_location'],
                                // value: _locationOptions[0],
                                items: _locationOptions
                                    .map((option) => DropdownMenuItem(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: AppPadding.p12,
                                            ),
                                            child: Text(
                                              option,
                                            ),
                                          ),
                                          value: option,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _billingInfo['convenient_location'] =
                                        value as String;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ----------------------    Sort by location section ends here -----------------------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              // I had to use the same code two times for direct order placement and indirect order placement so i just check the flag and show the notification of either success or failure
                              // bool _orderPlacedSuccessfully = false;

                              final _isValid = _form.currentState!.validate();
                              if (!_isValid) {
                                return;
                              }
                              _form.currentState!.save();

                              requestInfo["billing_info"] =
                                  json.decode(json.encode(_billingInfo));

                              if (await Provider.of<OrderRequests>(context,
                                      listen: false)
                                  .createOrderRequest(
                                      Provider.of<SessionProvider>(context,
                                              listen: false)
                                          .session as Session,
                                      requestInfo)) {
                                AlertHelper.showToastAlert(
                                    'Request has been sent successfully');
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // Navigator.pop(context);
                              } else {
                                AlertHelper.showToastAlert(
                                    'Something went wrong');
                              }
                            },
                            child: Text(
                              'Request Now',
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s18,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              padding: EdgeInsets.symmetric(
                                vertical: AppPadding.p12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailsPageImageGallery extends StatefulWidget {
  DetailsPageImageGallery({Key? key, required this.selectedPost})
      : super(key: key);

  @override
  State<DetailsPageImageGallery> createState() =>
      _DetailsPageImageGalleryState();

  final Book selectedPost;
}

class _DetailsPageImageGalleryState extends State<DetailsPageImageGallery> {
  int _selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    Book post = widget.selectedPost;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                post.images!.isEmpty
                    ? Container()
                    : Image.network(
                        // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        post.images![_selectedImage].image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: AppPadding.p8,
                      bottom: AppPadding.p24,
                      left: AppPadding.p4,
                      right: AppPadding.p4,
                    ),
                    // padding: EdgeInsets.symmetric(
                    //   vertical: AppPadding.p8,
                    //   horizontal: AppPadding.p4,
                    // ),
                    color: ColorManager.blackWithLowOpacity,
                    child: SizedBox(
                      height: AppHeight.h60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: post.images!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                _selectedImage = index;
                              });
                            }),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: _selectedImage == index
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.r12),
                                      )
                                    : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                    post.images![index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Image.network(
          //   // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
          //   post.images![_selectedImage].image,
          //   fit: BoxFit.cover,
          //   height: MediaQuery.of(context).size.height * 0.33,
          // ),
          // Container(
          //   padding: const EdgeInsets.only(
          //     top: AppPadding.p8,
          //     bottom: AppPadding.p16,
          //     left: AppPadding.p4,
          //     right: AppPadding.p4,
          //   ),
          //   color: ColorManager.blackWithLowOpacity,
          //   child: SizedBox(
          //     height: 50,
          //     child: ListView.builder(
          //       scrollDirection: Axis.horizontal,
          //       itemCount: post.images!.length,
          //       itemBuilder: (context, index) {
          //         return GestureDetector(
          //           onTap: (() {
          //             setState(() {
          //               _selectedImage = index;
          //             });
          //           }),
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 2),
          //             child: Container(
          //               padding: EdgeInsets.all(0),
          //               decoration: _selectedImage == index
          //                   ? BoxDecoration(
          //                       border: Border.all(
          //                         color: Colors.red,
          //                         width: 2,
          //                       ),
          //                       borderRadius:
          //                           BorderRadius.circular(AppRadius.r12),
          //                     )
          //                   : null,
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.circular(10),
          //                 child: Image.network(
          //                   // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
          //                   post.images![index].image,
          //                   fit: BoxFit.cover,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ItemCounter extends StatefulWidget {
  ItemCounter({
    Key? key,
    // required this.itemCount,
  }) : super(key: key);

  @override
  State<ItemCounter> createState() => _ItemCounterState();

  // int itemCount;
}

class _ItemCounterState extends State<ItemCounter> {
  @override
  Widget build(BuildContext context) {
    // int _itemCount = widget.itemCount;
    int itemCount = 1;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ButtonBar(
        buttonPadding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: 40,
            child: IconButton(
              color: Colors.black,
              padding: EdgeInsets.zero,
              disabledColor: Colors.grey,
              onPressed: itemCount > 1
                  ? () {
                      setState(() {
                        itemCount--;
                      });
                    }
                  : null,
              icon: Icon(Icons.remove),
            ),
          ),
          Text(
            // '1',
            itemCount.toString(),
            textAlign: TextAlign.center,
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s17,
            ),
          ),
          SizedBox(
            width: AppSize.s40,
            // height: AppSize.s20,
            child: IconButton(
              color: Colors.black,
              // padding: EdgeInsets.all(2.0),
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  itemCount++;
                });
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
