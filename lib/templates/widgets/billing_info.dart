import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/order.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../view_models/book_provider.dart';
import '../../view_models/cart_provider.dart';
import '../../view_models/order_provider.dart';
import '../../view_models/session_provider.dart';
import '../../view_models/user_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import '../screens/home_screen_new.dart';
import '../utils/payment.dart';

enum PaymentMethod {
  Esewa,
  Khalti,
  Cash,
}

class BillingInfo extends StatefulWidget {
  BillingInfo({Key? key, this.cartId}) : super(key: key);

  @override
  State<BillingInfo> createState() => _BillingInfoState();

  // If cart id is present then it is a direct order or else it will place an order using the existing cart information
  // bool placeDirectOrder;
  final String? cartId;
}

class _BillingInfoState extends State<BillingInfo> {
  final _form = GlobalKey<FormState>();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _sideNoteFocusNode = FocusNode();

  PaymentMethod _paymentMethod = PaymentMethod.Khalti;


  @override
  void initState() {
    Provider.of<BookProvider>(context, listen:false).bindBillingInfoWidgetViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    BookProvider _bookProvider = context.watch<BookProvider>();

    // OrderProvider orders = Provider.of<OrderProvider>(context);
    
    // CartProvider carts = Provider.of<CartProvider>(context, listen: false);
    // OrderRequests orderRequests =
    //     Provider.of<OrderRequests>(context, listen: false);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    // Session authSession =
    //     Provider.of<SessionProvider>(context).session as Session;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.cancel,
            color: ColorManager.black,
          ),
        ),
        title: Center(
          child: Text(
            'Billing Information',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppPadding.p16,
            horizontal: AppPadding.p14,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            // initialValue: _edittedUser.firstName,
                                            initialValue: _bookProvider.billingInfo
                                                    .containsKey('first_name')
                                                ? _bookProvider.billingInfo['first_name']
                                                : null,
                                            cursorColor:
                                                Theme.of(context).primaryColor,
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
                                              _bookProvider.billingInfo['first_name'] =
                                                  value.toString();
                                            }),
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          initialValue: _bookProvider.billingInfo
                                                  .containsKey('last_name')
                                              ? _bookProvider.billingInfo['last_name']
                                              : null,
                                          keyboardType: TextInputType.text,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          focusNode: _lastNameFocusNode,
                                          decoration: InputDecoration(
                                            labelText: 'Last Name',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context)
                                                .requestFocus(_emailFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide the last name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _bookProvider.billingInfo['last_name'] =
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
                                          _bookProvider.billingInfo.containsKey('email')
                                              ? _bookProvider.billingInfo['email']
                                              : null,
                                      focusNode: _emailFocusNode,
                                      keyboardType: TextInputType.text,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: 'Email Address',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode: AutovalidateMode.always,
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
                                        _bookProvider.billingInfo['email'] =
                                            value.toString();
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      initialValue:
                                          _bookProvider.billingInfo.containsKey('phone')
                                              ? _bookProvider.billingInfo['phone']
                                              : null,
                                      focusNode: _phoneNumberFocusNode,
                                      keyboardType: TextInputType.number,
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                      ),
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode: AutovalidateMode.always,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_sideNoteFocusNode);
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide the phone number to be contacted';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _bookProvider.billingInfo['phone'] =
                                            value.toString();
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    // initialValue: _edittedUser.description,
                                    focusNode: _sideNoteFocusNode,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      labelText: 'Side Note',
                                    ),
                                    textInputAction: TextInputAction.newline,
                                    autovalidateMode: AutovalidateMode.always,
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
                                      _bookProvider.billingInfo['side_note'] =
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
                            value: _bookProvider.billingInfo['convenient_location'],
                            // value: _locationOptions[0],
                            items: _bookProvider.locationOptions
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
                                _bookProvider.billingInfo['convenient_location'] =
                                    value as String;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              // ----------------------    Sort by location section ends here -----------------------------------
              // ----------------------    Payment gateway section starts here -----------------------------------

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p12,
                ),
              ),

              Text(
                'Select Payment Gateway',
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s18,
                ),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _paymentMethod == PaymentMethod.Esewa
                      ? ColorManager.green
                      : ColorManager.lightGrey,
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _paymentMethod = PaymentMethod.Esewa;
                  });
                },
                child: Text("Pay with e-Sewa"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _paymentMethod == PaymentMethod.Khalti
                      ? ColorManager.purple
                      : ColorManager.lightGrey,
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () async {
                  // _payWithKhalti();
                  setState(() {
                    _paymentMethod = PaymentMethod.Khalti;
                  });
                },
                child: Text("Pay with Khalti"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _paymentMethod == PaymentMethod.Cash
                      ? ColorManager.primary
                      : ColorManager.lightGrey,
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _paymentMethod = PaymentMethod.Cash;
                  });
                  // Initiate Ewsea payment
                  // EwseaResult result = await Ewsea.initializePayment(
                  //   "your-ewsea-key",
                  //   100.0, // payment amount
                  //   "USD", // currency code
                  // );

                  // // Handle payment response
                  // if (result.success) {
                  //   setState(() {
                  //     paymentGateway = "Ewsea";
                  //   });
                  // } else {
                  //   // Handle payment error
                  // }
                },
                child: Text("Pay with Cash"),
              ),

              // ----------------------    Payment gateway section ends here -----------------------------------

              SizedBox(
                height: AppHeight.h50,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: ColorManager.lighterGrey,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p12,
          vertical: AppPadding.p8,
        ),
        child: Row(
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

                    String paymentStatus = 'P';

                    if (_paymentMethod == PaymentMethod.Esewa) {
                      if (await PaymentHelper.payWithEsewa() == false) {
                        AlertHelper.showToastAlert(
                            "Something went wrong during payment. Please try again");
                        return;
                      } else
                        paymentStatus = "C";
                    }
                    if (_paymentMethod == PaymentMethod.Khalti) {
                      if (await PaymentHelper.payWithKhalti(context) == false) {
                        AlertHelper.showToastAlert(
                            "Something went wrong during the payment, please try again");
                        return;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Payment Successful'),
                            );
                          },
                        );
                        paymentStatus = "C";
                      }
                    }
                    // if (widget.cartId != null) {
                    //   if (await orders.placeOrder(
                    //     loggedInSession: authSession,
                    //     cartId: widget.cartId as String,
                    //     billingInfo: _billingInfo,
                    //     paymentMethod: _paymentMethod == PaymentMethod.Cash
                    //         ? "C"
                    //         : _paymentMethod == PaymentMethod.Esewa
                    //             ? "E"
                    //             : "K",
                    //   )) {
                    //     // _orderPlacedSuccessfully = true;
                    //     print('here');
                    //     if (_paymentMethod != PaymentMethod.Cash) {
                    //       Order order = orders.orders.last;
                    //       await orders.updatePaymentStatus(authSession,
                    //           order.id.toString(), paymentStatus);
                    //     }
                    //   }
                    // }

                    // if (
                    //     //   await orders.placeOrder(
                    //     //   authSession,
                    //     //   _billingInfo,
                    //     //   _paymentMethod == PaymentMethod.Cash
                    //     //       ? "C"
                    //     //       : _paymentMethod == PaymentMethod.Esewa
                    //     //           ? "E"
                    //     //           : "K",
                    //     // )
                    //     //   await orderRequests.createOrderRequest(authSession)) {
                    //     // if (_paymentMethod != PaymentMethod.Cash) {
                    //     await carts.createCart(authSession)) {
                    //   if (_paymentMethod != PaymentMethod.Cash) {
                    //     Order order = orders.orders.last;
                    //     await orders.updatePaymentStatus(
                    //         authSession, order.id.toString(), paymentStatus);
                    //   }

                    //   await carts.createCart(authSession);
                    //   carts.setCartItems([]);
                    //   SharedPreferences prefs = await _prefs;
                    //   prefs.remove('cartId');
                    //   prefs.setString('cartId', carts.cart!.id);
                    //   _showToastNotification(
                    //       "Order request created successfully");
                    //   Navigator.pushReplacementNamed(
                    //       context, HomeScreenNew.routeName,
                    //       arguments: {'authSession': authSession});
                    // } else {
                    //   _showToastNotification("Something went wrong");
                    // }

