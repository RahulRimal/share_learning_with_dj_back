import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/orders.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';

import '../../models/book.dart';
import '../../models/order.dart';
import '../../models/session.dart';
import '../managers/color_manager.dart';
import '../managers/values_manager.dart';

class OrderScreenNew extends StatelessWidget {
  static const routeName = '/order-list-new';
  OrderScreenNew({Key? key}) : super(key: key);
  final _filterForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Provider.of<Orders>(context).or
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final Session authSession = args['loggedInUserSession'] as Session;
    // Session authSession =
    //     Provider.of<SessionProvider>(context).session as Session;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              AppPadding.p24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Orders',
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s24,
                      ),
                    ),
                    CircleAvatar(
                      child: Image.asset(
                        ImageAssets.noProfile,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p16,
                  ),
                  child: Row(
                    children: [
                      Form(
                        key: _filterForm,
                        child: Expanded(
                          child: TextFormField(
                            cursorColor: ColorManager.white,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: ColorManager.primary,
                              fillColor: ColorManager.white,
                              filled: true,
                              focusColor: ColorManager.white,
                              labelText: 'Search for your order',
                              labelStyle: getMediumStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorManager.white,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: ColorManager.white,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide the bookName';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last 3 Months',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s20,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorManager.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p12,
                            vertical: AppPadding.p8,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Filters',
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: FutureBuilder(
                    future:
                        Provider.of<Orders>(context).getUserOrders(authSession),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          ),
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error'),
                          );
                        } else {
                          return Consumer<Orders>(
                            builder: (ctx, orders, child) {
                              return orders.orders.length <= 0
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: AppPadding.p45),
                                        child: Text(
                                          'No orders found',
                                          style: getBoldStyle(
                                              fontSize: FontSize.s20,
                                              color: ColorManager.primary),
                                        ),
                                      ),
                                    )
                                  // : ListView.builder(
                                  //     shrinkWrap: true,
                                  //     itemCount: orders.orders.length,
                                  //     itemBuilder: (ctx, index) {
                                  //       return OrderItemWidget(
                                  //           order: orders.orders[index]);
                                  //     },
                                  //   );
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: orders.orders.length,
                                      itemBuilder: (ctx, index) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: orders
                                                .orders[index].items.length,
                                            itemBuilder: (ctx, idx) {
                                              return OrderItemWidget(
                                                orderItem: orders
                                                    .orders[index].items[idx],
                                              );
                                            });
                                      },
                                    );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
                // ...List.generate(5, (index) => OrderItemWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);

  final OrderItem orderItem;
  late Book product;

  @override
  Widget build(BuildContext context) {
    Books booksProvider = Provider.of<Books>(context, listen: false);
    product = booksProvider.books.firstWhere(
      (book) => book.id == orderItem.productId.toString(),
      orElse: () {
        return booksProvider.getBookById(orderItem.productId.toString());
      },
    );
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppMargin.m12,
      ),
      decoration: BoxDecoration(
        color: ColorManager.lighterGrey,
        borderRadius: BorderRadius.circular(
          AppRadius.r12,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              AppPadding.p4,
            ),
            margin: EdgeInsets.only(
              right: AppMargin.m14,
            ),
            decoration: BoxDecoration(
              color: ColorManager.grey,
              borderRadius: BorderRadius.circular(
                AppRadius.r12,
              ),
            ),
            child: Image.asset(
              ImageAssets.noProfile,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.bookName,
                  softWrap: true,
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                Text(
                  'Rs. ${product.price.toString()}',
                  style: getMediumStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s14,
                  ),
                ),
                SizedBox(
                  height: AppHeight.h4,
                ),
                Row(
                  children: [
                    Text(
                      'Delivered on wednesday',
                      style: getBoldStyle(
                          color: ColorManager.green, fontSize: FontSize.s12),
                    ),
                    SizedBox(
                      width: AppSize.s4,
                    ),
                    Icon(
                      Icons.check_circle,
                      color: ColorManager.green,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
