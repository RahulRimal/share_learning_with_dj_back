// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:share_learning/models/book.dart';
// import 'package:share_learning/models/order_item.dart';
// import 'package:share_learning/models/session.dart';
// import 'package:share_learning/view_models/providers/order_provider.dart';
// import 'package:share_learning/templates/managers/color_manager.dart';
// import 'package:share_learning/templates/managers/values_manager.dart';

// import '../../view_models/providers/book_provider.dart';

// class OrderItemWidget extends StatefulWidget {
//   const OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);

//   final OrderItem orderItem;

//   @override
//   State<OrderItemWidget> createState() => _OrderItemWidgetState();
// }

// class _OrderItemWidgetState extends State<OrderItemWidget>
//     with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     OrderProvider ordersProvider =
//         Provider.of<OrderProvider>(context, listen: false);

//     ordersProvider.bindOrdersItemWidgetViewModel(context, widget.orderItem);

//     // Register this object as an observer
//     WidgetsBinding.instance.addObserver(this);
//     // WidgetsBinding.instance.addObserver(this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ordersProvider.orderItemWidgetGetOrdersItemBook(
//           widget.orderItem.productId.toString());
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     Provider.of<OrderProvider>(context, listen: false)
//         .unbindOrdersItemWidgetViewModel();
//     // Unregister this object as an observer
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     OrderProvider _orderProvider = context.watch<OrderProvider>();