// If cartid is provided, it will be passed to the function which will call direct order placement api function otherwise it will call  order placement api function which uses preexisting cart
                    if (await _bookProvider.orderProvider .placeOrder(
                      loggedInSession: _bookProvider.authSession,
                      cartId: widget.cartId,
                      billingInfo: _bookProvider.billingInfo,
                      paymentMethod: _paymentMethod == PaymentMethod.Cash
                          ? "C"
                          : _paymentMethod == PaymentMethod.Esewa
                              ? "E"
                              : "K",
                    )) {
                      if (_paymentMethod != PaymentMethod.Cash) {
                        Order order = _bookProvider.orderProvider.orders.last;
                        await _bookProvider.orderProvider.updatePaymentStatus(
                            _bookProvider.authSession, order.id.toString(), paymentStatus);
                      }

                      // Only recreate the cart and update it if the order is placed using the existing cart otherwise leave the cart as it is.
                      if (widget.cartId == null) {
                        await _bookProvider.cartProvider.createCart(_bookProvider.authSession);
                        _bookProvider.cartProvider.setCartItems([]);
                        SharedPreferences prefs = await _prefs;
                        prefs.remove('cartId');
                        prefs.setString('cartId', _bookProvider.cartProvider.cart!.id);
                      }

                      AlertHelper.showToastAlert("Order placed successfully");
                      Navigator.pushReplacementNamed(
                        context, HomeScreenNew.routeName,
                        // arguments: {'authSession': authSession}
                      );
                    } else {
                      AlertHelper.showToastAlert("Something went wrong");
                    }
                  },
                  child: Text(
                    'Place an order',
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
      ),
    );
  }
}
