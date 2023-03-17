import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/orders.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/widgets/cart_item_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/order.dart';
import '../../models/user.dart';
import '../../providers/users.dart';

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
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final Session authendicatedSession = args['loggedInUserSession'] as Session;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    // Carts carts = context.watch<Carts>();
    Carts carts = Provider.of<Carts>(context, listen: false);

    Orders orders = Provider.of<Orders>(context);
    Users users = Provider.of<Users>(context);

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
                Expanded(
                  child: CartList(
                      carts: carts, authendicatedSession: authendicatedSession),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: context.watch<Carts>().cartItems.length > 0
            ? ElevatedButton(
                onPressed: () async {
                  User user = users.user as User;
                  if (await orders.placeOrder(authendicatedSession, {
                    // 'first_name': 'Temp',
                    // 'last_name': 'Temp',
                    // 'phone': '1234567890',
                    // 'email': 'temp@temp.temp',
                    // 'convenient_location': 'temp location',
                    // 'side_note': 'Temp temp'
                    // 'last_name': 'Temp',
                    'first_name': user.firstName,
                    'last_name': user.lastName,
                    'phone': user.phone == null ? 'nullPhone' : user.phone,
                    'email': user.email,
                    'convenient_location': 'temp location',
                    'side_note': 'Temp temp'
                  })) {
                    carts.setCart(null);
                    carts.setCartItems([]);
                    SharedPreferences prefs = await _prefs;
                    prefs.remove('cartId');
                    _showToastNotification("Order placed successfully");
                    Navigator.pushReplacementNamed(context, HomeScreen.routeName, arguments: {'authSession': authendicatedSession}
                    );
                  } else {
                    _showToastNotification("Something went wrong");
                  }
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
