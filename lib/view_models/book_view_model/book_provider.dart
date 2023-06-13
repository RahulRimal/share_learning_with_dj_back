import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:provider/provider.dart';
import 'package:share_learning/data/book_api.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/order_item.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/models/wishlist.dart';
import 'package:share_learning/view_models/cart_provider.dart';
import 'package:share_learning/view_models/user_provider.dart';
import '../../models/book.dart';
import '../../models/post_category.dart';
import '../../models/user.dart';
import '../../templates/utils/system_helper.dart';
import '../book_filters_provider.dart';
import '../category_provider.dart';
import '../order_provider.dart';
import '../order_request_provider.dart';
import '../session_provider.dart';
import '../wishlist_provider.dart';
import 'base_book_view_model.dart';

class BookProvider
// mixin BookProvider
    with
        ChangeNotifier,
        BaseBookViewModel,
        PostNewWidgetViewModel,
        HomeScreenNewViewModel,
        PostDetailsViewModel {
  List<Book> _myBooks = [];
  bool _loading = false;
  BookError? _bookError;
  String? _nextPageUrl;
  String? _previousPageUrl;
  bool get loading => _loading;

  List<Book> get books {
    return [..._myBooks];
  }

  BookError? get bookError => _bookError;

  String? get nextPageUrl => _nextPageUrl;
  String? get previousPageUrl => _previousPageUrl;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
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

  // getMinPrice(List<Book> books) {

  //   double minPrice = books
  //       .reduce(
  //           (value, element) => value.price < element.price ? value : element)
  //       .price;
  //   return minPrice;
  // }

  // getMaxPrice(List<Book> books) {

  //   double maxPrice = books
  //       .reduce(
  //           (value, element) => value.price > element.price ? value : element)
  //       .price;
  //   return maxPrice;
  // }
  // Future<List<double>> getMinAndMaxPrice() async {
  getMinAndMaxPrice() async {
    // If user tried to get min and max price after searching then show min and max prices for the searched books
    var response = await BookApi.getMinAndMaxPrice(searchTextController.text);
    if (response is Success) {
      List<double> result = (response.response as Map)
          .values
          .map((value) => double.parse(value))
          .toList();
      return result;
    }
    // if (response is Failure) {
    //   print(response.errorResponse);
    // }
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
    // setLoading(true);
    setLoadingMorePosts(true);
    var response = await BookApi.getMoreBooks(nextPageUrl);
    // print(response);

    if (response is Success) {
      // If the search result books in not empty then, get more books is for search results so populate the search else populate the _myBooks list
      // if (searchResult.isNotEmpty)
      //   searchResult.addAll((response.response as Map)['books'] as List<Book>);
      // else
      _myBooks.addAll((response.response as Map)['books'] as List<Book>);

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

    // bookFiltersProvider.setMinAndMaxPrice(
    //     getMinPrice(_myBooks), getMaxPrice(_myBooks));

    setLoadingMorePosts(false);
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
  }

  Future<dynamic> searchBooks(
      Session loggedInSession, String searchTerm) async {
    setLoading(true);
    var response =
        await BookApi.getBooksBySearchTerm(loggedInSession, searchTerm);
    if (response is Success) {
      setBooks((response.response as Map)['books'] as List<Book>);
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
    setEnableClearSearch(true);
    setLoading(false);
  }

  getBooksWithFilters(Map<String, dynamic> filters, String? searchTerm) async {
    setLoading(true);
    Map<String, dynamic> newFilters = {};
    // print(filters);

    if (searchTerm != null) {
      newFilters['search'] = searchTerm;
    }

    if (filters.containsKey('categories') &&
        filters['categories'][0] != 'all') {
      List<String> categoryIds = [];
      filters['categories'].forEach((category) {
        categoryProvider.categories.forEach((element) =>
            element.name.toLowerCase() == category
                ? categoryIds.add(element.id.toString())
                : null);
      });
      String categories = categoryIds.join(',');
      newFilters['category_in'] = categories;
    }

    if (filters.containsKey('sort_by') && filters['sort_by'] == 'low_to_high') {
      newFilters['ordering'] = 'unit_price';
    }

    if (filters.containsKey('sort_by') && filters['sort_by'] == 'high_to_low') {
      newFilters['ordering'] = '-unit_price';
    }

    if (filters.containsKey('min_price')) {
      newFilters['unit_price__gt'] = filters['min_price'].round().toString();
    }

    if (filters.containsKey('max_price')) {
      newFilters['unit_price__lt'] = filters['max_price'].round().toString();
    }

    // If user first searched then applied filters then we should apply search and filter
    if (searchTextController.text.isNotEmpty) {
      newFilters['search'] = searchTextController.text;
    }

    var response = await BookApi.getBooksWithFilters(newFilters);
    // print(response);
    if (response is Success) {
      setBooks((response.response as Map)['books'] as List<Book>);
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
  }

  void addPosts(List<Book> receivedInfo) {
    _myBooks.addAll(receivedInfo);
    notifyListeners();
  }

  Future<bool> createPost(Session currentSession, Book receivedInfo) async {
    var response = await BookApi.createPost(currentSession, receivedInfo);

    if (response is Success) {
      addPost(response.response as Book);
      // addPost(response.response as Book);

      return true;
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);

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
        return true;
      }
      _myBooks.add(response.response as Book);
      setLoading(false);
      return true;
    }
    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      setLoading(false);
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
        return true;
      }
    });

    return false;
  }

  Future<bool> updatePost(Session currentSession, Book edittedPost) async {
    setLoading(true);
    var response = await BookApi.updatePost(currentSession, edittedPost);
    // print(response);
    if (response is Success) {
      final postIndex =
          _myBooks.indexWhere((element) => element.id == edittedPost.id);

      if (postIndex != -1) {
        _myBooks[postIndex] = response.response as Book;
      }
      return true;
    }

    if (response is Failure) {
      BookError bookError = BookError(
        code: response.code,
        message: response.errorResponse,
      );
      setBookError(bookError);
      return false;
    }
    setLoading(false);
    return false;
  }

  Future<bool> deletePost(Session currentSession, String postId) async {
    setLoading(true);
    var response = await BookApi.deletePost(currentSession, postId);
    // print(response);

    if (response is Success) {
      final postIndex = _myBooks.indexWhere((element) => element.id == postId);
      _myBooks.removeAt(postIndex);

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

    setLoading(false);
    return false;
  }

// ================================== Implementations for the output of BaseProvider functions start from here ===================================

  
  @override
  setBillingInfo() {
    if (user.firstName!.isNotEmpty) {
      billingInfo["first_name"] = user.firstName!;
    }
    if (user.lastName!.isNotEmpty) {
      billingInfo["last_name"] = user.lastName!;
    }
    if (user.email!.isNotEmpty) {
      billingInfo["email"] = user.email!;
    }
    if (user.phone != null) {
      if (user.phone!.isNotEmpty) {
        billingInfo["phone"] = user.phone!;
      }
    }
    billingInfo["convenient_location"] = locationOptions[0];
  }

  @override
  setBillingInfoLocationData(String value) {
    billingInfo["convenient_location"] = value;
    notifyListeners();
  }


  @override
  bindBaseProvider(BuildContext context){
    authSession =
        Provider.of<SessionProvider>(context, listen: false).session as Session;
    userProvider = Provider.of(context, listen: false);
    bookFiltersProvider =
        Provider.of<BookFiltersProvider>(context, listen: false);
    categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    orderRequestProvider = Provider.of<OrderRequestProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }


// ================================== Implementations for the output of BaseProvider functions ends from here ===================================



// ================================== Implementations for the output of HomeScreenNew functions start from here ===================================
  @override
  getSearchResult(GlobalKey<FormState> homeScreenNewSearchFormKey) async {
    final _isValid = homeScreenNewSearchFormKey.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    homeScreenNewSearchFormKey.currentState!.save();
    searchFocusNode.unfocus();
    selectedCategoryIndex = 0;
    // setEnableClearSearch(true);
    // Clear the filters while searchig
    bookFiltersProvider.clearFilters();
    searchBooks(authSession, searchTextController.text);
  }

  @override
  getScrollController() {
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    return scrollController;
    // return ScrollController();
  }

  @override
  setEnableClearSearch(bool value) {
    enableClearSearch = value;
    notifyListeners();
  }

  @override
  setShowFiltersButton(bool value) {
    showFilterButton = value;
    notifyListeners();
  }

  @override
  setLoadingMorePosts(bool value) {
    // loadingMorePosts.value = value;
    loadingMorePosts = value;
    notifyListeners();
  }

  @override
  scrollListener() async {
    if (scrollController!.position.pixels ==
        scrollController!.position.maxScrollExtent) {
      if (nextPageUrl != null) {
        await getMoreBooks(nextPageUrl as String);
      }
    }
  }

  @override
  bindHomeScreenNew(BuildContext context) {
    bindBaseProvider(context);
    selectedCategoryIndex = 0;
    searchFocusNode = FocusNode();
    searchTextController = TextEditingController();

    categories = categoryProvider.categories;
    categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: books.length),
    );

    // Registering FMC Device sarts here
    FCMDeviceHelper.registerDeviceToFCM(authSession);
    // Registering FMC Device ends here

    if (userProvider.user == null) {
      userProvider.getUserByToken(authSession.accessToken);
    } else {
      user = userProvider.user as User;
    }

    // This will show the filters icon after 3 seconds of homescreen being loaded
    Timer(Duration(seconds: 3), () {
      setShowFiltersButton(true);
    });
  }

  @override
  unBindHomeScreenNew() {
    searchFocusNode.dispose();
    scrollController!.dispose();
    // homeScreenNewSearchFormKey.currentState!.dispose();
  }

  // ================================== Implementations for the output of HomeScreenNew functions end from here ===================================

  // ================================== Implementations for the output of PostDetailsScreen functions start from here ===================================

  @override
  setSelectedBook(Book book) {
    selectedBook = book;
  }

  @override
  setMainImageIndex(int value){
    mainImageIndex = value;
    notifyListeners();
  }

  @override
  setEnableRequestButton(bool value) {
    enableRequestButton = value;
    notifyListeners();
  }


  @override
  setExpectedUnitPrice(double value) {
    expectedUnitPrice = value;
    notifyListeners();
  }

  @override
  setIsRequestLoading(bool value) {
    isRequestLoading = value;
    notifyListeners();
  }
  @override
  setIsCartLoading(bool value) {
    isCartLoading = value;
    notifyListeners();
  }
  @override
  setIsOrderPlacementLoading(bool value) {
    isOrderPlacementLoading = value;
    notifyListeners();
  }

  @override
  setItemCount(int value) {
    itemCount = value;
    notifyListeners();
  }


  @override
  getTomorrowDate() {
    NepaliDateTime initDate = NepaliDateTime.now();
    NepaliDateTime tomorrow =
        NepaliDateTime(initDate.year, initDate.month, initDate.day + 1);
    return tomorrow;
  }

  @override
  showPicker(BuildContext context) async {
    buyerExpectedDeadline = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: getTomorrowDate(),
      firstDate: getTomorrowDate(),
      lastDate: NepaliDateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );
    if (buyerExpectedDeadline != null) {
      datePickercontroller.text = DateFormat('yyyy-MM-dd')
          .format(buyerExpectedDeadline as DateTime)
          .toString();
    }
  }

  @override
  bindPostDetailsScreen(BuildContext context) {
    bindBaseProvider(context);
    // cartProvider = Provider.of<CartProvider>(context, listen: false);
    // orderRequestProvider =
    //     Provider.of<OrderRequestProvider>(context, listen: false);

    postDetailsPageCreateOrderRequestBototmSheetForm = GlobalKey<FormState>();
    postDetailsPageBototmSheetForm = GlobalKey<FormState>();
    setBillingInfo();
    initDate = NepaliDateTime.now();
    datePickercontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
          NepaliDateTime.now().year,
          NepaliDateTime.now().month,
          NepaliDateTime.now().day + 1)),
    );

    postDetailsPageCartBottomSheetBuyerDateFocusNode = FocusNode();
    postDetailsPageCartBottomSheetBuyerPriceFocusNode = FocusNode();
    postDetailsPageCartBottomSheetBuyerBooksCountFocusNode = FocusNode();
    postDetailsPageCartBottomSheetFirstNameFocusNode = FocusNode();
    postDetailsPageCartBottomSheetLastNameFocusNode = FocusNode();
    postDetailsPageCartBottomSheetEmailFocusNode = FocusNode();
    postDetailsPageCartBottomSheetPhoneNumberFocusNode = FocusNode();
    postDetailsPageCartBottomSheetSideNoteFocusNode = FocusNode();
  }

  @override
  unBindPostDetailsScreen() {}

  // ================================== Implementations for the output of PostDetailsScreen functions ends from here ===================================
  
  // ================================== Implementations for the output of PostNewWidget functions ends from here ===================================
  @override
  bindPostNewWidget(BuildContext context) {
    bindBaseProvider(context);
  }

  @override
  didChangeDependencyPostNewWidget(BuildContext context) {
    wishlistProvider = Provider.of<WishlistProvider>(context);
  }

  @override
  unBindPostNewWidget() {}

  // ================================== Implementations for the output of PostNewWidget functions ends from here ===================================
  
  
  // ================================== Implementations for the output of BillingInfoWidgetViewModel functions starts from here ===================================
  
  @override
  bindBillingInfoWidgetViewModel(BuildContext context) {
    bindBaseProvider(context);
    setBillingInfo();
    setBillingInfoLocationData(locationOptions[0]);

  }
  
  
  // ================================== Implementations for the output of BillingInfoWidgetViewModel functions ends from here ===================================




}



