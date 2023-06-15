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
  bool wishlistScreenLoadingMorePosts = false;

  bool wishlistScreenEnableClearSearch = false;
  bool wishlistScreenShowFilterButton = false;

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

  wishlistScreenGetScrollController() {
    wishlistScreenScrollController = ScrollController();
    wishlistScreenScrollController!.addListener(wishlistScreenScrollListener);
    return wishlistScreenScrollController;
  }

  wishlistScreenSetEnableClearSearch(bool value) {
    wishlistScreenEnableClearSearch = value;
    // notifyListeners();
  }

  wishlistScreenSetShowFiltersButton(bool value) {
    wishlistScreenShowFilterButton = value;
    // notifyListeners();
  }

  wishlistScreenSetLoadingMorePosts(bool value) {
    wishlistScreenLoadingMorePosts = value;
    // notifyListeners();
  }

  wishlistScreenGetSearchResult(GlobalKey<FormState> form) async {
    final _isValid = form.currentState!.validate();
    if (!_isValid) {
      return false;
    }
    form.currentState!.save();
    wishlistScreenSearchFocusNode.unfocus();
    selectedCategoryIndex = 0;
  }

  wishlistScreenScrollListener() async {
    if (wishlistScreenScrollController!.position.pixels ==
        wishlistScreenScrollController!.position.maxScrollExtent) {
      if (bookProvider.nextPageUrl != null) {
        await bookProvider.getMoreBooks(bookProvider.nextPageUrl as String);
      }
    }
  }
}
