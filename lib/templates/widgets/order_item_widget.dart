import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/order_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import '../../view_models/book_provider.dart';

class OrderItemWidget extends StatefulWidget {
  const OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);

  final OrderItem orderItem;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  // late bool _orderItemChanged;
  // late int _quantity;
  late OrderItem _edittedItem;

  // _ifOrderItemChanged() {
  //   if (_quantity != widget.orderItem.quantity) {
  //     setState(() {
  //       _orderItemChanged = true;
  //     });

  //     return;
  //   }

  //   setState(() {
  //     _orderItemChanged = false;
  //   });
  // }

  @override
  void initState() {
    _edittedItem = widget.orderItem;
    // _orderItemChanged = false;
    // _quantity = widget.orderItem.quantity;

    super.initState();
  }

  // Future<bool> _updatePost(
  //     Session loggedInUserSession, OrderItem edittedItem) async {
  //   _edittedItem.quantity = _quantity;
  //   // _edittedItem.wishlisted = _wishlisted;

  //   await Provider.of<Carts>(context, listen: false)
  //       .updateCartItem(loggedInUserSession, edittedItem)
  //       .then(
  //     (value) {
  //       if (value) {
  //         BotToast.showSimpleNotification(
  //           title: 'Cart Item updated',
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           // align: Alignment(0, 0),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //         _orderItemChanged = false;
  //       } else
  //         BotToast.showSimpleNotification(
  //           title: "Something went wrong, Please try again!",
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //     },
  //   );

  //   return true;
  // }

  // _deleteCartItem(Session userSession, String cartId) async {
  //   print(cartId);
  //   await Provider.of<Carts>(context, listen: false)
  //       .deleteCartItem(userSession, cartId)
  //       .then(
  //     (value) {
  //       if (value) {
  //         BotToast.showSimpleNotification(
  //           title: 'Book deleted from the cart',
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //       } else
  //         BotToast.showSimpleNotification(
  //           title: 'Something went wrong, Please try again!',
  //           duration: Duration(seconds: 3),
  //           backgroundColor: ColorManager.primary,
  //           titleStyle: getBoldStyle(color: ColorManager.white),
  //           align: Alignment(-1, -1),
  //           hideCloseButton: true,
  //         );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final Session authendicatedSession = args['loggedInUserSession'] as Session;

    OrderProvider _orders = context.watch<OrderProvider>();
    BookProvider _books = context.watch<BookProvider>();

    // return FutureBuilder(
    //     future: _orders.getOrderFromId(
    //         authendicatedSession, widget.orderItem.productId),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else {
    //         if (snapshot.hasError) {
    //           return Center(
    //             child: Text('Something went wrong'),
    //           );
    //         } else {
    //           if (snapshot.data is Book) {
    //             final Book orderedBook = snapshot.data as Book;
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
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 children: [
    //                                   Container(
    //                                     width: 158.00,
    //                                     child: Text(
    //                                       orderedBook.bookName,
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
    //                                   Padding(
    //                                     padding: EdgeInsets.only(
    //                                       bottom: 12.00,
    //                                     ),
    //                                     child: Container(
    //                                       height: 24.00,
    //                                       width: 24.00,
    //                                       child: IconButton(
    //                                         icon: Icon(
    //                                           _wishlisted
    //                                               ? Icons.favorite
    //                                               : Icons.favorite_border,
    //                                           color: ColorManager.primary,
    //                                         ),
    //                                         onPressed: () {
    //                                           _wishlisted = !_wishlisted;
    //                                           _ifOrderItemChanged();
    //                                           // _edittedItem.wishlisted =
    //                                           //     _wishlisted;
    //                                         },
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding: EdgeInsets.only(
    //                                       bottom: 12.00,
    //                                     ),
    //                                     child: Container(
    //                                       height: 24.00,
    //                                       width: 24.00,
    //                                       child: IconButton(
    //                                         icon: Icon(Icons.delete),
    //                                         onPressed: () {
    //                                           bool userConfirmed = false;
    //                                           showDialog(
    //                                             context: context,
    //                                             builder: (context) =>
    //                                                 AlertDialog(
    //                                               title: Text('Are you sure?'),
    //                                               content: Text(
    //                                                 'This will remove the item from  your cart',
    //                                                 style: getRegularStyle(
    //                                                   fontSize: FontSize.s16,
    //                                                   color: ColorManager.black,
    //                                                 ),
    //                                               ),
    //                                               actions: [
    //                                                 TextButton(
    //                                                   child: Text(
    //                                                     'Yes',
    //                                                     style: getBoldStyle(
    //                                                       fontSize:
    //                                                           FontSize.s16,
    //                                                       color: ColorManager
    //                                                           .primary,
    //                                                     ),
    //                                                   ),
    //                                                   onPressed: () {
    //                                                     userConfirmed = true;
    //                                                     Navigator.of(context)
    //                                                         .pop();
    //                                                   },
    //                                                 ),
    //                                                 TextButton(
    //                                                   child: Text(
    //                                                     'No',
    //                                                     style: getBoldStyle(
    //                                                       fontSize:
    //                                                           FontSize.s16,
    //                                                       // color: ColorManager.primary,
    //                                                       color: Colors.green,
    //                                                     ),
    //                                                   ),
    //                                                   onPressed: () {
    //                                                     Navigator.of(context)
    //                                                         .pop();
    //                                                   },
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ).then((_) {
    //                                             if (userConfirmed) {
    //                                               // _deleteCartItem(
    //                                               //   authendicatedSession,
    //                                               //   widget.cartItem.id,
    //                                               // );
    //                                             }
    //                                           });
    //                                         },
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
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 children: [
    //                                   Padding(
    //                                     padding: EdgeInsets.only(
    //                                       top: 1.00,
    //                                       bottom: 1.00,
    //                                     ),
    //                                     child: Text(
    //                                       // "Rs. ${widget.orderItem. * widget.cartItem.bookCount}",
    //                                       "test rupees",
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
    //                                     child: ButtonBar(
    //                                       children: [
    //                                         IconButton(
    //                                           color: Colors.black,
    //                                           onPressed: _quantity < 2
    //                                               ? null
    //                                               : () {
    //                                                   _quantity--;
    //                                                   _ifOrderItemChanged();
    //                                                   // _edittedItem.bookCount =
    //                                                   //     _quantity;
    //                                                 },
    //                                           icon: Container(
    //                                             width: AppSize.s40,
    //                                             alignment: Alignment.center,
    //                                             decoration: BoxDecoration(
    //                                               color: ColorManager.black,
    //                                             ),
    //                                             child: Text(
    //                                               '-',
    //                                               style: getBoldStyle(
    //                                                   color: ColorManager.white,
    //                                                   fontSize: FontSize.s20),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         Text(
    //                                           // '1',
    //                                           _quantity.toString(),
    //                                           style: getBoldStyle(
    //                                             color: ColorManager.primary,
    //                                             fontSize: FontSize.s20,
    //                                           ),
    //                                         ),
    //                                         IconButton(
    //                                           // color: ColorManager.primary,
    //                                           color: Colors.black,
    //                                           // onPressed: () {},
    //                                           // icon: Icon(
    //                                           //   Icons.miscellaneous_services,
    //                                           // ),
    //                                           // onPressed: _incrementQuantity(),
    //                                           onPressed: () {
    //                                             _quantity++;
    //                                             _ifOrderItemChanged();
    //                                             // _edittedItem.bookCount =
    //                                             //     _quantity;
    //                                           },
    //                                           icon: Container(
    //                                             width: AppSize.s40,
    //                                             alignment: Alignment.center,
    //                                             decoration: BoxDecoration(
    //                                               color: ColorManager.black,
    //                                             ),
    //                                             child: Text(
    //                                               '+',
    //                                               style: getBoldStyle(
    //                                                   color: ColorManager.white,
    //                                                   fontSize: FontSize.s17),
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
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
    //           } else if (snapshot.data is OrderError) {
    //             Center(
    //                 child: Container(
    //               child: Text((snapshot.data as OrderError).message.toString()),
    //             ));
    //           }
    //           return Container();
    //         }
    //       }
    //     });

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orders.orders.length,
      itemBuilder: (context, index) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _orders.orders[index].items.length,
          itemBuilder: (context, idx) {
            final OrderItem orderedItem = _orders.orders[index].items[idx];
            return FutureBuilder(
              future: _books.getBookByIdFromServer(
                  authendicatedSession, orderedItem.productId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    if (snapshot.data is Book) {
                      final Book orderedBook = snapshot.data as Book;
                      return Container(
                        margin: EdgeInsets.all(AppMargin.m8),
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(
                            5.00,
                          ),
                          border: Border.all(
                            color: ColorManager.primary,
                            width: 1.00,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.00,
                                    top: 16.00,
                                    bottom: 16.00,
                                  ),
                                  child: Image.network(
                                    // orderedBook.pictures![0],
                                    'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 12.00,
                                    top: 16.00,
                                    right: 16.00,
                                    bottom: 15.00,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 227.00,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              width: 158.00,
                                              child: Text(
                                                orderedBook.bookName,
                                                maxLines: null,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.indigo,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(
                                            //     bottom: 12.00,
                                            //   ),
                                            //   child: Container(
                                            //     height: 24.00,
                                            //     width: 24.00,
                                            //     child: IconButton(
                                            //       icon: Icon(
                                            //         _wishlisted
                                            //             ? Icons.favorite
                                            //             : Icons.favorite_border,
                                            //         color: ColorManager.primary,
                                            //       ),
                                            //       onPressed: () {
                                            //         _wishlisted = !_wishlisted;
                                            //         _ifOrderItemChanged();
                                            //         // _edittedItem.wishlisted =
                                            //         //     _wishlisted;
                                            //       },
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 12.00,
                                              ),
                                              child: Container(
                                                child: Expanded(
                                                  // child: Text(
                                                  //   "Total: " +
                                                  //       orderedBook.price
                                                  //           .toString(),
                                                  // ),
                                                  child: Text(
                                                    orderedBook.price
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 227.00,
                                        margin: EdgeInsets.only(
                                          top: 17.00,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 1.00,
                                                bottom: 1.00,
                                              ),
                                              child: Text(
                                                // "Rs. ${widget.orderItem. * widget.cartItem.bookCount}",
                                                "Rs. ${_edittedItem.quantity * orderedBook.price}",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightBlue,
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.50,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                  "Quantity: ${_edittedItem.quantity}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // _orderItemChanged
                            //     ? ElevatedButton(
                            //         onPressed: () => _updatePost(
                            //             authendicatedSession, _edittedItem),
                            //         child: Text('Update Order'))
                            //     : Container(),
                          ],
                        ),
                      );
                      // } else if (snapshot.data is OrderError) {
                      //   Center(
                      //       child: Container(
                      //     child: Text(
                      //         (snapshot.data as OrderError).message.toString()),
                      //   ));
                      // }
                    } else if (snapshot.data is OrderItemError) {
                      Center(
                          child: Container(
                        child: Text((snapshot.data as OrderItemError)
                            .message
                            .toString()),
                      ));
                    }
                    return Container();
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
