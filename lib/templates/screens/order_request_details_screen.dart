import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';

import '../../models/book.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/order_request.dart';
import '../../models/session.dart';
import '../../providers/carts.dart';
import '../../providers/order_request_provider.dart';
import '../../providers/sessions.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../widgets/billing_info.dart';
import 'home_screen_new.dart';

class OrderRequestDetailsScreen extends StatefulWidget {
  static const routeName = 'order-request-details-screen';
  const OrderRequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderRequestDetailsScreen> createState() =>
      _OrderRequestDetailsScreenState();
}

class _OrderRequestDetailsScreenState extends State<OrderRequestDetailsScreen> {
  ValueNotifier<bool> _showRequestButton = ValueNotifier(false);
  ValueNotifier<bool> _showOrderButton = ValueNotifier(false);
  double _newRequestPrice = 0;

  _shouldShowRequestButton(double requestPrice) {
    if (_newRequestPrice != requestPrice) {
      _showOrderButton.value = false;
      _showRequestButton.value = true;
      return;
    }
    _showRequestButton.value = false;
  }

  _shouldShowOrderButton(OrderRequest requestItem) {
    if (_newRequestPrice == double.parse(requestItem.product.unitPrice)) {
      _showRequestButton.value = false;
      _showOrderButton.value = true;
      return;
    }
    _showOrderButton.value = false;
  }

