import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/widgets/app_drawer.dart';
import 'package:share_learning/templates/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';

import '../../models/session.dart';
import '../../models/user.dart';
import '../../providers/books.dart';
import '../../providers/orders.dart';
import '../../providers/sessions.dart';
import '../../providers/users.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  static const routeName = '/home_new';

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final _form = GlobalKey<FormState>();
  final _filterForm = GlobalKey<FormState>();
  int _selectedIndex = 0;

  List<String> categories = [
    "Adventure",
    "Drama",
    "Comic",
    "Biography",
    "Scientific",
    "Food",
    "Clothing",
    "Electronics",
    "Grocery",
    "Health",
  ];

  List<String> images = [
    'https://images.unsplash.com/photo-1679428997403-c75e1c148b28?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    'https://images.unsplash.com/photo-1679760452619-cf2dcb88b659?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
    'https://images.unsplash.com/photo-1679946026929-454c89c3af10?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1440&q=80',
    'https://images.unsplash.com/photo-1679766826593-738e9b6338c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=627&q=80',
    'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'
  ];

  List<String> locationOptions = [
    'Kathmandu',
    'Bhaktapur',
    'Lalitpur',
    'Nepalgunj',
  ];

  Map<String, dynamic> filterOptions = {
    'selected_loaction': '',
    'min_price': 0,
    'max_price': 0,
  };

  User _user = new User(
      id: "temp",
      firstName: 'firstName',
      lastName: 'lastName',
      username: 'username',
      email: 'email',
      phone: 'phone',
      image: null,
      description: 'description',
      userClass: 'userClass',
      followers: 'followers',
      createdDate: DateTime.now());

  _setUserValue(User user) {
    // this.user = user;
    _user = user;
  }

  ScrollController _scrollController = ScrollController();
  // double _appBarHeight = 100.0;
  double _appBarHeight = 75.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      if (_scrollController.offset > 0 && _scrollController.offset < 30) {
        _appBarHeight = 75.0 - _scrollController.offset;
      } else if (_scrollController.offset >= 30) {
        _appBarHeight = 50.0;
      } else {
        _appBarHeight = 75.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;
    // Session authenticatedSession = args['authSession'] as Session;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    Session authenticatedSession;
    if (args['authSession'] != null) {
      authenticatedSession = args['authSession'] as Session;
    } else {
      authenticatedSession =
          Provider.of<SessionProvider>(context).session as Session;
    }

    Users _users = context.watch<Users>();
    if (_users.user == null) {
      _users.getUserByToken(authenticatedSession.accessToken);
    } else {
      _user = _users.user as User;
    }
    Books _books = context.watch<Books>();

    Orders _orders = context.watch<Orders>();

    return SafeArea(
      child: Scaffold(
        // body: CustomScrollView(
        //   slivers: [
        //     SliverAppBar(
        //       pinned: true,
        //       expandedHeight: 300,
        //       leading: Padding(
        //         padding: const EdgeInsets.only(left: AppPadding.p20),
        //         child: CircleAvatar(
        //           backgroundColor: ColorManager.black,
        //           radius: 30,
        //           child: Builder(
        //             builder: (context) {
        //               return IconButton(
        //                 icon: Icon(
        //                   Icons.menu,
        //                   size: AppSize.s22,
        //                 ),
        //                 onPressed: () => Scaffold.of(context).openDrawer(),
        //                 color: ColorManager.white,
        //               );
        //             },
        //           ),
        //         ),
        //       ),
        //       actions: [
        //         Padding(
        //           padding: const EdgeInsets.only(right: AppPadding.p20),
        //           child: CircleAvatar(
        //             radius: 25,
        //             child: Image.asset(
        //               ImageAssets.noProfile,
        //             ),
        //           ),
        //         ),
        //       ],
        //       flexibleSpace: FlexibleSpaceBar(
        //         // title: Text('Hello'),
        //         title: Row(
        //           children: [
        //             Form(
        //               key: _form,
        //               child: Expanded(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(right: 12),
        //                   child: TextFormField(
        //                     cursorColor: ColorManager.white,
        //                     decoration: InputDecoration(
        //                       prefixIcon: Icon(Icons.search),
        //                       prefixIconColor: ColorManager.primary,
        //                       fillColor: ColorManager.white,
        //                       filled: true,
        //                       focusColor: ColorManager.white,
        //                       labelText: 'Book Name',
        //                       enabledBorder: OutlineInputBorder(
        //                         borderSide: BorderSide(
        //                           color: ColorManager.white,
        //                         ),
        //                         borderRadius: BorderRadius.circular(20),
        //                       ),
        //                       focusedBorder: OutlineInputBorder(
        //                         borderSide: BorderSide(
        //                           color: ColorManager.white,
        //                         ),
        //                         borderRadius: BorderRadius.circular(20),
        //                       ),
        //                     ),
        //                     textInputAction: TextInputAction.next,
        //                     validator: (value) {
        //                       if (value!.isEmpty) {
        //                         return 'Please provide the bookName';
        //                       }
        //                       return null;
        //                     },
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             CircleAvatar(
        //               backgroundColor: ColorManager.black,
        //               radius: 25,
        //               child: IconButton(
        //                 onPressed: () {},
        //                 icon: Icon(Icons.settings),
        //                 color: ColorManager.white,
        //               ),
        //             ),
        //           ],
        //         ),
        //         background: Container(
        //           // height: MediaQuery.of(context).size.height,
        //           color: ColorManager.grey,
        //           child: Column(
        //             children: [
        //               Stack(
        //                 clipBehavior: Clip.none,
        //                 children: [
        //                   Stack(
        //                     children: [
        //                       Container(
        //                         height: 300,
        //                         // height:
        //                         //     MediaQuery.of(context).size.height * 0.17,
        //                         decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.only(
        //                             bottomLeft: Radius.circular(25),
        //                             bottomRight: Radius.circular(25),
        //                           ),
        //                           color: ColorManager.primary,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   Positioned(
        //                     bottom: -10,
        //                     left: 0,
        //                     right: 0,
        //                     child: Padding(
        //                       padding:
        //                           const EdgeInsets.symmetric(horizontal: 12),
        //                       child: Container(),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     SliverList(
        //       delegate: SliverChildBuilderDelegate(
        //         (context, index) => ListTile(
        //           title: Text("Item $index"),
        //         ),
        //         childCount: 20,
        //       ),
        //     ),
        //   ],
        // ),
        appBar: AppBar(
          toolbarHeight: _appBarHeight,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: AppPadding.p20),
            child: CircleAvatar(
              backgroundColor: ColorManager.black,
              radius: 30,
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: AppSize.s22,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    color: ColorManager.white,
                  );
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p20,
                top: AppPadding.p4,
                bottom: AppPadding.p4,
              ),
              child: CircleAvatar(
                radius: 20,
                child: Image.asset(
                  ImageAssets.noProfile,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            // height: MediaQuery.of(context).size.height,
            color: ColorManager.grey,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            color: ColorManager.primary,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -10,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Form(
                              key: _form,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextFormField(
                                    cursorColor: ColorManager.white,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      prefixIconColor: ColorManager.primary,
                                      fillColor: ColorManager.white,
                                      filled: true,
                                      focusColor: ColorManager.white,
                                      labelText: 'Search',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.white,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please provide the bookName';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: ColorManager.black,
                              radius: 25,
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    barrierColor:
                                        ColorManager.blackWithLowOpacity,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(AppRadius.r20),
                                            topRight: Radius.circular(
                                                AppRadius.r20))),
                                    context: context,
                                    builder: (context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          height: 300,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppPadding.p20,
                                          ),
                                          child: Form(
                                            key: _filterForm,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Filters',
                                                            style: getBoldStyle(
                                                              fontSize:
                                                                  AppSize.s24,
                                                              color:
                                                                  ColorManager
                                                                      .black,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons.cancel,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: AppPadding.p4,
                                                        ),
                                                        child: Text(
                                                          'Price Range',
                                                          style: getBoldStyle(
                                                            fontSize:
                                                                AppSize.s16,
                                                            color: ColorManager
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                fillColor:
                                                                    ColorManager
                                                                        .lighterGrey,
                                                                filled: true,
                                                                prefix:
                                                                    Text('Rs.'),
                                                                label: Text(
                                                                  'min',
                                                                  style:
                                                                      TextStyle(
                                                                    color: ColorManager
                                                                        .lighterGrey,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                AppMargin.m20,
                                                          ),
                                                          Flexible(
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration:
                                                                  InputDecoration(
                                                                prefix:
                                                                    Text('Rs.'),
                                                                label: Text(
                                                                  'max',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: AppPadding.p12,
                                                        ),
                                                        child: Divider(
                                                          height: 2,
                                                          thickness: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: AppPadding.p4,
                                                        ),
                                                        child: Text(
                                                          'Location',
                                                          style: getBoldStyle(
                                                            fontSize:
                                                                AppSize.s16,
                                                            color: ColorManager
                                                                .black,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                          color: Colors.grey,
                                                          width: 1.0,
                                                          style:
                                                              BorderStyle.solid,
                                                        )),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton(
                                                              isExpanded: true,
                                                              value:
                                                                  locationOptions[
                                                                      0],
                                                              // style: getMediumStyle(
                                                              //   color: ColorManager
                                                              //       .black,
                                                              // ),

                                                              items:
                                                                  locationOptions
                                                                      .map((option) =>
                                                                          DropdownMenuItem(
                                                                            child:
                                                                                Text(
                                                                              option,
                                                                              // style:
                                                                              //     getMediumStyle(
                                                                              //   color: ColorManager
                                                                              //       .black,
                                                                              // ),
                                                                            ),
                                                                            value:
                                                                                option,
                                                                          ))
                                                                      .toList(),
                                                              onChanged:
                                                                  (value) {}),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          top: AppPadding.p12,
                                                        ),
                                                        child: Divider(
                                                          height: 2,
                                                          thickness: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.settings),
                                color: ColorManager.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: FilterChip(
                          label: Text(categories[index]),
                          selectedColor: ColorManager.primary,
                          showCheckmark: false,
                          selected: _selectedIndex == index,
                          onSelected: (bool isSelected) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                MasonryGridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: images.length,
                  itemBuilder: (ctx, idx) => Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image.network(
                              images[idx],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                right: 8,
                              ),
                              child: CircleAvatar(
                                backgroundColor: ColorManager.black,
                                radius: 14,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      // Position the IconButton in the center of the CircleAvatar
                                      top: -9,
                                      left: -10,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_border,
                                          size: 24,
                                        ),
                                        color: ColorManager.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'C Programming Fundamentals II',
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s16,
                              ),
                            ),
                            SizedBox(
                              height: AppHeight.h2,
                            ),
                            Text(
                              'Rs. 999',
                              style: getBoldStyle(
                                color: ColorManager.grey,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        drawer: AppDrawer(authenticatedSession, null),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );

    // return SafeArea(
    //   child: Scaffold(
    //     extendBody: true,
    //     appBar: AppBar(
    //       toolbarHeight: AppHeight.h100,
    //       elevation: 0.0,
    //       leading: Padding(
    //         padding: const EdgeInsets.only(left: AppPadding.p20),
    //         child: CircleAvatar(
    //           backgroundColor: ColorManager.black,
    //           radius: 30,
    //           child: Builder(
    //             builder: (context) {
    //               return IconButton(
    //                 icon: Icon(
    //                   Icons.menu,
    //                   size: AppSize.s22,
    //                 ),
    //                 onPressed: () => Scaffold.of(context).openDrawer(),
    //                 color: ColorManager.white,
    //               );
    //             },
    //           ),
    //         ),
    //       ),
    //       actions: [
    //         Padding(
    //           padding: const EdgeInsets.only(right: AppPadding.p20),
    //           child: CircleAvatar(
    //             radius: 25,
    //             child: Image.asset(
    //               ImageAssets.noProfile,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //     body: SingleChildScrollView(
    //       child: Container(
    //         // height: MediaQuery.of(context).size.height,
    //         color: ColorManager.grey,
    //         child: Column(
    //           children: [
    //             Stack(
    //               clipBehavior: Clip.none,
    //               children: [
    //                 Stack(
    //                   children: [
    //                     Container(
    //                       // height: 175,
    //                       height: MediaQuery.of(context).size.height * 0.17,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.only(
    //                           bottomLeft: Radius.circular(25),
    //                           bottomRight: Radius.circular(25),
    //                         ),
    //                         color: ColorManager.primary,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Positioned(
    //                   bottom: -10,
    //                   left: 0,
    //                   right: 0,
    //                   child: Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 12),
    //                     child: Row(
    //                       children: [
    //                         Form(
    //                           key: _form,
    //                           child: Expanded(
    //                             child: Padding(
    //                               padding: const EdgeInsets.only(right: 12),
    //                               child: TextFormField(
    //                                 cursorColor: ColorManager.white,
    //                                 decoration: InputDecoration(
    //                                   prefixIcon: Icon(Icons.search),
    //                                   prefixIconColor: ColorManager.primary,
    //                                   fillColor: ColorManager.white,
    //                                   filled: true,
    //                                   focusColor: ColorManager.white,
    //                                   labelText: 'Book Name',
    //                                   enabledBorder: OutlineInputBorder(
    //                                     borderSide: BorderSide(
    //                                       color: ColorManager.white,
    //                                     ),
    //                                     borderRadius: BorderRadius.circular(20),
    //                                   ),
    //                                   focusedBorder: OutlineInputBorder(
    //                                     borderSide: BorderSide(
    //                                       color: ColorManager.white,
    //                                     ),
    //                                     borderRadius: BorderRadius.circular(20),
    //                                   ),
    //                                 ),
    //                                 textInputAction: TextInputAction.next,
    //                                 validator: (value) {
    //                                   if (value!.isEmpty) {
    //                                     return 'Please provide the bookName';
    //                                   }
    //                                   return null;
    //                                 },
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         CircleAvatar(
    //                           backgroundColor: ColorManager.black,
    //                           radius: 25,
    //                           child: IconButton(
    //                             onPressed: () {},
    //                             icon: Icon(Icons.settings),
    //                             color: ColorManager.white,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(
    //               height: 100,
    //               child: ListView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: categories.length,
    //                 itemBuilder: (context, index) {
    //                   return Padding(
    //                     padding: const EdgeInsets.symmetric(horizontal: 6),
    //                     child: FilterChip(
    //                       label: Text(categories[index]),
    //                       selectedColor: ColorManager.primary,
    //                       showCheckmark: false,
    //                       selected: _selectedIndex == index,
    //                       onSelected: (bool isSelected) {
    //                         setState(() {
    //                           _selectedIndex = index;
    //                         });
    //                       },
    //                     ),
    //                   );
    //                 },
    //               ),
    //             ),
    //             MasonryGridView.builder(
    //               physics: NeverScrollableScrollPhysics(),
    //               shrinkWrap: true,
    //               crossAxisSpacing: 12,
    //               mainAxisSpacing: 12,
    //               gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisCount: 2),
    //               itemCount: images.length,
    //               itemBuilder: (ctx, idx) => Column(
    //                 children: [
    //                   Stack(
    //                     children: [
    //                       ClipRRect(
    //                         borderRadius: BorderRadius.only(
    //                           topLeft: Radius.circular(10),
    //                           topRight: Radius.circular(10),
    //                         ),
    //                         child: Image.network(
    //                           images[idx],
    //                         ),
    //                       ),
    //                       Align(
    //                         alignment: Alignment.topRight,
    //                         child: Padding(
    //                           padding: const EdgeInsets.only(
    //                             top: 8,
    //                             right: 8,
    //                           ),
    //                           child: CircleAvatar(
    //                             backgroundColor: ColorManager.black,
    //                             radius: 14,
    //                             child: Stack(
    //                               children: [
    //                                 Positioned(
    //                                   // Position the IconButton in the center of the CircleAvatar
    //                                   top: -9,
    //                                   left: -10,
    //                                   child: IconButton(
    //                                     onPressed: () {},
    //                                     icon: Icon(
    //                                       Icons.favorite_border,
    //                                       size: 24,
    //                                     ),
    //                                     color: ColorManager.white,
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                   Container(
    //                     width: double.infinity,
    //                     decoration: BoxDecoration(
    //                       color: ColorManager.white,
    //                       borderRadius: BorderRadius.only(
    //                         bottomLeft: Radius.circular(10),
    //                         bottomRight: Radius.circular(10),
    //                       ),
    //                     ),
    //                     padding: EdgeInsets.all(12),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           'C Programming Fundamentals II',
    //                           style: getBoldStyle(
    //                             color: ColorManager.black,
    //                             fontSize: FontSize.s16,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: AppHeight.h2,
    //                         ),
    //                         Text(
    //                           'Rs. 999',
    //                           style: getBoldStyle(
    //                             color: ColorManager.grey,
    //                             fontSize: FontSize.s14,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     drawer: AppDrawer(authenticatedSession, null),
    //     bottomNavigationBar: CustomBottomNavigationBar(),
    //   ),
    // );
  }
}
