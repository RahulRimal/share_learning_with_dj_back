import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:share_learning/data/book_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/models/session.dart';
import '../models/book.dart';

class Books with ChangeNotifier {
  List<Book> _myBooks = [];
  bool _loading = false;
  BookError? _bookError;
  String? _nextPageUrl;
  String? _previousPageUrl;

  // final Session authenticatedSession;

  // Books(this.authenticatedSession);

  // Books() {
  //   getBooks();
  // }

  bool get loading => _loading;

  List<Book> get books {
    return [..._myBooks];
  }

  BookError? get bookError => _bookError;

  String? get nextPageUrl => _nextPageUrl;
  String? get previousPageUrl => _previousPageUrl;

  // factory Books.fromJson(Map<String, dynamic> parsedJson) {
  //   return Book(
  //     id: parsedJson['id'].toString(),postm
  //     userId: parsedJson['userId'].toString(),
  //     bookName: parsedJson['bookName'].toString(),
  //     description: parsedJson['description'].toString(),
  //     author: parsedJson['author'].toString(),
  //     boughtTime: NepaliDateTime.parse(parsedJson['boughtTime'].toString()),
  //     price: parsedJson['price'],
  //     bookCount: parsedJson['bookCount'],
  //     isWishlisted: parsedJson['isWishlisted'],
  //     selling: parsedJson['selling'],
  //   );
  // }

  setLoading(bool loading) async {
    _loading = loading;
    // notifyListeners();
  }

  setBooks(List<Book> books) {
    _myBooks = books;
  }

  setBookError(BookError bookError) {
    _bookError = bookError;
  }

  setNextPageUrl(String? nextPageUrl) {
    _nextPageUrl = nextPageUrl;
  }

  setPreviousPageUrl(String? previousPageUrl) {
    _previousPageUrl = previousPageUrl;
  }

  double getMinPrice() {
    List<Book> books = _myBooks;
    double minPrice = books
        .reduce(
            (value, element) => value.price < element.price ? value : element)
        .price;
    return minPrice;
  }

  double getMaxPrice() {
    List<Book> books = _myBooks;
    double maxPrice = books
        .reduce(
            (value, element) => value.price > element.price ? value : element)
        .price;
    return maxPrice;
  }

  // getBooks(String uId) async {
  getBooks(Session loggedInSession) async {
    setLoading(true);

    // var response = await BookApi.getBooks(uId);
    var response = await BookApi.getBooks(loggedInSession);

    if (response is Success) {
      setBooks(response.response as List<Book>);
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
    }
    setLoading(false);
  }

  getBooksAnnonimusly(Session loggedInSession) async {
    setLoading(true);

    // var response = await BookApi.getBooks(uId);
    var response = await BookApi.getAnnonimusPosts(loggedInSession);
    // print(response);

    if (response is Success) {
      setBooks((response.response as Map)['books'] as List<Book>);
      setNextPageUrl((response.response as Map)['next']);
      setPreviousPageUrl((response.response as Map)['previous']);
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
    }
    setLoading(false);
  }

  Book getBookById(String bookId) {
    // Book? result = books.firstWhereOrNull((book) => book.id == bookId);
    // if (result != null) {
    //   return result;
    // }
    // return await getBookByIdFromServer(authSession, bookId) as Book;
    return books.firstWhere((book) => book.id == bookId);
  }

  getMoreBooks(String nextPageUrl) async {
    setLoading(true);
    var response = await BookApi.getMoreBooks(nextPageUrl);
    // print(response);

    if (response is Success) {
      // setBooks((response.response as Map)['books'] as List<Book>);
      _myBooks.addAll((response.response as Map)['books'] as List<Book>);
      setNextPageUrl((response.response as Map)['next']);
      setPreviousPageUrl((response.response as Map)['previous']);
      notifyListeners();
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
    }
    setLoading(false);
    // notifyListeners();
  }

  Future<dynamic> getBookByIdFromServer(
      Session loggedInSession, String bookId) async {
    var response = await BookApi.getBookById(loggedInSession, bookId);
    // print(response);
    if (response is Success) {
      return response.response as Book;
    }
    if (response is Failure) {
      OrderItemError error = new OrderItemError(
          code: response.code, message: response.errorResponse);
      return error;
    }
  }

  Future<dynamic> getBooksByCategory(
      Session loggedInSession, String categoryId) async {
    setLoading(true);
    var response =
        await BookApi.getBooksByCategory(loggedInSession, categoryId);
    // print(response);
    if (response is Success) {
      // if((response.response as List<Book>).isEmpty)
      // {

      // }

      setBooks(response.response as List<Book>);
    }
    if (response is Failure) {
      BookError error = new BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(error);
    }
    setLoading(false);
    notifyListeners();
  }

  Future<dynamic> searchBooks(
      Session loggedInSession, String searchTerm) async {
    setLoading(true);
    var response =
        await BookApi.getBooksBySearchTerm(loggedInSession, searchTerm);
    if (response is Success) {
      setBooks((response.response as Map)['books'] as List<Book>);
      // _myBooks.addAll((response.response as Map)['books'] as List<Book>);
      setNextPageUrl((response.response as Map)['next']);
      setPreviousPageUrl((response.response as Map)['previous']);
    }
    if (response is Failure) {
      BookError error = new BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(error);
    }
    setLoading(false);
    notifyListeners();
  }

