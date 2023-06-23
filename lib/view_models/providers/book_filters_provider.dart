import 'package:flutter/cupertino.dart';
import 'package:share_learning/view_models/base_view_model.dart';

import '../../models/book.dart';
import '../book_filters_view_model.dart';

class BookFiltersProvider
    with ChangeNotifier, BaseViewModel, BookFiltersViewModel {
  Map<String, dynamic> _initialFilterOptions = {
    'selected_loaction': '',
    'min_price': 0,
    'max_price': 0,
    'sort_by': 'low_to_high',
    'categories': ['all'],
    'reviews': '',
    'location': '',
  };
  Map<String, dynamic> _filterOptions = {
    'selected_loaction': '',
    'min_price': 0,
    'max_price': 0,
    'sort_by': 'low_to_high',
    'categories': ['all'],
    // 'categories': [],
    'reviews': '2+',
    'location': 'Kathmandu',
  };

  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  bool _loading = false;
  bool _showFilteredResult = false;

  Map<String, dynamic> get filterOptions => _filterOptions;

  List<Book> get allBooks {
    return [..._allBooks];
  }

  List<Book> get filteredBooks {
    return [..._filteredBooks];
  }

  bool get loading {
    return _loading;
  }

  bool get showFilteredResult {
    return _showFilteredResult;
  }

  setFilterOptions(Map<String, dynamic> filterOptions) {
    _filterOptions = filterOptions;
  }

  setLoading(bool loading) {
    _loading = loading;
  }

  setShowFilteredResult(bool showFilteredResult) {
    _showFilteredResult = showFilteredResult;
  }

  void setAllBooks(List<Book> allBooks) {
    _allBooks = allBooks;
  }

  void setFilteredBooks(List<Book> filteredBooks) {
    _filteredBooks = filteredBooks;
  }

  setSortBy(String value) {
    _filterOptions['sort_by'] = value;
    notifyListeners();
  }

  setCategories(List<String> values) {
    _filterOptions['categories'] = values;
  }

  setReviews(String value) {
    _filterOptions['reviews'] = value;
    notifyListeners();
  }

  setLocation(String value) {
    _filterOptions['location'] = value;
    notifyListeners();
  }

  setMinPrice(double price) {
    _filterOptions['min_price'] = price;
    // notifyListeners();
  }

  setMaxPrice(double price) {
    _filterOptions['max_price'] = price;
    // notifyListeners();
  }

  addFilterToSortByCategories(String value) {
    if (value == 'all') {
      // if user selected all categories options then remove every filter from the list and add only add all so no specific product is selected and all products are made available
      _filterOptions['categories'] = <String>[];
      _filterOptions['categories'].add(value);
    } else {
      (_filterOptions['categories'] as List<String>).add(value);
      // Remove all from categories if any other category filters are available by all includes all products while having other filters should make only specific products available
      if ((_filterOptions['categories'] as List<String>).contains('all')) {
        (_filterOptions['categories'] as List<String>).remove('all');
      }
    }
    notifyListeners();
  }

  removeFilterFromSortByCategories(String value) {
    (_filterOptions['categories'] as List<String>).remove(value);
    // Add all to categories if any the categories list become empty this means no specific element is required so all products should be available which is done by all option
    if ((_filterOptions['categories'] as List<String>).isEmpty) {
      (_filterOptions['categories'] as List<String>).add('all');
    }
    notifyListeners();
  }

  filterBooks(Map<String, dynamic> filters) {
    setLoading(true);
    List<Book> filteredBooks = _allBooks;
    // print('here');

    if (filters.containsKey('sort_by')) {
      if (filters['sort_by'] == 'low_to_high') {
        filteredBooks.sort((a, b) => a.price.compareTo(b.price));
      }
      if (filters['sort_by'] == 'high_to_low') {
        filteredBooks.sort((a, b) => b.price.compareTo(a.price));
      }
    }

    if (filters.containsKey('min_price')) {
      filteredBooks = filteredBooks
          .where((book) => book.price >= filters['min_price'])
          .toList();
      // print(filteredBooks);
    }
    if (filters.containsKey('max_price')) {
      filteredBooks = filteredBooks
          .where((book) => book.price <= filters['max_price'])
          .toList();
      // print(filteredBooks);
    }
    // print(filteredBooks);
    if (filters.containsKey('categories')) {
      if (!filters['categories'].contains('all')) {
        filteredBooks = filteredBooks
            .where((book) => filters['categories']
                .contains(book.category!.name.toLowerCase()))
            .toList();
        // print(filteredBooks);
      }
    }

    setFilteredBooks(filteredBooks);
    setShowFilteredResult(true);
    setLoading(false);
    notifyListeners();
  }

  // clearFilters(double minPrice, double maxPrice, String location) {
  clearFilters() {
    setFilterOptions(_initialFilterOptions);
    setMinPrice(rangeSliderStart);
    setMaxPrice(rangeSliderEnd);
    setLocation(locationOptions[0]);
    setShowFilteredResult(false);
    notifyListeners();
  }
}
