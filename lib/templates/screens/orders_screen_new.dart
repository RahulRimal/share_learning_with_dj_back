import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/providers/orders.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/order_details_screen.dart';

import '../../models/book.dart';
import '../../models/order.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/users.dart';
import '../managers/color_manager.dart';
import '../managers/values_manager.dart';
import '../utils/user_helper.dart';

class OrdersScreenNew extends StatelessWidget {
  static const routeName = '/orders-list-new';
  OrdersScreenNew({Key? key}) : super(key: key);
  final _filterForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Provider.of<Orders>(context).or
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // final Session authSession = args['loggedInUserSession'] as Session;
    Session authSession = context.watch<SessionProvider>().session as Session;
    Users _users = context.watch<Users>();
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
                    // CircleAvatar(
                    //   child: Image.asset(
                    //     ImageAssets.noProfile,
                    //   ),
                    FutureBuilder(
                      future: _users.getUserByToken(authSession.accessToken),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: ColorManager.secondary,
                          );
                        } else {
                          if (snapshot.hasError) {
                            return CircleAvatar(
                              child: Image.asset(
                                ImageAssets.noProfile,
                              ),
                            );
                          } else {
                            if (snapshot.data is UserError) {
                              UserError error = snapshot.data as UserError;
                              return Text(error.message as String);
                            } else {
                              User _user = snapshot.data as User;
                              return _user.image != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          UserHelper.userProfileImage(_user)),
                                    )
                                  : CircleAvatar(
                                      // radius: AppRadius.r24,
                                      backgroundImage:
                                          AssetImage(ImageAssets.noProfile),
                                    );
                            }
                          }
                        }
                      },
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
                          backgroundColor: ColorManager.white,
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
                                            top: AppPadding.p12),
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
                                  //       return ListView.builder(
                                  //           shrinkWrap: true,
                                  //           itemCount: orders
                                  //               .orders[index].items.length,
                                  //           itemBuilder: (ctx, idx) {
                                  //             return OrderItemWidget(
                                  //               orderItem: orders
                                  //                   .orders[index].items[idx],
                                  //             );
                                  //           });
                                  //     },
                                  //   );
                                  // : ListView.builder(
                                  //     shrinkWrap: true,
                                  //     itemCount: orders.orders.length,
                                  //     itemBuilder: (ctx, index) {
                                  //       return OrderWidget(
                                  //           order: orders.orders[index]);
                                  //       // return ListView.builder(
                                  //       //     shrinkWrap: true,
                                  //       //     itemCount: orders
                                  //       //         .orders[index].items.length,
                                  //       //     itemBuilder: (ctx, idx) {
                                  //       //       return OrderItemWidget(
                                  //       //         orderItem: orders
                                  //       //             .orders[index].items[idx],
                                  //       //       );
                                  //       //     });
                                  //     },
                                  //   );
                                  : OrdersWidget(
                                      orders: orders.orders.reversed.toList(),
                                    );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
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

  @override
  Widget build(BuildContext context) {
    Books booksProvider = context.watch();
    Session authSession =
        Provider.of<SessionProvider>(context, listen: false).session as Session;
    Book? product = booksProvider.books.firstWhereOrNull(
      (book) => book.id == orderItem.productId.toString(),
    );
    if (product == null) {
      return FutureBuilder(
          future: booksProvider.getBookByIdFromServer(
              authSession, orderItem.productId.toString()),
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
                product = snapshot.data as Book;
                booksProvider.books.add(product as Book);
                return Container(
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
                        // child: Image.asset(
                        //   ImageAssets.noProfile,
                        // ),
                        child: product!.images != null
                            ? Image.network(
                                product!.images![0].image,
                                height: AppHeight.h75,
                              )
                            : Image.asset(
                                ImageAssets.noProfile,
                              ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product!.bookName,
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
                              'Unit price: Rs. ${product!.price.toString()}',
                              style: getMediumStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s14,
                              ),
                            ),
                            Text(
                              'Quantity: ${orderItem.quantity.toString()}',
                              style: getMediumStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s14,
                              ),
                            ),
                            SizedBox(
                              height: AppHeight.h4,
                            ),
                            Text(
                              'Total: Rs. ${(product!.price * orderItem.quantity).toString()}',
                              style: getMediumStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s14,
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
          });
    } else {
      return Container(
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
              // child: Image.asset(
              //   ImageAssets.noProfile,
              // ),
              child: product.images != null
                  ? Image.network(
                      product.images![0].image,
                      height: AppHeight.h75,
                    )
                  : Image.asset(
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
                    'Unit price: Rs. ${product.price.toString()}',
                    style: getMediumStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  Text(
                    'Quantity: ${orderItem.quantity.toString()}',
                    style: getMediumStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s14,
                    ),
                  ),
                  SizedBox(
                    height: AppHeight.h4,
                  ),
                  Text(
                    'Total: Rs. ${(product.price * orderItem.quantity).toString()}',
                    style: getMediumStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s14,
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
}

class OrdersWidget extends StatefulWidget {
  OrdersWidget({Key? key, required this.orders}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();

  final List<Order> orders;
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late List<Map<String, dynamic>> _orderInfo;

  @override
  void initState() {
    _orderInfo = List.generate(widget.orders.length, (index) {
      return {
        'order': widget.orders[index],
        'isExpanded': false,
      };
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: ((index, isExpanded) {
          setState(() {
            _orderInfo[index]['isExpanded'] = !isExpanded;
          });
        }),
        children: _orderInfo.map<ExpansionPanel>((Map<String, dynamic> item) {
          return ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              double totalPrice = 0;

              item['order'].items.forEach((OrderItem item) {
                totalPrice += item.quantity * item.orderedPrice;
              });

              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppPadding.p2,
                  horizontal: AppPadding.p8,
                ),
                title: Text(
                  'Order placed on ${DateFormat('d MMMM y').format(item['order'].placedAt)}',
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s16,
                  ),
                ),
                subtitle: (item['order'].deliveryInfo != null &&
                        item['order'].deliveryInfo['status'] == 'T')
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Delivering on ${DateFormat('d MMMM y').format(DateTime.parse((item['order'] as Order).deliveryInfo!['expected_delivery_date']))}',
                                style: getBoldStyle(
                                    color: Colors.orange,
                                    fontSize: FontSize.s14),
                              ),
                            ],
                          ),
                          Text(
                            (item['order'] as Order).paymentStatus ==
                                    PaymentStatus.PENDING
                                ? 'Payment: Cash on delivery'
                                : 'Payment: Completed',
                            style: getBoldStyle(
                                color: (item['order'] as Order).paymentStatus ==
                                        PaymentStatus.PENDING
                                    ? ColorManager.yellow
                                    : ColorManager.green,
                                fontSize: FontSize.s14),
                          ),
                          Text(
                            'Total: Rs.${totalPrice.toString()}',
                            style: getMediumStyle(
                              color: ColorManager.black,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                // 'Delivered on ${DateFormat('d MMMM y').format(item['order'].placedAt)}',

                                'Delivered on ${DateFormat('d MMMM y').format(DateTime.parse((item['order'] as Order).deliveryInfo!['expected_delivery_date']))}',
                                style: getBoldStyle(
                                    color: ColorManager.green,
                                    fontSize: FontSize.s14),
                              ),
                              SizedBox(
                                width: AppSize.s4,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: ColorManager.green,
                                size: AppSize.s18,
                              ),
                            ],
                          ),
                          Text(
                            (item['order'] as Order).paymentStatus ==
                                    PaymentStatus.PENDING
                                ? 'Payment: Cash on delivery'
                                : 'Payment: Completed',
                            style: getBoldStyle(
                                color: (item['order'] as Order).paymentStatus ==
                                        PaymentStatus.PENDING
                                    ? ColorManager.yellow
                                    : ColorManager.green,
                                fontSize: FontSize.s14),
                          ),
                          SizedBox(
                            height: AppHeight.h2,
                          ),
                          Text(
                            'Total: Rs.${totalPrice.toString()}',
                            style: getMediumStyle(
                              color: ColorManager.black,
                            ),
                          ),
                        ],
                      ),
              );
            },
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: item['order'].items.length,
              itemBuilder: (ctx, idx) {
                return Padding(
                  padding: const EdgeInsets.all(
                    AppPadding.p8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        OrderDetailsScreen.routeName,
                        arguments: {'order': item['order']},
                      );
                    },
                    child: OrderItemWidget(
                      orderItem: item['order'].items[idx],
                    ),
                  ),
                );
              },
            ),
            isExpanded: item['isExpanded'],
          );
        }).toList(),
      ),
    );
  }
}
