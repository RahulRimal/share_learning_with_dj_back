import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/templates/widgets/order_item_widget.dart';

import '../../models/session.dart';
import '../../view_models/providers/cart_provider.dart';
import '../../view_models/providers/order_provider.dart';
import '../managers/assets_manager.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';
import 'orders_screen_new.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  // static final routeName = '/order-list';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with WidgetsBindingObserver {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    OrderProvider ordersProvider =
        Provider.of<OrderProvider>(context, listen: false);

    ordersProvider.bindOrdersScreenViewModel(context);

    // Register this object as an observer
    WidgetsBinding.instance.addObserver(this);
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersProvider
          .getUserOrders(ordersProvider.sessionProvider.session as Session);
    });
  }

  @override
  void dispose() {
    Provider.of<OrderProvider>(context, listen: false)
        .unbindOrdersScreenViewModel();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider _orderProvider = context.watch<OrderProvider>();
    return Scaffold(
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
                    controller: _orderProvider.ordersScreenSearchController,
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
                    onFieldSubmitted: (_) {},
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
                            fontSize: FontSize.s20, color: ColorManager.white),
                      ),
                    )
                  ],
                ),
              ),
              OrderList(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderProvider _orderProvider = context.watch<OrderProvider>();

    return _orderProvider.orders.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _orderProvider.orders.length,
            itemBuilder: (context, index) {
              return ListView.builder(
                  itemCount: _orderProvider.orders[index].items.length,
                  itemBuilder: (context, idx) {
                    return OrderItemWidget(
                        orderItem: _orderProvider.orders[index].items[idx]);
                  });
            },
          )
        : Center(
            child: Text(
              'No Item in the order',
              style: getBoldStyle(
                  fontSize: FontSize.s20, color: ColorManager.primary),
            ),
          );

    // : FutureBuilder(
    //     future: _orderProvider.getUserOrders(
    //         _orderProvider.sessionProvider.session as Session),
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
    //           return Consumer<CartProvider>(
    //             builder: (ctx, cartItems, child) {
    //               // return carts.cartItems.length <= 0
    //               return _orderProvider.orders.length <= 0
    //                   ? Center(
    //                       child: Text(
    //                         'No Item in the order',
    //                         style: getBoldStyle(
    //                             fontSize: FontSize.s20,
    //                             color: ColorManager.primary),
    //                       ),
    //                     )
    //                   : ListView.builder(
    //                       shrinkWrap: true,
    //                       itemCount: _orderProvider.orders.length,
    //                       itemBuilder: (context, index) {
    //                         return ListView.builder(
    //                           shrinkWrap: true,
    //                           itemCount:
    //                               _orderProvider.orders[index].items.length,
    //                           itemBuilder: (context, idx) {
    //                             return OrderItemWidget(
    //                                 orderItem: _orderProvider
    //                                     .orders[index].items[idx]);
    //                           },
    //                         );
    //                       },
    //                     );
    //             },
    //           );
    //         }
    //       }
    //     },
    //   );

    // : FutureBuilder(
    //     future: _orderProvider.getUserOrders(
    //         _orderProvider.sessionProvider.session as Session),
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
    //           return Consumer<CartProvider>(
    //             builder: (ctx, cartItems, child) {
    //               // return carts.cartItems.length <= 0
    //               return _orderProvider.orders.length <= 0
    //                   ? Center(
    //                       child: Text(
    //                         'No Item in the order',
    //                         style: getBoldStyle(
    //                             fontSize: FontSize.s20,
    //                             color: ColorManager.primary),
    //                       ),
    //                     )
    //                   :
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
