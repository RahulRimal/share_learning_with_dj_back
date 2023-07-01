import 'dart:convert';

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
import '../utils/loading_helper.dart';

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
        child: _orderRequestProvider
                    .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                    .postType ==
                'S'
            ? SellingPostView()
            : BuyingPostView(),
      ),
    );
  }
}

class SellingPostView extends StatefulWidget {
  const SellingPostView({Key? key}) : super(key: key);

  @override
  State<SellingPostView> createState() => _SellingPostViewState();
}

class _SellingPostViewState extends State<SellingPostView> {
  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();
    ThemeData _theme = Theme.of(context);
    return Container(
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
              // color: Colors.white,
              color: _theme.colorScheme.secondary,
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
                  'You have received an offer from ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.lastName} for the following item:',
                  style: _theme.textTheme.titleSmall,
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                          .bookName,
                      style: _theme.textTheme.headlineMedium,
                    ),
                    Text(
                      'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestedProduct.price}',
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

                  style: _theme.textTheme.bodySmall,
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
                      style: _theme.textTheme.titleMedium,
                    ),
                    if (_orderRequestProvider
                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                            .requestedPrice ==
                        _orderRequestProvider
                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                            .product
                            .unitPrice)
                      Text(
                        'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice.toString()}',
                        style: _theme.textTheme.bodyMedium,
                      )
                    else
                      Text(
                        'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice.toString()}',
                        style: _theme.textTheme.bodyMedium,
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
                      if (_orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                              .requestedPrice ==
                          _orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                              .product
                              .unitPrice)
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice.toString()}',
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
                      style: _theme.textTheme.titleMedium,
                    ),
                    Text(
                      _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                          .quantity
                          .toString(),
                      style: _theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
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
                color: _theme.colorScheme.secondary,
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
                        style: _theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Pending',
                        style: _theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppHeight.h8,
                  ),
                  Text(
                    'We will let you know when ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} responds to the request',
                    style: TextStyle(
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
                    color: _theme.colorScheme.secondary,
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
                        style: _theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(height: 16.0),
                      Text(
                        'Please review the terms of the sale carefully before accepting. Once you accept, the sale is final and binding.',
                        style: _theme.textTheme.bodyMedium,
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
                                    if (await Provider.of<OrderRequestProvider>(
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

                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              RoutesManager.homeScreenNewRoute);
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

                              var tempCart = await carts.createTemporaryCart(
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
                                  if (await Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .placeOrderForRequestingCustomer(
                                          loggedInSession: _orderRequestProvider
                                              .sessionProvider
                                              .session as Session,
                                          customerId: _orderRequestProvider
                                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                                              .requestingCustomer
                                              .id
                                              .toString(),
                                          cartId: tempCart.id,
                                          billingInfo: _orderRequestProvider
                                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                                              .billingInfo as Map<String, dynamic>,
                                          paymentMethod: 'C')) {
                                    // Delete the order request when the order has been palced
                                    if (await Provider.of<OrderRequestProvider>(
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
                                              RoutesManager.homeScreenNewRoute);
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
                    color: _theme.colorScheme.secondary,
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
                          labelText: 'Change offer price',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice = 0;
                          } else {
                            _orderRequestProvider
                                    .orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice =
                                double.parse(value);
                          }
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

                    Consumer<OrderRequestProvider>(
                      builder: (context, orderRequestProvider, child) {
                        return orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelShowRequestButton
                            ? ElevatedButton(
                                onPressed: () => _orderRequestProvider
                                    .orderRequestForSellerDetailsScreenViewModelUpdateSellerOfferPrice(
                                        context,
                                        _orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                                            .id),
                                child: Text('Offer this price'),
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
    );
  }
}

class BuyingPostView extends StatefulWidget {
  const BuyingPostView({Key? key}) : super(key: key);

  @override
  State<BuyingPostView> createState() => _BuyingPostViewState();
}

class _BuyingPostViewState extends State<BuyingPostView> {
  final _form = GlobalKey<FormState>();

  _placeOrderForBuyingPost(OrderRequestProvider _orderRequestProvider) {
    ThemeData _theme = Theme.of(context);
    return showModalBottomSheet(
      barrierColor: ColorManager.blackWithLowOpacity,
      isDismissible: true,
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
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
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
                          style: _theme.textTheme.headlineLarge,
                        ),
                        SizedBox(
                          height: AppHeight.h4,
                        ),
                        Container(
                          decoration: BoxDecoration(),
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
                                                initialValue: _orderRequestProvider
                                                        .billingInfo
                                                        .containsKey(
                                                            'first_name')
                                                    ? _orderRequestProvider
                                                            .billingInfo[
                                                        'first_name']
                                                    : null,
                                                focusNode: _orderRequestProvider
                                                    .orderRequestsScreenForSellerViewModleFirstNameFocusNode,
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
                                                          _orderRequestProvider
                                                              .orderRequestsScreenForSellerViewModleLastNameFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please provide the first name';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _orderRequestProvider
                                                              .billingInfo[
                                                          'first_name'] =
                                                      value.toString();
                                                }),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              initialValue:
                                                  _orderRequestProvider
                                                          .billingInfo
                                                          .containsKey(
                                                              'last_name')
                                                      ? _orderRequestProvider
                                                              .billingInfo[
                                                          'last_name']
                                                      : null,
                                              keyboardType: TextInputType.text,
                                              // cursorColor: Theme.of(context)
                                              //     .primaryColor,
                                              focusNode: _orderRequestProvider
                                                  .orderRequestsScreenForSellerViewModleLastNameFocusNode,
                                              decoration: InputDecoration(
                                                labelText: 'Last Name',
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context).requestFocus(
                                                    _orderRequestProvider
                                                        .orderRequestsScreenForSellerViewModleEmailFocusNode);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please provide the last name';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _orderRequestProvider
                                                            .billingInfo[
                                                        'last_name'] =
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
                                          initialValue: _orderRequestProvider
                                                  .billingInfo
                                                  .containsKey('email')
                                              ? _orderRequestProvider
                                                  .billingInfo['email']
                                              : null,
                                          focusNode: _orderRequestProvider
                                              .orderRequestsScreenForSellerViewModleEmailFocusNode,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _orderRequestProvider
                                                    .orderRequestsScreenForSellerViewModlePhoneNumberFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide email to receive notifications';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _orderRequestProvider
                                                    .billingInfo['email'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          initialValue: _orderRequestProvider
                                                  .billingInfo
                                                  .containsKey('phone')
                                              ? _orderRequestProvider
                                                  .billingInfo['phone']
                                              : null,
                                          focusNode: _orderRequestProvider
                                              .orderRequestsScreenForSellerViewModlePhoneNumberFocusNode,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _orderRequestProvider
                                                    .orderRequestsScreenForSellerViewModleSideNoteFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide the phone number to be contacted';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _orderRequestProvider
                                                    .billingInfo['phone'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        focusNode: _orderRequestProvider
                                            .orderRequestsScreenForSellerViewModleSideNoteFocusNode,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          labelText: 'Side Note',
                                        ),
                                        textInputAction:
                                            TextInputAction.newline,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        minLines: 3,
                                        maxLines: 7,
                                        onSaved: (value) {
                                          _orderRequestProvider
                                                  .billingInfo['side_note'] =
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
                          style: _theme.textTheme.headlineLarge,
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
                                value: _orderRequestProvider
                                    .billingInfo['convenient_location'],
                                items: _orderRequestProvider.locationOptions
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
                                  _orderRequestProvider
                                      .setBillingInfoLocationData(
                                          value as String);
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
                          child: Consumer<OrderRequestProvider>(
                            builder: (context, orderRequestProvider, child) =>
                                ElevatedButton.icon(
                              icon: orderRequestProvider
                                      .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                                  ? SizedBox(
                                      height: AppHeight.h20,
                                      width: AppHeight.h20,
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        backgroundColor: ColorManager.primary,
                                      ),
                                    )
                                  : Container(),
                              onPressed: orderRequestProvider
                                      .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                                  ? null
                                  : () async {
                                      orderRequestProvider
                                              .orderRequestsScreenForSellerViewModleIsRequestOnProcess =
                                          true;

                                      // I had to use the same code two times for direct order placement and indirect order placement so i just check the flag and show the notification of either success or failure
                                      // bool _orderPlacedSuccessfully = false;

                                      final _isValid =
                                          _form.currentState!.validate();
                                      if (!_isValid) {
                                        return;
                                      }
                                      _form.currentState!.save();

                                      Map<String, dynamic> requestInfo = {
                                        'product_id': orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                                            .id,
                                        'quantity': orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                                            .quantity,
                                        // If the buyer accepts the request then he is accepting the seller price offer.
                                        'requested_price': orderRequestProvider
                                            .orderRequestForSellerDetailsScreenViewModelRequestItem
                                            .sellerOfferPrice
                                      };

                                      requestInfo["billing_info"] = json.decode(
                                          json.encode(_orderRequestProvider
                                              .billingInfo));

                                      // if (await Provider.of<OrderRequestProvider>(
                                      //         context,
                                      //         listen:
                                      //             false)
                                      //     .createOrderRequest(
                                      //         Provider.of<SessionProvider>(context, listen: false).session
                                      //             as Session,
                                      //         requestInfo))
                                      //          {
                                      //   orderRequestProvider
                                      //           .orderRequestsScreenForSellerViewModleIsRequestOnProcess =
                                      //       false;
                                      //   AlertHelper
                                      //       .showToastAlert(
                                      //           'Request has been sent successfully');
                                      //   Navigator.pop(
                                      //       context);
                                      //   Navigator.pop(
                                      //       context);
                                      // } else {
                                      //   AlertHelper
                                      //       .showToastAlert(
                                      //           'Something went wrong');
                                      // }
                                      // orderRequestProvider
                                      //     .postDetailsScreenSetEnableRequestButton(
                                      //         false);
                                      // orderRequestProvider
                                      //     .postDetailsScreenSetIsRequestOnProcess(
                                      //         false);

                                      CartProvider carts =
                                          Provider.of(context, listen: false);

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
                                          if (await Provider.of<OrderProvider>(
                                                  context,
                                                  listen: false)
                                              .placeOrderForRequestingCustomer(
                                                  loggedInSession:
                                                      _orderRequestProvider
                                                          .sessionProvider
                                                          .session as Session,
                                                  customerId: _orderRequestProvider
                                                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                                                      .requestingCustomer
                                                      .id
                                                      .toString(),
                                                  cartId: tempCart.id,
                                                  billingInfo:
                                                      _orderRequestProvider
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
                              label: orderRequestProvider
                                      .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                                  ? LoadingHelper.showTextLoading(
                                      'Placing order')
                                  : Text(
                                      'Place the order',
                                      style: _theme.textTheme.headlineLarge,
                                    ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppPadding.p12,
                                ),
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

  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();
    ThemeData _theme = Theme.of(context);
    return Container(
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
              // color: Colors.white,
              color: _theme.colorScheme.secondary,
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
                  'You have received an offer from ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.lastName} for the following item:',
                  style: _theme.textTheme.titleSmall,
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                          .bookName,
                      style: _theme.textTheme.headlineMedium,
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

                  style: _theme.textTheme.bodySmall,
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
                        'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice.toString()}',
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
                      '${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.firstName}\'s offer Price',
                      style: _theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice.toString()}',
                      style: _theme.textTheme.bodyMedium,
                    )
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
                      if (_orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                              .requestedPrice ==
                          _orderRequestProvider
                              .orderRequestForSellerDetailsScreenViewModelRequestItem
                              .product
                              .unitPrice)
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.product.unitPrice.toString()}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Text(
                          'Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice.toString()}',
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
                      style: _theme.textTheme.titleMedium,
                    ),
                    Text(
                      _orderRequestProvider
                          .orderRequestForSellerDetailsScreenViewModelRequestItem
                          .quantity
                          .toString(),
                      style: _theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          SizedBox(height: AppHeight.h20),
          // If the seller has accepted the requested price and the buyer has not started the order placement process then show this
          if (_orderRequestProvider
                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                      .priceChangedBySeller ==
                  true &&
              _orderRequestProvider
                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                      .requestedPrice ==
                  _orderRequestProvider
                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                      .sellerOfferPrice)
            Container(
              decoration: BoxDecoration(
                color: _theme.colorScheme.secondary,
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
                        style: _theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Pending',
                        style: _theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppHeight.h8,
                  ),
                  Text(
                    'Seller has accepted your offer price of Rs.${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedPrice} each. Please provide the billing information to proceed to place the order',
                    style: TextStyle(
                      color: ColorManager.yellow,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _placeOrderForBuyingPost(_orderRequestProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Place order now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (_orderRequestProvider
                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                      .priceChangedBySeller !=
                  null &&
              _orderRequestProvider
                      .orderRequestForSellerDetailsScreenViewModelRequestItem
                      .priceChangedBySeller ==
                  true)
            Column(
              children: [
                SizedBox(height: 24.0),
                // Accept offer for buyer when he gets the request from seller the starts here
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
                    color: _theme.colorScheme.secondary,
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
                        'By accepting this offer, you agree to buy the following item from ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.firstName} ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestedCustomer.lastName} for the price of Rs. ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.sellerOfferPrice} each :',
                        style: _theme.textTheme.bodyMedium,
                      ),
                      SizedBox(height: 8.0),
                      SizedBox(height: 16.0),
                      Text(
                        'Please review the terms of the buying carefully before accepting. Once you accept, the sale is final and binding.',
                        style: _theme.textTheme.bodyMedium,
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
                                    if (await Provider.of<OrderRequestProvider>(
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

                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              RoutesManager.homeScreenNewRoute);
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
                              _placeOrderForBuyingPost(_orderRequestProvider);
                              //   showModalBottomSheet(
                              //     barrierColor: ColorManager.blackWithLowOpacity,
                              //     isDismissible: true,
                              //     isScrollControlled: true,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.only(
                              //         topLeft: Radius.circular(AppRadius.r20),
                              //         topRight: Radius.circular(
                              //           AppRadius.r20,
                              //         ),
                              //       ),
                              //     ),
                              //     context: context,
                              //     builder: (context) {
                              //       return SingleChildScrollView(
                              //         child: Padding(
                              //           padding: EdgeInsets.only(
                              //               bottom: MediaQuery.of(context)
                              //                   .viewInsets
                              //                   .bottom),
                              //           child: Container(
                              //             padding: EdgeInsets.only(
                              //               left: AppPadding.p20,
                              //               right: AppPadding.p20,
                              //               bottom: AppPadding.p12,
                              //             ),
                              //             child: Column(
                              //               children: [
                              //                 // ----------------------    Name section starts here -----------------------------------
                              //                 Container(
                              //                   padding: EdgeInsets.symmetric(
                              //                     vertical: AppPadding.p12,
                              //                   ),
                              //                   child: Column(
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment.start,
                              //                     children: [
                              //                       Text(
                              //                         'Billing Information',
                              //                         style: _theme.textTheme
                              //                             .headlineLarge,
                              //                       ),
                              //                       SizedBox(
                              //                         height: AppHeight.h4,
                              //                       ),
                              //                       Container(
                              //                         decoration: BoxDecoration(),
                              //                         child: Column(
                              //                           mainAxisSize:
                              //                               MainAxisSize.min,
                              //                           children: [
                              //                             Form(
                              //                               key: _form,
                              //                               child: ListView(
                              //                                 shrinkWrap: true,
                              //                                 children: [
                              //                                   Row(
                              //                                     children: [
                              //                                       Expanded(
                              //                                         child:
                              //                                             Padding(
                              //                                           padding:
                              //                                               const EdgeInsets.all(
                              //                                                   8.0),
                              //                                           child: TextFormField(
                              //                                               initialValue: _orderRequestProvider.billingInfo.containsKey('first_name') ? _orderRequestProvider.billingInfo['first_name'] : null,
                              //                                               focusNode: _orderRequestProvider.orderRequestsScreenForSellerViewModleFirstNameFocusNode,
                              //                                               decoration: InputDecoration(
                              //                                                 labelText:
                              //                                                     'First Name',
                              //                                                 focusColor:
                              //                                                     Colors.redAccent,
                              //                                               ),
                              //                                               textInputAction: TextInputAction.next,
                              //                                               autovalidateMode: AutovalidateMode.always,
                              //                                               onFieldSubmitted: (_) {
                              //                                                 FocusScope.of(context).requestFocus(_orderRequestProvider.orderRequestsScreenForSellerViewModleLastNameFocusNode);
                              //                                               },
                              //                                               validator: (value) {
                              //                                                 if (value!.isEmpty) {
                              //                                                   return 'Please provide the first name';
                              //                                                 }
                              //                                                 return null;
                              //                                               },
                              //                                               onSaved: (value) {
                              //                                                 _orderRequestProvider.billingInfo['first_name'] =
                              //                                                     value.toString();
                              //                                               }),
                              //                                         ),
                              //                                       ),
                              //                                       Flexible(
                              //                                         child:
                              //                                             Padding(
                              //                                           padding:
                              //                                               const EdgeInsets.all(
                              //                                                   8.0),
                              //                                           child:
                              //                                               TextFormField(
                              //                                             initialValue: _orderRequestProvider.billingInfo.containsKey('last_name')
                              //                                                 ? _orderRequestProvider.billingInfo['last_name']
                              //                                                 : null,
                              //                                             keyboardType:
                              //                                                 TextInputType.text,
                              //                                             // cursorColor: Theme.of(context)
                              //                                             //     .primaryColor,
                              //                                             focusNode:
                              //                                                 _orderRequestProvider.orderRequestsScreenForSellerViewModleLastNameFocusNode,
                              //                                             decoration:
                              //                                                 InputDecoration(
                              //                                               labelText:
                              //                                                   'Last Name',
                              //                                             ),
                              //                                             textInputAction:
                              //                                                 TextInputAction.next,
                              //                                             autovalidateMode:
                              //                                                 AutovalidateMode.always,
                              //                                             onFieldSubmitted:
                              //                                                 (_) {
                              //                                               FocusScope.of(context)
                              //                                                   .requestFocus(_orderRequestProvider.orderRequestsScreenForSellerViewModleEmailFocusNode);
                              //                                             },
                              //                                             validator:
                              //                                                 (value) {
                              //                                               if (value!
                              //                                                   .isEmpty) {
                              //                                                 return 'Please provide the last name';
                              //                                               }
                              //                                               return null;
                              //                                             },
                              //                                             onSaved:
                              //                                                 (value) {
                              //                                               _orderRequestProvider.billingInfo['last_name'] =
                              //                                                   value.toString();
                              //                                             },
                              //                                           ),
                              //                                         ),
                              //                                       ),
                              //                                     ],
                              //                                   ),
                              //                                   Padding(
                              //                                     padding:
                              //                                         const EdgeInsets
                              //                                                 .all(
                              //                                             8.0),
                              //                                     child:
                              //                                         TextFormField(
                              //                                             initialValue: _orderRequestProvider.billingInfo.containsKey('email')
                              //                                                 ? _orderRequestProvider.billingInfo[
                              //                                                     'email']
                              //                                                 : null,
                              //                                             focusNode:
                              //                                                 _orderRequestProvider
                              //                                                     .orderRequestsScreenForSellerViewModleEmailFocusNode,
                              //                                             keyboardType:
                              //                                                 TextInputType
                              //                                                     .text,
                              //                                             decoration:
                              //                                                 InputDecoration(
                              //                                               labelText:
                              //                                                   'Email Address',
                              //                                             ),
                              //                                             textInputAction:
                              //                                                 TextInputAction
                              //                                                     .next,
                              //                                             autovalidateMode:
                              //                                                 AutovalidateMode
                              //                                                     .always,
                              //                                             onFieldSubmitted:
                              //                                                 (_) {
                              //                                               FocusScope.of(context)
                              //                                                   .requestFocus(_orderRequestProvider.orderRequestsScreenForSellerViewModlePhoneNumberFocusNode);
                              //                                             },
                              //                                             validator:
                              //                                                 (value) {
                              //                                               if (value!
                              //                                                   .isEmpty) {
                              //                                                 return 'Please provide email to receive notifications';
                              //                                               }
                              //                                               return null;
                              //                                             },
                              //                                             onSaved:
                              //                                                 (value) {
                              //                                               _orderRequestProvider.billingInfo['email'] =
                              //                                                   value.toString();
                              //                                             }),
                              //                                   ),
                              //                                   Padding(
                              //                                     padding:
                              //                                         const EdgeInsets
                              //                                                 .all(
                              //                                             8.0),
                              //                                     child:
                              //                                         TextFormField(
                              //                                             initialValue: _orderRequestProvider.billingInfo.containsKey('phone')
                              //                                                 ? _orderRequestProvider.billingInfo[
                              //                                                     'phone']
                              //                                                 : null,
                              //                                             focusNode:
                              //                                                 _orderRequestProvider
                              //                                                     .orderRequestsScreenForSellerViewModlePhoneNumberFocusNode,
                              //                                             keyboardType:
                              //                                                 TextInputType
                              //                                                     .number,
                              //                                             decoration:
                              //                                                 InputDecoration(
                              //                                               labelText:
                              //                                                   'Phone Number',
                              //                                             ),
                              //                                             textInputAction:
                              //                                                 TextInputAction
                              //                                                     .next,
                              //                                             autovalidateMode:
                              //                                                 AutovalidateMode
                              //                                                     .always,
                              //                                             onFieldSubmitted:
                              //                                                 (_) {
                              //                                               FocusScope.of(context)
                              //                                                   .requestFocus(_orderRequestProvider.orderRequestsScreenForSellerViewModleSideNoteFocusNode);
                              //                                             },
                              //                                             validator:
                              //                                                 (value) {
                              //                                               if (value!
                              //                                                   .isEmpty) {
                              //                                                 return 'Please provide the phone number to be contacted';
                              //                                               }
                              //                                               return null;
                              //                                             },
                              //                                             onSaved:
                              //                                                 (value) {
                              //                                               _orderRequestProvider.billingInfo['phone'] =
                              //                                                   value.toString();
                              //                                             }),
                              //                                   ),
                              //                                   Padding(
                              //                                     padding:
                              //                                         const EdgeInsets
                              //                                                 .all(
                              //                                             8.0),
                              //                                     child:
                              //                                         TextFormField(
                              //                                       focusNode:
                              //                                           _orderRequestProvider
                              //                                               .orderRequestsScreenForSellerViewModleSideNoteFocusNode,
                              //                                       keyboardType:
                              //                                           TextInputType
                              //                                               .multiline,
                              //                                       decoration:
                              //                                           InputDecoration(
                              //                                         labelText:
                              //                                             'Side Note',
                              //                                       ),
                              //                                       textInputAction:
                              //                                           TextInputAction
                              //                                               .newline,
                              //                                       autovalidateMode:
                              //                                           AutovalidateMode
                              //                                               .always,
                              //                                       minLines: 3,
                              //                                       maxLines: 7,
                              //                                       onSaved:
                              //                                           (value) {
                              //                                         _orderRequestProvider
                              //                                                 .billingInfo['side_note'] =
                              //                                             value
                              //                                                 .toString();
                              //                                       },
                              //                                     ),
                              //                                   ),
                              //                                 ],
                              //                               ),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //                 // ----------------------    Name section ends here -----------------------------------
                              //                 // ----------------------    Sort by locations section ends here -----------------------------------
                              //                 Container(
                              //                   padding: EdgeInsets.symmetric(
                              //                     vertical: AppPadding.p12,
                              //                   ),
                              //                   child: Column(
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment.start,
                              //                     children: [
                              //                       Text(
                              //                         'Location',
                              //                         style: _theme.textTheme
                              //                             .headlineLarge,
                              //                       ),
                              //                       SizedBox(
                              //                         height: AppHeight.h4,
                              //                       ),
                              //                       Container(
                              //                         decoration: BoxDecoration(
                              //                             border: Border.all(
                              //                           color: Colors.grey,
                              //                           width: 1.0,
                              //                           style: BorderStyle.solid,
                              //                         )),
                              //                         child:
                              //                             DropdownButtonHideUnderline(
                              //                           child: DropdownButton(
                              //                               isExpanded: true,
                              //                               value: _orderRequestProvider
                              //                                       .billingInfo[
                              //                                   'convenient_location'],
                              //                               items: _orderRequestProvider
                              //                                   .locationOptions
                              //                                   .map((option) =>
                              //                                       DropdownMenuItem(
                              //                                         child:
                              //                                             Padding(
                              //                                           padding:
                              //                                               const EdgeInsets
                              //                                                   .only(
                              //                                             left: AppPadding
                              //                                                 .p12,
                              //                                           ),
                              //                                           child:
                              //                                               Text(
                              //                                             option,
                              //                                           ),
                              //                                         ),
                              //                                         value:
                              //                                             option,
                              //                                       ))
                              //                                   .toList(),
                              //                               onChanged: (value) {
                              //                                 _orderRequestProvider
                              //                                     .setBillingInfoLocationData(
                              //                                         value
                              //                                             as String);
                              //                               }),
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //                 // ----------------------    Sort by location section ends here -----------------------------------
                              //                 Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Expanded(
                              //                       child: Container(
                              //                         decoration: BoxDecoration(
                              //                           shape: BoxShape.rectangle,
                              //                         ),
                              //                         child: Consumer<
                              //                             OrderRequestProvider>(
                              //                           builder: (context,
                              //                                   orderRequestProvider,
                              //                                   child) =>
                              //                               ElevatedButton.icon(
                              //                             icon: orderRequestProvider
                              //                                     .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                              //                                 ? SizedBox(
                              //                                     height:
                              //                                         AppHeight
                              //                                             .h20,
                              //                                     width: AppHeight
                              //                                         .h20,
                              //                                     child:
                              //                                         CircularProgressIndicator
                              //                                             .adaptive(
                              //                                       strokeWidth:
                              //                                           3,
                              //                                       valueColor: AlwaysStoppedAnimation<
                              //                                               Color>(
                              //                                           Colors
                              //                                               .white),
                              //                                       backgroundColor:
                              //                                           ColorManager
                              //                                               .primary,
                              //                                     ),
                              //                                   )
                              //                                 : Container(),
                              //                             onPressed:
                              //                                 orderRequestProvider
                              //                                         .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                              //                                     ? null
                              //                                     : () async {
                              //                                         orderRequestProvider
                              //                                                 .orderRequestsScreenForSellerViewModleIsRequestOnProcess =
                              //                                             true;
                              //                                         // I had to use the same code two times for direct order placement and indirect order placement so i just check the flag and show the notification of either success or failure
                              //                                         // bool _orderPlacedSuccessfully = false;
                              //                                         final _isValid = _form
                              //                                             .currentState!
                              //                                             .validate();
                              //                                         if (!_isValid) {
                              //                                           return;
                              //                                         }
                              //                                         _form
                              //                                             .currentState!
                              //                                             .save();
                              //                                         Map<String,
                              //                                                 dynamic>
                              //                                             requestInfo =
                              //                                             {
                              //                                           'product_id':
                              //                                               orderRequestProvider
                              //                                                   .orderRequestForSellerDetailsScreenViewModelRequestItem
                              //                                                   .id,
                              //                                           'quantity': orderRequestProvider
                              //                                               .orderRequestForSellerDetailsScreenViewModelRequestItem
                              //                                               .quantity,
                              //                                           // If the buyer accepts the request then he is accepting the seller price offer.
                              //                                           'requested_price': orderRequestProvider
                              //                                               .orderRequestForSellerDetailsScreenViewModelRequestItem
                              //                                               .sellerOfferPrice
                              //                                         };
                              //                                         requestInfo[
                              //                                                 "billing_info"] =
                              //                                             json.decode(
                              //                                                 json.encode(_orderRequestProvider.billingInfo));
                              //                                         // if (await Provider.of<OrderRequestProvider>(
                              //                                         //         context,
                              //                                         //         listen:
                              //                                         //             false)
                              //                                         //     .createOrderRequest(
                              //                                         //         Provider.of<SessionProvider>(context, listen: false).session
                              //                                         //             as Session,
                              //                                         //         requestInfo))
                              //                                         //          {
                              //                                         //   orderRequestProvider
                              //                                         //           .orderRequestsScreenForSellerViewModleIsRequestOnProcess =
                              //                                         //       false;
                              //                                         //   AlertHelper
                              //                                         //       .showToastAlert(
                              //                                         //           'Request has been sent successfully');
                              //                                         //   Navigator.pop(
                              //                                         //       context);
                              //                                         //   Navigator.pop(
                              //                                         //       context);
                              //                                         // } else {
                              //                                         //   AlertHelper
                              //                                         //       .showToastAlert(
                              //                                         //           'Something went wrong');
                              //                                         // }
                              //                                         // orderRequestProvider
                              //                                         //     .postDetailsScreenSetEnableRequestButton(
                              //                                         //         false);
                              //                                         // orderRequestProvider
                              //                                         //     .postDetailsScreenSetIsRequestOnProcess(
                              //                                         //         false);
                              //                                         CartProvider
                              //                                             carts =
                              //                                             Provider.of(
                              //                                                 context,
                              //                                                 listen:
                              //                                                     false);
                              //                                         var tempCart = await carts.createTemporaryCart(Provider.of<SessionProvider>(
                              //                                                 context,
                              //                                                 listen:
                              //                                                     false)
                              //                                             .session as Session);
                              //                                         if (tempCart
                              //                                             is CartError) {
                              //                                           AlertHelper
                              //                                               .showToastAlert(
                              //                                                   'Something went wrong');
                              //                                         }
                              //                                         if (tempCart
                              //                                             is Cart) {
                              //                                           CartItem
                              //                                               edittedItem =
                              //                                               new CartItem(
                              //                                             id: 0,
                              //                                             product:
                              //                                                 new Product(
                              //                                               id: int.parse(_orderRequestProvider
                              //                                                   .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                              //                                                   .id),
                              //                                               bookName: _orderRequestProvider
                              //                                                   .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                              //                                                   .bookName,
                              //                                               unitPrice: _orderRequestProvider
                              //                                                   .orderRequestForSellerDetailsScreenViewModelRequestedProduct
                              //                                                   .price
                              //                                                   .toString(),
                              //                                             ),
                              //                                             negotiatedPrice: double.parse(_orderRequestProvider
                              //                                                 .orderRequestForSellerDetailsScreenViewModelRequestItem
                              //                                                 .requestedPrice),
                              //                                             quantity: _orderRequestProvider
                              //                                                 .orderRequestForSellerDetailsScreenViewModelRequestItem
                              //                                                 .quantity,
                              //                                             totalPrice:
                              //                                                 0,
                              //                                           );
                              //                                           if (await carts.addItemToTemporaryCart(
                              //                                               tempCart,
                              //                                               edittedItem)) {
                              //                                             if (await Provider.of<OrderProvider>(context, listen: false).placeOrderForRequestingCustomer(
                              //                                                 loggedInSession: _orderRequestProvider.sessionProvider.session
                              //                                                     as Session,
                              //                                                 customerId:
                              //                                                     _orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.id.toString(),
                              //                                                 cartId: tempCart.id,
                              //                                                 billingInfo: _orderRequestProvider.billingInfo,
                              //                                                 paymentMethod: 'C')) {
                              //                                               // Delete the order request when the order has been palced
                              //                                               if (await Provider.of<OrderRequestProvider>(context, listen: false).deleteOrderRequest(
                              //                                                   _orderRequestProvider.sessionProvider.session as Session,
                              //                                                   _orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.id)) {
                              //                                                 AlertHelper.showToastAlert('Request accepted successfully');
                              //                                                 Navigator.of(context).pushReplacementNamed(RoutesManager.homeScreenNewRoute);
                              //                                               }
                              //                                             }
                              //                                           }
                              //                                         } else {
                              //                                           AlertHelper
                              //                                               .showToastAlert(
                              //                                                   'Something went wrong');
                              //                                         }
                              //                                       },
                              //                             label: orderRequestProvider
                              //                                     .orderRequestsScreenForSellerViewModleIsRequestOnProcess
                              //                                 ? LoadingHelper
                              //                                     .showTextLoading(
                              //                                         'Placing order')
                              //                                 : Text(
                              //                                     'Place the order',
                              //                                     style: _theme
                              //                                         .textTheme
                              //                                         .headlineLarge,
                              //                                   ),
                              //                             style: ElevatedButton
                              //                                 .styleFrom(
                              //                               padding: EdgeInsets
                              //                                   .symmetric(
                              //                                 vertical:
                              //                                     AppPadding.p12,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //   );
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
                    color: _theme.colorScheme.secondary,
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
                          labelText: 'Change offer price',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice = 0;
                          } else {
                            _orderRequestProvider
                                    .orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice =
                                double.parse(value);
                          }
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

                    Consumer<OrderRequestProvider>(
                      builder: (context, orderRequestProvider, child) {
                        return orderRequestProvider
                                .orderRequestForSellerDetailsScreenViewModelShowRequestButton
                            ? ElevatedButton(
                                // onPressed: () => _orderRequestProvider
                                //     .orderRequestForSellerDetailsScreenViewModelUpdateSellerOfferPrice(
                                //         context,
                                //         _orderRequestProvider
                                //             .orderRequestForSellerDetailsScreenViewModelRequestItem
                                //             .id),
                                onPressed: () => _orderRequestProvider
                                    .orderRequestForSellerDetailsScreenViewModelUpdateBuyerRequestPrice(
                                  context,
                                  changedBySeller: false,
                                ),
                                child: Text('Offer this price'),
                              )
                            : Container();
                      },
                    ),

                    // --------------------------Seller response to change Request Price ends here-----------------------
                  ]),
                ),
              ],
            )
          else
            Container(
              decoration: BoxDecoration(
                color: _theme.colorScheme.secondary,
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
                        style: _theme.textTheme.headlineSmall,
                      ),
                      Text(
                        'Pending',
                        style: _theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppHeight.h8,
                  ),
                  Text(
                    'We will let you know when ${_orderRequestProvider.orderRequestForSellerDetailsScreenViewModelRequestItem.requestingCustomer.firstName} responds to the request',
                    style: TextStyle(
                      color: ColorManager.yellow,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