abstract class HomeScreenNewViewModel{
  // final homeScreenNewSearchFormKey = GlobalKey<FormState>();

  // This flag will be used to render either send button or clear button on search bar. I need to use this because i can't clear the search bar if searchtext is not empty because the search will not work on text change but on button click. So the search might not have been completed even if the text is not empty
  bool enableClearSearch = false;
  bool showFilterButton = false;

  FocusNode searchFocusNode = FocusNode();
  int selectedCategoryIndex = 0;
  late TextEditingController searchTextController;
  ScrollController? scrollController;
  bool loadingMorePosts = false;
  User user = new User(
      id: "temp",
      firstName: 'firstName',
      lastName: 'lastName',
      username: 'username',
      email: 'email',
      phone: 'phone',
      image: null,
      description: 'description',
      userClass: 'userClass',
      followers: 'followers',
      createdDate: DateTime.now());
  List<PostCategory> categories = [];

  setEnableClearSearch(bool value);
  getSearchResult(GlobalKey<FormState> formKey);
  scrollListener();
  bindHomeScreenNew(BuildContext context);
  unBindHomeScreenNew();
  setLoadingMorePosts(bool value);
  getScrollController();
}

abstract class PostDetailsViewModel {
  
  
  int itemCount = 1;
  double expectedUnitPrice = 0;
  int mainImageIndex = 0;

