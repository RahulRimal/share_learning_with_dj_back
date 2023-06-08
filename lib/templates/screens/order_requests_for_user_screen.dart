import 'package:bot_toast/bot_toast.dart';
import 'package:esewa_client/esewa_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order_request.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/order_request_provider.dart';
import 'package:share_learning/providers/orders.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:share_learning/templates/widgets/cart_item_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/book.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../models/user.dart';

import '../../providers/users.dart';
import '../widgets/billing_info.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'order_request_details_screen.dart';
import 'order_requests_for_user_details_screen.dart';

class OrderRequestsForUserScreen extends StatefulWidget {
  const OrderRequestsForUserScreen({Key? key}) : super(key: key);
  static final routeName = '/order-requests-for-user-list';

  @override
  State<OrderRequestsForUserScreen> createState() =>
      _OrderRequestsForUserScreenState();
}

class _OrderRequestsForUserScreenState
    extends State<OrderRequestsForUserScreen> {
  final _form = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // final Session authendicatedSession = args['loggedInUserSession'] as Session;

    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    // Carts carts = Provider.of<Carts>(context, listen: false);
    OrderRequests orderRequests =
        Provider.of<OrderRequests>(context, listen: false);

    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: AppHeight.h20,
              ),
              Form(
                key: _form,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                  child: TextFormField(
                    controller: _searchController,
                    // focusNode: _searchFocusNode,
                    keyboardType: TextInputType.text,
                    cursorColor: Theme.of(context).primaryColor,
                    style: getBoldStyle(
                        fontSize: FontSize.s14, color: ColorManager.black),
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      hintText: 'Find your order request',
                      hintStyle: getBoldStyle(
                          fontSize: FontSize.s17,
                          color: ColorManager.primaryOpacity70),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorManager.primaryOpacity70,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: ColorManager.primaryOpacity70,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      // FocusScope.of(context)
                      //     .requestFocus(_priceFocusNode);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: AppHeight.h20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
                height: AppHeight.h150,
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "$IMAGE_PATH/education.svg",
                      // width: AppSize.s100,
                      height: AppHeight.h140,
                    ),
                    Flexible(
                      child: Text(
                        'Free Shipping inside the Valley',
                        style: getBoldStyle(
                            fontSize: FontSize.s20, color: ColorManager.white),
                      ),
                    )
                  ],
                ),
              ),
              // carts.cart!.items!.length <= 0
              // orderRequests.orderRequests.length <= 0
              //     ? Center(
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: AppPadding.p45),
              //           child: Text(
              //             'No request for the order found',
              //             style: getBoldStyle(
              //               fontSize: FontSize.s20,
              //               color: ColorManager.primary,
              //             ),
              //           ),
              //         ),
              //       )
              //     : Expanded(
              //         child: OrderRequestList(
              //             orderRequests: orderRequests,
              //             authendicatedSession: authendicatedSession),
              //       ),
              FutureBuilder(
                future: orderRequests.getRequestsForUser(authendicatedSession),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: ColorManager.secondary,
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      if (snapshot.data is OrderRequestError) {
                        OrderRequestError error =
                            snapshot.data as OrderRequestError;
                        return Text(error.message as String);
                      } else {
                        List<OrderRequest> data =
                            snapshot.data as List<OrderRequest>;
                        return data.length <= 0
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppPadding.p45),
                                  child: Text(
                                    'No request for the order found',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s20,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: OrderRequestList(
                                    orderRequests: orderRequests,
                                    authendicatedSession: authendicatedSession),
                              );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 3,
      ),
    );
  }
}

class OrderRequestList extends StatelessWidget {
  const OrderRequestList({
    Key? key,
    required this.orderRequests,
    required this.authendicatedSession,
  }) : super(key: key);

  final OrderRequests orderRequests;
  final Session authendicatedSession;

