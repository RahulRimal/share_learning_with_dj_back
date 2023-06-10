import 'package:flutter/material.dart';
import 'package:share_learning/data/cart_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/cart_item.dart';
import 'package:share_learning/models/session.dart';

class CartProvider with ChangeNotifier {
  Cart? _cart;
  List<CartItem> _cartItems = [];

  bool _loading = false;
  CartError? _cartError;
  CartItemError? _cartItemError;

  Cart? get cart => _cart;

  List<CartItem> get cartItems => [..._cartItems];
  // List<CartItem> get cartItems {
  //   return [..._myCartItems];
  // }

  bool get loading => _loading;
  CartError? get cartError => _cartError;
  CartItemError? get cartItemError => _cartItemError;

  setCart(Cart? cart) {
    _cart = cart;
    // notifyListeners();
  }

  setCartItems(List<CartItem> cartItems) {
    _cartItems = cartItems;
    // notifyListeners();
  }

  setLoading(bool loading) async {
    _loading = loading;
    // notifyListeners();
  }

  setCartError(CartError cartError) {
    _cartError = cartError;
    // notifyListeners();
  }

  setCartItemError(CartItemError cartItemError) {
    _cartItemError = cartItemError;
    // notifyListeners();
  }

  CartItem getCartItemById(String cartItemId) {
    return _cartItems
        .firstWhere((cartItem) => cartItem.id == int.parse(cartItemId));
  }

  Future<Object> getCartItemBook(Session loggedInSession, String bookId) async {
    var response = await CartApi.getCartItemBook(loggedInSession, bookId);
    if (response is Success) {
      // List<Book> responseList = response.response as List<Book>;
      return response.response as Book;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      return _cartError as CartError;
    }
    // return null;
    CartError cartError = CartError(
      code: (response as CartError).code,
      message: (response).message,
      // message: (response as CartError).message,
    );
    setCartError(cartError);
    return _cartError as CartError;
  }

  Future<bool> createCart(Session currentSession) async {
    var response = await CartApi.createCart(currentSession);

    if (response is Success) {
      setCart(response.response as Cart);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      notifyListeners();
    }
    return false;
  }

  // ---------------- This function creates a cart for temporary purpose like placing direct order without affecting the pre existing cart --------------------------------------------------------
  Future<Object> createTemporaryCart(Session currentSession) async {
    var response = await CartApi.createCart(currentSession);
    // print(response);
    if (response is Success) {
      // setCart(response.response as Cart);
      // notifyListeners();
      // return true;
      return response.response as Cart;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      // setCartError(cartError);
      return cartError;
    }
    return Object();
  }

  Future<bool> getCartInfo(String cartId) async {
    var response = await CartApi.getCartInfo(cartId);
    if (response is Success) {
      setCart(response.response as Cart);
      setCartItems((response.response as Cart).items as List<CartItem>);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      notifyListeners();
    }
    return false;
  }

  Future<bool> getCartItems(String cartId) async {
    var response = await CartApi.getCartItems(cartId);
    if (response is Success) {
      setCartItems(response.response as List<CartItem>);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartItemError cartItemError = CartItemError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartItemError(cartItemError);
      notifyListeners();
    }
    return false;
  }

  Future<bool> addItemToCart(Cart cart, CartItem receivedInfo) async {
    setLoading(true);
    // notifyListeners();
    var response = await CartApi.addItemToCart(cart, receivedInfo);
    // print(response);

    if (response is Success) {
      setCart(response.response as Cart);
      setCartItems((response.response as Cart).items as List<CartItem>);
      setLoading(false);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  // ---------------- This function adds items to tempoaray cart for temporary purpose like placing direct order without affecting the pre existing cart --------------------------------------------------------

  Future<bool> addItemToTemporaryCart(Cart cart, CartItem receivedInfo) async {
    setLoading(true);
    // notifyListeners();
    var response = await CartApi.addItemToCart(cart, receivedInfo);
    // print(response);

    if (response is Success) {
      // setCart(response.response as Cart);
      // setCartItems((response.response as Cart).items as List<CartItem>);
      setLoading(false);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      setLoading(false);
      notifyListeners();
    }
    return false;
  }

  // Future<bool> postCartItem(Session userSession, CartItem cartItem) async {
  //   var response = await CartApi.postCartItem(userSession, cartItem);

  //   if (response is Success) {
  //     List<Cart> carts = response.response as List<Cart>;
  //     cartItem = carts[0];

  //     _cartItems.add(cartItem);

  //     notifyListeners();
  //     return true;
  //   }

  //   if (response is Failure) {
  //     CartError cartError = CartError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setCartError(cartError);
  //     notifyListeners();
  //     return false;
  //   }

  //   return false;
  // }

  Future<bool> updateCartItem(String cartId, CartItem edittedItem) async {
    var response = await CartApi.updateCartItem(cartId, edittedItem);

    if (response is Success) {
      final postIndex =
          _cartItems.indexWhere((element) => element.id == edittedItem.id);

      CartItem cartItem = response.response as CartItem;
      _cartItems[postIndex] = cartItem;
      notifyListeners();
      return true;
    }

    if (response is Failure) {
      CartItemError cartItemError = CartItemError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartItemError(cartItemError);
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<bool> deleteCartItem(
      Session userSession, String cartId, String cartItemId) async {
    var response =
        await CartApi.deleteCartItem(userSession, cartId, cartItemId);
    if (response is Success) {
      final postIndex = _cartItems
          .indexWhere((element) => element.id == int.parse(cartItemId));
      _cartItems.removeAt(postIndex);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );
      setCartError(cartError);
      notifyListeners();
    }
    return false;
  }

  // void updateCart(Session currentSession, Cart edittedCart) async {
  //   var response = await CartApi.updatePost(currentSession, edittedPost);

  //   if (response is Success) {
  //     final postIndex =
  //         _myCarts.indexWhere((element) => element.id == edittedPost.id);
  //     _myCarts[postIndex] = response as Cart;
  //   }

  //   if (response is Failure) {
  //     CaartError CaartError = CaartError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setCaartError(CaartError);
  //   }

  //   notifyListeners();
  // }

  // Future<bool> deleteCart(Session currentSession, String postId) async {
  //   var response = await CartApi.deletePost(currentSession, postId);

  //   if (response is Success) {
  //     final postIndex = _myCarts.indexWhere((element) => element.id == postId);
  //     _myCarts.removeAt(postIndex);
  //     // notifyListeners();
  //     return true;
  //   }
  //   if (response is Failure) {
  //     CaartError CaartError = CaartError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setCaartError(CaartError);
  //     // notifyListeners();
  //     return false;
  //   }
  //   notifyListeners();
  //   return false;
  // }

  bool cartItemsContains(int bookId) {
    return _cartItems.any((element) => element.product.id == bookId);
  }
}
// 622153a0-33b2-4d6c-aaeb-25c2046e56ed