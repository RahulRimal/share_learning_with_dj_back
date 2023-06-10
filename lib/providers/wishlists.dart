import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:share_learning/data/wishlist_api.dart';

import '../models/api_status.dart';
import '../models/book.dart';
import '../models/session.dart';
import '../models/wishlist.dart';

class Wishlists with ChangeNotifier {
  List<Wishlist> _wishlists = [];
  List<Book> _wishlistedBooks = [];

  bool _loading = false;
  WishlistError? _wishlistError;

  bool get loading => _loading;

  WishlistError? get wishlistError => _wishlistError;

  List<Book> get wishlistedBooks {
    return [..._wishlistedBooks];
  }

  List<Wishlist> get wishlists {
    return [..._wishlists];
  }

  setLoading(loading) {
    _loading = loading;
  }

  setWishlists(List<Wishlist> wishlists) {
    this._wishlists = wishlists;
  }

  setWishlistedBooks(List<Book> wishlistedBooks) {
    _wishlistedBooks = wishlistedBooks;
  }

  setWishlistError(error) {
    _wishlistError = error;
  }

  getWishlistedBooks(Session authSession) async {
    setLoading(true);

    // var response = await BookApi.getBooks(uId);
    var response = await WishlistApi.wishlistedBooks(authSession);
    // print(response);

    if (response is Success) {
      if ((response.response as List).isEmpty) {
        setLoading(false);
        notifyListeners();
        return;
      }
      setWishlists(response.response as List<Wishlist>);
    }
    if (response is Failure) {
      WishlistError wishlistError = WishlistError(
        code: response.code,
        message: response.errorResponse,
      );
      setWishlistError(wishlistError);
    }
    setLoading(false);
    notifyListeners();
  }

  toggleWishlistBook(Session authSession, Book book) async {
    setLoading(true);
    var response;
    Wishlist? match = wishlists.firstWhereOrNull(
        (Wishlist wishlist) => wishlist.post == int.parse(book.id));
    if (match != null) {
      response = await WishlistApi.removeBookFromWishlist(
          authSession, match.id.toString());
      // print(response);
      if (response is Success) {
        _wishlists.remove(match);
      } else {
        WishlistError wishlistError = WishlistError(
          code: response.code,
          message: response.errorResponse,
        );
        setWishlistError(wishlistError);
      }
    } else {
      response = await WishlistApi.addBookToWishlist(authSession, book.id);
      // print(response);
      if (response is Success) {
        _wishlists.add(response.response as Wishlist);
        // _wishlistedBooks.add(response.response as Book);
      }
      if (response is Failure) {
        WishlistError wishlistError = WishlistError(
          code: response.code,
          message: response.errorResponse,
        );
        setWishlistError(wishlistError);
      }
    }

    setLoading(false);
    notifyListeners();
  }

  Future<dynamic> searchBooks(
      Session loggedInSession, String searchTerm) async {
    setLoading(true);
    var response =
        await WishlistApi.getBooksBySearchTerm(loggedInSession, searchTerm);
    if (response is Success) {
      setWishlists(response.response as List<Wishlist>);
    }
    if (response is Failure) {
      WishlistError error = new WishlistError(
        code: response.code,
        message: response.errorResponse,
      );
      setWishlistError(error);
    }
    setLoading(false);
    notifyListeners();
  }



  Future<dynamic> getWishlistsByBookCategory(
      Session loggedInSession, String categoryId) async {
    setLoading(true);
    var response =
        await WishlistApi.getWishlistsByBookCategory(loggedInSession, categoryId);
    // print(response);
    if (response is Success) {
      

      setWishlists(response.response as List<Wishlist>);
    }
    if (response is Failure) {
      WishlistError error = new WishlistError(
        code: response.code,
        message: response.errorResponse,
      );
      setWishlistError(error);
    }
    setLoading(false);
    notifyListeners();
  }


}
