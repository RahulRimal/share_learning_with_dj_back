import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/cart_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import 'package:share_learning/templates/widgets/cart_item_widget.dart';

import '../widgets/billing_info.dart';
import '../widgets/custom_bottom_navbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  // static final routeName = '/cart-list';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false)
        .bindCartScreenViewModel(context);
  }

  @override
  void dispose() {
    Provider.of<CartProvider>(context, listen: false)
        .unBindCartScreenViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider _cartProvider = context.watch<CartProvider>();

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
                      controller: _cartProvider.cartScreenSearchController,
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
                _cartProvider.cart!.items!.length <= 0
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
                        child: CartList(),
                      ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 4,
        ),
        bottomSheet: _cartProvider.cartItems.length > 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                child: ElevatedButton(
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
                    backgroundColor: ColorManager.primary,
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
                ),
              )
            : null);
  }
}

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider _cartProvider = context.watch<CartProvider>();

    return ListView.builder(
      itemCount: context.watch<CartProvider>().cartItems.length,
      itemBuilder: (context, index) {
        return CartItemWidget(cartItem: _cartProvider.cartItems[index]);
      },
    );
  }
}
