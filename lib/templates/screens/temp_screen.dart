import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';

import '../managers/color_manager.dart';
import '../managers/values_manager.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Temporary Screen',
          ),
        ),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            barrierColor: ColorManager.blackWithLowOpacity,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.r20),
                topRight: Radius.circular(AppRadius.r20),
              ),
            ),
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p20,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Text(
                        'Select Payment Method',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        'Pay with e-Sewa',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        'Pay with Khalti',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        'Pay with fonePay',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        'Pay with cash',
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s18,
                        ),
                      ),
                    ),
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
                                        // bookFilters.setSortBy(
                                        //     sortByButtons[index]['value']
                                        //         .toString());
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        // primary: _selectedSortOption ==
                                        //         sortByButtons[index]['value']
                                        //     // ? ColorManager.primary
                                        //     ? ColorManager.black
                                        //     : ColorManager.white,
                                        ),
                                    child: Text(
                                      sortByButtons[index]['title'].toString(),
                                      // style: getBoldStyle(
                                      // color: _selectedSortOption ==
                                      //         sortByButtons[index]['value']
                                      //     ? ColorManager.white
                                      //     : ColorManager.black,
                                      // fontSize: FontSize.s12,
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Center(
          child: Text(
            'Click me',
          ),
        ),
      ),
    );
  }
}