//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: _orderProvider.orders.length,
//       itemBuilder: (context, index) {
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: _orderProvider.orders[index].items.length,
//           itemBuilder: (context, idx) {
//             final OrderItem orderedItem =
//                 _orderProvider.orders[index].items[idx];
//             // return FutureBuilder(
//             //   future: _orderProvider.bookProvider.getBookByIdFromServer(
//             //       _orderProvider.sessionProvider.session as Session,
//             //       orderedItem.productId.toString()),
//             //   builder: (context, snapshot) {
//             //     if (snapshot.connectionState == ConnectionState.waiting) {
//             //       return Center(
//             //         child: CircularProgressIndicator(),
//             //       );
//             //     } else {
//             //       if (snapshot.hasError) {
//             //         return Center(
//             //           child: Text('Something went wrong'),
//             //         );
//             //       } else {
//             //         if (snapshot.data is Book) {
//             //           final Book orderedBook = snapshot.data as Book;
//             //           return Container(
//             //             margin: EdgeInsets.all(AppMargin.m8),
//             //             decoration: BoxDecoration(
//             //               color: ColorManager.white,
//             //               borderRadius: BorderRadius.circular(
//             //                 5.00,
//             //               ),
//             //               border: Border.all(
//             //                 color: ColorManager.primary,
//             //                 width: 1.00,
//             //               ),
//             //             ),
//             //             child: Column(
//             //               children: [
//             //                 Row(
//             //                   crossAxisAlignment: CrossAxisAlignment.center,
//             //                   mainAxisSize: MainAxisSize.max,
//             //                   children: [
//             //                     Padding(
//             //                       padding: EdgeInsets.only(
//             //                         left: 16.00,
//             //                         top: 16.00,
//             //                         bottom: 16.00,
//             //                       ),
//             //                       child: Image.network(
//             //                         'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
//             //                         width: 100.0,
//             //                         height: 100.0,
//             //                       ),
//             //                     ),
//             //                     Padding(
//             //                       padding: EdgeInsets.only(
//             //                         left: 12.00,
//             //                         top: 16.00,
//             //                         right: 16.00,
//             //                         bottom: 15.00,
//             //                       ),
//             //                       child: Column(
//             //                         mainAxisSize: MainAxisSize.min,
//             //                         crossAxisAlignment:
//             //                             CrossAxisAlignment.start,
//             //                         mainAxisAlignment: MainAxisAlignment.start,
//             //                         children: [
//             //                           Container(
//             //                             width: 227.00,
//             //                             child: Row(
//             //                               mainAxisAlignment:
//             //                                   MainAxisAlignment.spaceBetween,
//             //                               crossAxisAlignment:
//             //                                   CrossAxisAlignment.start,
//             //                               mainAxisSize: MainAxisSize.max,
//             //                               children: [
//             //                                 Container(
//             //                                   width: 158.00,
//             //                                   child: Text(
//             //                                     orderedBook.bookName,
//             //                                     maxLines: null,
//             //                                     textAlign: TextAlign.left,
//             //                                     style: TextStyle(
//             //                                       color: Colors.indigo,
//             //                                       fontSize: 12,
//             //                                       fontFamily: 'Poppins',
//             //                                       fontWeight: FontWeight.w700,
//             //                                       letterSpacing: 0.50,
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                                 // Padding(
//             //                                 //   padding: EdgeInsets.only(
//             //                                 //     bottom: 12.00,
//             //                                 //   ),
//             //                                 //   child: Container(
//             //                                 //     height: 24.00,
//             //                                 //     width: 24.00,
//             //                                 //     child: IconButton(
//             //                                 //       icon: Icon(
//             //                                 //         _wishlisted
//             //                                 //             ? Icons.favorite
//             //                                 //             : Icons.favorite_border,
//             //                                 //         color: ColorManager.primary,
//             //                                 //       ),
//             //                                 //       onPressed: () {
//             //                                 //         _wishlisted = !_wishlisted;
//             //                                 //         _ifOrderItemChanged();
//             //                                 //         // _edittedItem.wishlisted =
//             //                                 //         //     _wishlisted;
//             //                                 //       },
//             //                                 //     ),
//             //                                 //   ),
//             //                                 // ),
//             //                                 Padding(
//             //                                   padding: EdgeInsets.only(
//             //                                     bottom: 12.00,
//             //                                   ),
//             //                                   child: Container(
//             //                                     child: Expanded(
//             //                                       // child: Text(
//             //                                       //   "Total: " +
//             //                                       //       orderedBook.price
//             //                                       //           .toString(),
//             //                                       // ),
//             //                                       child: Text(
//             //                                         orderedBook.price
//             //                                             .toString(),
//             //                                       ),
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                           Container(
//             //                             width: 227.00,
//             //                             margin: EdgeInsets.only(
//             //                               top: 17.00,
//             //                             ),
//             //                             child: Row(
//             //                               mainAxisAlignment:
//             //                                   MainAxisAlignment.spaceBetween,
//             //                               crossAxisAlignment:
//             //                                   CrossAxisAlignment.center,
//             //                               mainAxisSize: MainAxisSize.max,
//             //                               children: [
//             //                                 Padding(
//             //                                   padding: EdgeInsets.only(
//             //                                     top: 1.00,
//             //                                     bottom: 1.00,
//             //                                   ),
//             //                                   child: Text(
//             //                                     // "Rs. ${widget.orderItem. * widget.cartItem.bookCount}",
//             //                                     "Rs. ${_orderProvider.ordersItemWidgetEdittedItem.quantity * orderedBook.price}",
//             //                                     overflow: TextOverflow.ellipsis,
//             //                                     textAlign: TextAlign.left,
//             //                                     style: TextStyle(
//             //                                       color: Colors.lightBlue,
//             //                                       fontSize: 12,
//             //                                       fontFamily: 'Poppins',
//             //                                       fontWeight: FontWeight.w700,
//             //                                       letterSpacing: 0.50,
//             //                                     ),
//             //                                   ),
//             //                                 ),
//             //                                 Container(
//             //                                   child: Text(
//             //                                       "Quantity: ${_orderProvider.ordersItemWidgetEdittedItem.quantity}"),
//             //                                 ),
//             //                               ],
//             //                             ),
//             //                           ),
//             //                         ],
//             //                       ),
//             //                     ),
//             //                   ],
//             //                 ),
//             //                 // _orderItemChanged
//             //                 //     ? ElevatedButton(
//             //                 //         onPressed: () => _updatePost(
//             //                 //             authendicatedSession, _edittedItem),
//             //                 //         child: Text('Update Order'))
//             //                 //     : Container(),
//             //               ],
//             //             ),
//             //           );
//             //           // } else if (snapshot.data is OrderError) {
//             //           //   Center(
//             //           //       child: Container(
//             //           //     child: Text(
//             //           //         (snapshot.data as OrderError).message.toString()),
//             //           //   ));
//             //           // }
//             //         } else if (snapshot.data is OrderItemError) {
//             //           Center(
//             //               child: Container(
//             //             child: Text((snapshot.data as OrderItemError)
//             //                 .message
//             //                 .toString()),
//             //           ));
//             //         }
//             //         return Container();
//             //       }
//             //     }
//             //   },
//             // );
//             return Container(
//               margin: EdgeInsets.all(AppMargin.m8),
//               decoration: BoxDecoration(
//                 color: ColorManager.white,
//                 borderRadius: BorderRadius.circular(
//                   5.00,
//                 ),
//                 border: Border.all(
//                   color: ColorManager.primary,
//                   width: 1.00,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 16.00,
//                           top: 16.00,
//                           bottom: 16.00,
//                         ),
//                         child: Image.network(
//                           'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
//                           width: 100.0,
//                           height: 100.0,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 12.00,
//                           top: 16.00,
//                           right: 16.00,
//                           bottom: 15.00,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 227.00,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     width: 158.00,
//                                     child: Text(
//                                       _orderProvider
//                                           .ordersItemWidgetOrderItemBook!
//                                           .bookName,
//                                       maxLines: null,
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                         color: Colors.indigo,
//                                         fontSize: 12,
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w700,
//                                         letterSpacing: 0.50,
//                                       ),
//                                     ),
//                                   ),
//                                   // Padding(
//                                   //   padding: EdgeInsets.only(
//                                   //     bottom: 12.00,
//                                   //   ),
//                                   //   child: Container(
//                                   //     height: 24.00,
//                                   //     width: 24.00,
//                                   //     child: IconButton(
//                                   //       icon: Icon(
//                                   //         _wishlisted
//                                   //             ? Icons.favorite
//                                   //             : Icons.favorite_border,
//                                   //         color: ColorManager.primary,
//                                   //       ),
//                                   //       onPressed: () {
//                                   //         _wishlisted = !_wishlisted;
//                                   //         _ifOrderItemChanged();
//                                   //         // _edittedItem.wishlisted =
//                                   //         //     _wishlisted;
//                                   //       },
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       bottom: 12.00,
//                                     ),
//                                     child: Container(
//                                       child: Expanded(
//                                         child: Text(
//                                           _orderProvider
//                                               .ordersItemWidgetOrderItemBook!
//                                               .price
//                                               .toString(),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: 227.00,
//                               margin: EdgeInsets.only(
//                                 top: 17.00,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       top: 1.00,
//                                       bottom: 1.00,
//                                     ),
//                                     child: Text(
//                                       // "Rs. ${widget.orderItem. * widget.cartItem.bookCount}",
//                                       "Rs. ${_orderProvider.ordersItemWidgetEdittedItem.quantity * _orderProvider.ordersItemWidgetOrderItemBook.price}",
//                                       overflow: TextOverflow.ellipsis,
//                                       textAlign: TextAlign.left,
//                                       style: TextStyle(
//                                         color: Colors.lightBlue,
//                                         fontSize: 12,
//                                         fontFamily: 'Poppins',
//                                         fontWeight: FontWeight.w700,
//                                         letterSpacing: 0.50,
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     child: Text(
//                                         "Quantity: ${_orderProvider.ordersItemWidgetEdittedItem.quantity}"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   // _orderItemChanged
//                   //     ? ElevatedButton(
//                   //         onPressed: () => _updatePost(
//                   //             authendicatedSession, _edittedItem),
//                   //         child: Text('Update Order'))
//                   //     : Container(),
//                 ],
//               ),
//             );
//             // return FutureBuilder(
//             //   future: _orderProvider.bookProvider.getBookByIdFromServer(
//             //       _orderProvider.sessionProvider.session as Session,
//             //       orderedItem.productId.toString()),
//             //   builder: (context, snapshot) {
//             //     if (snapshot.connectionState == ConnectionState.waiting) {
//             //       return Center(
//             //         child: CircularProgressIndicator(),
//             //       );
//             //     } else {
//             //       if (snapshot.hasError) {
//             //         return Center(
//             //           child: Text('Something went wrong'),
//             //         );
//             //       } else {
//             //         if (snapshot.data is Book) {
//             //           final Book orderedBook = snapshot.data as Book;
//             //           return
//             //           // } else if (snapshot.data is OrderError) {
//             //           //   Center(
//             //           //       child: Container(
//             //           //     child: Text(
//             //           //         (snapshot.data as OrderError).message.toString()),
//             //           //   ));
//             //           // }
//             //         } else if (snapshot.data is OrderItemError) {
//             //           Center(
//             //               child: Container(
//             //             child: Text((snapshot.data as OrderItemError)
//             //                 .message
//             //                 .toString()),
//             //           ));
//             //         }
//             //         return Container();
//             //       }
//             //     }
//             //   },
//             // );
//           },
//         );
//       },
//     );
//   }
// }
