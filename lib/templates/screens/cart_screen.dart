import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khalti/khalti.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
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

import '../../models/user.dart';

import '../../providers/users.dart';
import '../widgets/custom_bottom_navbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static final routeName = '/cart-list';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _form = GlobalKey<FormState>();
  // final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // final Session authendicatedSession = args['loggedInUserSession'] as Session;

    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    Carts carts = Provider.of<Carts>(context, listen: false);

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
                        hintText: 'Find your order',
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
                carts.cart!.items!.length <= 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppPadding.p45),
                          child: Text(
                            'No items found on cart',
                            style: getBoldStyle(
                              fontSize: FontSize.s20,
                              color: ColorManager.primary,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: CartList(
                            carts: carts,
                            authendicatedSession: authendicatedSession),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 3,
        ),
        bottomSheet: context.watch<Carts>().cartItems.length > 0
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
                  //   User user = users.user as User;
                  //   if (await orders.placeOrder(authendicatedSession, {

                  //     'first_name':
                  //         user.firstName!.isEmpty ? "Temp" : user.firstName,
                  //     'last_name':
                  //         user.lastName!.isEmpty ? "Temp" : user.lastName,
                  //     'phone': user.phone == null ? 'nullPhone' : user.phone,
                  //     'email': user.email,
                  //     'convenient_location': 'temp location',
                  //     'side_note': 'Temp temp'
                  //   })) {
                  //     carts.setCart(null);
                  //     carts.setCartItems([]);
                  //     SharedPreferences prefs = await _prefs;
                  //     prefs.remove('cartId');
                  //     _showToastNotification("Order placed successfully");
                  //     Navigator.pushReplacementNamed(
                  //         context, HomeScreenNew.routeName,
                  //         arguments: {'authSession': authendicatedSession});
                  //   } else {
                  //     _showToastNotification("Something went wrong");
                  //   }
                  // },
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

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
    required this.carts,
    required this.authendicatedSession,
  }) : super(key: key);

  final Carts carts;
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
      itemCount: context.watch<Carts>().cartItems.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          cartItem: carts.cartItems[index],
        );
      },
    );
    // )
    // : FutureBuilder(
    //     future: carts.getCartItems(authendicatedSession),
    //     // builder: carts.getUserCart(authendicatedSession),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else {
    //         if (snapshot.hasError) {
    //           return Center(
    //             child: Text(
    //               'Error',
    //             ),
    //           );
    //         } else {
    //           return Consumer<Carts>(
    //             builder: (ctx, cartItems, child) {
    //               return carts.cartItems.length <= 0
    //                   ? Center(
    //                       child: Text(
    //                         'No Item in the cart',
    //                         style: getBoldStyle(
    //                             fontSize: FontSize.s20,
    //                             color: ColorManager.primary),
    //                       ),
    //                     )
    //                   : ListView.builder(
    //                       itemCount: carts.cartItems.length,
    //                       itemBuilder: (ctx, index) {
    //                         return CartItemWidget(
    //                           cartItem: carts.cartItems[index],
    //                         );
    //                       },
    //                     );
    //             },
    //           );
    //         }
    //       }
    //     },
    //   );
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

  PaymentMethod _paymentMethod = PaymentMethod.Cash;

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
      if (!user.phone!.isNotEmpty) {
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
                      ? ColorManager.primary
                      : ColorManager.lightGrey,
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _paymentMethod = PaymentMethod.Esewa;
                  });
                  // Initiate PayPal payment
                  // PayPalResult result = await PayPal.initializePayment(
                  //   "your-client-id",
                  //   "your-secret-key",
                  //   100.0, // payment amount
                  //   "USD", // currency code
                  // );

                  // // Handle payment response
                  // if (result.success) {
                  //   setState(() {
                  //     paymentGateway = "PayPal";
                  //   });
                  // } else {
                  //   // Handle payment error
                  // }
                },
                child: Text("Pay with e-Sewa"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: _paymentMethod == PaymentMethod.Khalti
                      ? ColorManager.primary
                      : ColorManager.lightGrey,
                  fixedSize: Size.fromWidth(
                    MediaQuery.of(context).size.width,
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _paymentMethod = PaymentMethod.Khalti;
                  });

                  // await Khalti.init(
                  //   publicKey:
                  //       'test_public_key_78965ea539884431b8e9172178d08e91',
                  //   enabledDebugging: false,
                  // );
                  // final service = KhaltiService(client: KhaltiHttpClient());

                  // final initiationModel = await service.initiatePayment(
                  //   request: PaymentInitiationRequestModel(
                  //     amount: 1000, // in paisa
                  //     mobile: '9868957429',
                  //     productIdentity: 'mac-mini',
                  //     productName: 'Apple Mac Mini',
                  //     transactionPin: '1027',
                  //     productUrl:
                  //         'https://khalti.com/bazaar/mac-mini-16-512-m1',
                  //     additionalData: {
                  //       'vendor': 'Oliz Store',
                  //       'manufacturer': 'Apple Inc.',
                  //     },
                  //   ),
                  // );

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
                      if (_paymentMethod == PaymentMethod.Esewa) {}

                      final _isValid = _form.currentState!.validate();
                      if (!_isValid) {
                        return;
                      }
                      _form.currentState!.save();

                      if (await orders.placeOrder(
                        authSession,
                        _billingInfo,
                      )) {
                        carts.setCart(null);
                        carts.setCartItems([]);
                        SharedPreferences prefs = await _prefs;
                        prefs.remove('cartId');
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
