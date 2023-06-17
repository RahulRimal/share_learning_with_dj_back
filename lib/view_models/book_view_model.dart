import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/templates/utils/system_helper.dart';

import '../models/book.dart';
import '../models/post_category.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin HomeScreenNewViewModel on BaseViewModel {
  // This flag will be used to render either send button or clear button on search bar. I need to use this because i can't clear the search bar if searchtext is not empty because the search will not work on text change but on button click. So the search might not have been completed even if the text is not empty
  bool homeScreenNewEnableClearSearch = false;
  bool homeScreenNewShowFilterButton = false;

  FocusNode homeScreenNewSearchFocusNode = FocusNode();
  int homeScreenNewSelectedCategoryIndex = 0;
  late TextEditingController homeScreenNewSearchTextController;
  ScrollController? homeScreenNewScrollController;
  bool homeScreenNewLoadingMorePosts = false;

  List<PostCategory> homeScreenNewCategories = [];

  homeScreenNewGetSearchResult(
      GlobalKey<FormState> homeScreenNewSearchFormKey) async {
    final isValid = homeScreenNewSearchFormKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    homeScreenNewSearchFormKey.currentState!.save();
    homeScreenNewSearchFocusNode.unfocus();
    homeScreenNewSelectedCategoryIndex = 0;
    // Clear the filters while searchig
    bookFiltersProvider.clearFilters();
    bookProvider.searchBooks(sessionProvider.session as Session,
        homeScreenNewSearchTextController.text);
  }

  homeScreenNewGetScrollController() {
    homeScreenNewScrollController = ScrollController();
    homeScreenNewScrollController!.addListener(homeScreenNewScrollListener);
    return homeScreenNewScrollController;
  }

  homeScreenNewSetEnableClearSearch(bool value) {
    homeScreenNewEnableClearSearch = value;
    notifyListeners();
  }

  homeScreenNewSetShowFiltersButton(bool value) {
    homeScreenNewShowFilterButton = value;
    notifyListeners();
  }

  homeScreenNewSetLoadingMorePosts(bool value) {
    homeScreenNewLoadingMorePosts = value;
    notifyListeners();
  }

  homeScreenNewScrollListener() async {
    if (homeScreenNewScrollController!.position.pixels ==
        homeScreenNewScrollController!.position.maxScrollExtent) {
      if (bookProvider.nextPageUrl != null) {
        await bookProvider.getMoreBooks(bookProvider.nextPageUrl as String);
      }
    }
  }

  bindHomeScreenNew(BuildContext context) {
    bindBaseViewModal(context);
    homeScreenNewSelectedCategoryIndex = 0;
    homeScreenNewSearchFocusNode = FocusNode();
    homeScreenNewSearchTextController = TextEditingController();

    homeScreenNewCategories = categoryProvider.categories;
    homeScreenNewCategories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: bookProvider.books.length),
    );

    // Registering FMC Device sarts here
    FCMDeviceHelper.registerDeviceToFCM(sessionProvider.session as Session);
    // Registering FMC Device ends here

    if (userProvider.user == null) {
      userProvider
          .getUserByToken((sessionProvider.session as Session).accessToken);
    }

    // This will show the filters icon after 3 seconds of homescreen being loaded
    Timer(Duration(seconds: 3), () {
      homeScreenNewSetShowFiltersButton(true);
    });
  }

  unBindHomeScreenNew() {
    homeScreenNewSearchFocusNode.dispose();
    homeScreenNewScrollController!.dispose();
  }
}