  List<Book> postsByUser(String userId) {
    return books.where((book) => book.userId == userId).toList();
  }

  bool hasPostByUser(String userId) {
    final userBook = books.firstWhereOrNull((post) => post.userId == userId);

    if (userBook != null)
      return true;
    else
      return false;
  }

  Future<dynamic> getUserBooks(String userId) async {
    setLoading(true);
    var response = await BookApi.getUserBooks(userId);
    // print(response);
    if (response is Success) {
      // setBooks(response.response as List<Book>);
      return response.response;
    }
    if (response is Failure) {
      BookError error = new BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(error);
    }
    setLoading(false);
    notifyListeners();
  }

  void addPost(Book receivedInfo) {
    // Book newBook = Book(
    //   id: receivedInfo.id,
    //   userId: receivedInfo.userId,
    //   bookName: receivedInfo.bookName,
    //   author: receivedInfo.author,
    //   boughtDate: receivedInfo.boughtDate,
    //   description: receivedInfo.description,
    //   wishlisted: receivedInfo.wishlisted,
    //   price: receivedInfo.price,
    //   bookCount: receivedInfo.bookCount,
    //   postType: receivedInfo.postType,
    //   postedOn: receivedInfo.postedOn,
    //   postRating: receivedInfo.postRating,
    // );

    _myBooks.add(receivedInfo);
    // notifyListeners();
  }

  void addPosts(List<Book> receivedInfo) {
    // for (Book book in receivedInfo) {
    //   Book newBook = Book(
    //     id: book.id,
    //     userId: book.userId,
    //     bookName: book.bookName,
    //     author: book.author,
    //     boughtTime: book.boughtTime,
    //     description: book.description,
    //     isWishlisted: book.isWishlisted,
    //     price: book.price,
    //     bookCount: book.bookCount,
    //     selling: book.selling,
    //   );
    //   _myBooks.add(newBook);
    // }

    _myBooks.addAll(receivedInfo);
    notifyListeners();
  }

  Future<bool> createPost(Session currentSession, Book receivedInfo) async {
    var response = await BookApi.createPost(currentSession, receivedInfo);

    if (response is Success) {
      addPost(response.response as Book);
      // addPost(response.response as Book);
      // notifyListeners();
      return true;
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      // notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> updatePictures(Session userSession, Book book) async {
    setLoading(true);

    List<String> images = [];

    for (var i = 0; i < book.images!.length; i++) {
      // images.add(book.pictures![i].path);
      images.add(book.images![i].path);
    }

    // book.pictures = images;

    var response = await BookApi.postPictures(userSession, book);
    // print(response);
    if (response is Success) {
      if (_myBooks.contains(response.response)) {
        // _myBooks.remove(response.response);
        setLoading(false);
        notifyListeners();
        return true;
      }
      _myBooks.add(response.response as Book);
      setLoading(false);
      notifyListeners();
      return true;
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      setLoading(false);
      notifyListeners();
      return false;
    }
    return false;
  }

  Future<bool> deletePictures(Session userSession, String postId,
      List<BookImage> imagesToDelete) async {
    setLoading(true);

    var response;

    for (var i = 0; i < imagesToDelete.length; i++) {
      response =
          await BookApi.deletePicture(userSession, postId, imagesToDelete[i]);
      // print(response);
      if (response is Failure) {
        BookError bookError = BookError(
          code: response.code,
          message: response.errorResponse,
        );
        setBookError(bookError);
        setLoading(false);
        notifyListeners();
        return false;
      }
    }
    Future.delayed(Duration.zero).then((_) {
      // Do something after the loop has finished
      if (response is Success) {
        // print('here');
        int bookIndex = _myBooks.indexWhere((element) => element.id == postId);
        Book bookToUpdate = _myBooks[bookIndex];
        _myBooks.remove(bookToUpdate);

        imagesToDelete.forEach(
          (element) {
            bookToUpdate.images!.remove(element);
          },
        );

        _myBooks.add(bookToUpdate);

        setLoading(false);
        notifyListeners();
        return true;
      }
    });

    return false;
  }

  Future<bool> updatePost(Session currentSession, Book edittedPost) async {
    var response = await BookApi.updatePost(currentSession, edittedPost);
    // print(response);
    if (response is Success) {
      final postIndex =
          _myBooks.indexWhere((element) => element.id == edittedPost.id);

      if (postIndex != -1) {
        _myBooks[postIndex] = response.response as Book;
      }

      notifyListeners();
      return true;
    }

    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      notifyListeners();
      return false;
    }

    return false;
  }

  Future<bool> deletePost(Session currentSession, String postId) async {
    setLoading(true);
    var response = await BookApi.deletePost(currentSession, postId);
    // print(response);

    if (response is Success) {
      final postIndex = _myBooks.indexWhere((element) => element.id == postId);
      _myBooks.removeAt(postIndex);
      notifyListeners();
      setLoading(true);
      return true;
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      // return false;
    }
    notifyListeners();
    setLoading(false);
    return false;
  }
}