  // _getCartId() async {
  //   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   SharedPreferences prefs = await _prefs;
  //   String cartId = prefs.getString('cartId') as String;
  //   return cartId;
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // itemCount: context.watch<Carts>().cartItems.length,
      itemCount: context.watch<OrderRequests>().orderRequestsForUser.length,
      itemBuilder: (context, index) {
        return OrderRequestItemWidget(
          // cartItem: carts.cartItems[index],
          requestedItem: orderRequests.orderRequestsForUser[index],
        );
      },
    );
  }
}

class OrderRequestItemWidget extends StatefulWidget {
  const OrderRequestItemWidget({Key? key, required this.requestedItem})
      : super(key: key);

  final OrderRequest requestedItem;

  @override
  State<OrderRequestItemWidget> createState() => _OrderRequestItemWidgetState();
}

class _OrderRequestItemWidgetState extends State<OrderRequestItemWidget> {
  ValueNotifier<bool> _showRequestButton = ValueNotifier(false);
  ValueNotifier<bool> _showOrderButton = ValueNotifier(false);
  bool _isLoading = false;

  double _newRequestPrice = 0;

  _shouldShowRequestButton() {
    if (_newRequestPrice != double.parse(widget.requestedItem.requestedPrice) &&
        _newRequestPrice !=
            double.parse(widget.requestedItem.product.unitPrice)) {
      _showRequestButton.value = true;
      return;
    }
    _showRequestButton.value = false;
  }

  _shouldShowOrderButton() {
    if (_newRequestPrice ==
        double.parse(widget.requestedItem.product.unitPrice)) {
      _showOrderButton.value = true;
      return;
    }
    _showOrderButton.value = false;
  }