mixin AddPostScreenViewModel on BaseViewModel, ChangeNotifier {
  List<XFile>? addPostScreenStoredImages;
  List<BookImage> addPostScreenSctualImages = [];
  ImagePicker addPostScreenImagePicker = ImagePicker();

  bool addPostScreenIsPostingNewBook = false;

  late FocusNode addPostScreenAuthorFocusNode;
  late FocusNode addPostScreenDateFocusNode;
  late FocusNode addPostScreenPriceFocusNode;
  late FocusNode addPostScreenBooksCountFocusNode;
  late FocusNode addPostScreenDescFocusNode;

  List<bool> addPostScreenPostTypeSelling = [true, false];

  bool addPostScreenIsPostType = true;

  picker.NepaliDateTime? addPostScreenBoughtDate;

  var addPostScreenEdittedBook = Book(
    id: '',
    author: 'Unknown',
    bookName: '',
    userId: '1',
    postType: 'B',
    category: null,
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    // wishlisted: false,
    price: 0,
    bookCount: 1,
    images: [],
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

  final addPostScreenDatePickercontroller = TextEditingController(
    text:
        DateFormat('yyyy-MM-dd').format(picker.NepaliDateTime.now()).toString(),
  );

  bindAddPostScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    addPostScreenAuthorFocusNode = FocusNode();
    addPostScreenDescFocusNode = FocusNode();
    addPostScreenDateFocusNode = FocusNode();
    addPostScreenPriceFocusNode = FocusNode();
    addPostScreenBooksCountFocusNode = FocusNode();
  }

  unbindAddPostScreenViewModel() {
    addPostScreenAuthorFocusNode.dispose();
    addPostScreenAuthorFocusNode.dispose();
    addPostScreenDescFocusNode.dispose();
    addPostScreenPriceFocusNode.dispose();
    addPostScreenBooksCountFocusNode.dispose();
  }

  addPostScreenEraseImage(dynamic image) {
    if (image is XFile) {
      // setState(() {
      addPostScreenStoredImages?.remove(image);
      addPostScreenSctualImages.remove(image.path);
      // });
      notifyListeners();
    } else {
      // setState(() {
      XFile imageToRemove = addPostScreenStoredImages!
          .firstWhere((element) => element.path == image.image);
      addPostScreenStoredImages?.remove(imageToRemove);
      addPostScreenSctualImages.remove(image);
      notifyListeners();
      // });
    }
  }

  // Future<void> addPostScreenGetPicture() async {
  addPostScreenGetPicture() async {
    final imageFiles = await addPostScreenImagePicker.pickMultiImage(
        maxWidth: 770, imageQuality: 100);

    addPostScreenStoredImages = imageFiles;

    // setState(() {
    for (int i = 0; i < addPostScreenStoredImages!.length; i++) {
      addPostScreenSctualImages
          .add(BookImage(id: null, image: addPostScreenStoredImages![i].path));
      notifyListeners();
    }
    // });
  }

  Future<void> addPostScreenShowPicker(BuildContext context) async {
    addPostScreenBoughtDate = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: picker.NepaliDateTime.now(),
      firstDate: picker.NepaliDateTime(2070),
      lastDate: picker.NepaliDateTime.now(),
    );

    addPostScreenDatePickercontroller.text = DateFormat('yyyy-MM-dd')
        .format(addPostScreenBoughtDate as DateTime)
        .toString();
    notifyListeners();
  }

  addPostScreenSavePost(GlobalKey<FormState> form) async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return;
    }

    form.currentState!.save();
    addPostScreenEdittedBook.postType = addPostScreenIsPostType ? 'S' : 'B';

    addPostScreenEdittedBook.postRating = 0.0;
    addPostScreenEdittedBook.userId = userProvider.user!.id;

    if (await bookProvider.createPost(
        sessionProvider.session as Session, addPostScreenEdittedBook)) {
      if (addPostScreenStoredImages != null) {
        addPostScreenEdittedBook = bookProvider.books.last;
        addPostScreenEdittedBook.images = addPostScreenStoredImages;

        if (await bookProvider.updatePictures(
            sessionProvider.session as Session, addPostScreenEdittedBook)) {
          addPostScreenIsPostingNewBook = false;
          return true;
        } else {
          addPostScreenIsPostingNewBook = false;
          return false;
        }
      }
    }
    addPostScreenIsPostingNewBook = false;
    return false;
  }

  setAddPostScreenIsPostingNewBook(value) {
    addPostScreenIsPostingNewBook = value;
    notifyListeners();
  }
}

