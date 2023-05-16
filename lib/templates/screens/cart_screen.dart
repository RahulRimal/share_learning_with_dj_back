import 'package:bot_toast/bot_toast.dart';
import 'package:esewa_client/esewa_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
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

import '../../models/order.dart';
import '../../models/user.dart';

import '../../providers/order_request_provider.dart';
import '../../providers/users.dart';
import '../widgets/billing_info.dart';
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