  Future<bool> _updateRequestPrice(
      String requestId, double newRequestPrice) async {
    await Provider.of<OrderRequests>(context, listen: false)
        .updateRequestPrice(widget.requestedItem.id, _newRequestPrice)
        .then(
      (value) {
        if (value) {
          BotToast.showSimpleNotification(
            title: 'Request price changed',
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            // align: Alignment(0, 0),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
          _showRequestButton.value = false;
        } else
          BotToast.showSimpleNotification(
            title: "Something went wrong, Please try again!",
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
      },
    );

    return true;
  }

  _deleteCartItem(Session userSession, String cartId, String cartItemId) async {
    bool value = await Provider.of<Carts>(context, listen: false)
        .deleteCartItem(userSession, cartId, cartItemId);
    if (value) {
      BotToast.showSimpleNotification(
        title: 'Book deleted from the cart',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
    } else
      BotToast.showSimpleNotification(
        title: 'Something went wrong, Please try again!',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
  }

  // _deleteCartItem(Session userSession, String cartId, String cartItemId) async {
  //   await Provider.of<Carts>(context, listen: false)
  //       .deleteCartItem(userSession, cartId, cartItemId)
  //       .then(
  //     (value) {
  //       if (value) {
  //         BotToast.showSimpleNotification(
  //           title: 'Book deleted from the cart',
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //       } else
  //         BotToast.showSimpleNotification(
  //           title: 'Something went wrong, Please try again!',
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //     },
  //   );
  // }

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
    OrderRequest requestedItem = widget.requestedItem;
    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    Carts _carts = context.watch<Carts>();
    OrderRequests _orderRequests = context.watch<OrderRequests>();

    return FutureBuilder(
        // future: _carts.getCartItemBook(
        //     authendicatedSession, widget.requestedItem.product.id.toString()),
        future: _orderRequests.getRequestedItemBook(
            authendicatedSession, widget.requestedItem.product.id.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              if (snapshot.data is Book) {
                final Book requestedBook = snapshot.data as Book;
                return Container(
                  margin: EdgeInsets.all(AppMargin.m8),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(
                      5.00,
                    ),
                    border: Border.all(
                      color: ColorManager.primary,
                      width: 1.00,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 16.00,
                              top: 16.00,
                              bottom: 16.00,
                            ),
                            // child: Image.network(
                            //   'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
                            //   width: 100.0,
                            //   height: 100.0,
                            // ),
                            child: Image.network(
                              requestedBook.images![0].image,
                              width: 100.0,
                              height: 100.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 12.00,
                              top: 16.00,
                              right: 16.00,
                              bottom: 15.00,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 227.00,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 158.00,
                                        child: Text(
                                          requestedBook.bookName,
                                          maxLines: null,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.50,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 12.00,
                                        ),
                                        child: Container(
                                          height: 24.00,
                                          width: 24.00,
                                          child: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              bool userConfirmed = false;
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text(
                                                    'The request will be deleted forever',
                                                    style: getRegularStyle(
                                                      fontSize: FontSize.s16,
                                                      color: ColorManager.black,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Yes',
                                                        style: getBoldStyle(
                                                          fontSize:
                                                              FontSize.s16,
                                                          color: ColorManager
                                                              .primary,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        userConfirmed = true;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'No',
                                                        style: getBoldStyle(
                                                          fontSize:
                                                              FontSize.s16,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ).then((_) {
                                                if (userConfirmed) {
                                                  _deleteCartItem(
                                                    authendicatedSession,
                                                    Provider.of<Carts>(context,
                                                            listen: false)
                                                        .cart!
                                                        .id,
                                                    widget.requestedItem.id
                                                        .toString(),
                                                  );
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 227.00,
                                  margin: EdgeInsets.only(
                                    top: 17.00,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // --------------------------Original Unit Price starts here-----------------------
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: Text(
                                                "Unit Price",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: ColorManager.black,
                                                  fontSize: FontSize.s12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: Text(
                                                "Rs. ${widget.requestedItem.product.unitPrice}",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: FontSize.s14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // --------------------------Original Unit Price ends here-----------------------

                                      // --------------------------Expected Unit Price starts here-----------------------
                                      Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: Text(
                                                "Requested unit price",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: ColorManager.black,
                                                  fontSize: FontSize.s12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: Text(
                                                "Rs. ${widget.requestedItem.requestedPrice}",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: FontSize.s14,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // --------------------------Expected Unit Price ends here-----------------------

                                      // --------------------------Change Request Price starts here-----------------------

                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //     top: AppPadding.p8,
                                      //   ),
                                      //   child: TextFormField(
                                      //     keyboardType: TextInputType.number,
                                      //     cursorColor:
                                      //         Theme.of(context).primaryColor,
                                      //     decoration: InputDecoration(
                                      //       labelText: 'Change requst price',
                                      //       focusedBorder: OutlineInputBorder(
                                      //         borderSide: BorderSide(
                                      //           color: Colors.redAccent,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     textInputAction: TextInputAction.done,
                                      //     onChanged: (value) {
                                      //       _newRequestPrice =
                                      //           double.parse(value);
                                      //       _shouldShowRequestButton();
                                      //       _shouldShowOrderButton();
                                      //     },
                                      //     // onFieldSubmitted: (_) {
                                      //     //   FocusScope.of(context).requestFocus(_authorFocusNode);
                                      //     // },
                                      //     validator: (value) {
                                      //       if (value!.isEmpty) {
                                      //         return 'Please provide the bookName';
                                      //       }
                                      //       return null;
                                      //     },
                                      //     onSaved: (value) {},
                                      //   ),
                                      // ),

                                      // ValueListenableBuilder(
                                      //   valueListenable: _showRequestButton,
                                      //   builder: (BuildContext context,
                                      //       bool showRequestButton,
                                      //       Widget? child) {
                                      //     return showRequestButton
                                      //         ? ElevatedButton(
                                      //             onPressed: () =>
                                      //                 _updateRequestPrice(
                                      //                     requestedItem.id,
                                      //                     _newRequestPrice),
                                      //             // child: Text('Update Request Price'),
                                      //             child: Text(
                                      //                 'Request for this price'),
                                      //           )
                                      //         : Container();
                                      //   },
                                      // ),
                                      // ValueListenableBuilder(
                                      //   valueListenable: _showOrderButton,
                                      //   builder: (BuildContext context,
                                      //       bool showOrderButton,
                                      //       Widget? child) {
                                      //     return showOrderButton
                                      //         ? ElevatedButton(
                                      //             onPressed: () async {
                                      //               Carts carts = Provider.of(
                                      //                   context,
                                      //                   listen: false);
                                      //               setState(() {
                                      //                 _isLoading = true;
                                      //               });
                                      //               var tempCart = await carts
                                      //                   .createTemporaryCart(
                                      //                       Provider.of<SessionProvider>(
                                      //                                   context,
                                      //                                   listen:
                                      //                                       false)
                                      //                               .session
                                      //                           as Session);
                                      //               if (tempCart is CartError) {
                                      //                 _showToastNotification(
                                      //                     'Something went wrong');
                                      //               }
                                      //               if (tempCart is Cart) {
                                      //                 CartItem edittedItem =
                                      //                     new CartItem(
                                      //                   id: 0,
                                      //                   product: new Product(
                                      //                     id: int.parse(
                                      //                         requestedBook.id),
                                      //                     bookName:
                                      //                         requestedBook
                                      //                             .bookName,
                                      //                     unitPrice:
                                      //                         requestedBook
                                      //                             .price
                                      //                             .toString(),
                                      //                   ),
                                      //                   negotiatedPrice:
                                      //                       _newRequestPrice,
                                      //                   quantity: requestedItem
                                      //                       .quantity,
                                      //                   totalPrice: 0,
                                      //                 );
                                      //                 if (await carts
                                      //                     .addItemToTemporaryCart(
                                      //                         tempCart,
                                      //                         edittedItem)) {
                                      //                   return showModalBottomSheet(
                                      //                     barrierColor: ColorManager
                                      //                         .blackWithLowOpacity,
                                      //                     isScrollControlled:
                                      //                         true,
                                      //                     shape:
                                      //                         RoundedRectangleBorder(
                                      //                       borderRadius:
                                      //                           BorderRadius
                                      //                               .only(
                                      //                         topLeft: Radius
                                      //                             .circular(
                                      //                                 AppRadius
                                      //                                     .r20),
                                      //                         topRight: Radius
                                      //                             .circular(
                                      //                           AppRadius.r20,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                     context: context,
                                      //                     builder: (context) {
                                      //                       return Container(
                                      //                         height: MediaQuery.of(
                                      //                                     context)
                                      //                                 .size
                                      //                                 .height *
                                      //                             0.9,
                                      //                         padding: EdgeInsets
                                      //                             .symmetric(
                                      //                           horizontal:
                                      //                               AppPadding
                                      //                                   .p20,
                                      //                         ),
                                      //                         child: BillingInfo(
                                      //                             cartId:
                                      //                                 tempCart
                                      //                                     .id),
                                      //                       );
                                      //                     },
                                      //                   );
                                      //                 }
                                      //               } else {
                                      //                 // print('here');
                                      //                 _showToastNotification(
                                      //                     'Something went wrong');
                                      //               }
                                      //             },
                                      //             child: Text(
                                      //                 'Order this book now'),
                                      //           )
                                      //         : Container();
                                      //   },
                                      // ),

                                      // --------------------------Change Request Price ends here-----------------------
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pushNamed(
                                                OrderRequestForUserDetailsScreen
                                                    .routeName,
                                                arguments: {
                                                  'requestItem': requestedItem,
                                                  'requestedProduct':
                                                      requestedBook
                                                },
                                              ),
                                          child: Text('Show request details'))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.data is CartError) {
                Center(
                    child: Container(
                  child: Text((snapshot.data as CartError).message.toString()),
                ));
              }
              return Container();
            }
          }
        });
  }
}