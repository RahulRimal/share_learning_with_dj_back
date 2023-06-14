import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/book.dart';
import '../../models/post_category.dart';
import '../../view_models/providers/book_provider.dart';
import '../../view_models/providers/category_provider.dart';
import '../../view_models/providers/book_filters_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';
import '../managers/values_manager.dart';

class BookFiltersWidget extends StatefulWidget {
  BookFiltersWidget({Key? key, required this.booksToFilter}) : super(key: key);

  final List<Book> booksToFilter;

  @override
  State<BookFiltersWidget> createState() => _BookFiltersWidgetState();
}

class _BookFiltersWidgetState extends State<BookFiltersWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    BookFiltersProvider bookFiltersProvider =
        Provider.of<BookFiltersProvider>(context, listen: false);
    bookFiltersProvider.bind(context, widget.booksToFilter);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // bookFiltersProvider.setMinAndMaxPrice(
      //     bookFiltersProvider.bookProvider.getMinPrice(widget.booksToFilter),
      //     bookFiltersProvider.bookProvider.getMaxPrice(widget.booksToFilter));
    });
  }

  @override
  void dispose() {
    // Provider.of<BookFiltersProvider>(context, listen: false).unBind();
    // Unregister this object as an observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookFiltersProvider _bookFiltersProvider =
        Provider.of<BookFiltersProvider>(context);

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
                          _bookFiltersProvider.sortByButtons.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(
                              AppPadding.p4,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // setState(() {
                                _bookFiltersProvider.setSortBy(
                                    _bookFiltersProvider.sortByButtons[index]
                                            ['value']
                                        .toString());
                                // });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    // selectedSortOption ==
                                    _bookFiltersProvider
                                                .filterOptions['sort_by'] ==
                                            _bookFiltersProvider
                                                .sortByButtons[index]['value']
                                        // ? ColorManager.primary
                                        ? ColorManager.black
                                        : ColorManager.white,
                              ),
                              child: Text(
                                _bookFiltersProvider.sortByButtons[index]
                                        ['title']
                                    .toString(),
                                style: getBoldStyle(
                                  color:
                                      // selectedSortOption ==
                                      _bookFiltersProvider
                                                  .filterOptions['sort_by'] ==
                                              _bookFiltersProvider
                                                  .sortByButtons[index]['value']
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
                              _bookFiltersProvider.categories.length,
                              (index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // 'All',
                                    _bookFiltersProvider.categories[index].name,
                                    style: getBoldStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s14,
                                    ),
                                  ),
                                  Checkbox(
                                    // activeColor: ColorManager.primary,
                                    activeColor: ColorManager.black,
                                    value: (_bookFiltersProvider
                                                .filterOptions['categories']
                                            // as List<dynamic>)
                                            as List<String>)
                                        .contains(_bookFiltersProvider
                                            .categories[index].name
                                            .toLowerCase()),
                                    onChanged: (value) {
                                      if (value == true) {
                                        _bookFiltersProvider
                                            .addFilterToSortByCategories(
                                                _bookFiltersProvider
                                                    .categories[index].name
                                                    .toLowerCase());
                                      }
                                      if (value == false) {
                                        _bookFiltersProvider
                                            .removeFilterFromSortByCategories(
                                                _bookFiltersProvider
                                                    .categories[index].name
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
                            'Rs. ${_bookFiltersProvider.filterOptions['min_price'].round().toString()} - Rs. ${_bookFiltersProvider.filterOptions['max_price'].round().toString()}',
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
                              // min: _bookFiltersProvider
                              //     .filterOptions['min_price']
                              //     .toDouble(),
                              // max: _bookFiltersProvider
                              //     .filterOptions['max_price']
                              //     .toDouble(),
                              min: _bookFiltersProvider.rangeSliderStart,
                              max: _bookFiltersProvider.rangeSliderEnd,

                              divisions: 100,
                              labels: RangeLabels(
                                _bookFiltersProvider.filterOptions['min_price']
                                    .round()
                                    .toString(),
                                _bookFiltersProvider.filterOptions['max_price']
                                    .round()
                                    .toString(),
                              ),
                              values: RangeValues(
                                double.parse(_bookFiltersProvider
                                    .filterOptions['min_price']
                                    .round()
                                    .toString()),
                                double.parse(_bookFiltersProvider
                                    .filterOptions['max_price']
                                    .round()
                                    .toString()),
                              ),
                              onChanged: (RangeValues values) {
                                // setState(() {

                                // _bookFiltersProvider.filterOptions['min_price'] = values.start;
                                // _bookFiltersProvider.filterOptions['max_price'] = values.end;
                                // _bookFiltersProvider.setMinPrice(values.start);
                                // _bookFiltersProvider.setMaxPrice(values.end);
                                _bookFiltersProvider.setMinAndMaxPrice(
                                    values.start, values.end);
                                // });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ----------------------    Sort by categories section ends here -----------------------------------

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
                            value:
                                _bookFiltersProvider.filterOptions['location'],
                            items: _bookFiltersProvider.locationOptions
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
                              // setState(() {
                              _bookFiltersProvider.setLocation(value as String);
                              // });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              // ----------------------    Sort by location section ends here -----------------------------------

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
                          _bookFiltersProvider.sortByButtons.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(
                              AppPadding.p4,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // setState(() {
                                _bookFiltersProvider.setReviews(
                                    _bookFiltersProvider.reviews[index]);
                                // });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _bookFiltersProvider
                                            .filterOptions['reviews'] ==
                                        _bookFiltersProvider.reviews[index]
                                    // ? ColorManager.primary
                                    ? ColorManager.black
                                    : ColorManager.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ...List.generate(
                                    int.parse(
                                      _bookFiltersProvider.reviews[index]
                                          .replaceAll(RegExp(r'[^\d]+'), ''),
                                    ),
                                    (idx) => Icon(
                                      Icons.star,
                                      color: _bookFiltersProvider
                                                  .filterOptions['reviews'] ==
                                              _bookFiltersProvider
                                                  .reviews[index]
                                          ? ColorManager.white
                                          : ColorManager.black,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: AppSize.s16,
                                    color: _bookFiltersProvider
                                                .filterOptions['reviews'] ==
                                            _bookFiltersProvider.reviews[index]
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
                    // bookFilters.clearFilters(_minPrice, _maxPrice, 'Kathmandu');
                    _bookFiltersProvider.clearFilters();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Clear Filters',
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.white,
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
                    onPressed: () {
                      // _bookFiltersProvider.setAllBooks(
                      //     Provider.of<BookProvider>(context, listen: false)
                      //         .books);
                      // _bookFiltersProvider
                      //     .filterBooks(_bookFiltersProvider.filterOptions);
                      Provider.of<BookProvider>(context, listen: false)
                          .getBooksWithFilters(
                              _bookFiltersProvider.filterOptions, null);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Show results',
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
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





// class BookFiltersWidget extends StatefulWidget {
//   BookFiltersWidget({Key? key, required this.booksToFilter}) : super(key: key);

//   final List<Book> booksToFilter;

//   @override
//   State<BookFiltersWidget> createState() => _BookFiltersWidgetState();
// }

// class _BookFiltersWidgetState extends State<BookFiltersWidget> {
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<BookFiltersProvider>(context, listen: false)
//         .bind(context, widget.booksToFilter);
//     // .bind(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     BookFiltersProvider _bookFiltersProvider =
//         context.watch<BookFiltersProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorManager.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.cancel,
//             color: ColorManager.black,
//           ),
//         ),
//         title: Center(
//           child: Text(
//             'Filters',
//             style: getBoldStyle(
//               color: ColorManager.black,
//               fontSize: FontSize.s20,
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             vertical: AppPadding.p16,
//             horizontal: AppPadding.p14,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ----------------------    Sort by section starts here -----------------------------------
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   vertical: AppPadding.p14,
//                 ),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Sort By',
//                         style: getBoldStyle(
//                           color: ColorManager.black,
//                           fontSize: FontSize.s18,
//                         ),
//                       ),
//                       Wrap(
//                         spacing: AppMargin.m4,
//                         children: List.generate(
//                           _bookFiltersProvider.sortByButtons.length,
//                           (index) => Padding(
//                             padding: const EdgeInsets.all(
//                               AppPadding.p4,
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _bookFiltersProvider.setSortBy(
//                                     _bookFiltersProvider.sortByButtons[index]
//                                             ['value']
//                                         .toString());
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor:
//                                     _bookFiltersProvider.selectedSortOption ==
//                                             _bookFiltersProvider
//                                                 .sortByButtons[index]['value']
//                                         // ? ColorManager.primary
//                                         ? ColorManager.black
//                                         : ColorManager.white,
//                               ),
//                               child: Text(
//                                 _bookFiltersProvider.sortByButtons[index]
//                                         ['title']
//                                     .toString(),
//                                 style: getBoldStyle(
//                                   color:
//                                       _bookFiltersProvider.selectedSortOption ==
//                                               _bookFiltersProvider
//                                                   .sortByButtons[index]['value']
//                                           ? ColorManager.white
//                                           : ColorManager.black,
//                                   fontSize: FontSize.s12,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//               ),

//               // ----------------------    Sort by section ends here -----------------------------------
//               // ----------------------    Sort by categories section starts here -----------------------------------

//               Container(
//                 padding: EdgeInsets.symmetric(
//                   vertical: AppPadding.p4,
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Categories',
//                             style: getBoldStyle(
//                               color: ColorManager.black,
//                               fontSize: FontSize.s18,
//                             ),
//                           ),
//                           Column(
//                             children: List.generate(
//                               _bookFiltersProvider.categories.length,
//                               (index) => Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     // 'All',
//                                     _bookFiltersProvider.categories[index].name,
//                                     style: getBoldStyle(
//                                       color: ColorManager.black,
//                                       fontSize: FontSize.s14,
//                                     ),
//                                   ),
//                                   Checkbox(
//                                     // activeColor: ColorManager.primary,
//                                     activeColor: ColorManager.black,
//                                     value: (_bookFiltersProvider
//                                                 .filterOptions['categories']
//                                             // as List<dynamic>)
//                                             as List<String>)
//                                         .contains(_bookFiltersProvider
//                                             .categories[index].name
//                                             .toLowerCase()),
//                                     onChanged: (value) {
//                                       if (value == true) {
//                                         _bookFiltersProvider
//                                             .addFilterToSortByCategories(
//                                                 _bookFiltersProvider
//                                                     .categories[index].name
//                                                     .toLowerCase());
//                                       }
//                                       if (value == false) {
//                                         _bookFiltersProvider
//                                             .removeFilterFromSortByCategories(
//                                                 _bookFiltersProvider
//                                                     .categories[index].name
//                                                     .toLowerCase());
//                                       }
//                                     },
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         vertical: AppPadding.p12,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Price Range',
//                             style: getBoldStyle(
//                               color: ColorManager.black,
//                               fontSize: FontSize.s18,
//                             ),
//                           ),
//                           SizedBox(
//                             height: AppHeight.h4,
//                           ),
//                           Text(
//                             'Rs. ${_bookFiltersProvider.filterOptions['min_price'].toString()} - Rs. ${_bookFiltersProvider.filterOptions['max_price'].toString()}',
//                             style: getBoldStyle(
//                               color: ColorManager.grey,
//                               fontSize: FontSize.s14,
//                             ),
//                           ),
//                           SliderTheme(
//                             data: SliderThemeData(
//                               activeTickMarkColor: ColorManager.transparent,
//                               inactiveTickMarkColor: ColorManager.transparent,
//                               // activeTrackColor: ColorManager.primary,
//                               activeTrackColor: ColorManager.black,
//                               inactiveTrackColor:
//                                   ColorManager.primaryColorWithOpacity,
//                               // thumbColor: ColorManager.primary,
//                               thumbColor: ColorManager.black,
//                             ),
//                             child: RangeSlider(
//                               divisions: 20,
//                               labels: RangeLabels(
//                                 _bookFiltersProvider.filterOptions['min_price']
//                                     .round()
//                                     .toString(),
//                                 _bookFiltersProvider.filterOptions['max_price']
//                                     .round()
//                                     .toString(),
//                               ),
//                               values: RangeValues(
//                                 double.parse(_bookFiltersProvider
//                                     .filterOptions['min_price']
//                                     .round()
//                                     .toString()),
//                                 double.parse(_bookFiltersProvider
//                                     .filterOptions['max_price']
//                                     .round()
//                                     .toString()),
//                               ),
//                               min: _bookFiltersProvider.minPrice,
//                               max: _bookFiltersProvider.maxPrice,
//                               onChanged: (RangeValues values) {
//                                 // _bookFiltersProvider.filterOptions['min_price'] = values.start;
//                                 // _bookFiltersProvider.filterOptions['max_price'] = values.end;
//                                 _bookFiltersProvider.setMinPrice(values.start);
//                                 _bookFiltersProvider.setMaxPrice(values.end);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ----------------------    Sort by categories section ends here -----------------------------------

//               // ----------------------    Sort by locations section ends here -----------------------------------
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   vertical: AppPadding.p12,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Location',
//                       style: getBoldStyle(
//                         color: ColorManager.black,
//                         fontSize: FontSize.s18,
//                       ),
//                     ),
//                     SizedBox(
//                       height: AppHeight.h4,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                         color: Colors.grey,
//                         width: 1.0,
//                         style: BorderStyle.solid,
//                       )),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton(
//                             isExpanded: true,
//                             style: getBoldStyle(color: ColorManager.black),
//                             value:
//                                 _bookFiltersProvider.filterOptions['location'],
//                             items: _bookFiltersProvider.locationOptions
//                                 .map((option) => DropdownMenuItem(
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                           left: AppPadding.p12,
//                                         ),
//                                         child: Text(
//                                           option,
//                                         ),
//                                       ),
//                                       value: option,
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               _bookFiltersProvider.setLocation(value as String);
//                             }),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // ----------------------    Sort by location section ends here -----------------------------------

//               // ----------------------    Sort by reviews section starts here -----------------------------------
//               Container(
//                 padding: EdgeInsets.only(
//                   top: AppPadding.p2,
//                 ),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Reviews',
//                         style: getBoldStyle(
//                           color: ColorManager.black,
//                           fontSize: FontSize.s18,
//                         ),
//                       ),
//                       Wrap(
//                         spacing: AppMargin.m4,
//                         children: List.generate(
//                           _bookFiltersProvider.sortByButtons.length,
//                           (index) => Padding(
//                             padding: const EdgeInsets.all(
//                               AppPadding.p4,
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _bookFiltersProvider.setReviews(
//                                     _bookFiltersProvider.reviews[index]);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: _bookFiltersProvider
//                                             .filterOptions['reviews'] ==
//                                         _bookFiltersProvider.reviews[index]
//                                     // ? ColorManager.primary
//                                     ? ColorManager.black
//                                     : ColorManager.white,
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ...List.generate(
//                                     int.parse(
//                                       _bookFiltersProvider.reviews[index]
//                                           .replaceAll(RegExp(r'[^\d]+'), ''),
//                                     ),
//                                     (idx) => Icon(
//                                       Icons.star,
//                                       color: _bookFiltersProvider
//                                                   .filterOptions['reviews'] ==
//                                               _bookFiltersProvider
//                                                   .reviews[index]
//                                           ? ColorManager.white
//                                           : ColorManager.black,
//                                     ),
//                                   ),
//                                   Icon(
//                                     Icons.add,
//                                     size: AppSize.s16,
//                                     color: _bookFiltersProvider
//                                                 .filterOptions['reviews'] ==
//                                             _bookFiltersProvider.reviews[index]
//                                         ? ColorManager.white
//                                         : ColorManager.black,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//               ),
//               // ----------------------    Sort by reviews section ends here ---------------
//               SizedBox(
//                 height: AppHeight.h50,
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomSheet: Container(
//           decoration: BoxDecoration(
//             border: Border(
//               top: BorderSide(
//                 color: ColorManager.lighterGrey,
//                 width: 1,
//               ),
//             ),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: AppPadding.p12,
//             vertical: AppPadding.p8,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.rectangle,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     _bookFiltersProvider.clearFilters(
//                         _bookFiltersProvider.minPrice,
//                         _bookFiltersProvider.maxPrice,
//                         'Kathmandu');
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Clear Filters',
//                     style: getBoldStyle(
//                       color: ColorManager.black,
//                       fontSize: FontSize.s16,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorManager.white,
//                     padding: EdgeInsets.symmetric(
//                       vertical: AppPadding.p12,
//                       horizontal: AppPadding.p20,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: AppSize.s20,
//               ),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                   ),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _bookFiltersProvider
//                           .setAllBooks(_bookFiltersProvider.bookProvider.books);
//                       _bookFiltersProvider
//                           .filterBooks(_bookFiltersProvider.filterOptions);
//                       Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Show results',
//                       style: getBoldStyle(
//                         color: ColorManager.black,
//                         fontSize: FontSize.s18,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorManager.primary,
//                       padding: EdgeInsets.symmetric(
//                         vertical: AppPadding.p12,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