mixin EditPostScreenViewModel on BaseViewModel, ChangeNotifier {
  bool first = true;
  bool editPostScreenShowLoading = false;

  late FocusNode editPostScreenDateFocusNode;
  late FocusNode editPostScreenPriceFocusNode;
  late FocusNode editPostScreenBooksCountFocusNode;
  late FocusNode editPostScreenDescFocusNode;
  late FocusNode editPostScreenCateFocusNode;
  late FocusNode editPostScreenAuthorFocusNode;

  late PostCategory editPostScreenSelectedCategory;

  List<bool> editPostScreenPostTypeSelling = [true, false];

  List<XFile>? editPostScreenStoredImages;
  List<BookImage> editPostScreenActualImages = [];

  List<BookImage> editPostScreenImagesToDelete = [];
  late List<PostCategory> editPostScreenCategories;

  ImagePicker editPostScreenImagePicker = ImagePicker();
  late Book editPostScreenSelectedBook;

  var editPostScreenEdittedBook = Book(
    id: '',
    author: '',
    bookName: '',
    userId: '',
    category: null,
    // postType: false,
    postType: 'B',
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    // wishlisted: false,
    price: 0,
    bookCount: 1,
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

  bool editPostScreenIspostType = true;

  NepaliDateTime? editPostScreenBoughtDate;

  TextEditingController editPostScreenDatePickercontroller =
      TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(NepaliDateTime.now()).toString(),
  );

  bindEditPostScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);

    editPostScreenAuthorFocusNode = FocusNode();
    editPostScreenDateFocusNode = FocusNode();
    editPostScreenPriceFocusNode = FocusNode();
    editPostScreenBooksCountFocusNode = FocusNode();
    editPostScreenDescFocusNode = FocusNode();
    editPostScreenCateFocusNode = FocusNode();

    editPostScreenEdittedBook =
        bookProvider.getBookById(editPostScreenSelectedBook.id);
    editPostScreenCategories = categoryProvider.categories;

    editPostScreenIspostType =
        editPostScreenEdittedBook.postType == 'S' ? true : false;
    editPostScreenPostTypeSelling = [
      editPostScreenIspostType,
      !editPostScreenIspostType
    ];
    if (first) editPostScreenRetrieveImage(editPostScreenEdittedBook);

    editPostScreenDatePickercontroller.text = DateFormat('yyyy-MM-dd')
        .format(editPostScreenEdittedBook.boughtDate)
        .toString();
  }

  // editPostScreenDidChangeDependencies() {
  // if (bookId.isNotEmpty) {
  //     edittedBook =
  //       Provider.of<BookProvider>(context, listen: false).getBookById(bookId);
  //   ispostType =   edittedBook.postType == 'S' ? true : false;
  //   postTypeSelling = [ispostType, !ispostType];
  //   if (  first)   retrieveImage(  edittedBook);
  // } else
  //   print('Book Id Is Empty');
  //   datePickercontroller.text =
  //     DateFormat('yyyy-MM-dd').format(  edittedBook.boughtDate).toString();
  // super.didChangeDependencies();
  // }

  unbindEditPostScreenViewModel() {
    editPostScreenAuthorFocusNode.dispose();
    editPostScreenDateFocusNode.dispose();
    editPostScreenPriceFocusNode.dispose();
    editPostScreenBooksCountFocusNode.dispose();
    editPostScreenDescFocusNode.dispose();
    editPostScreenCateFocusNode.dispose();
  }

  setEditPostScreenSelectedBook(Book book) {
    editPostScreenSelectedBook = book;
    notifyListeners();
  }

  setEditPostScreenShowLoading(bool value) {
    editPostScreenShowLoading = value;
    notifyListeners();
  }

  editPostScreenRetrieveImage(Book post) {
    if (post.images != null) {
      for (int i = 0; i < post.images!.length; i++) {
        // actualImages.add(post.images![i]['image']);
        editPostScreenActualImages.add(post.images![i]);
      }
      // print(actualImages);
    }

    // actualImages.addAll(post.pictures);
  }

  Future<void> editPostScreenGetPicture() async {
    final imageFiles = await editPostScreenImagePicker.pickMultiImage(
        maxWidth: 770, imageQuality: 100);

    // if (imageFiles == null) return;

    if (editPostScreenStoredImages == null) {
      editPostScreenStoredImages = [];
    }

    editPostScreenStoredImages!.addAll(imageFiles);

    // setState(() {
    for (int i = 0; i < editPostScreenStoredImages!.length; i++) {
      // actualImages.add(  storedImages![i].path);
      editPostScreenActualImages
          .add(BookImage(id: null, image: editPostScreenStoredImages![i].path));
      notifyListeners();
    }
    // });

    first = false;
  }

  editPostScreenEraseImage(dynamic image) {
    // Null Id means it is a XFile
    // if (image is XFile) {
    if (image.id == null) {
      // setState(() {
      editPostScreenStoredImages?.remove(image);
      editPostScreenActualImages.remove(image);
      notifyListeners();
      // });
    } else {
      // setState(() {
      // if (  storedImages != null) {
      try {
        editPostScreenImagesToDelete.add(editPostScreenActualImages
            .firstWhere((element) => element.id == image.id));
        editPostScreenActualImages.remove(image);
        notifyListeners();
      } on StateError {
        // imagesToRemove = null;
        print('here');
      }

      // actualImages.remove(image);
      // if (  edittedBook.pictures!.contains(image))   imagesToDelete.add(image);
      // });
    }
  }

  Future<void> editPostScreenShowPicker(BuildContext context) async {
    editPostScreenBoughtDate = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: editPostScreenEdittedBook.boughtDate,
      firstDate: picker.NepaliDateTime(2070),
      lastDate: picker.NepaliDateTime.now(),
    );
    editPostScreenDatePickercontroller.text = DateFormat('yyyy-MM-dd')
        .format(editPostScreenBoughtDate as DateTime)
        .toString();
  }
  // Map<String, dynamic>   getBookWithEdittedFields (Book book1, Book book2) {
  //   final map1 = SystemHelper.convertKeysToSnakeCase(book1.toMap());
  //   map1['bought  date'] = DateFormat('yyyy-MM-dd').format(book1.boughtDate);
  //   final map2 = SystemHelper.convertKeysToSnakeCase(book2.toMap());
  //   map2['bought  date'] = DateFormat('yyyy-MM-dd').format(book1.boughtDate);
  //   final differentFields = Map<String, dynamic>.from({});
  //    map1.forEach((key, value) {
  //   if (map2[key] != value) {
  //     differentFields[key] = value;
  //   }
  // });
  // differentFields.remove("pictures");
  // return differentFields;
  // // return Book.fromMap(differentFields);
  // }

  Future<bool> editPostScreenUpdatePost(GlobalKey<FormState> form) async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    form.currentState!.save();
    editPostScreenEdittedBook.postType = editPostScreenIspostType ? 'S' : 'B';

    if (await bookProvider.updatePost(
        bookProvider.sessionProvider.session as Session,
        editPostScreenEdittedBook)) {
      if (editPostScreenImagesToDelete.isNotEmpty) {
        await bookProvider.deletePictures(
            bookProvider.sessionProvider.session as Session,
            editPostScreenEdittedBook.id,
            editPostScreenImagesToDelete);
      }
      if (editPostScreenStoredImages != null) {
        if (editPostScreenStoredImages!.isNotEmpty) {
          editPostScreenEdittedBook.images = editPostScreenStoredImages;
          if (await bookProvider.updatePictures(
              bookProvider.sessionProvider.session as Session,
              editPostScreenEdittedBook)) {
            AlertHelper.showToastAlert('Post has been successfully updated');
          }
        }
      }
    }
    if (bookProvider.bookError != null) {
      AlertHelper.showToastAlert(
        bookProvider.bookError!.message.toString(),
      );
    }
    AlertHelper.showToastAlert('Something went wrong, please try again');

    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    // showUpdateSnackbar(context);

    return true;
  }
}

