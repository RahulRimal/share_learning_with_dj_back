import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:share_learning/data/category_api.dart';
import 'package:share_learning/models/post_category.dart';

import '../../models/api_status.dart';
import '../../models/session.dart';

class CategoryProvider with ChangeNotifier {
  List<PostCategory> _categories = [];
  bool _loading = false;

  CategoryError? _categoryError;
  String? _nextPageUrl;
  String? _previousPageUrl;

  List<PostCategory> get categories {
    return [..._categories];
  }

  bool get loading {
    return _loading;
  }

  CategoryError get categoryError {
    return _categoryError as CategoryError;
  }

  String? get nextPageUrl => _nextPageUrl;
  String? get previousPageUrl => _previousPageUrl;

  setCategories(categories) {
    _categories = categories;
  }

  setLoading(loading) {
    _loading = loading;
    // notifyListeners();
  }

  setCategoryError(categoryError) {
    _categoryError = categoryError;
  }

  setNextPageUrl(String? nextPageUrl) {
    _nextPageUrl = nextPageUrl;
  }

  setPreviousPageUrl(String? previousPageUrl) {
    _previousPageUrl = previousPageUrl;
  }

  add(PostCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  remove(PostCategory category) {
    _categories.remove(category);
    notifyListeners();
  }

  getCategories(Session authSession) async {
    setLoading(true);
    var response = await CategoryApi.getCategories(authSession);
    // print(response);

    if (response is Success) {
      // setCategories(response.response);
      setCategories(
          (response.response as Map)['categories'] as List<PostCategory>);
      setNextPageUrl((response.response as Map)['next']);
      setPreviousPageUrl((response.response as Map)['previous']);
    }
    if (response is Failure) {
      CategoryError categoryError = CategoryError(
        code: response.code,
        message: response.errorResponse,
      );
      setCategoryError(categoryError);
    }

    setLoading(false);
    notifyListeners();
  }

  getCategoryById(Session authSession, int categoryId) async {
    setLoading(true);
    var response = await CategoryApi.getCategoryById(authSession, categoryId);
    // print(response);

    if (response is Success) {
      // setCategories(response.response);
      setLoading(false);

      return response.response as PostCategory;
    }
    if (response is Failure) {
      CategoryError categoryError = CategoryError(
        code: response.code,
        message: response.errorResponse,
      );
      setCategoryError(categoryError);
      setLoading(false);
      notifyListeners();
      return categoryError;
    }
  }
}
