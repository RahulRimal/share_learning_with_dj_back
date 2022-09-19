import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/carts.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

class CartItem extends StatefulWidget {
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  final Cart cartItem;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  // bool _cartItemChanged = false;
  late bool _cartItemChanged;
  late int _quantity;
  late bool _wishlisted;
  late Cart _edittedItem;

  _ifCartItemChanged() {
    if (_quantity != widget.cartItem.bookCount) {
      setState(() {
        _cartItemChanged = true;
      });

      return;
    }
    if (_wishlisted != widget.cartItem.wishlisted) {
      setState(() {
        _cartItemChanged = true;
      });
      return;
    }
    setState(() {
      _cartItemChanged = false;
    });
  }

  @override
  void initState() {
    _edittedItem = widget.cartItem;
    _cartItemChanged = false;
    _quantity = widget.cartItem.bookCount;
    _wishlisted = widget.cartItem.wishlisted;
    super.initState();
  }

  Future<bool> _updatePost(
      Session loggedInUserSession, Cart edittedItem) async {
    _edittedItem.bookCount = _quantity;
    _edittedItem.wishlisted = _wishlisted;

    await Provider.of<Carts>(context, listen: false)
        .updateCartItem(loggedInUserSession, edittedItem)
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
          _cartItemChanged = false;
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

  _deleteCartItem(Session userSession, String cartId) async {
    print(cartId);
    await Provider.of<Carts>(context, listen: false)
        .deleteCartItem(userSession, cartId)
        .then(
      (value) {
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final Session authendicatedSession = args['loggedInUserSession'] as Session;

    Carts _carts = context.watch<Carts>();

    return FutureBuilder(
        future: _carts.getCartItemBook(
            authendicatedSession, widget.cartItem.bookId),
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
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 12.00,
                                        ),
                                        child: Container(
                                          height: 24.00,
                                          width: 24.00,
                                          child: IconButton(
                                            icon: Icon(
                                              _wishlisted
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: ColorManager.primary,
                                            ),
                                            onPressed: () {
                                              _wishlisted = !_wishlisted;
                                              _ifCartItemChanged();
                                              // _edittedItem.wishlisted =
                                              //     _wishlisted;
                                            },
                                          ),
                                        ),
                                      ),
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
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text(
                                                    'This will remove the item from  your cart',
                                                    style: getRegularStyle(
                                                      fontSize: FontSize.s16,
                                                      color: ColorManager.black,
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Yes',
                                                        style: getBoldStyle(
                                                          fontSize:
                                                              FontSize.s16,
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
                                                          fontSize:
                                                              FontSize.s16,
                                                          // color: ColorManager.primary,
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
                                              ).then((_) {
                                                if (userConfirmed) {
                                                  _deleteCartItem(
                                                    authendicatedSession,
                                                    widget.cartItem.id,
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
                                          "Rs. ${widget.cartItem.pricePerPiece * widget.cartItem.bookCount}",
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
                                            IconButton(
                                              color: Colors.black,
                                              onPressed: _quantity < 2
                                                  ? null
                                                  : () {
                                                      _quantity--;
                                                      _ifCartItemChanged();

                                                      // _edittedItem.bookCount =
                                                      //     _quantity;
                                                    },
                                              icon: Container(
                                                width: AppSize.s40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.black,
                                                ),
                                                child: Text(
                                                  '-',
                                                  style: getBoldStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s20),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              // '1',
                                              _quantity.toString(),
                                              style: getBoldStyle(
                                                color: ColorManager.primary,
                                                fontSize: FontSize.s20,
                                              ),
                                            ),
                                            IconButton(
                                              // color: ColorManager.primary,
                                              color: Colors.black,
                                              // onPressed: () {},
                                              // icon: Icon(
                                              //   Icons.miscellaneous_services,
                                              // ),
                                              // onPressed: _incrementQuantity(),
                                              onPressed: () {
                                                _quantity++;
                                                _ifCartItemChanged();

                                                // _edittedItem.bookCount =
                                                //     _quantity;
                                              },

                                              icon: Container(
                                                width: AppSize.s40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: ColorManager.black,
                                                ),
                                                child: Text(
                                                  '+',
                                                  style: getBoldStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s17),
                                                ),
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
                          ),
                        ],
                      ),
                      _cartItemChanged
                          ? ElevatedButton(
                              onPressed: () => _updatePost(
                                  authendicatedSession, _edittedItem),
                              child: Text('Update Cart'))
                          : Container(),
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
