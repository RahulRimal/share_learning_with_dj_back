import 'package:flutter/foundation.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/data/book_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/models/session.dart';
import '../models/book.dart';
import 'package:collection/collection.dart';

class Books with ChangeNotifier {
  // List<Book> _myBooks = [
  //   // Book(
  //   //   id: '0',
  //   //   userId: '0',
  //   //   bookName: 'C Programming Fundamentals II Edition',
  //   //   description:
  //   //       'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //   //   author: 'Rahul Rimal',
  //   //   boughtTime: NepaliDateTime.parse('2078-03-12'),
  //   //   price: 299,
  //   //   bookCount: 2,
  //   //   isWishlisted: true,
  //   //   selling: true,
  //   //   pictures: [
  //   //     'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2019/12/19/14/52/dewdrop-4706329_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2020/09/06/08/00/red-thread-5548304_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2014/04/10/11/24/rose-320868_960_720.jpg',
  //   //   ],
  //   // ),
  //   // Book(
  //   //   id: '1',
  //   //   userId: '0',
  //   //   bookName: 'Data Structures and Algorithms Revised Edition',
  //   //   description:
  //   //       'Not a a a a a Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //   //   author: 'Rahul Rimal',
  //   //   boughtTime: NepaliDateTime.parse('2072-10-12'),
  //   //   price: 100,
  //   //   bookCount: 1,
  //   //   isWishlisted: false,
  //   //   selling: false,
  //   // ),
  //   // Book(
  //   //   id: '2',
  //   //   userId: '1',
  //   //   bookName: 'Mathematics II',
  //   //   description:
  //   //       'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //   //   author: 'Surendra Jha',
  //   //   boughtTime: NepaliDateTime.parse('2077-06-12'),
  //   //   price: 1000,
  //   //   bookCount: 4,
  //   //   isWishlisted: false,
  //   //   selling: false,
  //   //   pictures: [
  //   //     'https://cdn.pixabay.com/photo/2021/08/16/19/24/boat-6551183_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2021/08/10/18/32/cat-6536684__340.jpg',
  //   //     'https://cdn.pixabay.com/photo/2021/06/25/17/51/ladybug-6364312__340.jpg',
  //   //   ],
  //   // ),
  //   // Book(
  //   //   id: '3',
  //   //   userId: '1',
  //   //   bookName: 'Computer Networking',
  //   //   description:
  //   //       'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  //   //   author: 'Krishna Pd. Rimal',
  //   //   boughtTime: NepaliDateTime.parse('2078-05-12'),
  //   //   price: 800,
  //   //   bookCount: 1,
  //   //   isWishlisted: true,
  //   //   selling: true,
  //   //   pictures: [
  //   //     'https://cdn.pixabay.com/photo/2021/08/16/19/24/boat-6551183_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_960_720.jpg',
  //   //     'https://cdn.pixabay.com/photo/2021/08/10/18/32/cat-6536684__340.jpg',
  //   //     'https://cdn.pixabay.com/photo/2021/06/25/17/51/ladybug-6364312__340.jpg',
  //   //   ],
  //   // ),
  // ];

  List<Book> _myBooks = [];
  bool _loading = false;
  BookError? _bookError;

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

  Book getBookById(String bookId) {
    return books.firstWhere((book) => book.id == bookId);
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

  // void updatePost(String id, Book edittedPost){

  //   final postIndex = _myBooks.indexWhere((element) => element.id == id);

  //   _myBooks[postIndex] = edittedPost;

  //   notifyListeners();
  // }

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

      imagesToDelete.forEach((element) {
        bookToUpdate.images!.remove(element);
      },);

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
    var response = await BookApi.deletePost(currentSession, postId);
    // print(response);

    if (response is Success) {
      final postIndex = _myBooks.indexWhere((element) => element.id == postId);
      _myBooks.removeAt(postIndex);
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
    notifyListeners();
    return false;
  }
}
