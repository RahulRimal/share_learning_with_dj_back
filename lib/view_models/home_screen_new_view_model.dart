import 'dart:async';

import 'package:flutter/material.dart';

import '../models/post_category.dart';
import '../models/session.dart';
import '../models/user.dart';
import '../templates/utils/system_helper.dart';
import 'base_view_model.dart';

mixin HomeScreenNewViewModel on BaseViewModel{

  // This flag will be used to render either send button or clear button on search bar. I need to use this because i can't clear the search bar if searchtext is not empty because the search will not work on text change but on button click. So the search might not have been completed even if the text is not empty
  bool enableClearSearch = false;
  bool showFilterButton = false;

  FocusNode searchFocusNode = FocusNode();
  int selectedCategoryIndex = 0;
  late TextEditingController searchTextController;
  ScrollController? scrollController;
  bool loadingMorePosts = false;
  
  List<PostCategory> categories = [];

 
  getSearchResult(GlobalKey<FormState> homeScreenNewSearchFormKey) async {
    final _isValid = homeScreenNewSearchFormKey.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    homeScreenNewSearchFormKey.currentState!.save();
    searchFocusNode.unfocus();
    selectedCategoryIndex = 0;
    // Clear the filters while searchig
    bookFiltersProvider.clearFilters();
    bookProvider.searchBooks(sessionProvider.session as Session, searchTextController.text);
  }

   
  getScrollController() {
    scrollController = ScrollController();
    scrollController!.addListener(scrollListener);
    return scrollController;
  }

   
  setEnableClearSearch(bool value) {
    enableClearSearch = value;
    // notifyListeners();
  }

  
  setShowFiltersButton(bool value) {
    showFilterButton = value;
    // notifyListeners();
  }

  
  setLoadingMorePosts(bool value) {
    loadingMorePosts = value;
    // notifyListeners();
  }

  
  scrollListener() async {
    if (scrollController!.position.pixels ==
        scrollController!.position.maxScrollExtent) {
      if (bookProvider. nextPageUrl != null) {
        await bookProvider.getMoreBooks(bookProvider.nextPageUrl as String);
      }
    }
  }

  
  bindHomeScreenNew(BuildContext context) {
    bindBaseViewModal(context);
    selectedCategoryIndex = 0;
    searchFocusNode = FocusNode();
    searchTextController = TextEditingController();

    categories = categoryProvider.categories;
    categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: bookProvider.books.length),
    );

    // Registering FMC Device sarts here
    FCMDeviceHelper.registerDeviceToFCM(sessionProvider.session as Session);
    // Registering FMC Device ends here

    if (userProvider.user == null) {
      userProvider.getUserByToken((sessionProvider.session as Session).accessToken);
    } else {
      user = userProvider.user as User;
    }

    // This will show the filters icon after 3 seconds of homescreen being loaded
    Timer(Duration(seconds: 3), () {
      setShowFiltersButton(true);
    });
  }

   
  unBindHomeScreenNew() {
    searchFocusNode.dispose();
    scrollController!.dispose();
    // homeScreenNewSearchFormKey.currentState!.dispose();
  }




  // setEnableClearSearch(bool value);
  // getSearchResult(GlobalKey<FormState> formKey);
  // scrollListener();
  // bindHomeScreenNew(BuildContext context);
  // unBindHomeScreenNew();
  // setLoadingMorePosts(bool value);
  // getScrollController();




}