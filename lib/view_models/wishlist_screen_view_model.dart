import 'package:flutter/cupertino.dart';
import 'package:share_learning/view_models/base_view_model.dart';

import '../models/post_category.dart';
import '../models/session.dart';
import '../models/user.dart';

mixin WishlistScreenViewModel on BaseViewModel {
  late int selectedCategoryIndex;

  late TextEditingController wishlistScreenSearchTextController;
  late FocusNode wishlistScreenSearchFocusNode;
  List<PostCategory> wishlistScreenCategories = [];
  ScrollController? wishlistScreenScrollController;
  bool loadingMorePosts = false;

  bool enableClearSearch = false;
  bool showFilterButton = false;

  bindWishlistScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
    wishlistScreenSearchTextController = TextEditingController();
    wishlistScreenSearchFocusNode = FocusNode();
    selectedCategoryIndex = 0;
    wishlistScreenCategories = categoryProvider.categories;
    wishlistScreenCategories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: bookProvider.books.length),
    );

    if (userProvider.user == null) {
      userProvider
          .getUserByToken((sessionProvider.session as Session).accessToken);
    }
  }

  unbindWishlistScreenViewModel() {
    wishlistScreenSearchTextController.dispose();
    wishlistScreenSearchFocusNode.dispose();
  }

  getScrollController() {
    wishlistScreenScrollController = ScrollController();
    wishlistScreenScrollController!.addListener(scrollListener);
    return wishlistScreenScrollController;
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

  getSearchResult(GlobalKey<FormState> form) async {
    final _isValid = form.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    form.currentState!.save();
    wishlistScreenSearchFocusNode.unfocus();
    selectedCategoryIndex = 0;
  }

  scrollListener() async {
    if (wishlistScreenScrollController!.position.pixels ==
        wishlistScreenScrollController!.position.maxScrollExtent) {
      if (bookProvider.nextPageUrl != null) {
        await bookProvider.getMoreBooks(bookProvider.nextPageUrl as String);
      }
    }
  }
}
