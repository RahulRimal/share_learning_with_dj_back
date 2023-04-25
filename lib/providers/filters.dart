import 'package:flutter/cupertino.dart';

import '../models/book.dart';

class BookFilters with ChangeNotifier {
  // Map<String, dynamic> _initialState = {
  //   'filtered_products': [],
  //   'all_products': [],
  //   // 'sort': 'price_lowest'
  //   'sort': 'low_to_high',
  //   'filters': {
  //     'category': 'all',
  //     'min_price': 0,
  //     'max_price': 0,
  //     'price': 0,
  //     'shipping': false,
  //   }
  // };

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

  setMinPrice(double price) {
    _filterOptions['min_price'] = price;
  }

  setMaxPrice(double price) {
    _filterOptions['max_price'] = price;
  }

  addFilterToSortByCategories(String value) {
    (_filterOptions['categories'] as List<String>).add(value);
    notifyListeners();
  }

  removeFilterFromSortByCategories(String value) {
    (_filterOptions['categories'] as List<String>).remove(value);
    notifyListeners();
  }

  filterBooks(Map<String, dynamic> filters) {
    setLoading(true);
    List<Book> filteredBooks = _allBooks;
    // print('here');

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

  clearFilters(double minPrice, double maxPrice, String location) {
    setFilterOptions(_initialFilterOptions);
    setMinPrice(minPrice);
    setMaxPrice(maxPrice);
    setLocation(location);
    setShowFilteredResult(false);
    notifyListeners();
  }
}
