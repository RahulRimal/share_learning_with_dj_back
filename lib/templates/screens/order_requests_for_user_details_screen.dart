import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/providers/users.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import '../../models/book.dart';
import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/order_request.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/carts.dart';
import '../../providers/order_request_provider.dart';
import '../../providers/orders.dart';
import '../managers/style_manager.dart';
import '../widgets/billing_info.dart';

class OrderRequestForUserDetailsScreen extends StatefulWidget {
  static const routeName = 'order-request-for-user-details-screen';
  const OrderRequestForUserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderRequestForUserDetailsScreen> createState() =>
      _OrderRequestForUserDetailsScreenState();
}

class _OrderRequestForUserDetailsScreenState
    extends State<OrderRequestForUserDetailsScreen> {
  ValueNotifier<bool> _showRequestButton = ValueNotifier(false);
  ValueNotifier<bool> _showOrderButton = ValueNotifier(false);

  double _newSellerOfferPrice = 0;

  _shouldShowRequestButton(double requestPrice) {
    if (_newSellerOfferPrice != requestPrice) {
      _showRequestButton.value = true;
      return;
    }
    _showRequestButton.value = false;
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

  Future<bool> _updateSellerOfferPrice(
      Session authSession, String requestId) async {
    await Provider.of<OrderRequests>(context, listen: false)
        .updateSellerOfferPrice(requestId, _newSellerOfferPrice)
        .then(
      (value) {
        if (value) {
          BotToast.showSimpleNotification(
            title: 'Request price changed',
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
          _showRequestButton.value = false;
          Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    OrderRequest requestItem = args['requestItem'];
    Book requestedProduct = args['requestedProduct'];
    User currentUser = Provider.of<Users>(context).user as User;
    Session authSession =
        Provider.of<SessionProvider>(context).session as Session;
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
                      // currentUser.id ==
                      //         requestItem.requestedCustomer.id.toString()
                      //     ? 'You have received an offer from ${requestItem.requestingCustomer.firstName} ${requestItem.requestingCustomer.lastName} for the following item:'
                      //     : 'You have sent an offer to ${requestItem.requestedCustomer.firstName} ${requestItem.requestedCustomer.lastName} for the following item:',
                      'You have received an offer from ${requestItem.requestingCustomer.firstName} ${requestItem.requestingCustomer.lastName} for the following item:',
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
                    // ----------------------- Show this row when selling user has send the offer price start here -----------------------------
                    // if price has been changed by the seller is false then buyer was the one to recently offer the price because the priceChangedBySeller is also not null which mean seller had offered some price before so show this before buyer's offer price
                    if (requestItem.priceChangedBySeller != null &&
                        requestItem.priceChangedBySeller == false)
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
                            'Rs. ${requestItem.sellerOfferPrice.toString()}',
                            // '\$20.00',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    // ----------------------- Show this row when selling user has send the offer price ends here -----------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${requestItem.requestingCustomer.firstName}\'s offer Price',
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
                    SizedBox(height: 8.0),
                    // ----------------------- Show this row when selling user has send the offer price start here -----------------------------
                    // if price has been changed by the seller is true then seller was the one to recently offer the price so show this after buyer's offer price
                    if (requestItem.priceChangedBySeller != null &&
                        requestItem.priceChangedBySeller == true)
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
              SizedBox(height: AppHeight.h20),
              if (requestItem.priceChangedBySeller != null &&
                  requestItem.priceChangedBySeller == true)
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
                        'We will let you know when ${requestItem.requestingCustomer.firstName} responds to the request',
                        style: TextStyle(
                          // color: Colors.grey[600],
                          color: ColorManager.yellow,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    SizedBox(height: 24.0),
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Product Name',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     Text(
                          //       '\$25.00',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 8.0),
                          // Text(
                          //   'Description of product goes here. It can be multiple lines long and should be informative enough for the buyer to make a decision.',
                          //   style: TextStyle(
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                          // SizedBox(height: 16.0),
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
                          //       '\$20.00',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 8.0),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Quantity',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     Text(
                          //       '1',
                          //       style: TextStyle(
                          //         color: Colors.grey[600],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 16.0),
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
                                onPressed: () {},
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
                                  // setState(() {
                                  //   _isLoading = true;
                                  // });
                                  var tempCart =
                                      await carts.createTemporaryCart(
                                          Provider.of<SessionProvider>(context,
                                                  listen: false)
                                              .session as Session);
                                  if (tempCart is CartError) {
                                    _showToastNotification(
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
                                      negotiatedPrice: double.parse(
                                          requestItem.requestedPrice),
                                      quantity: requestItem.quantity,
                                      totalPrice: 0,
                                    );
                                    if (await carts.addItemToTemporaryCart(
                                        tempCart, edittedItem)) {
                                      if (await Provider.of<Orders>(context,
                                              listen: false)
                                          .placeOrderForRequestingCustomer(
                                              loggedInSession: authSession,
                                              userId: requestItem
                                                  .requestingCustomer.id
                                                  .toString(),
                                              cartId: tempCart.id,
                                              billingInfo:
                                                  requestItem.billingInfo,
                                              paymentMethod: 'C')) {
                                        // Delete the order request when the order has been palced
                                        if (await Provider.of<OrderRequests>(
                                                context,
                                                listen: false)
                                            .deleteOrderRequest(
                                                authSession, requestItem.id)) {
                                          _showToastNotification(
                                              'Request accepted successfully');
                                          Navigator.pop(context);
                                        }
                                      }
                                    }
                                  } else {
                                    // print('here');
                                    _showToastNotification(
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
                        // --------------------------Seller response to change Request Price starts here-----------------------

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
                              _newSellerOfferPrice = double.parse(value);
                              _shouldShowRequestButton(
                                  double.parse(requestItem.requestedPrice));
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
                                    onPressed: () => _updateSellerOfferPrice(
                                        authSession, requestItem.id),
                                    // child: Text('Update Request Price'),
                                    child: Text('Request for this price'),
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