  Future<bool> _updateRequestPrice(String requestId) async {
    await Provider.of<OrderRequests>(context, listen: false)
        .updateRequestPrice(requestId, _newRequestPrice)
        .then(
      (value) {
        if (value) {
          AlertHelper.showToastAlert('Request price changed');

          _showRequestButton.value = false;
          Navigator.of(context).pop();
        } else
          AlertHelper.showToastAlert("Something went wrong, Please try again!");
      },
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    OrderRequest requestItem = args['requestItem'];
    Book requestedProduct = args['requestedProduct'];
    Session authSession =
        Provider.of<SessionProvider>(context).session as Session;
    // User currentUser = Provider.of<Users>(context).user as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Request'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   currentUser.id == requestItem.requestedCustomer ?
              //   'Request for you':'Your request',
              //   style: TextStyle(
              //     fontSize: 20.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 16.0),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8.0),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.3),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   padding: EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             // 'Product Name',
              //             requestedProduct.bookName,
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             // '\$25.00',
              //             requestedProduct.price.toString(),
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 8.0),
              //       Text(
              //         requestedProduct.description,
              //         maxLines: 3,
              //         overflow: TextOverflow.ellipsis,
              //         // 'Description of product goes here. It can be multiple lines long and should be informative enough for the buyer to make a decision.',
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 24.0),
              // Text(
              //   'Shipping Information',
              //   style: TextStyle(
              //     fontSize: 20.0,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 16.0),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8.0),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.3),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   padding: EdgeInsets.all(16.0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'John Doe',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       SizedBox(height: 8.0),
              //       Text(
              //         '123 Main St',
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //         ),
              //       ),
              //       SizedBox(height: 8.0),
              //       Text(
              //         'Anytown, USA 12345',
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //         ),
              //       ),
              //       SizedBox(height: 8.0),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Shipping Method',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             'Standard',
              //             style: TextStyle(
              //               color: Colors.grey[600],
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(height: 24.0),
              Text(
                'Offer Details',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have sent an offer to ${requestItem.requestedCustomer.firstName} ${requestItem.requestedCustomer.lastName} for the following item:',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // 'Product Name',
                          requestedProduct.bookName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${requestedProduct.price}',
                          // '\$25.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      requestedProduct.description,
                      // 'Description of product goes here. It can be multiple lines long and should be informative enough for the buyer to make a decision.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Offer Price',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Rs. ${requestItem.requestedPrice.toString()}',
                    //       // '\$20.00',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // ----------------------- Show this row when selling user has send the offer price start here -----------------------------
                    // if price has been changed by the seller is false then buyer was the one to recently offer the price because the priceChangedBySeller is also not null which mean seller had offered some price before so show this before buyer's offer price
                    if (requestItem.priceChangedBySeller != null &&
                        requestItem.priceChangedBySeller == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${requestItem.requestedCustomer.firstName}\'s offer Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs. ${requestItem.sellerOfferPrice.toString()}',
                            // '\$20.00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your offer Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${requestItem.requestedPrice.toString()}',
                          // '\$20.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // ----------------------- Show this row when selling user has send the offer price ends here -----------------------------

                    SizedBox(height: 8.0),
                    // ----------------------- Show this row when selling user has send the offer price start here -----------------------------
                    // if price has been changed by the seller is true then seller was the one to recently offer the price so show this after buyer's offer price
                    if (requestItem.priceChangedBySeller != null &&
                        requestItem.priceChangedBySeller == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${requestItem.requestedCustomer.firstName}\'s offer Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rs. ${requestItem.sellerOfferPrice.toString()}',
                            // '\$20.00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    // ----------------------- Show this row when selling user has send the offer price ends here -----------------------------
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // '1',
                          requestItem.quantity.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       'Shipping Method',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //     Text(
                    //       'Standard',
                    //       style: TextStyle(
                    //         color: Colors.grey[600],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 24.0),

              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8.0),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.3),
              //         spreadRadius: 2,
              //         blurRadius: 5,
              //         offset: Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   padding: EdgeInsets.all(16.0),
              //   child: Column(
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Request status',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Text(
              //             'Pending',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(
              //         height: AppHeight.h8,
              //       ),
              //       Text(
              //         'We will let you know when ${requestItem.requestedCustomer.firstName} responds to the request',
              //         style: TextStyle(
              //           // color: Colors.grey[600],
              //           color: ColorManager.yellow,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              if (requestItem.priceChangedBySeller == null ||
                  (requestItem.priceChangedBySeller != null &&
                      requestItem.priceChangedBySeller == false))
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Request status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pending',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppHeight.h8,
                      ),
                      Text(
                        'We will let you know when ${requestItem.requestedCustomer.firstName} responds to the request',
                        style: TextStyle(
                          // color: Colors.grey[600],
                          color: ColorManager.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
              if (requestItem.priceChangedBySeller != null &&
                  requestItem.priceChangedBySeller == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 24.0),
                    // Accept offer for seller when he gets the request from the starts here
                    Text(
                      'Accept Offer',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By accepting this offer, you agree to sell the following item to ${requestItem.requestingCustomer.firstName} ${requestItem.requestingCustomer.lastName} for the price of Rs. ${requestItem.requestedPrice} each :',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(height: 16.0),
                          Text(
                            'Please review the terms of the sale carefully before accepting. Once you accept, the sale is final and binding.',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  bool userConfirmed = false;
                                  showGeneralDialog(
                                    barrierDismissible: true,
                                    barrierLabel:
                                        'Delete cart item dilaog dismissed',
                                    context: context,
                                    pageBuilder: (ctx, a1, a2) {
                                      return Container();
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    transitionBuilder: (ctx, a1, a2, child) {
                                      var curve =
                                          Curves.easeInOut.transform(a1.value);
                                      return Transform.scale(
                                        scale: curve,
                                        child: AlertDialog(
                                          title: Text('Are you sure?'),
                                          content: Text(
                                            'This request will be deleted permanently!',
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
                                                  fontSize: FontSize.s16,
                                                  color: ColorManager.primary,
                                                ),
                                              ),
                                              onPressed: () {
                                                userConfirmed = true;
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'No',
                                                style: getBoldStyle(
                                                  fontSize: FontSize.s16,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).then(
                                    (_) async {
                                      if (userConfirmed) {
                                        if (await Provider.of<OrderRequests>(
                                                context,
                                                listen: false)
                                            .deleteOrderRequest(
                                                authSession, requestItem.id)) {
                                          AlertHelper.showToastAlert(
                                              'Request deleted successfully');

                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  HomeScreenNew.routeName);
                                        }
                                      }
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Carts carts =
                                      Provider.of(context, listen: false);

                                  var tempCart =
                                      await carts.createTemporaryCart(
                                          Provider.of<SessionProvider>(context,
                                                  listen: false)
                                              .session as Session);
                                  if (tempCart is CartError) {
                                    AlertHelper.showToastAlert(
                                        'Something went wrong');
                                  }
                                  if (tempCart is Cart) {
                                    CartItem edittedItem = new CartItem(
                                      id: 0,
                                      product: new Product(
                                        id: int.parse(requestedProduct.id),
                                        bookName: requestedProduct.bookName,
                                        unitPrice:
                                            requestedProduct.price.toString(),
                                      ),
                                      negotiatedPrice: double.parse(requestItem
                                          .sellerOfferPrice as String),
                                      quantity: requestItem.quantity,
                                      totalPrice: 0,
                                    );
                                    if (await carts.addItemToTemporaryCart(
                                        tempCart, edittedItem)) {
                                      // Delete the order request when the order has been palced
                                      Provider.of<OrderRequests>(context,
                                              listen: false)
                                          .deleteOrderRequest(
                                              authSession, requestItem.id);
                                      return showModalBottomSheet(
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
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.9,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: AppPadding.p20,
                                            ),
                                            child: BillingInfo(
                                                cartId: tempCart.id),
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    // print('here');
                                    AlertHelper.showToastAlert(
                                        'Something went wrong');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(
                                  'Accept Offer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.0),
                    Text(
                      'Send your offer',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppHeight.h8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                        // --------------------------Buyer response to change offer Price starts here-----------------------

                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p8,
                          ),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              labelText: 'Change requst price',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            onChanged: (value) {
                              _newRequestPrice = double.parse(value);
                              _shouldShowRequestButton(
                                  double.parse(requestItem.requestedPrice));
                              _shouldShowOrderButton(requestItem);
                            },
                            // onFieldSubmitted: (_) {
                            //   FocusScope.of(context).requestFocus(_authorFocusNode);
                            // },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide valid price';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        ),

                        ValueListenableBuilder(
                          valueListenable: _showRequestButton,
                          builder: (BuildContext context,
                              bool showRequestButton, Widget? child) {
                            return showRequestButton
                                ? ElevatedButton(
                                    onPressed: () =>
                                        _updateRequestPrice(requestItem.id),
                                    // child: Text('Update Request Price'),
                                    child: Text('Request for this price'),
                                  )
                                : Container();
                          },
                        ),

                        ValueListenableBuilder(
                          valueListenable: _showOrderButton,
                          builder: (BuildContext context, bool showOrderButton,
                              Widget? child) {
                            return showOrderButton
                                ? ElevatedButton(
                                    onPressed: () async {
                                      Carts carts =
                                          Provider.of(context, listen: false);
                                      // setState(() {
                                      //   _isLoading = true;
                                      // });
                                      var tempCart =
                                          await carts.createTemporaryCart(
                                              Provider.of<SessionProvider>(
                                                      context,
                                                      listen: false)
                                                  .session as Session);
                                      if (tempCart is CartError) {
                                        AlertHelper.showToastAlert(
                                            'Something went wrong');
                                      }
                                      if (tempCart is Cart) {
                                        CartItem edittedItem = new CartItem(
                                          id: 0,
                                          product: new Product(
                                            id: int.parse(requestedProduct.id),
                                            bookName: requestedProduct.bookName,
                                            unitPrice: requestedProduct.price
                                                .toString(),
                                          ),
                                          negotiatedPrice: _newRequestPrice,
                                          quantity: requestItem.quantity,
                                          totalPrice: 0,
                                        );
                                        if (await carts.addItemToTemporaryCart(
                                            tempCart, edittedItem)) {
                                          // Delete the order request when the order has been palced
                                          Provider.of<OrderRequests>(context,
                                                  listen: false)
                                              .deleteOrderRequest(
                                                  authSession, requestItem.id);
                                          return showModalBottomSheet(
                                            barrierColor: ColorManager
                                                .blackWithLowOpacity,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    AppRadius.r20),
                                                topRight: Radius.circular(
                                                  AppRadius.r20,
                                                ),
                                              ),
                                            ),
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: AppPadding.p20,
                                                ),
                                                child: BillingInfo(
                                                    cartId: tempCart.id),
                                              );
                                            },
                                          );
                                        }
                                      } else {
                                        // print('here');
                                        AlertHelper.showToastAlert(
                                            'Something went wrong');
                                      }
                                    },
                                    child: Text('Order this book now'),
                                  )
                                : Container();
                          },
                        ),

                        // --------------------------Seller response to change Request Price ends here-----------------------
                      ]),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