mixin UserPostsScreenViewModel on BaseViewModel, ChangeNotifier {
  late int _selectedCategoryIndex;
  int? _selectedUserId;
  late List<Book> _userBooks;
  // Making it nullable because i can check it for empty and not empty to show no books found text if list is not null but is empty, if we initialize it with empty list then we can't check if search result is empty
  List<Book>? _filteredBooks;
  final _searchTextController = TextEditingController();
  late FocusNode _searchFocusNode;

  late List<PostCategory> _categories;

  int get userPostsScreenViewModelSelectedCategoryIndex =>
      _selectedCategoryIndex;
  set userPostsScreenViewModelSelectedCategoryIndex(int index) =>
      _selectedCategoryIndex = index;

  int? get userPostsScreenViewModelSelectedUserId => _selectedUserId;
  set userPostsScreenViewModelSelectedUserId(int? index) =>
      _selectedUserId = index;

  List<Book> get userPostsScreenViewModelUserBooks => _userBooks;
  set userPostsScreenViewModelUserBooks(List<Book> books) => _userBooks = books;

  List<Book>? get userPostsScreenViewModelSelectedFilteredBooks =>
      _filteredBooks;
  set userPostsScreenViewModelSelectedFilteredBooks(
          List<Book>? filteredBooks) =>
      _filteredBooks = filteredBooks;

  get userPostsScreenViewModelSearchTextController => _searchTextController;

  get userPostsScreenViewModelSearchFocusNode => _searchFocusNode;

  List<PostCategory> get userPostsScreenViewModelCategories => _categories;

  set userPostsScreenViewModelCategories(List<PostCategory> categories) =>
      _categories = categories;

  bindUserPostsScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    _searchFocusNode = FocusNode();
    _selectedCategoryIndex = 0;
    _categories = categoryProvider.categories;
    _categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: bookProvider.books.length),
    );
  }

  unBindUserPostsScreenViewModel() {
    _searchTextController.dispose();
    _searchFocusNode.dispose();
  }

  userPostsScreenViewModelSearchUserBooks(GlobalKey<FormState> form) {
    final _isValid = form.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    form.currentState!.save();
    _searchFocusNode.unfocus();
    _selectedCategoryIndex = 0;
    List<Book> allBooks = bookProvider.postsByUser(userProvider.user!.id);

    String searchTerm = _searchTextController.text.toLowerCase();

    List<Book> _filteredBookList = [];

    for (Book book in allBooks) {
      if (book.bookName.toLowerCase().contains(searchTerm)) {
        _filteredBookList.add(book);
      }
    }

    // setState(() {
    _filteredBooks = _filteredBookList;
    notifyListeners();
    // });
  }
}
