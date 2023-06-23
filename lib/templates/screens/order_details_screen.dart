import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/view_models/providers/order_provider.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';

import '../../models/book.dart';
import '../../models/order.dart';
import '../../models/order_item.dart';
import '../../models/session.dart';
import '../../view_models/providers/book_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../utils/payment.dart';

class OrderDetailsScreen extends StatefulWidget {
  // static const routeName = 'order-details-screen';
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    OrderProvider _orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _orderProvider.orderDetailsScreenOrder.items.length > 1
                    ? 'Ordered books'
                    : 'Ordered book',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // ------------------------------------------------------ Order items start here ----------------------------------------------------
              ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      _orderProvider.orderDetailsScreenOrder.items.length,
                  itemBuilder: (context, index) {
                    OrderItem _orderItem =
                        _orderProvider.orderDetailsScreenOrder.items[index];

                    return FutureBuilder(
                        future:
                            Provider.of<BookProvider>(context, listen: false)
                                .getBookByIdFromServer(
                                    _orderProvider.sessionProvider.session
                                        as Session,
                                    _orderItem.productId.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(AppPadding.p8),
                              child: CircularProgressIndicator(
                                color: ColorManager.primary,
                              ),
                            ));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            Book orderedBook = snapshot.data as Book;

                            return Container(
                              margin: EdgeInsets.only(bottom: AppMargin.m8),
                              padding: EdgeInsets.all(AppPadding.p16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          orderedBook.bookName,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          '\Rs ${_orderItem.orderedPrice}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    // 'Description of product goes here. It can be multiple lines long and should be informative enough for the buyer to make a decision.',
                                    orderedBook.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                  }),

              // ------------------------------------------------------ Order items ends here ----------------------------------------------------
              SizedBox(height: 24.0),
              // ------------------------------------------------------ Shipping Information start here ----------------------------------------------------
              Text(
                'Shipping Information',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_orderProvider.orderDetailsScreenOrder.billingInfo!['first_name']} ${_orderProvider.orderDetailsScreenOrder.billingInfo!['last_name']} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      // '123 Main St',
                      "${_orderProvider.orderDetailsScreenOrder.deliveryInfo!['address']}",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      // 'Anytown, USA 12345',
                      "${_orderProvider.orderDetailsScreenOrder.billingInfo!['email']}, ${_orderProvider.orderDetailsScreenOrder.billingInfo!['phone']}",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Convenient Location',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_orderProvider.orderDetailsScreenOrder.billingInfo!['convenient_location']}",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppHeight.h12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping Method',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          // 'Standard',
                          "${_orderProvider.orderDetailsScreenOrder.deliveryInfo!['method'] == 'S' ? 'Standard' : 'Emergency'}",

                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ------------------------------------------------------ Shipping Information ends here ----------------------------------------------------
              SizedBox(height: 24.0),

              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: AppPadding.p0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: AppPadding.p4),
                        child: Text(
                          'Order placed on ${DateFormat('d MMMM y').format(_orderProvider.orderDetailsScreenOrder.placedAt)}',
                          style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s16),
                        ),
                      ),
                      subtitle: (_orderProvider
                                      .orderDetailsScreenOrder.deliveryInfo !=
                                  null &&
                              _orderProvider.orderDetailsScreenOrder
                                      .deliveryInfo!['status'] ==
                                  'T')
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppPadding.p4),
                                      child: Text(
                                        'Delivering on ${DateFormat('d MMMM y').format(DateTime.parse(_orderProvider.orderDetailsScreenOrder.deliveryInfo!['expected_delivery_date']))}',
                                        style: getBoldStyle(
                                            color: Colors.orange,
                                            fontSize: FontSize.s14),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppPadding.p4),
                                  child: Text(
                                    _orderProvider.orderDetailsScreenOrder
                                                .paymentStatus ==
                                            PaymentStatus.PENDING
                                        ? 'Payment: Cash on delivery'
                                        : 'Payment: Completed',
                                    style: getBoldStyle(
                                        color: _orderProvider
                                                    .orderDetailsScreenOrder
                                                    .paymentStatus ==
                                                PaymentStatus.PENDING
                                            ? ColorManager.yellow
                                            : ColorManager.green,
                                        fontSize: FontSize.s14),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppPadding.p4),
                                      child: Text(
                                        // 'Delivered on ${DateFormat('d MMMM y').format(item['order'].placedAt)}',

                                        'Delivered on ${DateFormat('d MMMM y').format(DateTime.parse(_orderProvider.orderDetailsScreenOrder.deliveryInfo!['expected_delivery_date']))}',
                                        style: getBoldStyle(
                                            color: ColorManager.green,
                                            fontSize: FontSize.s14),
                                      ),
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppPadding.p4),
                                  child: Text(
                                    _orderProvider.orderDetailsScreenOrder
                                                .paymentStatus ==
                                            PaymentStatus.PENDING
                                        ? 'Payment: Cash on delivery'
                                        : 'Payment: Completed',
                                    style: getBoldStyle(
                                        color: _orderProvider
                                                    .orderDetailsScreenOrder
                                                    .paymentStatus ==
                                                PaymentStatus.PENDING
                                            ? ColorManager.yellow
                                            : ColorManager.green,
                                        fontSize: FontSize.s14),
                                  ),
                                ),
                                SizedBox(
                                  height: AppHeight.h2,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              // ------------------------------------------------------ Complete payment start here ----------------------------------------------------
              if (_orderProvider.orderDetailsScreenOrder.paymentStatus ==
                  PaymentStatus.PENDING)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete payment',
                      style: TextStyle(
                        fontSize: FontSize.s20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.green,
                            fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width,
                            ),
                          ),
                          onPressed: () async {
                            if (await PaymentHelper.payWithEsewa()) {
                              setState(() {
                                _orderProvider.orderDetailsScreenOrder
                                    .paymentStatus = PaymentStatus.COMPLETE;
                              });
                              AlertHelper.showToastAlert(
                                  'Payment completed successfully');
                            }
                          },
                          child: Text("Pay with e-Sewa"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.purple,
                            fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width,
                            ),
                          ),
                          onPressed: () async {
                            if (await PaymentHelper.payWithKhalti(context)) {
                              setState(() {
                                _orderProvider.orderDetailsScreenOrder
                                    .paymentStatus = PaymentStatus.COMPLETE;
                              });
                              AlertHelper.showToastAlert(
                                  'Payment completed successfully');
                            }
                          },
                          child: Text("Pay with Khalti"),
                        ),
                      ]),
                    ),
                  ],
                ),
              // ------------------------------------------------------ Complete payment ends here ----------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}
