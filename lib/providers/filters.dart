import 'package:flutter/cupertino.dart';

class BookFilters with ChangeNotifier {
  Map<String, dynamic> _filterOptions = {
    'selected_loaction': '',
    'min_price': 50,
    'max_price': 80,
    'sort_by': 'low_to_high',
    'categories': ['all', 'science', 'fiction'],
    'reviews': '2+',
    'location': 'Kathmandu',
  };

  Map<String, dynamic> get filterOptions => _filterOptions;

  setSortBy(String value) {
    _filterOptions['sort_by'] = value;
  }

  setCategories(List<String> values) {
    _filterOptions['categories'] = values;
  }

  setReviews(String value) {
    _filterOptions['reviews'] = value;
  }

  setLocation(String value) {
    _filterOptions['location'] = value;
  }

  addFilterToSortByCategories(String value) {
    (_filterOptions['categories'] as List<String>).add(value);
    notifyListeners();
  }

  removeFilterFromSortByCategories(String value) {
    (_filterOptions['categories'] as List<String>).remove(value);
    notifyListeners();
  }
}
