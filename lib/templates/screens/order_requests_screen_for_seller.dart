import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order_request.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/order_request_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import 'package:share_learning/templates/utils/alert_helper.dart';

import '../../models/book.dart';
import '../../models/cart.dart';

import '../managers/routes_manager.dart';
import '../widgets/custom_bottom_navbar.dart';

class OrderRequestsScreenForSeller extends StatefulWidget {
  const OrderRequestsScreenForSeller({Key? key}) : super(key: key);
  // static final routeName = '/order-requests-for-user-list';

  @override
  State<OrderRequestsScreenForSeller> createState() =>
      _OrderRequestsScreenForSellerState();
}

class _OrderRequestsScreenForSellerState
    extends State<OrderRequestsScreenForSeller> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<OrderRequestProvider>(context, listen: false)
        .bindOrderRequestsScreenForSellerViewModle(context);
  }

  @override
  void dispose() {
    Provider.of<OrderRequestProvider>(context, listen: false)
        .unBindOrderRequestsScreenForSellerViewModle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();

    return Scaffold(
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
                    controller: _orderRequestProvider
                        .orderRequestScreenSearchController,
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
              FutureBuilder(
                future: _orderRequestProvider.getRequestsForUser(
                    _orderRequestProvider.sessionProvider.session as Session),
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
                                    orderRequests: _orderRequestProvider,
                                    authendicatedSession: _orderRequestProvider
                                        .sessionProvider.session as Session),
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

  final OrderRequestProvider orderRequests;
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
      itemCount:
          context.watch<OrderRequestProvider>().orderRequestsForUser.length,
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
  _deleteRequestItem(Session userSession, String orderRequestId) async {
    bool value = await Provider.of<OrderRequestProvider>(context, listen: false)
        .deleteOrderRequest(userSession, orderRequestId);
    if (value) {
      AlertHelper.showToastAlert(
        'Request deleted successfully',
      );
    } else
      AlertHelper.showToastAlert('Something went wrong, Please try again!');
  }

  @override
  Widget build(BuildContext context) {
    OrderRequest requestedItem = widget.requestedItem;
    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();

    ThemeData _theme = Theme.of(context);

    return FutureBuilder(
        // future: _carts.getCartItemBook(
        //     authendicatedSession, widget.requestedItem.product.id.toString()),
        future: _orderRequestProvider.getRequestedItemBook(
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
                    // color: ColorManager.whit,
                    color: _theme.colorScheme.secondary,
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
                                          // style: TextStyle(
                                          //   color: Colors.indigo,
                                          //   fontSize: 12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style:
                                              _theme.textTheme.headlineMedium,
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
                                                    // style: getRegularStyle(
                                                    //   fontSize: FontSize.s16,
                                                    //   color: ColorManager.black,
                                                    // ),
                                                    style: _theme
                                                        .textTheme.bodyMedium,
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
                                                  _deleteRequestItem(
                                                    authendicatedSession,
                                                    requestedItem.id,
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
                                                // style: TextStyle(
                                                //   color: ColorManager.black,
                                                //   fontSize: FontSize.s12,
                                                //   fontFamily: 'Poppins',
                                                //   fontWeight: FontWeight.w700,
                                                //   letterSpacing: 0.50,
                                                // ),
                                                style:
                                                    _theme.textTheme.bodySmall,
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
                                                // style: TextStyle(
                                                //   color: Colors.lightBlue,
                                                //   fontSize: FontSize.s14,
                                                //   fontFamily: 'Poppins',
                                                //   fontWeight: FontWeight.w700,
                                                //   letterSpacing: 0.50,
                                                // ),
                                                style: _theme
                                                    .textTheme.headlineSmall,
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
                                              child: (widget.requestedItem
                                                          .product.postType ==
                                                      'B')
                                                  ? Text(
                                                      "Offered unit price",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      // style: TextStyle(
                                                      //   color: ColorManager.black,
                                                      //   fontSize: FontSize.s12,
                                                      //   fontFamily: 'Poppins',
                                                      //   fontWeight: FontWeight.w700,
                                                      //   letterSpacing: 0.50,
                                                      // ),
                                                      style: _theme
                                                          .textTheme.bodySmall,
                                                    )
                                                  : Text(
                                                      "Requested unit price",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: _theme
                                                          .textTheme.bodySmall,
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: (widget.requestedItem
                                                          .product.postType ==
                                                      'B')
                                                  ? Text(
                                                      "Rs. ${widget.requestedItem.sellerOfferPrice}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      // style: TextStyle(
                                                      //   color: Colors.lightBlue,
                                                      //   fontSize: FontSize.s14,
                                                      //   fontFamily: 'Poppins',
                                                      //   fontWeight: FontWeight.w700,
                                                      //   letterSpacing: 0.50,
                                                      // ),
                                                      style: _theme.textTheme
                                                          .headlineSmall,
                                                    )
                                                  : Text(
                                                      "Rs. ${widget.requestedItem.requestedPrice}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: _theme.textTheme
                                                          .headlineSmall,
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
                                          onPressed: () {
                                            _orderRequestProvider
                                                    .orderRequestForSellerDetailsScreenViewModelRequestItem =
                                                requestedItem;
                                            _orderRequestProvider
                                                    .orderRequestForSellerDetailsScreenViewModelRequestedProduct =
                                                requestedBook;
                                            Navigator.of(context).pushNamed(
                                              RoutesManager
                                                  .orderRequestForSellerDetailsScreenRoute,

                                              // arguments: {
                                              //   'requestItem': requestedItem,
                                              //   'requestedProduct':
                                              //       requestedBook
                                              // },
                                            );
                                          },
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
