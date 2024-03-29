import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/cart_item.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/cart_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import 'package:share_learning/templates/utils/alert_helper.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  final CartItem cartItem;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  // with TickerProviderStateMixin {
  late ValueNotifier<bool> _cartItemChanged;
  late ValueNotifier<int> _quantity;
  late CartItem _edittedItem;

  _ifCartItemChanged() {
    if (_quantity.value != widget.cartItem.quantity) {
      _cartItemChanged.value = true;
      return;
    }

    _cartItemChanged.value = false;
  }

  @override
  void initState() {
    _edittedItem = widget.cartItem;
    _cartItemChanged = ValueNotifier<bool>(false);
    _quantity = ValueNotifier<int>(widget.cartItem.quantity);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _updateCartItem(Cart cart, CartItem edittedItem) async {
    _edittedItem.quantity = _quantity.value;

    await Provider.of<CartProvider>(context, listen: false)
        .updateCartItem(cart.id, edittedItem)
        .then(
      (value) {
        if (value) {
          AlertHelper.showToastAlert('Cart Item updated');

          _cartItemChanged.value = false;
        } else
          AlertHelper.showToastAlert("Something went wrong, Please try again!");
      },
    );

    return true;
  }

  _deleteCartItem(Session userSession, String cartId, String cartItemId) async {
    bool value = await Provider.of<CartProvider>(context, listen: false)
        .deleteCartItem(userSession, cartId, cartItemId);
    if (value) {
      AlertHelper.showToastAlert('Book deleted from the cart');
    } else
      AlertHelper.showToastAlert('Something went wrong, Please try again!');
  }

  @override
  Widget build(BuildContext context) {
    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    CartProvider _carts = context.watch<CartProvider>();
    ThemeData _theme = Theme.of(context);

    return FutureBuilder(
        future: _carts.getCartItemBook(
            authendicatedSession, widget.cartItem.product.id.toString()),
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
                  padding: EdgeInsets.all(AppPadding.p8),
                  decoration: BoxDecoration(
                    // color: ColorManager.white,
                    color: _theme.colorScheme.secondary,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: AppPadding.p12),
                            child: Image.network(
                              // 'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
                              orderedBook.images![0].image,
                              width: 20.w,

                              // height: 100.0,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        orderedBook.bookName,
                                        maxLines: null,
                                        textAlign: TextAlign.left,
                                        // style: TextStyle(
                                        //   color: Colors.indigo,
                                        //   fontSize: 12,
                                        //   fontFamily: 'Poppins',
                                        //   fontWeight: FontWeight.w700,
                                        //   letterSpacing: 0.50,
                                        // ),
                                        style: _theme.textTheme.headlineMedium,
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
                                    //         _ifCartItemChanged();
                                    //         // _edittedItem.wishlisted =
                                    //         //     _wishlisted;
                                    //       },
                                    //     ),
                                    //   ),
                                    // ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        bool userConfirmed = false;
                                        showGeneralDialog(
                                          barrierDismissible: true,
                                          barrierLabel:
                                              'Delete cart item dilaog dismissed',
                                          context: context,
                                          pageBuilder: (ctx, a1, a2) {
                                            return Container();
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          transitionBuilder:
                                              (ctx, a1, a2, child) {
                                            var curve = Curves.easeInOut
                                                .transform(a1.value);
                                            return Transform.scale(
                                              scale: curve,
                                              child: AlertDialog(
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                  'This will remove the item from  your cart',
                                                  // style: getRegularStyle(
                                                  //   fontSize: FontSize.s16,
                                                  //   color: ColorManager.black,
                                                  // ),
                                                  style: _theme
                                                      .textTheme.bodyMedium,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Yes',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s16,
                                                        color: ColorManager
                                                            .primary,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      userConfirmed = true;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'No',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s16,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).then((_) {
                                          if (userConfirmed) {
                                            _deleteCartItem(
                                              authendicatedSession,
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .cart!
                                                  .id,
                                              widget.cartItem.id.toString(),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Unit Price",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: ColorManager.black,
                                          //   fontSize: FontSize.s12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          "Rs. ${widget.cartItem.totalPrice}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: Colors.lightBlue,
                                          //   fontSize: 12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: ButtonBar(
                                        children: [
                                          ValueListenableBuilder<int>(
                                            valueListenable: _quantity,
                                            builder: (BuildContext context,
                                                int value, Widget? child) {
                                              return IconButton(
                                                color: Colors.black,
                                                onPressed: _quantity.value > 1
                                                    ? () {
                                                        _quantity.value--;
                                                        _ifCartItemChanged();
                                                      }
                                                    : null,
                                                icon: Container(
                                                  // width: AppSize.s40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: ColorManager.black,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: ColorManager.white,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: _quantity,
                                            builder: (BuildContext context,
                                                int quantity, Widget? child) {
                                              return AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  child: Text(
                                                    quantity.toString(),
                                                    key: ValueKey(quantity),
                                                    style: getBoldStyle(
                                                      color:
                                                          ColorManager.primary,
                                                      fontSize: FontSize.s20,
                                                    ),
                                                  ),
                                                  transitionBuilder:
                                                      (Widget child,
                                                          Animation<double>
                                                              animation) {
                                                    return ScaleTransition(
                                                        scale: animation,
                                                        child: child);
                                                  });
                                            },
                                          ),
                                          ValueListenableBuilder<int>(
                                            valueListenable: _quantity,
                                            builder: (BuildContext context,
                                                int value, Widget? child) {
                                              return IconButton(
                                                color: ColorManager.white,
                                                onPressed:
                                                    orderedBook.bookCount >
                                                            _quantity.value
                                                        ? () {
                                                            _quantity.value++;
                                                            // ValueNotifier(
                                                            //     _quantity.value++);
                                                            _ifCartItemChanged();
                                                          }
                                                        : null,
                                                icon: Container(
                                                  // width: AppSize.s40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: ColorManager.black,
                                                  ),
                                                  child: Icon(Icons.add),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: _cartItemChanged,
                        builder: (BuildContext context, bool itemChanged,
                            Widget? child) {
                          return AnimatedContainer(
                            duration: const Duration(
                                milliseconds:
                                    200), // Adjust the duration as needed
                            curve:
                                Curves.easeInOut, // Adjust the curve as desired
                            height: itemChanged
                                ? AppHeight.h40
                                : 0, // Define the desired height when visible or hidden
                            child: ElevatedButton(
                              onPressed: () => _updateCartItem(
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .cart as Cart,
                                _edittedItem,
                              ),
                              child: Text(
                                'Update Cart',
                                style: _theme.textTheme.headlineSmall,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else if (snapshot.data is CartError) {
                Center(
                    child: Container(
                  child: Text((snapshot.data as CartError).message.toString()),
                ));
              }
              return Container();
            }
          }
        });
  }
}


// ===================================================================== Cart Item widget with mvvm applied starts form here==============================================================

// class CartItemWidget extends StatefulWidget {
//   const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

//   final CartItem cartItem;

//   @override
//   State<CartItemWidget> createState() => _CartItemWidgetState();
// }

// class _CartItemWidgetState extends State<CartItemWidget> {
  

//   @override
//   void initState() {
//     super.initState();
//     Provider.of<CartProvider>(context,listen: false).bindCartItemWidgetViewModel(context, widget.cartItem);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     Provider.of<CartProvider>(context,listen: false).unbindCartItemWidgetViewModel();
//   }

  
//   @override
//   Widget build(BuildContext context) {

//     CartProvider _cartProvider = context.watch<CartProvider>();

//     return FutureBuilder(
//         future: _cartProvider.getCartItemBook(
//             _cartProvider.sessionProvider.session as Session, widget.cartItem.product.id.toString()),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text('Something went wrong'),
//               );
//             } else {
//               if (snapshot.data is Book) {
//                 final Book orderedBook = snapshot.data as Book;
//                 return Container(
//                   margin: EdgeInsets.all(AppMargin.m8),
//                   padding: EdgeInsets.all(AppPadding.p8),
//                   decoration: BoxDecoration(
//                     color: ColorManager.white,
//                     borderRadius: BorderRadius.circular(
//                       5.00,
//                     ),
//                     border: Border.all(
//                       color: ColorManager.primary,
//                       width: 1.00,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(right: AppPadding.p12),
//                             child: Image.network(
//                               // 'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
//                               orderedBook.images![0].image,
//                               width: 20.w,

//                               // height: 100.0,
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         orderedBook.bookName,
//                                         maxLines: null,
//                                         textAlign: TextAlign.left,
//                                         style: TextStyle(
//                                           color: Colors.indigo,
//                                           fontSize: 12,
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w700,
//                                           letterSpacing: 0.50,
//                                         ),
//                                       ),
//                                     ),
//                                     // Padding(
//                                     //   padding: EdgeInsets.only(
//                                     //     bottom: 12.00,
//                                     //   ),
//                                     //   child: Container(
//                                     //     height: 24.00,
//                                     //     width: 24.00,
//                                     //     child: IconButton(
//                                     //       icon: Icon(
//                                     //         _wishlisted
//                                     //             ? Icons.favorite
//                                     //             : Icons.favorite_border,
//                                     //         color: ColorManager.primary,
//                                     //       ),
//                                     //       onPressed: () {
//                                     //         _wishlisted = !_wishlisted;
//                                     //         _ifCartItemChanged();
//                                     //         // _edittedItem.wishlisted =
//                                     //         //     _wishlisted;
//                                     //       },
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                     IconButton(
//                                       icon: Icon(Icons.delete),
//                                       onPressed: () {
//                                         bool userConfirmed = false;
//                                         showGeneralDialog(
//                                           barrierDismissible: true,
//                                           barrierLabel:
//                                               'Delete cart item dilaog dismissed',
//                                           context: context,
//                                           pageBuilder: (ctx, a1, a2) {
//                                             return Container();
//                                           },
//                                           transitionDuration:
//                                               const Duration(milliseconds: 300),
//                                           transitionBuilder:
//                                               (ctx, a1, a2, child) {
//                                             var curve = Curves.easeInOut
//                                                 .transform(a1.value);
//                                             return Transform.scale(
//                                               scale: curve,
//                                               child: AlertDialog(
//                                                 title: Text('Are you sure?'),
//                                                 content: Text(
//                                                   'This will remove the item from  your cart',
//                                                   style: getRegularStyle(
//                                                     fontSize: FontSize.s16,
//                                                     color: ColorManager.black,
//                                                   ),
//                                                 ),
//                                                 actions: [
//                                                   TextButton(
//                                                     child: Text(
//                                                       'Yes',
//                                                       style: getBoldStyle(
//                                                         fontSize: FontSize.s16,
//                                                         color: ColorManager
//                                                             .primary,
//                                                       ),
//                                                     ),
//                                                     onPressed: () {
//                                                       userConfirmed = true;
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                   ),
//                                                   TextButton(
//                                                     child: Text(
//                                                       'No',
//                                                       style: getBoldStyle(
//                                                         fontSize: FontSize.s16,
//                                                         color: Colors.green,
//                                                       ),
//                                                     ),
//                                                     onPressed: () {
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ).then((_) {
//                                           if (userConfirmed) {
//                                             _cartProvider.removeItemFromCart(widget.cartItem
//                                             );
//                                           }
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Unit Price",
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.left,
//                                           style: TextStyle(
//                                             color: ColorManager.black,
//                                             fontSize: FontSize.s12,
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w700,
//                                             letterSpacing: 0.50,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Rs. ${widget.cartItem.totalPrice}",
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.left,
//                                           style: TextStyle(
//                                             color: Colors.lightBlue,
//                                             fontSize: 12,
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w700,
//                                             letterSpacing: 0.50,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Container(
//                                       child: ButtonBar(
//                                         children: [
//                                           ValueListenableBuilder<int>(
//                                             valueListenable: _cartProvider.quantity,
//                                             builder: (BuildContext context,
//                                                 int value, Widget? child) {
//                                               return IconButton(
//                                                 color: Colors.black,
//                                                 onPressed: _cartProvider.quantity.value > 1
//                                                     ? () {
//                                                         _cartProvider.quantity.value--;
//                                                       }
//                                                     : null,
//                                                 icon: Container(
//                                                   // width: AppSize.s40,
//                                                   alignment: Alignment.center,
//                                                   decoration: BoxDecoration(
//                                                     color: ColorManager.black,
//                                                   ),
//                                                   child: Icon(
//                                                     Icons.remove,
//                                                     color: ColorManager.white,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                           ValueListenableBuilder(
//                                             valueListenable: _cartProvider. quantity,
//                                             builder: (BuildContext context,
//                                                 int quantity, Widget? child) {
//                                               return AnimatedSwitcher(
//                                                   duration: const Duration(
//                                                       milliseconds: 200),
//                                                   child: Text(
//                                                     quantity.toString(),
//                                                     key: ValueKey(quantity),
//                                                     style: getBoldStyle(
//                                                       color:
//                                                           ColorManager.primary,
//                                                       fontSize: FontSize.s20,
//                                                     ),
//                                                   ),
//                                                   transitionBuilder:
//                                                       (Widget child,
//                                                           Animation<double>
//                                                               animation) {
//                                                     return ScaleTransition(
//                                                         scale: animation,
//                                                         child: child);
//                                                   });
//                                             },
//                                           ),
//                                           ValueListenableBuilder<int>(
//                                             valueListenable: _cartProvider. quantity,
//                                             builder: (BuildContext context,
//                                                 int value, Widget? child) {
//                                               return IconButton(
//                                                 color: ColorManager.white,
//                                                 onPressed:
//                                                     orderedBook.bookCount >
//                                                             _cartProvider. quantity.value
//                                                         ? () {
//                                                             _cartProvider. quantity.value++;
//                                                             // ValueNotifier(
//                                                             //     _quantity.value++);
//                                                             _cartProvider. ifCartItemChanged(widget.cartItem);
//                                                           }
//                                                         : null,
//                                                 icon: Container(
//                                                   // width: AppSize.s40,
//                                                   alignment: Alignment.center,
//                                                   decoration: BoxDecoration(
//                                                     color: ColorManager.black,
//                                                   ),
//                                                   child: Icon(Icons.add),
//                                                 ),
//                                               );
//                                             },
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       ValueListenableBuilder(
//                         valueListenable: _cartProvider.cartItemChanged,
//                         builder: (BuildContext context, bool itemChanged,
//                             Widget? child) {
//                           return AnimatedContainer(
//                             duration: const Duration(
//                                 milliseconds:
//                                     200), // Adjust the duration as needed
//                             curve:
//                                 Curves.easeInOut, // Adjust the curve as desired
//                             height: itemChanged
//                                 ? AppHeight.h40
//                                 : 0, // Define the desired height when visible or hidden
//                             child: ElevatedButton(
//                               onPressed: () => _cartProvider.updateItemOnTheCart(
//                               ),
//                               child: Text('Update Cart'),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (snapshot.data is CartError) {
//                 Center(
//                     child: Container(
//                   child: Text((snapshot.data as CartError).message.toString()),
//                 ));
//               }
//               return Container();
//             }
//           }
//         });
//   }
// }
