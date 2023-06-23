import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/post_category.dart';
import 'base_view_model.dart';

mixin BookFiltersViewModel on BaseViewModel {
  List<Map<String, String>> sortByButtons = [
    {
      'title': 'Price: Low to High',
      'value': 'low_to_high',
    },
    {
      'title': 'Price: High to Low',
      'value': 'high_to_low',
    },
    {
      'title': 'Customer review',
      'value': 'customer_review',
    },
    {
      'title': 'Sale',
      'value': 'sale',
    },
  ];

  List<String> locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];

  List<String> reviews = ['1+', '2+', '3+', '4+'];

  // late String selectedSortOption;
  // String _selectedSortOption = filterOptions['sort_by'];

  double rangeSliderStart = 0.0;
  double rangeSliderEnd = 0.0;

  List<Book> booksToFilter = [];

  late List<PostCategory> categories;

  setBooksToFilter(List<Book> booksToFilter) {
    this.booksToFilter = booksToFilter;
  }

  set selectedSortOption(String _selectedSortOption) {
    selectedSortOption = _selectedSortOption;
  }

  // This function  sets min an max price value and then notifies the listner other wise there will be range values error if i use setminprice and setmaxprice with notifylistner on them

  setMinAndMaxPrice(double min, double max) {
    bookFiltersProvider.setMinPrice(min);
    bookFiltersProvider.setMaxPrice(max);
    notifyListeners();
  }

  bind(BuildContext context, List<Book> booksToFilter) async {
    bindBaseViewModal(context);
    this.booksToFilter = booksToFilter;

    categories = categoryProvider.categories;

    categories.insert(
      0,
      PostCategory(id: 0, name: 'All', postsCount: bookProvider.books.length),
    );

    List<double> minAndMaxPrice =
        await bookProvider.getMinAndMaxPrice() as List<double>;
    rangeSliderStart = minAndMaxPrice[0];
    rangeSliderEnd = minAndMaxPrice[1];
    setMinAndMaxPrice(minAndMaxPrice[0], minAndMaxPrice[1]);
  }

  unBind() {}
}
