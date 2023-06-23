import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';

import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/session.dart';
import '../../view_models/providers/cart_provider.dart';
import '../../view_models/providers/order_request_provider.dart';
import '../../view_models/providers/order_provider.dart';
import '../managers/font_manager.dart';
import '../managers/routes_manager.dart';
import '../managers/style_manager.dart';

class OrderRequestForSellerDetailsScreen extends StatefulWidget {
  // static const routeName = 'order-request-for-user-details-screen';
  const OrderRequestForSellerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderRequestForSellerDetailsScreen> createState() =>
      _OrderRequestForSellerDetailsScreenState();
}

class _OrderRequestForSellerDetailsScreenState
    extends State<OrderRequestForSellerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderRequestProvider>(context, listen: false)
        .bindOrderRequestForSellerDetailsScreenViewModel(context);
  }

  @override
  void dispose() {
    Provider.of<OrderRequestProvider>(context, listen: false)
        .unbindOrderRequestForSellerDetailsScreenViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();
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
                      //         _orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.id.toString()
                      //     ? 'You have received an offer from ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.lastName} for the following item:'
                      //     : 'You have sent an offer to ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.lastName} for the following item:',
                      'You have received an offer from ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.lastName} for the following item:',
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
                          _orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                              .bookName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestedProduct.price}',
                          // '\$25.00',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                          .description,
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
                    if (_orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelRequestItem
                                .priceChangedBySeller !=
                            null &&
                        _orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelRequestItem
                                .priceChangedBySeller ==
                            false)
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
                            'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice.toString()}',
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
                          '${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName}\'s offer Price',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice.toString()}',
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
                    if (_orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelRequestItem
                                .priceChangedBySeller !=
                            null &&
                        _orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelRequestItem
                                .priceChangedBySeller ==
                            true)
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
                            'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice.toString()}',
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
                          _orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                              .quantity
                              .toString(),
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
              if (_orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                          .priceChangedBySeller !=
                      null &&
                  _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                          .priceChangedBySeller ==
                      true)
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
                        'We will let you know when ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} responds to the request',
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
                            'By accepting this offer, you agree to sell the following item to ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.lastName} for the price of Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice} each :',
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
                                        if (await Provider.of<
                                                    OrderRequestProvider>(
                                                context,
                                                listen: false)
                                            .deleteOrderRequest(
                                                _orderRequestProvider
                                                    .sessionProvider
                                                    .session as Session,
                                                _orderRequestProvider
                                                    .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                    .id)) {
                                          AlertHelper.showToastAlert(
                                              'Request deleted successfully');
                                          // Navigator.pop(context);
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  RoutesManager
                                                      .homeScreenNewRoute);
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
                                  CartProvider carts =
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
                                    AlertHelper.showToastAlert(
                                        'Something went wrong');
                                  }
                                  if (tempCart is Cart) {
                                    CartItem edittedItem = new CartItem(
                                      id: 0,
                                      product: new Product(
                                        id: int.parse(_orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                                            .id),
                                        bookName: _orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                                            .bookName,
                                        unitPrice: _orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                                            .price
                                            .toString(),
                                      ),
                                      negotiatedPrice: double.parse(
                                          _orderRequestProvider
                                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                                              .requestedPrice),
                                      quantity: _orderRequestProvider
                                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                                          .quantity,
                                      totalPrice: 0,
                                    );
                                    if (await carts.addItemToTemporaryCart(
                                        tempCart, edittedItem)) {
                                      if (await Provider.of<
                                                  OrderProvider>(
                                              context,
                                              listen: false)
                                          .placeOrderForRequestingCustomer(
                                              loggedInSession:
                                                  _orderRequestProvider
                                                      .sessionProvider
                                                      .session as Session,
                                              userId: _orderRequestProvider
                                                  .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                  .requestingCustomer
                                                  .id
                                                  .toString(),
                                              cartId: tempCart.id,
                                              billingInfo: _orderRequestProvider
                                                  .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                  .billingInfo,
                                              paymentMethod: 'C')) {
                                        // Delete the order request when the order has been palced
                                        if (await Provider.of<
                                                    OrderRequestProvider>(
                                                context,
                                                listen: false)
                                            .deleteOrderRequest(
                                                _orderRequestProvider
                                                    .sessionProvider
                                                    .session as Session,
                                                _orderRequestProvider
                                                    .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                    .id)) {
                                          AlertHelper.showToastAlert(
                                              'Request accepted successfully');

                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  RoutesManager
                                                      .homeScreenNewRoute);
                                        }
                                      }
                                    }
                                  } else {
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
                              _orderRequestProvider
                                      .orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice =
                                  double.parse(value);
                              _orderRequestProvider
                                  .orderRequestForSellerDetailsScreenViewModelShouldShowRequestButton(
                                      double.parse(_orderRequestProvider
                                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                                          .requestedPrice));
                            },
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
                          valueListenable: ValueNotifier(_orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelShowRequestButton),
                          builder: (BuildContext context,
                              bool showRequestButton, Widget? child) {
                            return showRequestButton
                                ? ElevatedButton(
                                    onPressed: () => _orderRequestProvider
                                        .orderRequestForSellerDetailsScreenViewModelUpdateSellerOfferPrice(
                                            context,
                                            _orderRequestProvider
                                                .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                .id),
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
