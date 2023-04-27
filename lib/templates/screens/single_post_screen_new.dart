import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/cart_screen.dart';
import 'package:share_learning/templates/screens/edit_post_screen.dart';
import 'package:share_learning/templates/widgets/post_comments_new.dart';

import '../../models/book.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/carts.dart';
import '../../providers/sessions.dart';
import '../../providers/users.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';

class SinglePostScreenNew extends StatefulWidget {
  static const routeName = '/post-details-new';

  const SinglePostScreenNew({Key? key}) : super(key: key);

  @override
  State<SinglePostScreenNew> createState() => _SinglePostScreenNewState();
}

class _SinglePostScreenNewState extends State<SinglePostScreenNew> {
// class SinglePostScreenNew extends StatelessWidget {
  int _selectedImage = 0;

  NepaliDateTime? _buyerExpectedDeadline;

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

  Book _buyerExpectedBook = new Book(
    id: '',
    author: 'Unknown',
    bookName: '',
    userId: '1',
    postType: 'B',
    category: null,
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    // wishlisted: false,
    price: 0,
    bookCount: 1,
    images: [],
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

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
    final _form = GlobalKey<FormState>();
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.7,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
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
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 4),
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
                                  ),
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
  Session authenticatedSession;
  User loggedInUser;
  String postId;
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
  NepaliDateTime initDate = NepaliDateTime.now();

  final _buyerDateFocusNode = FocusNode();
  final _buyerPriceFocusNode = FocusNode();
  final _buyerBooksCountFocusNode = FocusNode();

  int _itemCount = 1;

  final _datePickercontroller = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
        NepaliDateTime.now().year,
        NepaliDateTime.now().month,
        NepaliDateTime.now().day + 1)),
  );

  NepaliDateTime? _buyerExpectedDeadline;
  Book _buyerExpectedBook = new Book(
    id: '',
    author: 'Unknown',
    bookName: '',
    userId: '1',
    postType: 'B',
    category: null,
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    // wishlisted: false,
    price: 0,
    bookCount: 1,
    images: [],
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

  _checkBookInCart(Carts carts, Book selectedPost) {
    var check = carts.cartItems
        .indexWhere((element) => element.product.id == selectedPost.id);
    if (check == -1) return false;
    return true;
  }

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

  _showToastNotification(String msg) {
    BotToast.showSimpleNotification(
        title: msg,
        // duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        // align: Alignment(1, 1),
        align: Alignment(1, -1),
        hideCloseButton: true,
        dismissDirections: [
          DismissDirection.horizontal,
          DismissDirection.vertical,
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    Book selectedPost = widget.selectedPost;
    Users users = context.watch<Users>();

    Carts carts = Provider.of<Carts>(context);
    User _loggedInUser;
    if (users.user != null) {
      _loggedInUser = users.user as User;
    } else {
      _loggedInUser = widget.loggedInUser;
    }
    return _loggedInUser.id != selectedPost.userId
        ? (context.watch<Carts>().cartItems.length > 0 &&
                _checkBookInCart(carts, selectedPost)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ColorManager.grey,
                  // primary: Colors.black,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () async {},
                child: const Text(
                  'Book already ordered',
                  style: TextStyle(fontSize: 24),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: selectedPost.userId == _loggedInUser.id
                    ? null
                    : carts.cartItemsContains(int.parse(selectedPost.id))
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                CartScreen.routeName,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              // primary: ColorManager.primaryColorWithOpacity,
                              primary: ColorManager.primary,
                              minimumSize: const Size.fromHeight(40), // NEW
                            ),
                            child: const Text(
                              // "Already added to cart",
                              "Go to cart",
                              style: TextStyle(
                                fontSize: FontSize.s16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p18,
                              vertical: AppPadding.p8,
                            ),
                            child: SizedBox(
                              height: AppHeight.h40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _buyerExpectedBook = selectedPost;
                                      showModalBottomSheet(
                                        barrierColor:
                                            ColorManager.blackWithLowOpacity,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(AppRadius.r20),
                                            topRight: Radius.circular(
                                              AppRadius.r20,
                                            ),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: AppPadding.p8,
                                              left: AppPadding.p8,
                                              right: AppPadding.p8,
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child: Form(
                                              key: _form,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical:
                                                            AppPadding.p18,
                                                        horizontal:
                                                            AppPadding.p12,
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            _datePickercontroller,
                                                        focusNode:
                                                            _buyerDateFocusNode,
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Your expected deadline',
                                                          suffix: IconButton(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            tooltip:
                                                                'Tap to open date picker',
                                                            onPressed: () {
                                                              _showPicker(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .always,
                                                        onFieldSubmitted: (_) {
                                                          FocusScope.of(context)
                                                              .requestFocus(
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: AppPadding.p8,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal:
                                                                  AppPadding
                                                                      .p12,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              initialValue:
                                                                  _buyerExpectedBook
                                                                      .price
                                                                      .round()
                                                                      .toString(),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              cursorColor: Theme
                                                                      .of(context)
                                                                  .primaryColor,
                                                              focusNode:
                                                                  _buyerPriceFocusNode,
                                                              decoration:
                                                                  InputDecoration(
                                                                prefix: Text(
                                                                    'Rs. '),
                                                                labelText:
                                                                    'Expected price per piece',
                                                                focusColor: Colors
                                                                    .redAccent,
                                                              ),
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .always,
                                                              onFieldSubmitted:
                                                                  (_) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        _buyerBooksCountFocusNode);
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if (value!
                                                                    .isEmpty) {
                                                                  return 'Price can\'t be empty';
                                                                }
                                                                if (double.tryParse(
                                                                        value) ==
                                                                    null) {
                                                                  return 'Invalid number';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (value) {},
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal:
                                                                AppPadding.p12,
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
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
                                                            child: StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    StateSetter
                                                                        setState) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  IconButton(
                                                                    color: Colors
                                                                        .black,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    disabledColor:
                                                                        Colors
                                                                            .grey,
                                                                    splashRadius:
                                                                        AppRadius
                                                                            .r12,
                                                                    onPressed:
                                                                        _itemCount >
                                                                                1
                                                                            ? () {
                                                                                setState(() {
                                                                                  _itemCount--;
                                                                                });
                                                                              }
                                                                            : null,
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                  ),
                                                                  Text(
                                                                    _itemCount
                                                                        .toString(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        getBoldStyle(
                                                                      color: ColorManager
                                                                          .black,
                                                                      fontSize:
                                                                          FontSize
                                                                              .s17,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    color: Colors
                                                                        .black,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    disabledColor:
                                                                        Colors
                                                                            .grey,
                                                                    splashRadius:
                                                                        AppRadius
                                                                            .r12,
                                                                    onPressed: selectedPost.bookCount >
                                                                            _itemCount
                                                                        ? () {
                                                                            setState(() {
                                                                              _itemCount++;
                                                                            });
                                                                          }
                                                                        : null,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: AppPadding
                                                                  .p14),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          minimumSize: const Size
                                                                  .fromHeight(
                                                              40), // NEW
                                                        ),
                                                        child: Text(
                                                          // 'Place an order',
                                                          'Add book to cart',
                                                          style: getBoldStyle(
                                                            color: ColorManager
                                                                .white,
                                                            fontSize:
                                                                FontSize.s14,
                                                          ),
                                                        ),
                                                        onPressed: () async {
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
                                                              _showToastNotification(
                                                                  'Something went wrong');
                                                            }
                                                            _form.currentState!
                                                                .save();

                                                            CartItem
                                                                edittedItem =
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
                                                              // quantity:
                                                              //     _buyerExpectedBook
                                                              //         .bookCount,
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
                                                              Navigator.pop(
                                                                  context);
                                                              _showToastNotification(
                                                                  'Book added to cart successfully');
                                                            }
                                                          } else {
                                                            _showToastNotification(
                                                                'Something went wrong');
                                                          }
                                                        },
                                                      ),
                                                    ),
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
                                      'Add to cart',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ))
        // : SizedBox(
        //     height: 5.0,
        //   );
        : Padding(
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
                      Provider.of<SessionProvider>(context, listen: false)
                          .session,
                });
              },
            ),
          );
  }
}

class DetailsPageImageGallery extends StatefulWidget {
  DetailsPageImageGallery({Key? key, required this.selectedPost})
      : super(key: key);

  @override
  State<DetailsPageImageGallery> createState() =>
      _DetailsPageImageGalleryState();

  Book selectedPost;
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
                Image.network(
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
