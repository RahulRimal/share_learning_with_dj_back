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
import '../widgets/custom_bottom_navbar.dart';

class OrderRequestScreen extends StatefulWidget {
  const OrderRequestScreen({Key? key}) : super(key: key);
  static final routeName = '/order-request-list';

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
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
                              fontSize: FontSize.s20,
                              color: ColorManager.white),
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
                  future: orderRequests.getOrderRequests(authendicatedSession),
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
                                      authendicatedSession:
                                          authendicatedSession),
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
        // bottomSheet: context.watch<Carts>().cartItems.length > 0
        bottomSheet: context.watch<OrderRequests>().orderRequests.length > 0
            ? ElevatedButton(
                onPressed: () async {
                  showModalBottomSheet(
                    barrierColor: ColorManager.blackWithLowOpacity,
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
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p20,
                        ),
                        child: BillingInfo(),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: ColorManager.primary,
                  minimumSize: const Size.fromHeight(40), // NEW
                ),
                child: const Text(
                  "Order these items",
                  style: TextStyle(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )
            : null);
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
      itemCount: context.watch<OrderRequests>().orderRequests.length,
      itemBuilder: (context, index) {
        return OrderRequestItemWidget(
          // cartItem: carts.cartItems[index],
          requestedItem: orderRequests.orderRequests[index],
        );
      },
    );
  }
}

enum PaymentMethod {
  Esewa,
  Khalti,
  Cash,
}

class BillingInfo extends StatefulWidget {
  const BillingInfo({Key? key}) : super(key: key);

  @override
  State<BillingInfo> createState() => _BillingInfoState();
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

                      if (await orders.placeOrder(
                        loggedInSession: authSession,
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
                        // carts.setCart(null);
                        // carts.setCartItems([]);
                        // SharedPreferences prefs = await _prefs;
                        // prefs.remove('cartId');

                        await carts.createCart(authSession);
                        carts.setCartItems([]);
                        SharedPreferences prefs = await _prefs;
                        prefs.remove('cartId');
                        prefs.setString('cartId', carts.cart!.id);
                        _showToastNotification("Order placed successfully");
                        Navigator.pushReplacementNamed(
                            context, HomeScreenNew.routeName,
                            arguments: {'authSession': authSession});
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

class OrderRequestItemWidget extends StatefulWidget {
  const OrderRequestItemWidget({Key? key, required this.requestedItem})
      : super(key: key);

  final OrderRequest requestedItem;

  @override
  State<OrderRequestItemWidget> createState() => _OrderRequestItemWidgetState();
}

class _OrderRequestItemWidgetState extends State<OrderRequestItemWidget> {
  late ValueNotifier<bool> _requestedItemChanged;
  late ValueNotifier<int> _quantity;
  late OrderRequest _edittedItem;

  _ifRequestItemChanged() {
    if (_quantity.value != widget.requestedItem.quantity) {
      _requestedItemChanged.value = true;
      return;
    }

    _requestedItemChanged.value = false;
  }

  @override
  void initState() {
    _edittedItem = widget.requestedItem;
    _requestedItemChanged = ValueNotifier<bool>(false);
    _quantity = ValueNotifier<int>(widget.requestedItem.quantity);
    // _wishlisted = widget.cartItem.wishlisted;
    super.initState();
  }

  Future<bool> _updateCartItem(Cart cart, CartItem edittedItem) async {
    _edittedItem.quantity = _quantity.value;
    // _edittedItem.wishlisted = _wishlisted;

    await Provider.of<Carts>(context, listen: false)
        .updateCartItem(cart.id, edittedItem)
        .then(
      (value) {
        if (value) {
          BotToast.showSimpleNotification(
            title: 'Cart Item updated',
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            // align: Alignment(0, 0),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
          _requestedItemChanged.value = false;
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

  @override
  Widget build(BuildContext context) {
    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    Carts _carts = context.watch<Carts>();

    return FutureBuilder(
        future: _carts.getCartItemBook(
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
                final Book orderedBook = snapshot.data as Book;
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
                            child: Image.network(
                              'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
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
                                          orderedBook.bookName,
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
                                                    'This will remove the item from  your cart',
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
                                                  color: Colors.lightBlue,
                                                  fontSize: 12,
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
                                                  fontSize: 12,
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
                                                "Expected unit price",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: 12,
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
                                                  fontSize: 12,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: _requestedItemChanged,
                        builder: (BuildContext context, bool itemChanged,
                            Widget? child) {
                          return itemChanged
                              ? ElevatedButton(
                                  // onPressed: () => _updateCartItem(
                                  //     Provider.of<Carts>(context, listen: false)
                                  //         .cart as Cart,
                                  //     _requestedItem),
                                  onPressed: () {},
                                  child: Text('Update Request Price'),
                                )
                              : Container();
                        },
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
