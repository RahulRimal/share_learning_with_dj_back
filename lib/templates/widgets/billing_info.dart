import 'package:bot_toast/bot_toast.dart';
import 'package:esewa_client/esewa_client.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/order.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/carts.dart';
import '../../providers/order_request_provider.dart';
import '../../providers/orders.dart';
import '../../providers/sessions.dart';
import '../../providers/users.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import '../screens/home_screen_new.dart';

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
  String? cartId;
}

class _BillingInfoState extends State<BillingInfo> {
  final _form = GlobalKey<FormState>();

  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _sideNoteFocusNode = FocusNode();

  Map<String, String> _billingInfo = {};

  PaymentMethod _paymentMethod = PaymentMethod.Khalti;

  List<String> _locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];

  _setBillingInfo(User user) {
    if (user.firstName!.isNotEmpty) {
      _billingInfo['first_name'] = user.firstName!;
    }
    if (user.lastName!.isNotEmpty) {
      _billingInfo['last_name'] = user.lastName!;
    }
    if (user.email!.isNotEmpty) {
      _billingInfo['email'] = user.email!;
    }
    if (user.phone != null) {
      if (user.phone!.isNotEmpty) {
        _billingInfo['phone'] = user.phone!;
      }
    }
    // print(_billingInfo);
  }

  _showToastNotification(String msg) {
    BotToast.showSimpleNotification(
      title: msg,
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );
  }

  _payWithKhalti() async {
    bool paymentSuccess = false;
    await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: 1000,
          productIdentity: 'cart/product id',
          productName: 'productName',
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
          PaymentPreference.sct,
        ],
        onSuccess: (PaymentSuccessModel success) {
          paymentSuccess = true;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Payment Successful'),
                // actions: [
                //   SimpleDialogOption(
                //     child: Text('OK'),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                // ],
              );
            },
          );
        },
        onFailure: (PaymentFailureModel failure) {
          print(failure.toString());
          paymentSuccess = false;
        },
        onCancel: () {
          print('Khalti Canceled');
          paymentSuccess = false;
        });

    return paymentSuccess;
  }

  _payWithEsewa() {
    EsewaClient _esewaClient = EsewaClient.configure(
      clientId: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: EsewaEnvironment.TEST,
    );

    /*
    * Enter your own callback url to receive response callback from esewa to your client server
    * */
    EsewaPayment payment = EsewaPayment(
        productId: "test_id",
        amount: "10",
        name: "Test Product",
        callbackUrl: "http://example.com/");

    // start your payment procedure
    _esewaClient.startPayment(
        esewaPayment: payment,
        onSuccess: (data) {
          print("success");
          return false;
        },
        onFailure: (data) {
          print("failure");
          return false;
        },
        onCancelled: (data) {
          print("cancelled");
          return false;
        });
  }

  @override
  void initState() {
    _billingInfo['convenient_location'] = _locationOptions[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BookFilters bookFilters = Provider.of<BookFilters>(context);
    // Map<String, dynamic> filterOptions = bookFilters.filterOptions;

    User user = Provider.of<Users>(context).user as User;
    Orders orders = Provider.of<Orders>(context);
    Users users = Provider.of<Users>(context);
    Carts carts = Provider.of<Carts>(context, listen: false);
    OrderRequests orderRequests =
        Provider.of<OrderRequests>(context, listen: false);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    Session authSession =
        Provider.of<SessionProvider>(context).session as Session;

    _setBillingInfo(user);

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
              // ----------------------    Name section ends here -----------------------------------

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
                                                    .containsKey('first_name')
                                                ? _billingInfo['first_name']
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
                  primary: _paymentMethod == PaymentMethod.Esewa
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
                  primary: _paymentMethod == PaymentMethod.Khalti
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
                  primary: _paymentMethod == PaymentMethod.Cash
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
                        if (_payWithEsewa() == false) {
                          _showToastNotification(
                              "Something went wrong during payment. Please try again");
                          return;
                        } else
                          paymentStatus = "C";
                      }
                      if (_paymentMethod == PaymentMethod.Khalti) {
                        if (await _payWithKhalti() == false) {
                          _showToastNotification(
                              "Something went wrong during the payment, please try again");
                          return;
                        } else
                          paymentStatus = "C";
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
                      if (await orders.placeOrder(
                        loggedInSession: authSession,
                        cartId: widget.cartId,
                        billingInfo: _billingInfo,
                        paymentMethod: _paymentMethod == PaymentMethod.Cash
                            ? "C"
                            : _paymentMethod == PaymentMethod.Esewa
                                ? "E"
                                : "K",
                      )) {
                        if (_paymentMethod != PaymentMethod.Cash) {
                          Order order = orders.orders.last;
                          await orders.updatePaymentStatus(
                              authSession, order.id.toString(), paymentStatus);
                        }

                        // Only recreate the cart and update it if the order is placed using the existing cart otherwise leave the cart as it is.
                        if (widget.cartId == null) {
                          await carts.createCart(authSession);
                          carts.setCartItems([]);
                          SharedPreferences prefs = await _prefs;
                          prefs.remove('cartId');
                          prefs.setString('cartId', carts.cart!.id);
                        }

                        _showToastNotification("Order placed successfully");
                        Navigator.pushReplacementNamed(
                          context, HomeScreenNew.routeName,
                          // arguments: {'authSession': authSession}
                        );
                      } else {
                        _showToastNotification("Something went wrong");
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
                      primary: ColorManager.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
