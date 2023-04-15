import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category.dart';
import '../../providers/filters.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';

class BookFiltersWidget extends StatefulWidget {
  const BookFiltersWidget({Key? key}) : super(key: key);

  @override
  State<BookFiltersWidget> createState() => _BookFiltersWidgetState();
}

class _BookFiltersWidgetState extends State<BookFiltersWidget> {
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

  List<Category> _categories = [
    new Category(
      id: 1,
      name: 'All',
      postsCount: 1,
      featuredPost: null,
    ),
    new Category(
      id: 1,
      name: 'Adventure',
      postsCount: 1,
      featuredPost: null,
    ),
    new Category(
      id: 1,
      name: 'History',
      postsCount: 1,
      featuredPost: null,
    ),
    new Category(
      id: 1,
      name: 'Science',
      postsCount: 1,
      featuredPost: null,
    ),
    new Category(
      id: 1,
      name: 'Drama',
      postsCount: 1,
      featuredPost: null,
    ),
  ];

  List<String> _locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];

  List<String> _reviews = ['1+', '2+', '3+', '4+'];

  @override
  Widget build(BuildContext context) {
    BookFilters bookFilters = Provider.of<BookFilters>(context);
    Map<String, dynamic> filterOptions = bookFilters.filterOptions;
    String _selectedSortOption = filterOptions['sort_by'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.cancel,
            color: ColorManager.black,
          ),
        ),
        title: Center(
          child: Text(
            'Filters',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppPadding.p16,
            horizontal: AppPadding.p14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----------------------    Sort by section starts here -----------------------------------
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p14,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sort By',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      Wrap(
                        spacing: AppMargin.m4,
                        children: List.generate(
                          sortByButtons.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(
                              AppPadding.p4,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  bookFilters.setSortBy(
                                      sortByButtons[index]['value'].toString());
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: _selectedSortOption ==
                                        sortByButtons[index]['value']
                                    // ? ColorManager.primary
                                    ? ColorManager.black
                                    : ColorManager.white,
                              ),
                              child: Text(
                                sortByButtons[index]['title'].toString(),
                                style: getBoldStyle(
                                  color: _selectedSortOption ==
                                          sortByButtons[index]['value']
                                      ? ColorManager.white
                                      : ColorManager.black,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),

              // ----------------------    Sort by section ends here -----------------------------------
              // ----------------------    Sort by categories section starts here -----------------------------------

              Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p4,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          Column(
                            children: List.generate(
                              _categories.length,
                              (index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // 'All',
                                    _categories[index].name,
                                    style: getBoldStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  Checkbox(
                                    // activeColor: ColorManager.primary,
                                    activeColor: ColorManager.black,
                                    value: (filterOptions['categories']
                                            as List<String>)
                                        .contains(_categories[index]
                                            .name
                                            .toLowerCase()),
                                    onChanged: (value) {
                                      if (value == true) {
                                        bookFilters.addFilterToSortByCategories(
                                            _categories[index]
                                                .name
                                                .toLowerCase());
                                      }
                                      if (value == false) {
                                        bookFilters
                                            .removeFilterFromSortByCategories(
                                                _categories[index]
                                                    .name
                                                    .toLowerCase());
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price Range',
                            style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          SizedBox(
                            height: AppHeight.h4,
                          ),
                          Text(
                            'Rs. ${filterOptions['min_price'].toString()} - Rs. ${filterOptions['max_price'].toString()}',
                            style: getBoldStyle(
                              color: ColorManager.grey,
                              fontSize: FontSize.s14,
                            ),
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTickMarkColor: ColorManager.transparent,
                              inactiveTickMarkColor: ColorManager.transparent,
                              // activeTrackColor: ColorManager.primary,
                              activeTrackColor: ColorManager.black,
                              inactiveTrackColor:
                                  ColorManager.primaryColorWithOpacity,
                              // thumbColor: ColorManager.primary,
                              thumbColor: ColorManager.black,
                            ),
                            child: RangeSlider(
                              divisions: 20,
                              labels: RangeLabels(
                                filterOptions['min_price'].toString(),
                                filterOptions['max_price'].toString(),
                              ),
                              values: RangeValues(
                                double.parse(
                                    filterOptions['min_price'].toString()),
                                double.parse(
                                    filterOptions['max_price'].toString()),
                              ),
                              min: 0.0,
                              max: 100.0,
                              onChanged: (RangeValues values) {
                                setState(() {
                                  filterOptions['min_price'] =
                                      values.start.round();
                                  filterOptions['max_price'] =
                                      values.end.round();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ----------------------    Sort by locations section ends here -----------------------------------
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    SizedBox(
                      height: AppHeight.h4,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                        style: BorderStyle.solid,
                      )),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isExpanded: true,
                            style: getBoldStyle(color: ColorManager.black),
                            value: filterOptions['location'],
                            items: _locationOptions
                                .map((option) => DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: AppPadding.p12,
                                        ),
                                        child: Text(
                                          option,
                                        ),
                                      ),
                                      value: option,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                bookFilters.setLocation(value as String);
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              // ----------------------    Sort by location section ends here -----------------------------------
              // ----------------------    Sort by categories section ends here -----------------------------------

              // ----------------------    Sort by reviews section starts here -----------------------------------
              Container(
                padding: EdgeInsets.only(
                  top: AppPadding.p2,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reviews',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      Wrap(
                        spacing: AppMargin.m4,
                        children: List.generate(
                          sortByButtons.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(
                              AppPadding.p4,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  bookFilters.setReviews(_reviews[index]);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    filterOptions['reviews'] == _reviews[index]
                                        // ? ColorManager.primary
                                        ? ColorManager.black
                                        : ColorManager.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...List.generate(
                                    int.parse(
                                      _reviews[index]
                                          .replaceAll(RegExp(r'[^\d]+'), ''),
                                    ),
                                    (idx) => Icon(
                                      Icons.star,
                                      color: filterOptions['reviews'] ==
                                              _reviews[index]
                                          ? ColorManager.white
                                          : ColorManager.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: AppSize.s16,
                                    color: filterOptions['reviews'] ==
                                            _reviews[index]
                                        ? ColorManager.white
                                        : ColorManager.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              // ----------------------    Sort by reviews section ends here ---------------
              SizedBox(
                height: AppHeight.h50,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorManager.lighterGrey,
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back',
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: ColorManager.white,
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                      horizontal: AppPadding.p20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: AppSize.s20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Show results',
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ColorManager.primary,
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
