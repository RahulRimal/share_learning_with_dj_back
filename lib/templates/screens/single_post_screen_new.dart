import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/style_manager.dart';

class SinglePostScreenNew extends StatefulWidget {
  const SinglePostScreenNew({Key? key}) : super(key: key);

  @override
  State<SinglePostScreenNew> createState() => _SinglePostScreenNewState();
}

class _SinglePostScreenNewState extends State<SinglePostScreenNew> {
  int _itemCount = 1;

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         expandedHeight: MediaQuery.of(context).size.height * 0.35,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.network(
    //             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       SliverToBoxAdapter(
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Colors.blue,
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(AppPadding.p12),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 SizedBox(
    //                   height: AppHeight.h50,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: 5,
    //                     itemBuilder: (context, index) {
    //                       return Padding(
    //                         padding:
    //                             EdgeInsets.symmetric(horizontal: AppPadding.p2),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(10),
    //                           child: Image.network(
    //                             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           padding: EdgeInsets.only(top: AppPadding.p14),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'C Programming Fundamentals II ',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.black,
    //                                 fontSize: FontSize.s18,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.only(
    //                             top: AppPadding.p4,
    //                           ),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'Dr. Suresh Rana',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.grey,
    //                                 fontSize: FontSize.s14,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     // Itemcount counter
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: ColorManager.lighterGrey,
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       child: ButtonBar(
    //                         buttonPadding: EdgeInsets.zero,
    //                         children: [
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               padding: EdgeInsets.zero,
    //                               disabledColor: ColorManager.lightGrey,
    //                               onPressed: _itemCount > 1
    //                                   ? () {
    //                                       setState(() {
    //                                         _itemCount--;
    //                                       });
    //                                     }
    //                                   : null,
    //                               icon: Icon(Icons.remove),
    //                             ),
    //                           ),
    //                           Text(
    //                             // '1',
    //                             _itemCount.toString(),
    //                             textAlign: TextAlign.center,
    //                             style: getBoldStyle(
    //                               color: ColorManager.black,
    //                               fontSize: FontSize.s17,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             // height: AppSize.s20,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               // padding: EdgeInsets.all(2.0),
    //                               padding: EdgeInsets.zero,
    //                               onPressed: () {
    //                                 setState(() {
    //                                   _itemCount++;
    //                                 });
    //                               },
    //                               icon: Icon(Icons.add),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(),
    //                     Text(
    //                       'Available in stock',
    //                       softWrap: true,
    //                       style: getBoldStyle(
    //                         color: ColorManager.black,
    //                         fontSize: FontSize.s12,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: AppPadding.p14),
    //                   child: Text(
    //                     'Description',
    //                     softWrap: true,
    //                     style: getBoldStyle(
    //                       color: ColorManager.black,
    //                       fontSize: FontSize.s14,
    //                     ),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(
    //                     top: AppPadding.p4,
    //                   ),
    //                   child: Flexible(
    //                     child: Text(
    //                       'Aliquet dui porttitor sed velit praesent proin sed nec dictum. Justo ligula luctus ultrices nulla nibh varius amet. Pharetra vel sagittis vitae mattis dolor lacus.',
    //                       softWrap: true,
    //                       style: getMediumStyle(
    //                         color: ColorManager.grey,
    //                         fontSize: FontSize.s14,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Image.network(
    //         'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //         fit: BoxFit.cover,
    //         height: MediaQuery.of(context).size.height * 0.45,
    //         width: MediaQuery.of(context).size.width,
    //       ),
    //       // Overlapping container
    //       // Container(
    //       // height: MediaQuery.of(context).size.height,
    //       // width: MediaQuery.of(context).size.width,
    //       // decoration: BoxDecoration(
    //       //   gradient: LinearGradient(
    //       //     begin: Alignment.bottomCenter,
    //       //     end: Alignment.topCenter,
    //       //     colors: [
    //       //       Colors.black.withOpacity(0.5),
    //       //       Colors.transparent,
    //       //     ],
    //       //   ),
    //       // ),
    //       // ),
    //       // Your content here
    //       // ...
    //       Positioned(
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: ColorManager.white,
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20),
    //               topRight: Radius.circular(20),
    //             ),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(AppPadding.p12),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 SizedBox(
    //                   height: AppHeight.h50,
    //                   child: ListView.builder(
    //                     scrollDirection: Axis.horizontal,
    //                     itemCount: 5,
    //                     itemBuilder: (context, index) {
    //                       return Padding(
    //                         padding:
    //                             EdgeInsets.symmetric(horizontal: AppPadding.p2),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(10),
    //                           child: Image.network(
    //                             'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    //                             fit: BoxFit.cover,
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Container(
    //                           padding: EdgeInsets.only(top: AppPadding.p14),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'C Programming Fundamentals II ',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.black,
    // //                                 fontSize: FontSize.s18,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.only(
    //                             top: AppPadding.p4,
    //                           ),
    //                           child: Flexible(
    //                             fit: FlexFit.loose,
    //                             child: Text(
    //                               'Dr. Suresh Rana',
    //                               softWrap: true,
    //                               style: getBoldStyle(
    //                                 color: ColorManager.grey,
    //                                 fontSize: FontSize.s14,
    //                               ),
    //                               textAlign: TextAlign.start,
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),

    //                     // Itemcount counter
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: ColorManager.lighterGrey,
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       child: ButtonBar(
    //                         buttonPadding: EdgeInsets.zero,
    //                         children: [
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               padding: EdgeInsets.zero,
    //                               disabledColor: ColorManager.lightGrey,
    //                               onPressed: _itemCount > 1
    //                                   ? () {
    //                                       setState(() {
    //                                         _itemCount--;
    //                                       });
    //                                     }
    //                                   : null,
    //                               icon: Icon(Icons.remove),
    //                             ),
    //                           ),
    //                           Text(
    //                             // '1',
    //                             _itemCount.toString(),
    //                             textAlign: TextAlign.center,
    //                             style: getBoldStyle(
    //                               color: ColorManager.black,
    //                               fontSize: FontSize.s17,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: AppSize.s40,
    //                             // height: AppSize.s20,
    //                             child: IconButton(
    //                               color: Colors.black,
    //                               // padding: EdgeInsets.all(2.0),
    //                               padding: EdgeInsets.zero,
    //                               onPressed: () {
    //                                 setState(() {
    //                                   _itemCount++;
    //                                 });
    //                               },
    //                               icon: Icon(Icons.add),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Container(),
    //                     Text(
    //                       'Available in stock',
    //                       softWrap: true,
    //                       style: getBoldStyle(
    //                         color: ColorManager.black,
    //                         fontSize: FontSize.s12,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(top: AppPadding.p14),
    //                   child: Text(
    //                     'Description',
    //                     softWrap: true,
    //                     style: getBoldStyle(
    //                       color: ColorManager.black,
    //                       fontSize: FontSize.s14,
    //                     ),
    //                     textAlign: TextAlign.start,
    //                   ),
    //                 ),
    //                 Container(
    //                   padding: EdgeInsets.only(
    //                     top: AppPadding.p4,
    //                   ),
    //                   child: Flexible(
    //                     child: Text(
    //                       'Aliquet dui porttitor sed velit praesent proin sed nec dictum. Justo ligula luctus ultrices nulla nibh varius amet. Pharetra vel sagittis vitae mattis dolor lacus.',
    //                       softWrap: true,
    //                       style: getMediumStyle(
    //                         color: ColorManager.grey,
    //                         fontSize: FontSize.s14,
    //                       ),
    //                       textAlign: TextAlign.start,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.65,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppPadding.p45,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        'C Programming Fundamentals II',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Dr. Suresh Rana',
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Itemcount counter
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ButtonBar(
                                  buttonPadding: EdgeInsets.zero,
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        color: Colors.black,
                                        padding: EdgeInsets.zero,
                                        disabledColor: Colors.grey,
                                        onPressed: _itemCount > 1
                                            ? () {
                                                setState(() {
                                                  _itemCount--;
                                                });
                                              }
                                            : null,
                                        icon: Icon(Icons.remove),
                                      ),
                                    ),
                                    Text(
                                      // '1',
                                      _itemCount.toString(),
                                      textAlign: TextAlign.center,
                                      style: getBoldStyle(
                                        color: ColorManager.black,
                                        fontSize: FontSize.s17,
                                      ),
                                    ),
                                    SizedBox(
                                      width: AppSize.s40,
                                      // height: AppSize.s20,
                                      child: IconButton(
                                        color: Colors.black,
                                        // padding: EdgeInsets.all(2.0),
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          setState(() {
                                            _itemCount++;
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                            top: AppMargin.m4,
                          ),
                          child: Text(
                            'Available in stock',
                            softWrap: true,
                            style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: AppPadding.p14),
                          child: Text(
                            'Description',
                            style: getBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          // height: 200,
                          padding: EdgeInsets.only(
                            top: AppPadding.p4,
                          ),
                          child: Text(
                            'Aliquet dui porttitor sed velit praesent proin sed nec dictum. Justo ligula luctus ultrices nulla nibh varius amet. Pharetra vel sagittis vitae mattis dolor lacus.',
                            style: getMediumStyle(
                              color: ColorManager.grey,
                              fontSize: FontSize.s14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),

                        // SizedBox(
                        //   height: 100,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p8,
        ),
        child: SizedBox(
          height: AppHeight.h40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Total price',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: FontSize.s12,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppPadding.p2,
                    ),
                    child: Text(
                      'Rs. 999',
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: FontSize.s17,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart),
                label: Text(
                  'Add to cart',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