  bool isRequestLoading = false;
  bool isCartLoading = false;
  bool isOrderPlacementLoading = false;
  bool enableRequestButton = false;

  late GlobalKey<FormState> postDetailsPageCreateOrderRequestBototmSheetForm;
  late GlobalKey<FormState> postDetailsPageBototmSheetForm;
  late Book selectedBook;
  late NepaliDateTime initDate;
  late NepaliDateTime? buyerExpectedDeadline;
  late TextEditingController datePickercontroller;

  late FocusNode postDetailsPageCartBottomSheetBuyerDateFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerPriceFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerBooksCountFocusNode;

  // These focus nodes are for order request billing info fields
  late FocusNode postDetailsPageCartBottomSheetFirstNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetLastNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetEmailFocusNode;
  late FocusNode postDetailsPageCartBottomSheetPhoneNumberFocusNode;
  late FocusNode postDetailsPageCartBottomSheetSideNoteFocusNode;

  late CartProvider cartProvider;
  late OrderRequestProvider orderRequestProvider;

  bindPostDetailsScreen(BuildContext context);
  unBindPostDetailsScreen();
  setSelectedBook(Book selectedBook);
  // setBillingInfo();
  getTomorrowDate();

  showPicker(BuildContext context);
  setExpectedUnitPrice(double value);
  setEnableRequestButton(bool value);
  setIsRequestLoading(bool value);
  setIsCartLoading(bool value);
  setIsOrderPlacementLoading(bool value);
  // setBillingInfoLocationData(String value);
  setMainImageIndex(int value);
  setItemCount(int value);
}

abstract class PostNewWidgetViewModel {
  late WishlistProvider wishlistProvider;

  bindPostNewWidget(BuildContext context);
  didChangeDependencyPostNewWidget(BuildContext context);
  unBindPostNewWidget();
}



abstract class BillingInfoWidgetViewModel {

  

  bindBillingInfoWidgetViewModel(BuildContext context);


}