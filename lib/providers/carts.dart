import 'package:flutter/material.dart';
import 'package:share_learning/data/cart_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/cart.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/templates/widgets/cart_item.dart';

class Carts with ChangeNotifier {
  List<Cart> _myCartItems = [];

  // List<Cart> _myCartItems = [
  //   Cart(
  //     id: '1',
  //     bookId: '1',
  //     sellingUserId: '1',
  //     buyingUserId: '2',
  //     bookCount: 2,
  //     pricePerPiece: 500,
  //     wishlisted: true,
  //     postType: "B",
  //   ),
  //   Cart(
  //     id: '3',
  //     bookId: '1',
  //     sellingUserId: '2',
  //     buyingUserId: '5',
  //     bookCount: 1,
  //     pricePerPiece: 300,
  //     wishlisted: true,
  //     postType: "S",
  //   ),
  //   // Cart(
  //   //   id: '6',
  //   //   bookId: '3',
  //   //   sellingUserId: '1',
  //   //   buyingUserId: '5',
  //   //   bookCount: 1,
  //   //   pricePerPiece: 300,
  //   //   wishlisted: true,
  //   //   postType: "B",
  //   // ),
  // ];

  bool _loading = false;

  // CaartError? _CaartError;

  CartError? _cartError;

  // final Session authenticatedSession;

  // Carts(this.authenticatedSession);

  // Carts() {
  //   getCarts();
  // }

  bool get loading => _loading;

  List<Cart> get cartItems {
    return [..._myCartItems];
  }

  CartError? get cartError => _cartError;

  // factory Carts.fromJson(Map<String, dynamic> parsedJson) {
  //   return Cart(
  //     id: parsedJson['id'].toString(),postm
  //     userId: parsedJson['userId'].toString(),
  //     CartName: parsedJson['CartName'].toString(),
  //     description: parsedJson['description'].toString(),
  //     author: parsedJson['author'].toString(),
  //     boughtTime: NepaliDateTime.parse(parsedJson['boughtTime'].toString()),
  //     price: parsedJson['price'],
  //     CartCount: parsedJson['CartCount'],
  //     isWishlisted: parsedJson['isWishlisted'],
  //     selling: parsedJson['selling'],
  //   );
  // }

  setLoading(bool loading) async {
    _loading = loading;
    // notifyListeners();
  }

  setCartItems(List<Cart> cartItems) {
    _myCartItems = cartItems;
  }

  // setCaartError(CartError cartError) {
  //   _cartError = cartError;
  // }
  setCartError(CartError cartError) {
    _cartError = cartError;
  }

  // getCarts(Session loggedInSession) async {
  //   setLoading(true);

  //   // var response = await CartApi.getCarts(uId);
  //   var response = await CartApi.getCarts(loggedInSession);

  //   if (response is Success) {
  //     setCarts(response.response as List<Cart>);
  //   }
  //   if (response is Failure) {
  //     CaartError CaartError = CaartError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setCaartError(CaartError);
  //   }
  //   setLoading(false);
  // }

  // getCartsAnnonimusly(Session loggedInSession) async {
  //   setLoading(true);

  //   var response = await CartApi.getAnnonimusPosts(loggedInSession);

  //   if (response is Success) {
  //     setCarts(response.response as List<Cart>);
  //   }
  //   if (response is Failure) {
  //     CaartError CaartError = CaartError(
  //       code: response.code,
  //       message: response.errorResponse,
  //     );
  //     setCaartError(CaartError);
  //   }
  //   setLoading(false);
  // }

  Cart getCartItemById(String cartId) {
    return cartItems.firstWhere((cart) => cart.id == cartId);
  }

  // Future<Book> getBokById(String bookId) {}

  // List<Cart> CartsByUser(String userId) {
  //   return Carts.where((Cart) => Cart.buyingUserId == userId).toList();
  // }

  // bool hasPostByUser(String userId) {
  //   final userCart = Carts.firstWhereOrNull((post) => post.userId == userId);

  //   if (userCart != null)
  //     return true;
  //   else
  //     return false;
  // }

  Future<Object> getCartItemBook(Session loggedInSession, String bookId) async {
    var response = await CartApi.getCartItemBook(loggedInSession, bookId);
    if (response is Success) {
      // return response.response as Book;
      List<Book> responseList = response.response as List<Book>;
      return responseList[0];
      // return response.response;
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

  getUserCart(Session loggedInSession) async {
    var response = await CartApi.getUserCart(loggedInSession);
    if (response is Success) {
      setCartItems(response.response as List<Cart>);
      // setCarts(response.response);
    }

    if (response is Failure) {
      CartError cartError = CartError(
        code: response.code,
        message: response.errorResponse,
      );

      setCartError(cartError);
    }
  }

  void addCartItem(Cart receivedInfo) {
    // Cart newCart = Cart(
    //   id: receivedInfo.id,
    //   userId: receivedInfo.userId,
    //   CartName: receivedInfo.CartName,
    //   author: receivedInfo.author,
    //   boughtDate: receivedInfo.boughtDate,
    //   description: receivedInfo.description,
    //   wishlisted: receivedInfo.wishlisted,
    //   price: receivedInfo.price,
    //   CartCount: receivedInfo.CartCount,
    //   postType: receivedInfo.postType,
    //   postedOn: receivedInfo.postedOn,
    //   postRating: receivedInfo.postRating,
    // );

    _myCartItems.add(receivedInfo);
    notifyListeners();
  }

  void addCartItems(List<Cart> receivedInfo) {
    _myCartItems.addAll(receivedInfo);
    notifyListeners();
  }

  Future<bool> postCartItem(Session userSession, Cart cartItem) async {
    var response = await CartApi.postCartItem(userSession, cartItem);

    if (response is Success) {
      List<Cart> carts = response.response as List<Cart>;
      cartItem = carts[0];

      _myCartItems.add(cartItem);

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
      return false;
    }

    return false;
  }

  Future<bool> updateCartItem(Session userSession, Cart edittedItem) async {
    var response = await CartApi.updateCartItem(userSession, edittedItem);

    if (response is Success) {
      final postIndex =
          _myCartItems.indexWhere((element) => element.id == edittedItem.id);

      List<Cart> carts = response.response as List<Cart>;
      _myCartItems[postIndex] = carts[0];
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
      return false;
    }

    return false;
  }

  Future<bool> deleteCartItem(Session userSession, String cartId) async {
    var response = await CartApi.deleteCartItem(userSession, cartId);
    if (response is Success) {
      final postIndex =
          _myCartItems.indexWhere((element) => element.id == cartId);
      _myCartItems.removeAt(postIndex);
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
      return false;
    }
    return false;
  }

  // void createCart(Session currentSession, Cart receivedInfo) async {
  //   var response = await CartApi.createPost(currentSession, receivedInfo);

  //   if (response is Success) {
  //     addPost(response.response as Cart);
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

}
