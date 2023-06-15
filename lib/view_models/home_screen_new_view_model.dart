import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;

import '../models/book.dart';
import '../models/post_category.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/utils/system_helper.dart';
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
    final _isValid = homeScreenNewSearchFormKey.currentState!.validate();
    if (!_isValid) {
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
