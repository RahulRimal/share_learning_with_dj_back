import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/order.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import '../../models/book.dart';
import '../../models/order_item.dart';
import '../../providers/books.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = 'order-details-screen';
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    Order order = args['order'];
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
                order.items.length > 1 ? 'Ordered books' : 'Ordered book',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // ------------------------------------------------------ Order items start here ----------------------------------------------------
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    Books booksProvider =
                        Provider.of<Books>(context, listen: false);
                    OrderItem _orderItem = order.items[index];
                    Book orderedBook = booksProvider.books.firstWhere(
                      (book) => book.id == _orderItem.productId.toString(),
                      orElse: () {
                        return booksProvider
                            .getBookById(_orderItem.productId.toString());
                      },
                    );
                    return Container(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      "${order.billingInfo!['first_name']} ${order.billingInfo!['last_name']} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      // '123 Main St',
                      "${order.deliveryInfo!['address']}",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      // 'Anytown, USA 12345',
                      "${order.billingInfo!['email']}, ${order.billingInfo!['phone']}",
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
                          "${order.billingInfo!['convenient_location']}",
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
                          "${order.deliveryInfo!['method'] == 'S' ? 'Standard' : 'Emergency'}",

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
                          'Order placed on ${DateFormat('d MMMM y').format(order.placedAt)}',
                          style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s16),
                        ),
                      ),
                      subtitle: (order.deliveryInfo != null &&
                              order.deliveryInfo!['status'] == 'T')
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppPadding.p4),
                                      child: Text(
                                        'Delivering on ${DateFormat('d MMMM y').format(DateTime.parse(order.deliveryInfo!['expected_delivery_date']))}',
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
                                    order.paymentStatus == PaymentStatus.PENDING
                                        ? 'Payment: Cash on delivery'
                                        : 'Payment: Completed',
                                    style: getBoldStyle(
                                        color: order.paymentStatus ==
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

                                        'Delivered on ${DateFormat('d MMMM y').format(DateTime.parse(order.deliveryInfo!['expected_delivery_date']))}',
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
                                    order.paymentStatus == PaymentStatus.PENDING
                                        ? 'Payment: Cash on delivery'
                                        : 'Payment: Completed',
                                    style: getBoldStyle(
                                        color: order.paymentStatus ==
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
            ],
          ),
        ),
      ),
    );
  }
}
