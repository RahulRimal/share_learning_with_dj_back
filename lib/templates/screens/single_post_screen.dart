import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/user.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/image_gallery.dart';
import 'package:share_learning/templates/widgets/post_comments.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart_item.dart';
import '../../providers/orders.dart';
import 'edit_post_screen.dart';
import 'user_posts_screen.dart';

// ignore: must_be_immutable
class SinglePostScreen extends StatelessWidget {
  static const routeName = '/post-details';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // final _form = GlobalKey<FormState>();

  NepaliDateTime initDate = NepaliDateTime.now();
  // final _buyerDateFocusNode = FocusNode();
  // final _buyerPriceFocusNode = FocusNode();
  // final _buyerBooksCountFocusNode = FocusNode();

  // final _datePickercontroller = TextEditingController(
  //   text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
  //       NepaliDateTime.now().year,
  //       NepaliDateTime.now().month,
  //       NepaliDateTime.now().day + 1)),
  // );

  Users users = new Users(
    // Session(
    //   id: '0',
    //   userId: '0',
    //   accessToken: 'abc',
    //   accessTokenExpiry: DateTime(2050),
    //   refreshToken: 'abc',
    //   refreshTokenExpiry: DateTime(2050),
    // ),
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
  //   boughtDate: DateTime.now().toNepaliDateTime(),
  //   description: '',
  //   wishlisted: false,
  //   price: 0,
  //   bookCount: 1,
  //   pictures: [],
  //   postedOn: DateTime.now().toNepaliDateTime(),
  //   postRating: '',
  // );

  var bookId;
  // NepaliDateTime? _buyerExpectedDeadline;

  Future<void> _getSessionUser(String accessToken) async {
    await users.getUserByToken(accessToken);
    if (users.user != null)
      loggedInUser = users.user!;
    else {
      await users.getUserByToken(accessToken);
      loggedInUser = users.user!;
    }
  }

  // _getCartInfo(Carts carts) async {
  //   if (carts.cart == null)
  //   {
  //     SharedPreferences prefs = await _prefs;
  //     await carts.getCartInfo(prefs.getString('cartId') as String);
  //   }
  //   else{
  //   await carts.getCartInfo(carts.cart!.id);
  //   }
  // }
  _getCartInfo(Carts carts) async {
    await carts.getCartInfo(carts.cart!.id);
  }

  // _checkBookInCart(Carts carts, Book selectedPost) {
  //   var check = carts.cartItems
  //       .indexWhere((element) => element.product.id == selectedPost.id);
  //   if (check == -1) return false;
  //   return true;
  // }

  // NepaliDateTime _getTomorrowDate() {
  //   NepaliDateTime initDate = NepaliDateTime.now();
  //   NepaliDateTime tomorrow =
  //       NepaliDateTime(initDate.year, initDate.month, initDate.day + 1);
  //   return tomorrow;
  // }

  // Future<void> _showPicker(BuildContext context) async {
  //   _buyerExpectedDeadline = await picker.showAdaptiveDatePicker(
  //     context: context,
  //     // initialDate: picker.NepaliDateTime.now(),
  //     initialDate: _getTomorrowDate(),
  //     // firstDate: picker.NepaliDateTime.t
  //     firstDate: _getTomorrowDate(),
  //     // lastDate: picker.NepaliDateTime.now(),
  //     lastDate: picker.NepaliDateTime(2080),
  //   );
  //   _datePickercontroller.text = DateFormat('yyyy-MM-dd')
  //       .format(_buyerExpectedDeadline as DateTime)
  //       .toString();
  // }

  // _showToastNotification(String msg) {
  //   BotToast.showSimpleNotification(
  //     title: msg,
  //     duration: Duration(seconds: 3),
  //     backgroundColor: ColorManager.primary,
  //     titleStyle: getBoldStyle(color: ColorManager.white),
  //     align: Alignment(1, 1),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    bookId = args['id'];
    final Session loggedInUserSession = args['loggedInUserSession'] as Session;
    // users.getUserByToken(loggedInUserSession.accessToken);
    _getSessionUser(loggedInUserSession.accessToken);

    Book selectedPost = Provider.of<Books>(
      context,
      listen: false,
    ).books.firstWhere((book) => book.id == bookId);

    // Comments comments = context.watch<Comments>();

    Books books = context.watch<Books>();

    // Carts carts = Provider.of<Carts>(context);
    Carts carts = Provider.of<Carts>(context, listen: false);

    Orders orders = Provider.of<Orders>(context);

    _getCartInfo(carts);

    Duration timeDifference =
        NepaliDateTime.now().difference(selectedPost.boughtDate);
    double duration =
        double.parse((timeDifference.inDays / 365).toStringAsFixed(1));

    if (users.user != null) {
      loggedInUser = users.user as User;
    } else {
      users.getUserByToken(loggedInUserSession.accessToken);
    }

    return Scaffold(
      // drawer: users.user == null
      //     ? AppDrawer(
      //         loggedInUserSession,
      //         null,
      //       )
      //     : AppDrawer(
      //         loggedInUserSession,
      //         users.user,
      //       ),
      drawer: AppDrawer(loggedInUserSession),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: context.watch<Users>().user!.id == selectedPost.userId
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Navigator.of(context)
                      //     .pushNamed(EditPostScreen.routeName, arguments: {
                      //   'bookId': bookId,
                      //   'loggedInUserSession': loggedInUserSession
                      // });

                      if (await books.deletePost(loggedInUserSession, bookId)) {
                        // Navigator.pop(context);
                        Navigator.of(context).pushReplacementNamed(
                            HomeScreen.routeName,
                            arguments: {
                              'authSession': loggedInUserSession,
                            });
                        AlertHelper.showToastAlert('Post deleted successfully');
                      } else {
                        AlertHelper.showToastAlert('Colubn\'t delete post!');
                      }
                    },
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            // child: loggedInUserSession.userId == selectedPost.userId
            child: context.watch<Users>().user!.id == selectedPost.userId
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditPostScreen.routeName,
                          arguments: {
                            'bookId': bookId,
                            'loggedInUserSession': loggedInUserSession
                          });
                    },
                  )
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  selectedPost.bookName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        UserPostsScreen.routeName,
                        arguments: {
                          'uId': selectedPost.userId,
                          'loggedInUserSession': loggedInUserSession,
                        },
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.person),
                          Text(
                            'Author',
                          ),
                          Text(
                            selectedPost.author,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                            ),
                            child: Text(
                              // 'Bought 1 Year Ago',
                              duration > 1.0
                                  ? '$duration Years ago'
                                  : duration == 1.0
                                      ? '$duration Year ago'
                                      : duration == 0.1
                                          ? '1 Month ago'
                                          : '${((duration % 1) * 10).floor()} Months ago',

                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Flexible(
                              fit: FlexFit.loose,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 10,
                                ),
                                child: Text(
                                  selectedPost.description,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Total Books: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${selectedPost.bookCount}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Total Price: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Rs.${selectedPost.price}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Image Gallery Starts Here

              // ImageGallery(true, this.bookId),
              // selectedPost.pictures != null
              selectedPost.images != null
                  ? ImageGallery(
                      true,
                      images: selectedPost.images,
                      isErasable: false,
                      bookId: selectedPost.id,
                    )
                  : SizedBox(
                      height: AppHeight.h100,
                      child: Center(
                        child: Text(
                          'No Images found',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

              // Image Gallery Ends Here

              // Comments Starts here
              Container(
                padding: EdgeInsets.all(5),
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
              PostComments(loggedInUserSession, loggedInUser, this.bookId),

              // Add your comment ends here !!
            ],
          ),
        ),
      ),
      bottomSheet: CartBottomSheet(
          selectedPost: selectedPost, loggedInUser: loggedInUser),
      // bottomSheet: loggedInUserSession.userId != selectedPost.userId
      // bottomSheet: '1' != selectedPost.userId
      //     ? (carts.cartItems.length > 0 && _checkBookInCart(carts, selectedPost)
      //         // ? (Provider.of<Carts>(context).cartItems.length > 0 && _checkBookInCart(carts, selectedPost)
      //         ? ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               primary: ColorManager.grey,
      //               // primary: Colors.black,
      //               minimumSize: const Size.fromHeight(50), // NEW
      //             ),
      //             onPressed: () async {},
      //             child: const Text(
      //               'Book already ordered',
      //               style: TextStyle(fontSize: 24),
      //             ),
      //           )
      //         : Padding(
      //             padding: const EdgeInsets.all(AppPadding.p8),
      //             child: selectedPost.userId == loggedInUser.id
      //                 ? null
      //                 : carts.cartItemsContains(int.parse(selectedPost.id))
      //                     ? ElevatedButton(
      //                         onPressed: () {},
      //                         style: ElevatedButton.styleFrom(
      //                           primary: ColorManager.primaryColorWithOpacity,
      //                           minimumSize: const Size.fromHeight(40), // NEW
      //                         ),
      //                         child: const Text(
      //                           "Already added to cart",
      //                           style: TextStyle(
      //                             fontSize: FontSize.s16,
      //                             fontWeight: FontWeight.w600,
      //                             color: Colors.black,
      //                           ),
      //                         ))
      //                     : ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                           // primary: Colors.black,
      //                           minimumSize: const Size.fromHeight(40), // NEW
      //                         ),
      //                         onPressed: () {
      //                           _buyerExpectedBook = selectedPost;
      //                           showModalBottomSheet(
      //                             barrierColor:
      //                                 ColorManager.blackWithLowOpacity,
      //                             isScrollControlled: true,
      //                             shape: RoundedRectangleBorder(
      //                                 borderRadius: BorderRadius.only(
      //                                     topLeft:
      //                                         Radius.circular(AppRadius.r20),
      //                                     topRight:
      //                                         Radius.circular(AppRadius.r20))),
      //                             context: context,
      //                             builder: (context) {
      //                               return Padding(
      //                                 padding: EdgeInsets.only(
      //                                   top: AppPadding.p8,
      //                                   left: AppPadding.p8,
      //                                   right: AppPadding.p8,
      //                                   bottom: MediaQuery.of(context)
      //                                       .viewInsets
      //                                       .bottom,
      //                                 ),
      //                                 child: Form(
      //                                   key: _form,
      //                                   child: Column(
      //                                     mainAxisSize: MainAxisSize.min,
      //                                     children: [
      //                                       Flexible(
      //                                         child: Padding(
      //                                           padding:
      //                                               const EdgeInsets.symmetric(
      //                                             vertical: AppPadding.p18,
      //                                             horizontal: AppPadding.p12,
      //                                           ),
      //                                           child: TextFormField(
      //                                             controller:
      //                                                 _datePickercontroller,
      //                                             focusNode:
      //                                                 _buyerDateFocusNode,
      //                                             keyboardType:
      //                                                 TextInputType.datetime,
      //                                             cursorColor: Theme.of(context)
      //                                                 .primaryColor,
      //                                             decoration: InputDecoration(
      //                                               labelText:
      //                                                   'Your expected deadline',
      //                                               suffix: IconButton(
      //                                                 icon: Icon(
      //                                                     Icons.calendar_today),
      //                                                 tooltip:
      //                                                     'Tap to open date picker',
      //                                                 onPressed: () {
      //                                                   _showPicker(context);
      //                                                 },
      //                                               ),
      //                                             ),
      //                                             textInputAction:
      //                                                 TextInputAction.next,
      //                                             autovalidateMode:
      //                                                 AutovalidateMode.always,
      //                                             onFieldSubmitted: (_) {
      //                                               FocusScope.of(context)
      //                                                   .requestFocus(
      //                                                       _buyerPriceFocusNode);
      //                                             },
      //                                             validator: (value) {
      //                                               if (value!.isEmpty) {
      //                                                 return 'Please provide your expected deadline';
      //                                               }
      //                                               return null;
      //                                             },
      //                                             onSaved: (value) {},
      //                                           ),
      //                                         ),
      //                                       ),
      //                                       Padding(
      //                                         padding: const EdgeInsets.only(
      //                                           bottom: AppPadding.p8,
      //                                         ),
      //                                         child: Row(
      //                                           mainAxisAlignment:
      //                                               MainAxisAlignment.center,
      //                                           children: [
      //                                             Flexible(
      //                                               child: Padding(
      //                                                 padding: const EdgeInsets
      //                                                     .symmetric(
      //                                                   horizontal:
      //                                                       AppPadding.p12,
      //                                                 ),
      //                                                 child: TextFormField(
      //                                                     // initialValue: _edittedBook.price.toString(),
      //                                                     initialValue:
      //                                                         _buyerExpectedBook
      //                                                             .price
      //                                                             .toString(),
      //                                                     cursorColor:
      //                                                         Theme.of(context)
      //                                                             .primaryColor,
      //                                                     focusNode:
      //                                                         _buyerPriceFocusNode,
      //                                                     decoration:
      //                                                         InputDecoration(
      //                                                       prefix:
      //                                                           Text('Rs. '),
      //                                                       labelText:
      //                                                           'Expected price per piece',
      //                                                       focusColor: Colors
      //                                                           .redAccent,
      //                                                     ),
      //                                                     textInputAction:
      //                                                         TextInputAction
      //                                                             .next,
      //                                                     autovalidateMode:
      //                                                         AutovalidateMode
      //                                                             .always,
      //                                                     onFieldSubmitted:
      //                                                         (_) {
      //                                                       FocusScope.of(
      //                                                               context)
      //                                                           .requestFocus(
      //                                                               _buyerBooksCountFocusNode);
      //                                                     },
      //                                                     validator: (value) {
      //                                                       if (value!
      //                                                           .isEmpty) {
      //                                                         return 'Price can\'t be empty';
      //                                                       }
      //                                                       if (double.tryParse(
      //                                                               value) ==
      //                                                           null) {
      //                                                         return 'Invalid number';
      //                                                       }
      //                                                       return null;
      //                                                     },
      //                                                     onSaved: (value) {}),
      //                                               ),
      //                                             ),
      //                                             Flexible(
      //                                               child: Padding(
      //                                                 padding: const EdgeInsets
      //                                                     .symmetric(
      //                                                   horizontal:
      //                                                       AppPadding.p12,
      //                                                 ),
      //                                                 child: TextFormField(
      //                                                   initialValue:
      //                                                       _buyerExpectedBook
      //                                                           .bookCount
      //                                                           .toString(),
      //                                                   focusNode:
      //                                                       _buyerBooksCountFocusNode,
      //                                                   keyboardType:
      //                                                       TextInputType
      //                                                           .number,
      //                                                   cursorColor:
      //                                                       Theme.of(context)
      //                                                           .primaryColor,
      //                                                   decoration:
      //                                                       InputDecoration(
      //                                                     labelText:
      //                                                         'Number of Books you want',
      //                                                   ),
      //                                                   textInputAction:
      //                                                       TextInputAction
      //                                                           .next,
      //                                                   autovalidateMode:
      //                                                       AutovalidateMode
      //                                                           .always,
      //                                                   // onFieldSubmitted: (_) {
      //                                                   //   FocusScope.of(context).requestFocus(_descFocusNode);
      //                                                   // },
      //                                                   validator: (value) {
      //                                                     if (double.tryParse(value
      //                                                             as String) ==
      //                                                         null) {
      //                                                       return 'Invalid Number';
      //                                                     }

      //                                                     if (double.parse(
      //                                                             value) <
      //                                                         1) {
      //                                                       return 'Book count must be at least 1';
      //                                                     }
      //                                                     return null;
      //                                                   },
      //                                                   onSaved: (value) {
      //                                                     _buyerExpectedBook
      //                                                             .bookCount =
      //                                                         int.parse(value
      //                                                             .toString());
      //                                                   },
      //                                                 ),
      //                                               ),
      //                                               // ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                       Flexible(
      //                                         child: Padding(
      //                                           padding: const EdgeInsets.only(
      //                                               bottom: AppPadding.p14),
      //                                           child: ElevatedButton(
      //                                             style:
      //                                                 ElevatedButton.styleFrom(
      //                                               minimumSize:
      //                                                   const Size.fromHeight(
      //                                                       40), // NEW
      //                                             ),
      //                                             child: Text(
      //                                               // 'Place an order',
      //                                               'Add book to cart',
      //                                               style: getBoldStyle(
      //                                                 color: ColorManager.white,
      //                                                 fontSize: FontSize.s14,
      //                                               ),
      //                                             ),
      //                                             onPressed: () async {
      //                                               // ----------------------Order without cart starts here ----------------------
      //                                               // if (await orders.getUserOrder(
      //                                               //     loggedInUserSession,
      //                                               //     users.user as User)) {
      //                                               //   final isValid = _form
      //                                               //       .currentState!
      //                                               //       .validate();
      //                                               //   if (!isValid) {
      //                                               //     _showToastNotification(
      //                                               //         'Something went wrong');
      //                                               //   }
      //                                               //   _form.currentState!.save();
      //                                               //   OrderItem item =
      //                                               //       new OrderItem(
      //                                               //           id: 0,
      //                                               //           productId: int.parse(
      //                                               //               selectedPost.id),
      //                                               //           quantity:
      //                                               //               _buyerExpectedBook
      //                                               //                   .bookCount);
      //                                               //   if (await orders.addOrderItem(
      //                                               //       item,
      //                                               //       orders.order as Order)) {
      //                                               //     Navigator.pop(context);
      //                                               //     _showToastNotification(
      //                                               //         'Book has been ordered successfully');
      //                                               //   }
      //                                               // } else {
      //                                               //   _showToastNotification(
      //                                               //       'Something went wrong');
      //                                               // }
      //                                               // ----------------------Order without cart ends here ----------------------

      //                                               if (carts.cart != null) {
      //                                                 final isValid = _form
      //                                                     .currentState!
      //                                                     .validate();
      //                                                 if (!isValid) {
      //                                                   _showToastNotification(
      //                                                       'Something went wrong');
      //                                                 }
      //                                                 _form.currentState!
      //                                                     .save();

      //                                                 CartItem edittedItem =
      //                                                     new CartItem(
      //                                                   id: 0,
      //                                                   product: new Product(
      //                                                     id: int.parse(
      //                                                         selectedPost.id),
      //                                                     bookName: selectedPost
      //                                                         .bookName,
      //                                                     unitPrice:
      //                                                         selectedPost.price
      //                                                             .toString(),
      //                                                   ),
      //                                                   quantity:
      //                                                       _buyerExpectedBook
      //                                                           .bookCount,
      //                                                   totalPrice: 0,
      //                                                 );

      //                                                 if (await carts
      //                                                     .addItemToCart(
      //                                                         carts.cart
      //                                                             as Cart,
      //                                                         edittedItem)) {
      //                                                   Navigator.pop(context);
      //                                                   _showToastNotification(
      //                                                       'Book added to cart successfully');
      //                                                 }
      //                                               } else {
      //                                                 _showToastNotification(
      //                                                     'Something went wrong');
      //                                               }
      //                                             },
      //                                           ),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               );
      //                             },
      //                           );
      //                         },

      //                         // ------------ Order without involving cart starts here ------------
      //                         // child: orders.orderItemsContains(
      //                         //         int.parse(selectedPost.id))
      //                         //     ? const Text(
      //                         //         "You've Already ordered this book",
      //                         //         style: TextStyle(
      //                         //           fontSize: FontSize.s16,
      //                         //           fontWeight: FontWeight.w600,
      //                         //           color: Colors.black,
      //                         //         ),
      //                         //       )
      //                         //     : const Text(
      //                         //         'Order this book',
      //                         //         style: TextStyle(
      //                         //           fontSize: FontSize.s20,
      //                         //           fontWeight: FontWeight.w600,
      //                         //         ),
      //                         //       ),

      //                         // ------------ Order without involving cart ends here ------------
      //                         child: const Text(
      //                           'Add to cart',
      //                           style: TextStyle(
      //                             fontSize: FontSize.s20,
      //                             fontWeight: FontWeight.w600,
      //                           ),
      //                         ),
      //                       ),
      //           ))
      //     : SizedBox(
      //         height: 5.0,
      //       ),
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
      // initialDate: picker.NepaliDateTime.now(),
      initialDate: _getTomorrowDate(),
      // firstDate: picker.NepaliDateTime.t
      firstDate: _getTomorrowDate(),
      // lastDate: picker.NepaliDateTime.now(),
      lastDate: picker.NepaliDateTime(2080),
    );
    _datePickercontroller.text = DateFormat('yyyy-MM-dd')
        .format(_buyerExpectedDeadline as DateTime)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    Book selectedPost = widget.selectedPost;
    double _expectedUnitPrice = 0;
    // Book _buyerExpectedBook = widget.buyerExpectedBook;
    Users users = context.watch<Users>();

    Carts carts = Provider.of<Carts>(context);
    User _loggedInUser;
    if (users.user != null) {
      _loggedInUser = users.user as User;
    } else {
      _loggedInUser = widget.loggedInUser;
    }

    // return users.user!.id != selectedPost.userId
    return _loggedInUser.id != selectedPost.userId

        // ? (carts.cartItems.length > 0 && _checkBookInCart(carts, selectedPost)
        ? (context.watch<Carts>().cartItems.length > 0 &&
                _checkBookInCart(carts, selectedPost)
            // ? (Provider.of<Carts>(context).cartItems.length > 0 && _checkBookInCart(carts, selectedPost)
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.grey,
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColorWithOpacity,
                              minimumSize: const Size.fromHeight(40), // NEW
                            ),
                            child: const Text(
                              "Already added to cart",
                              style: TextStyle(
                                fontSize: FontSize.s16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // primary: Colors.black,
                              minimumSize: const Size.fromHeight(40), // NEW
                            ),
                            onPressed: () {
                              _buyerExpectedBook = selectedPost;
                              showModalBottomSheet(
                                barrierColor: ColorManager.blackWithLowOpacity,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(AppRadius.r20),
                                        topRight:
                                            Radius.circular(AppRadius.r20))),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: AppPadding.p18,
                                                horizontal: AppPadding.p12,
                                              ),
                                              child: TextFormField(
                                                controller:
                                                    _datePickercontroller,
                                                focusNode: _buyerDateFocusNode,
                                                keyboardType:
                                                    TextInputType.datetime,
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Your expected deadline',
                                                  suffix: IconButton(
                                                    icon: Icon(
                                                        Icons.calendar_today),
                                                    tooltip:
                                                        'Tap to open date picker',
                                                    onPressed: () {
                                                      _showPicker(context);
                                                    },
                                                  ),
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
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
                                            padding: const EdgeInsets.only(
                                              bottom: AppPadding.p8,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal:
                                                          AppPadding.p12,
                                                    ),
                                                    child: TextFormField(
                                                        // initialValue: _edittedBook.price.toString(),
                                                        initialValue:
                                                            _buyerExpectedBook
                                                                .price
                                                                .toString(),
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        focusNode:
                                                            _buyerPriceFocusNode,
                                                        decoration:
                                                            InputDecoration(
                                                          prefix: Text('Rs. '),
                                                          labelText:
                                                              'Expected price per piece',
                                                          focusColor:
                                                              Colors.redAccent,
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
                                                                  _buyerBooksCountFocusNode);
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Price can\'t be empty';
                                                          }
                                                          if (double.tryParse(
                                                                  value) ==
                                                              null) {
                                                            return 'Invalid number';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {
                                                          _expectedUnitPrice =
                                                              double.parse(value
                                                                  as String);
                                                        }),
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal:
                                                          AppPadding.p12,
                                                    ),
                                                    child: TextFormField(
                                                      initialValue:
                                                          _buyerExpectedBook
                                                              .bookCount
                                                              .toString(),
                                                      focusNode:
                                                          _buyerBooksCountFocusNode,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      cursorColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Number of Books you want',
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .always,
                                                      // onFieldSubmitted: (_) {
                                                      //   FocusScope.of(context).requestFocus(_descFocusNode);
                                                      // },
                                                      validator: (value) {
                                                        if (double.tryParse(value
                                                                as String) ==
                                                            null) {
                                                          return 'Invalid Number';
                                                        }

                                                        if (double.parse(
                                                                value) <
                                                            1) {
                                                          return 'Book count must be at least 1';
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        _buyerExpectedBook
                                                                .bookCount =
                                                            int.parse(value
                                                                .toString());
                                                      },
                                                    ),
                                                  ),
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: AppPadding.p14),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size.fromHeight(
                                                          40), // NEW
                                                ),
                                                child: Text(
                                                  // 'Place an order',
                                                  'Add book to cart',
                                                  style: getBoldStyle(
                                                    color: ColorManager.white,
                                                    fontSize: FontSize.s14,
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

                                                  if (carts.cart != null) {
                                                    final isValid = _form
                                                        .currentState!
                                                        .validate();
                                                    if (!isValid) {
                                                      AlertHelper.showToastAlert(
                                                          'Something went wrong');
                                                    }
                                                    _form.currentState!.save();

                                                    CartItem edittedItem =
                                                        new CartItem(
                                                      id: 0,
                                                      product: new Product(
                                                        id: int.parse(
                                                            selectedPost.id),
                                                        bookName: selectedPost
                                                            .bookName,
                                                        unitPrice: selectedPost
                                                            .price
                                                            .toString(),
                                                      ),
                                                      quantity:
                                                          _buyerExpectedBook
                                                              .bookCount,
                                                      negotiatedPrice:
                                                          _expectedUnitPrice,
                                                      totalPrice: 0,
                                                    );

                                                    if (await carts
                                                        .addItemToCart(
                                                            carts.cart as Cart,
                                                            edittedItem)) {
                                                      AlertHelper.showToastAlert(
                                                          'Book added to cart successfully');

                                                      Navigator.pop(context);
                                                    }
                                                  } else {
                                                    AlertHelper.showToastAlert(
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

                            // ------------ Order without involving cart starts here ------------
                            // child: orders.orderItemsContains(
                            //         int.parse(selectedPost.id))
                            //     ? const Text(
                            //         "You've Already ordered this book",
                            //         style: TextStyle(
                            //           fontSize: FontSize.s16,
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.black,
                            //         ),
                            //       )
                            //     : const Text(
                            //         'Order this book',
                            //         style: TextStyle(
                            //           fontSize: FontSize.s20,
                            //           fontWeight: FontWeight.w600,
                            //         ),
                            //       ),

                            // ------------ Order without involving cart ends here ------------
                            child: const Text(
                              'Add to cart',
                              style: TextStyle(
                                fontSize: FontSize.s20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
              ))
        : SizedBox(
            height: 5.0,
          );
  }
}
