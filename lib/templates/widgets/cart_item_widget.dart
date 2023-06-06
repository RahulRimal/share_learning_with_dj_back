import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/cart_item.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'dart:math' as math;

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

  // late AnimationController _controller;
  // late Animation<double> _opacityAnimation;

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

    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 300),
    //   vsync: this,
    // );
    // if (_cartItemChanged.value) {
    //   _controller.forward();
    // } else {
    //   _controller.reverse();
    // }
    // _opacityAnimation =
    //     Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  Future<bool> _updateCartItem(Cart cart, CartItem edittedItem) async {
    _edittedItem.quantity = _quantity.value;
    // _edittedItem.wishlisted = _wishlisted;

    await Provider.of<Carts>(context, listen: false)
        .updateCartItem(cart.id, edittedItem)
        .then(
      (value) {
        if (value) {
          BotToast.showSimpleNotification(
            title: 'Cart Item updated',
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            // align: Alignment(0, 0),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
          _cartItemChanged.value = false;
        } else
          BotToast.showSimpleNotification(
            title: "Something went wrong, Please try again!",
            duration: Duration(seconds: 3),
            backgroundColor: ColorManager.primary,
            titleStyle: getBoldStyle(color: ColorManager.white),
            align: Alignment(-1, -1),
            hideCloseButton: true,
          );
      },
    );

    return true;
  }

  _deleteCartItem(Session userSession, String cartId, String cartItemId) async {
    bool value = await Provider.of<Carts>(context, listen: false)
        .deleteCartItem(userSession, cartId, cartItemId);
    if (value) {
      BotToast.showSimpleNotification(
        title: 'Book deleted from the cart',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
    } else
      BotToast.showSimpleNotification(
        title: 'Something went wrong, Please try again!',
        duration: Duration(seconds: 3),
        backgroundColor: ColorManager.primary,
        titleStyle: getBoldStyle(color: ColorManager.white),
        align: Alignment(-1, -1),
        hideCloseButton: true,
      );
  }

  // _deleteCartItem(Session userSession, String cartId, String cartItemId) async {
  //   await Provider.of<Carts>(context, listen: false)
  //       .deleteCartItem(userSession, cartId, cartItemId)
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
    // final args = ModalRoute.of(context)!.settings.arguments as Map;

    // final Session authendicatedSession = args['loggedInUserSession'] as Session;

    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    Carts _carts = context.watch<Carts>();

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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      //         _ifCartItemChanged();
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
                                          height: 24.00,
                                          width: 24.00,
                                          child: IconButton(
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
                                                    const Duration(
                                                        milliseconds: 300),
                                                transitionBuilder:
                                                    (ctx, a1, a2, child) {
                                                  var curve = Curves.easeInOut
                                                      .transform(a1.value);
                                                  return Transform.scale(
                                                    scale: curve,
                                                    child: AlertDialog(
                                                      title:
                                                          Text('Are you sure?'),
                                                      content: Text(
                                                        'This will remove the item from  your cart',
                                                        style: getRegularStyle(
                                                          fontSize:
                                                              FontSize.s16,
                                                          color: ColorManager
                                                              .black,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            'Yes',
                                                            style: getBoldStyle(
                                                              fontSize:
                                                                  FontSize.s16,
                                                              color:
                                                                  ColorManager
                                                                      .primary,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            userConfirmed =
                                                                true;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                            'No',
                                                            style: getBoldStyle(
                                                              fontSize:
                                                                  FontSize.s16,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
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
                                                    Provider.of<Carts>(context,
                                                            listen: false)
                                                        .cart!
                                                        .id,
                                                    widget.cartItem.id
                                                        .toString(),
                                                  );
                                                }
                                              });
                                            },
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
                                          "Rs. ${widget.cartItem.totalPrice}",
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
                                                    width: AppSize.s40,
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
                                                        color: ColorManager
                                                            .primary,
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
                                                    width: AppSize.s40,
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
                            padding: EdgeInsets.only(
                              bottom: AppPadding.p8,
                            ),
                            duration: const Duration(
                                milliseconds:
                                    200), // Adjust the duration as needed
                            curve:
                                Curves.easeInOut, // Adjust the curve as desired
                            height: itemChanged
                                ? AppHeight.h50
                                : 0, // Define the desired height when visible or hidden
                            child: ElevatedButton(
                              onPressed: () => _updateCartItem(
                                Provider.of<Carts>(context, listen: false).cart
                                    as Cart,
                                _edittedItem,
                              ),
                              child: Text('Update Cart'),
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
