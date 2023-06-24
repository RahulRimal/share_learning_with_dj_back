import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/utils/alert_helper.dart';
import 'package:share_learning/templates/widgets/post_comments_new.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';

import '../../models/cart.dart';
import '../../models/cart_item.dart';
import '../../models/session.dart';
import '../../models/user.dart';
import '../../view_models/providers/order_request_provider.dart';
import '../../view_models/providers/session_provider.dart';
import '../managers/color_manager.dart';
import '../managers/font_manager.dart';
import '../managers/routes_manager.dart';
import '../managers/style_manager.dart';
import '../utils/loading_helper.dart';
import '../widgets/billing_info.dart';

class PostDetailsScreen extends StatefulWidget {
  // static const routeName = '/post-details-screen';

  const PostDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  BookProvider? bookProvider;

  @override
  void initState() {
    super.initState();
    bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider!.postDetailsScreenBindPostDetailsScreen(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Added this line to save the reference of provider so it doesn't throw an exception on dispose
    bookProvider = Provider.of<BookProvider>(context, listen: false);
  }

  @override
  void dispose() {
    bookProvider!.unBindPostDetailsScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();
    ThemeData _theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: ColorManager.lighterGrey,
      body: Stack(
        children: [
          // DetailsPageImageGallery(selectedPost: _bookProvider.selectedBook),
          DetailsPageImageGallery(),
          Positioned(
            bottom: AppHeight.h18,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              constraints: BoxConstraints(),
              decoration: BoxDecoration(
                color: _theme.colorScheme.background,
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
                                  Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.9,
                                    width: 90.w,
                                    child: Text(
                                      _bookProvider
                                          .postDetailsScreenSelectedBook
                                          .bookName,
                                      softWrap: true,
                                      // style: TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      //   color: Colors.black,
                                      //   fontSize: 18,
                                      // ),
                                      style: _theme.textTheme.displayLarge,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Container(
                                    width: 90.w,
                                    child: Text(
                                      _bookProvider
                                          .postDetailsScreenSelectedBook.author,
                                      softWrap: true,
                                      // style: TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      //   color: Colors.grey,
                                      //   fontSize: 14,
                                      // ),
                                      style: _theme.textTheme.bodyMedium,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  // Flexible(
                                  //   flex: 2,
                                  //   child: Container(
                                  //     padding: EdgeInsets.only(top: 4),
                                  //     child: Text(
                                  //       post.author,
                                  //       softWrap: true,
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.bold,
                                  //         color: Colors.grey,
                                  //         fontSize: 14,
                                  //       ),
                                  //       textAlign: TextAlign.start,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // Itemcount counter
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.grey[200],
                              //     borderRadius: BorderRadius.circular(20),
                              //   ),
                              //   child: ButtonBar(
                              //     buttonPadding: EdgeInsets.zero,
                              //     children: [
                              //       SizedBox(
                              //         width: 40,
                              //         child: IconButton(
                              //           color: Colors.black,
                              //           padding: EdgeInsets.zero,
                              //           disabledColor: Colors.grey,
                              //           onPressed: _itemCount > 1
                              //               ? () {
                              //                   setState(() {
                              //                     _itemCount--;
                              //                   });
                              //                 }
                              //               : null,
                              //           icon: Icon(Icons.remove),
                              //         ),
                              //       ),
                              //       Text(
                              //         // '1',
                              //         _itemCount.toString(),
                              //         textAlign: TextAlign.center,
                              //         style: getBoldStyle(
                              //           color: ColorManager.black,
                              //           fontSize: FontSize.s17,
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: AppSize.s40,
                              //         // height: AppSize.s20,
                              //         child: IconButton(
                              //           color: Colors.black,
                              //           // padding: EdgeInsets.all(2.0),
                              //           padding: EdgeInsets.zero,
                              //           onPressed: () {
                              //             setState(() {
                              //               _itemCount++;
                              //             });
                              //           },
                              //           icon: Icon(Icons.add),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // ItemCounter(
                              //     // itemCount: _itemCount,
                              //     // increaseItemCount: _increaseItemCount,
                              //     // decreaseItemCount: _decreaseItemCount,
                              //     ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: AppPadding.p14),
                          child: Text(
                            'Description',
                            // style: getBoldStyle(
                            //   color: ColorManager.black,
                            //   fontSize: FontSize.s14,
                            // ),
                            style: _theme.textTheme.headlineSmall,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          // height: 200,
                          padding: EdgeInsets.only(
                            top: AppPadding.p4,
                          ),
                          child: Text(
                            _bookProvider
                                .postDetailsScreenSelectedBook.description,
                            
                            style: _theme.textTheme.bodyMedium,
                            textAlign: TextAlign.start,
                          ),
                        ),

                        // ! Comments Starts here
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppPadding.p20,
                            
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Comments',
                                
                                style: _theme.textTheme.headlineSmall,
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  height: 5,
                                  indent: 15,
                                  // color: Theme.of(context).primaryColor,
                                  color: ColorManager.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PostCommentsNew(),

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Recommendations for you',
                          
                          
                          style: _theme.textTheme.headlineSmall,
                        ),
                        Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // bottomSheet: CartBottomSheet(
      //   selectedPost: _bookProvider.selectedBook,
      //   loggedInUser: _bookProvider.user,
      // ),
      bottomSheet: PostDetailsScreenBottomSheet(),
    );
  }
}

class SinglePostCommenstSection extends StatefulWidget {
  SinglePostCommenstSection({
    Key? key,
  }) : super(key: key);

  @override
  State<SinglePostCommenstSection> createState() =>
      _SinglePostCommenstSectionState();
}

class _SinglePostCommenstSectionState extends State<SinglePostCommenstSection> {
  @override
  Widget build(BuildContext context) {
    

    return Column(
      children: [
        // Comments Starts here
        Padding(
          padding: const EdgeInsets.only(
            top: AppPadding.p20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Comments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 1,
                  height: 5,
                  indent: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),

        // PostCommentsNew(

        //     _bookProvider.sessionProvider.session as Session,
        //     _bookProvider.user,
        //     _bookProvider.selectedBook.id,
        //     ),
        PostCommentsNew(),
      ],
    );
  }
}

class PostDetailsScreenBottomSheet extends StatefulWidget {
  const PostDetailsScreenBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<PostDetailsScreenBottomSheet> createState() => _PostDetailsScreenBottomSheetState();
}

class _PostDetailsScreenBottomSheetState extends State<PostDetailsScreenBottomSheet> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();
    ThemeData _theme = Theme.of(context);

    if(_bookProvider.postDetailsScreenSelectedBook.postType=='S')
    return _widgetForSellingTypePost();
    else
    return _widgetForBuyingTypePost();
  }
    _widgetForBuyingTypePost(){
    BookProvider _bookProvider = context.watch<BookProvider>();
    ThemeData _theme = Theme.of(context);
      if ((_bookProvider.userProvider.user as User).id ==
        _bookProvider.postDetailsScreenSelectedBook.userId) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p4,
        ),
        child: ElevatedButton(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.center,
            child: Text(
              'Edit post',
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          onPressed: () {
            _bookProvider.setEditPostScreenSelectedBook(
                _bookProvider.postDetailsScreenSelectedBook);
            Navigator.of(context)
                .pushNamed(RoutesManager.editPostScreenRoute, arguments: {});
          },
        ),
      );
    }
    if (_bookProvider.orderRequestProvider.orderRequestsByUserContains(
        int.parse(_bookProvider.postDetailsScreenSelectedBook.id))) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutesManager.orderRequestScreenRoute,
            );
          },
          style: ElevatedButton.styleFrom(
            // backgroundColor: ColorManager.primary,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          child: const Text(
            "Check request status",
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p8,
        ),
        child: Container(
          height: AppHeight.h40,
          color: _theme.bottomSheetTheme.backgroundColor,
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
                      
                      style: _theme.textTheme.headlineSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppPadding.p2,
                    ),
                    child: Text(
                      'Rs. ${_bookProvider.postDetailsScreenSelectedBook.price}',
                      softWrap: true,
                      
                      style: _theme.textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              _bookProvider.orderRequestProvider.orderRequestsByUser
                          .firstWhereOrNull((orderRequest) =>
                              orderRequest.product.id ==
                              int.parse(_bookProvider
                                  .postDetailsScreenSelectedBook.id)) !=
                      null
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Check request progress',
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          barrierColor: ColorManager.blackWithLowOpacity,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppRadius.r20),
                              topRight: Radius.circular(
                                AppRadius.r20,
                              ),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            
                            return Padding(
                              padding: EdgeInsets.only(
                                top: AppPadding.p20,
                                left: AppPadding.p12,
                                right: AppPadding.p12,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom + AppPadding.p12,
                              ),
                              child: Form(
                                key: _form,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppPadding.p8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppPadding.p12,
                                              ),
                                              child: TextFormField(
                                                initialValue: _bookProvider
                                                    .postDetailsScreenSelectedBook
                                                    .price
                                                    .round()
                                                    .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                focusNode: _bookProvider
                                                    .postDetailsPageCartBottomSheetBuyerPriceFocusNode,
                                                decoration: InputDecoration(
                                                  prefix: Text('Rs. '),
                                                  labelText:
                                                      'Your offer price per piece',
                                                  focusColor: Colors.redAccent,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_bookProvider
                                                          .postDetailsPageCartBottomSheetBuyerBooksCountFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Price can\'t be empty';
                                                  }
                                                  if (double.tryParse(value) ==
                                                      null) {
                                                    return 'Invalid number';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  _bookProvider
                                                      .postDetailsScreenSetExpectedUnitPrice(
                                                          double.parse(value));
                                                  if (_bookProvider
                                                          .postDetailsScreenExpectedUnitPrice ==
                                                      _bookProvider
                                                          .postDetailsScreenSelectedBook
                                                          .price) {
                                                    _bookProvider
                                                        .postDetailsScreenSetEnableRequestButton(
                                                            false);
                                                  } else {
                                                    _bookProvider
                                                        .postDetailsScreenSetEnableRequestButton(
                                                            true);
                                                  }
                                                  // });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppPadding.p12,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // color: Colors.grey[200],
                                                color: _theme.brightness ==
                                                        Brightness.dark
                                                    ? _theme
                                                        .colorScheme.background
                                                    : ColorManager.lightestGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        IconButton(
                                                      // color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: bookProvider
                                                                  .postDetailsScreenItemCount >
                                                              1
                                                          ? () {
                                                              // setState(() {
                                                              bookProvider
                                                                  .postDetailsScreenSetItemCount(
                                                                      bookProvider
                                                                              .postDetailsScreenItemCount -
                                                                          1);

                                                              // });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.remove),
                                                    ),
                                                  ),
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        AnimatedSwitcher(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            child: Text(
                                                              bookProvider
                                                                  .postDetailsScreenItemCount
                                                                  .toString(),
                                                              key: ValueKey(
                                                                  bookProvider
                                                                      .postDetailsScreenItemCount),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              // style:
                                                              //     getBoldStyle(
                                                              //   color:
                                                              //       ColorManager
                                                              //           .black,
                                                              //   fontSize:
                                                              //       FontSize
                                                              //           .s17,
                                                              // ),
                                                              style: _theme
                                                                  .textTheme
                                                                  .headlineMedium,
                                                            ),
                                                            transitionBuilder: (Widget
                                                                    child,
                                                                Animation<
                                                                        double>
                                                                    animation) {
                                                              return ScaleTransition(
                                                                  scale:
                                                                      animation,
                                                                  child: child);
                                                            }),
                                                  ),
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        IconButton(
                                                      // color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: bookProvider
                                                                  .postDetailsScreenSelectedBook
                                                                  .bookCount >
                                                              bookProvider
                                                                  .postDetailsScreenItemCount
                                                          ? () {
                                                              // setState(() {
                                                              bookProvider
                                                                  .postDetailsScreenSetItemCount(
                                                                      bookProvider
                                                                              .postDetailsScreenItemCount +
                                                                          1);
                                                              // });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Consumer<BookProvider>(
                                      builder:
                                          (context, bookProvider, child) =>
                                              ElevatedButton.icon(
                                                style: _theme.brightness == Brightness.dark ? ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all( ColorManager.primary,),
                                                ): null,
                                        
                                        icon: bookProvider
                                                .postDetailsScreenIsRequestOnProcess
                                            ? SizedBox(
                                                height: AppHeight.h20,
                                                width: AppHeight.h20,
                                                child:
                                                    CircularProgressIndicator
                                                        .adaptive(
                                                  strokeWidth: 3,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.white),
                                                  backgroundColor:
                                                      ColorManager.primary,
                                                ),
                                              )
                                            : Container(),
                                        label: bookProvider
                                      .postDetailsScreenIsRequestOnProcess
                                  ? LoadingHelper.showTextLoading('Sending you offer')
                                  : Text(
                                      'Send the offer',
                                      
                                      style: _theme.textTheme.headlineLarge,
                                    ),

                                        
                                        onPressed: !bookProvider
                                                .postDetailsScreenEnableRequestButton
                                            ? null
                                            : () async {

                                              bookProvider.postDetailsScreenSetIsRequestOnProcess(true);
                                                final isValid = _form
                                                    .currentState!
                                                    .validate();
                                                if (!isValid) {
                                                  AlertHelper.showToastAlert(
                                                      'Something went wrong');
                                                }
                                                bookProvider.postDetailsScreenSetEnableRequestButton(false);
                                                
                                                _form.currentState!.save();
                                                Map<String, dynamic>
                                                    requestInfo = {
                                                  'product_id': _bookProvider
                                                      .postDetailsScreenSelectedBook
                                                      .id,
                                                  'quantity': _bookProvider
                                                      .postDetailsScreenItemCount,
                                                  'requested_price':
                                                      _bookProvider
                                                          .postDetailsScreenSelectedBook.price,
                                                  'seller_offer_price': _bookProvider.postDetailsScreenExpectedUnitPrice,
                                                  'changed_by_seller': true,
                                                };
                                    
                                                if (await Provider.of<
                                                  OrderRequestProvider>(context,
                                              listen: false)
                                          .createOrderRequest(
                                              Provider.of<SessionProvider>(
                                                      context,
                                                      listen: false)
                                                  .session as Session,
                                              
                                              json.decode(json.encode( requestInfo)))) {
                                        bookProvider
                                            .postDetailsScreenSetIsRequestOnProcess(
                                                false);
                                        AlertHelper.showToastAlert(
                                            'Offer has been sent successfully');
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // Navigator.pop(context);
                                      } else {
                                        AlertHelper.showToastAlert(
                                            'Something went wrong');
                                      }
                                      bookProvider
                                          .postDetailsScreenSetEnableRequestButton(
                                              false);
                                      bookProvider
                                          .postDetailsScreenSetIsRequestOnProcess(
                                              false);
                                               
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.bookmark),
                      label: Text(
                        
                        'I have this book',
                        style: getBoldStyle(color: ColorManager.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  

  }


  _widgetForSellingTypePost(){
    BookProvider _bookProvider = context.watch<BookProvider>();
    ThemeData _theme = Theme.of(context);
      if ((_bookProvider.userProvider.user as User).id ==
        _bookProvider.postDetailsScreenSelectedBook.userId) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p4,
        ),
        child: ElevatedButton(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.05,
            alignment: Alignment.center,
            child: Text(
              'Edit post',
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          onPressed: () {
            _bookProvider.setEditPostScreenSelectedBook(
                _bookProvider.postDetailsScreenSelectedBook);
            Navigator.of(context)
                .pushNamed(RoutesManager.editPostScreenRoute, arguments: {});
          },
        ),
      );
    }
    if (_bookProvider.cartProvider.cartItemsContains(
        int.parse(_bookProvider.postDetailsScreenSelectedBook.id))) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutesManager.cartScreenRoute,
            );
          },
          style: ElevatedButton.styleFrom(
            // primary: ColorManager.primaryColorWithOpacity,
            // backgroundColor: ColorManager.primary,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          child: const Text(
            // "Already added to cart",
            "Go to cart",
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    
    }
    if (_bookProvider.orderRequestProvider.orderRequestsByUserContains(
        int.parse(_bookProvider.postDetailsScreenSelectedBook.id))) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p12,
          horizontal: AppPadding.p12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutesManager.orderRequestScreenRoute,
            );
          },
          style: ElevatedButton.styleFrom(
            // backgroundColor: ColorManager.primary,
            minimumSize: const Size.fromHeight(40), // NEW
          ),
          child: const Text(
            "Check request status",
            style: TextStyle(
              fontSize: FontSize.s16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p8,
        ),
        child: Container(
          height: AppHeight.h40,
          color: _theme.bottomSheetTheme.backgroundColor,
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
                      // style: TextStyle(
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.grey,
                      //   fontSize: FontSize.s12,
                      // ),
                      style: _theme.textTheme.headlineSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: AppPadding.p2,
                    ),
                    child: Text(
                      'Rs. ${_bookProvider.postDetailsScreenSelectedBook.price}',
                      softWrap: true,
                      // style: TextStyle(
                      //   fontWeight: FontWeight.bold,
                      //   color: Colors.black,
                      //   fontSize: FontSize.s17,
                      // ),
                      style: _theme.textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              _bookProvider.orderRequestProvider.orderRequestsByUser
                          .firstWhereOrNull((orderRequest) =>
                              orderRequest.product.id ==
                              int.parse(_bookProvider
                                  .postDetailsScreenSelectedBook.id)) !=
                      null
                  ? ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Check request progress',
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          barrierColor: ColorManager.blackWithLowOpacity,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppRadius.r20),
                              topRight: Radius.circular(
                                AppRadius.r20,
                              ),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            
                            return Padding(
                              padding: EdgeInsets.only(
                                top: AppPadding.p8,
                                left: AppPadding.p8,
                                right: AppPadding.p8,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Form(
                                key: _form,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppPadding.p8,
                                          horizontal: AppPadding.p12,
                                        ),
                                        child: TextFormField(
                                          controller: _bookProvider
                                              .postDetailsScreenDatePickercontroller,
                                          focusNode: _bookProvider
                                              .postDetailsPageCartBottomSheetBuyerDateFocusNode,
                                          keyboardType: TextInputType.datetime,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: AppPadding.p12,
                                                bottom: AppPadding.p8),
                                            labelText: 'Your expected deadline',
                                            suffix: IconButton(
                                              icon: Icon(Icons.calendar_today),
                                              tooltip:
                                                  'Tap to open date picker',
                                              onPressed: () {
                                                _bookProvider
                                                    .postDetailsScreenShowPicker(
                                                        context);
                                              },
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _bookProvider
                                                    .postDetailsPageCartBottomSheetBuyerPriceFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide your expected deadline';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppPadding.p8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppPadding.p12,
                                              ),
                                              child: TextFormField(
                                                initialValue: _bookProvider
                                                    .postDetailsScreenSelectedBook
                                                    .price
                                                    .round()
                                                    .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                focusNode: _bookProvider
                                                    .postDetailsPageCartBottomSheetBuyerPriceFocusNode,
                                                decoration: InputDecoration(
                                                  prefix: Text('Rs. '),
                                                  labelText:
                                                      'Expected price per piece',
                                                  focusColor: Colors.redAccent,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_bookProvider
                                                          .postDetailsPageCartBottomSheetBuyerBooksCountFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Price can\'t be empty';
                                                  }
                                                  if (double.tryParse(value) ==
                                                      null) {
                                                    return 'Invalid number';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  _bookProvider
                                                      .postDetailsScreenSetExpectedUnitPrice(
                                                          double.parse(value));
                                                  if (_bookProvider
                                                          .postDetailsScreenExpectedUnitPrice ==
                                                      _bookProvider
                                                          .postDetailsScreenSelectedBook
                                                          .price) {
                                                    _bookProvider
                                                        .postDetailsScreenSetEnableRequestButton(
                                                            false);
                                                  } else {
                                                    _bookProvider
                                                        .postDetailsScreenSetEnableRequestButton(
                                                            true);
                                                  }
                                                  // });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppPadding.p12,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // color: Colors.grey[200],
                                                color: _theme.brightness ==
                                                        Brightness.dark
                                                    ? _theme
                                                        .colorScheme.background
                                                    : ColorManager.lightestGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        IconButton(
                                                      // color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: bookProvider
                                                                  .postDetailsScreenItemCount >
                                                              1
                                                          ? () {
                                                              // setState(() {
                                                              bookProvider
                                                                  .postDetailsScreenSetItemCount(
                                                                      bookProvider
                                                                              .postDetailsScreenItemCount -
                                                                          1);

                                                              // });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.remove),
                                                    ),
                                                  ),
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        AnimatedSwitcher(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            child: Text(
                                                              bookProvider
                                                                  .postDetailsScreenItemCount
                                                                  .toString(),
                                                              key: ValueKey(
                                                                  bookProvider
                                                                      .postDetailsScreenItemCount),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              // style:
                                                              //     getBoldStyle(
                                                              //   color:
                                                              //       ColorManager
                                                              //           .black,
                                                              //   fontSize:
                                                              //       FontSize
                                                              //           .s17,
                                                              // ),
                                                              style: _theme
                                                                  .textTheme
                                                                  .headlineMedium,
                                                            ),
                                                            transitionBuilder: (Widget
                                                                    child,
                                                                Animation<
                                                                        double>
                                                                    animation) {
                                                              return ScaleTransition(
                                                                  scale:
                                                                      animation,
                                                                  child: child);
                                                            }),
                                                  ),
                                                  Consumer<BookProvider>(
                                                    builder: (context,
                                                            bookProvider,
                                                            child) =>
                                                        IconButton(
                                                      // color: Colors.black,
                                                      padding: EdgeInsets.zero,
                                                      disabledColor:
                                                          Colors.grey,
                                                      splashRadius:
                                                          AppRadius.r12,
                                                      onPressed: bookProvider
                                                                  .postDetailsScreenSelectedBook
                                                                  .bookCount >
                                                              bookProvider
                                                                  .postDetailsScreenItemCount
                                                          ? () {
                                                              // setState(() {
                                                              bookProvider
                                                                  .postDetailsScreenSetItemCount(
                                                                      bookProvider
                                                                              .postDetailsScreenItemCount +
                                                                          1);
                                                              // });
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.add),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      spacing: AppHeight.h16,
                                      alignment: WrapAlignment.center,
                                      runSpacing: AppHeight.h4,
                                      children: [
                                        // Using consumer here because context.watch() only works for build and not for the callback functions, since i have used provider property value to enable or disable the callback, so i have wrpped the widget containing callback with consumer
                                        Consumer<BookProvider>(
                                          builder:
                                              (context, bookProvider, child) =>
                                                  ElevatedButton.icon(
                                            // icon: _bookProvider
                                            icon: bookProvider
                                                    .postDetailsScreenIsRequestOnProcess
                                                ? SizedBox(
                                                    height: AppHeight.h20,
                                                    width: AppHeight.h20,
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(
                                                      strokeWidth: 3,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                    ),
                                                  )
                                                : Container(),
                                            label: Text(
                                              'Request for this price',
                                              style: getBoldStyle(
                                                color: ColorManager.white,
                                                fontSize: FontSize.s14,
                                              ),
                                            ),
                                            // onPressed: !_bookProvider.enableRequestButton
                                            onPressed: !bookProvider
                                                    .postDetailsScreenEnableRequestButton
                                                ? null
                                                : () async {
                                                    // _bookProvider.setIsRequestOnProcess(true);

                                                    final isValid = _form
                                                        .currentState!
                                                        .validate();
                                                    if (!isValid) {
                                                      AlertHelper.showToastAlert(
                                                          'Something went wrong');
                                                    }
                                                    _form.currentState!.save();
                                                    Map<String, dynamic>
                                                        requestInfo = {
                                                      'product_id': _bookProvider
                                                          .postDetailsScreenSelectedBook
                                                          .id,
                                                      'quantity': _bookProvider
                                                          .postDetailsScreenItemCount,
                                                      'requested_price':
                                                          _bookProvider
                                                              .postDetailsScreenExpectedUnitPrice
                                                    };

                                                    _createOrderRequest(
                                                        _bookProvider,
                                                        requestInfo);
                                                    // if (await orderRequests
                                                    //     .createOrderRequest(
                                                    //         authenticatedSession,
                                                    //         requestInfo)) {
                                                    //   Navigator.pop(
                                                    //       context);
                                                    //   _showToastNotification(
                                                    //       'Request has been sent successfully');
                                                    // } else {
                                                    //   _showToastNotification(
                                                    //       'Something went wrong');
                                                    // }
                                                  },
                                          ),
                                        ),

                                        // Using consumer here because context.watch() only works for build and not for the callback functions, since i have used provider property value to enable or disable the callback, so i have wrpped the widget containing callback with consumer
                                        Consumer<BookProvider>(builder:
                                            (BuildContext context, bookProvider,
                                                Widget? child) {
                                          return ElevatedButton.icon(
                                            icon: bookProvider
                                                    .postDetailsScreenIsCartOnProcess
                                                ? SizedBox(
                                                    height: AppHeight.h20,
                                                    width: AppHeight.h20,
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(
                                                      strokeWidth: 3,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                    ),
                                                  )
                                                : Container(),
                                            label: bookProvider
                                                    .postDetailsScreenIsCartOnProcess
                                                ? LoadingHelper.showTextLoading(
                                                    'Adding')
                                                : Text(
                                                    'Add book to cart',
                                                    style: getBoldStyle(
                                                      color: ColorManager.white,
                                                      fontSize: FontSize.s14,
                                                    ),
                                                  ),
                                            // If request button is enabled, or if the add to cart process is loading then disable cart button other enable it
                                            onPressed: bookProvider
                                                        .postDetailsScreenEnableRequestButton ||
                                                    bookProvider
                                                        .postDetailsScreenIsCartOnProcess
                                                ? null
                                                : () async {
                                                    // ----------------------Order without cart starts here ----------------------
                                                    // if (await orders.getUserOrder(
                                                    //     loggedInUserSession,
                                                    //     users.user as User)) {
                                                    //   final isValid = _form
                                                    //       .currentState!
                                                    //       .validate();
                                                    //   if (!isValid) {
                                                    //     _showToastNotification(
                                                    //         'Something went wrong');
                                                    //   }
                                                    //   _form.currentState!.save();
                                                    //   OrderItem item =
                                                    //       new OrderItem(
                                                    //           id: 0,
                                                    //           productId: int.parse(
                                                    //               selectedPost.id),
                                                    //           quantity:
                                                    //               _buyerExpectedBook
                                                    //                   .bookCount);
                                                    //   if (await orders.addOrderItem(
                                                    //       item,
                                                    //       orders.order as Order)) {
                                                    //     Navigator.pop(context);
                                                    //     _showToastNotification(
                                                    //         'Book has been ordered successfully');
                                                    //   }
                                                    // } else {
                                                    //   _showToastNotification(
                                                    //       'Something went wrong');
                                                    // }
                                                    // ----------------------Order without cart ends here ----------------------

                                                    _bookProvider
                                                        .postDetailsScreenSetIsCartOnProcess(
                                                            true);

                                                    if (_bookProvider
                                                            .cartProvider
                                                            .cart ==
                                                        null) {
                                                      await _bookProvider
                                                          .cartProvider
                                                          .createCart(Provider
                                                                  .of<SessionProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .session as Session);
                                                    }
                                                    if (_bookProvider
                                                            .cartProvider
                                                            .cart !=
                                                        null) {
                                                      final isValid = _form
                                                          .currentState!
                                                          .validate();
                                                      if (!isValid) {
                                                        AlertHelper.showToastAlert(
                                                            'Something went wrong');
                                                      }
                                                      _form.currentState!
                                                          .save();

                                                      CartItem edittedItem =
                                                          new CartItem(
                                                        id: 0,
                                                        product: new Product(
                                                          id: int.parse(
                                                              _bookProvider
                                                                  .postDetailsScreenSelectedBook
                                                                  .id),
                                                          bookName: _bookProvider
                                                              .postDetailsScreenSelectedBook
                                                              .bookName,
                                                          unitPrice: _bookProvider
                                                              .postDetailsScreenSelectedBook
                                                              .price
                                                              .toString(),
                                                        ),
                                                        negotiatedPrice:
                                                            _bookProvider
                                                                .postDetailsScreenSelectedBook
                                                                .price,
                                                        quantity: _bookProvider
                                                            .postDetailsScreenItemCount,
                                                        totalPrice: 0,
                                                      );

                                                      if (await _bookProvider
                                                          .cartProvider
                                                          .addItemToCart(
                                                              _bookProvider
                                                                  .cartProvider
                                                                  .cart as Cart,
                                                              edittedItem)) {
                                                        _bookProvider
                                                            .postDetailsScreenSetIsCartOnProcess(
                                                                false);

                                                        Navigator.pop(context);
                                                        AlertHelper.showToastAlert(
                                                            'Book added to cart successfully');
                                                      }
                                                    } else {
                                                      AlertHelper.showToastAlert(
                                                          'Something went wrong');
                                                    }
                                                    // Hide order placement loading indicator
                                                    _bookProvider
                                                        .postDetailsScreenSetIsCartOnProcess(
                                                            false);
                                                  },
                                          );
                                        }),
                                        // Using consumer here because context.watch() only works for build and not for the callback functions, since i have used provider property value to enable or disable the callback, so i have wrpped the widget containing callback with consumer
                                        Consumer<BookProvider>(builder:
                                            (BuildContext context, bookProvider,
                                                Widget? child) {
                                          return ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(
                                                      AppHeight.h36),
                                            ),
                                            icon: bookProvider
                                                    .postDetailsScreenIsOrderPlacementOnProcess
                                                ? SizedBox(
                                                    height: AppHeight.h20,
                                                    width: AppHeight.h20,
                                                    child:
                                                        CircularProgressIndicator
                                                            .adaptive(
                                                      strokeWidth: 3,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                      backgroundColor:
                                                          ColorManager.primary,
                                                    ),
                                                  )
                                                : Container(),
                                            label: Text(
                                              'Place direct order',
                                              style: getBoldStyle(
                                                color: ColorManager.white,
                                                fontSize: FontSize.s14,
                                              ),
                                            ),
                                            // If request button is enabled, or if the add to direct order placement process is loading then disable place direct order button other enable it
                                            onPressed: bookProvider
                                                        .postDetailsScreenEnableRequestButton ||
                                                    bookProvider
                                                        .postDetailsScreenIsOrderPlacementOnProcess
                                                ? null
                                                : () async {
                                                    _bookProvider
                                                        .postDetailsScreenSetIsOrderPlacementOnProcess(
                                                            true);

                                                    var tempCart = await _bookProvider
                                                        .cartProvider
                                                        .createTemporaryCart(
                                                            Provider.of<SessionProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .session
                                                                as Session);
                                                    if (tempCart is CartError) {
                                                      AlertHelper.showToastAlert(
                                                          'Something went wrong');
                                                    }
                                                    if (tempCart is Cart) {
                                                      final isValid = _form
                                                          .currentState!
                                                          .validate();
                                                      if (!isValid) {
                                                        AlertHelper.showToastAlert(
                                                            'Something went wrong');
                                                      }
                                                      _form.currentState!
                                                          .save();

                                                      CartItem edittedItem =
                                                          new CartItem(
                                                        id: 0,
                                                        product: new Product(
                                                          id: int.parse(
                                                              _bookProvider
                                                                  .postDetailsScreenSelectedBook
                                                                  .id),
                                                          bookName: _bookProvider
                                                              .postDetailsScreenSelectedBook
                                                              .bookName,
                                                          unitPrice: _bookProvider
                                                              .postDetailsScreenSelectedBook
                                                              .price
                                                              .toString(),
                                                        ),
                                                        quantity: _bookProvider
                                                            .postDetailsScreenItemCount,
                                                        negotiatedPrice:
                                                            _bookProvider
                                                                .postDetailsScreenSelectedBook
                                                                .price,
                                                        totalPrice: 0,
                                                      );

                                                      if (await _bookProvider
                                                          .cartProvider
                                                          .addItemToTemporaryCart(
                                                              tempCart,
                                                              edittedItem)) {
                                                        _bookProvider
                                                            .postDetailsScreenSetIsOrderPlacementOnProcess(
                                                                false);
                                                        return showModalBottomSheet(
                                                          barrierColor: ColorManager
                                                              .blackWithLowOpacity,
                                                          isScrollControlled:
                                                              true,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      AppRadius
                                                                          .r20),
                                                              topRight: Radius
                                                                  .circular(
                                                                AppRadius.r20,
                                                              ),
                                                            ),
                                                          ),
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.9,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    AppPadding
                                                                        .p20,
                                                              ),
                                                              child: BillingInfo(
                                                                  cartId:
                                                                      tempCart
                                                                          .id),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      AlertHelper.showToastAlert(
                                                          'Something went wrong');
                                                    }
                                                    // Hide order placement loading indicator
                                                    _bookProvider
                                                        .postDetailsScreenSetIsOrderPlacementOnProcess(
                                                            false);
                                                  },
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text(
                        
                        'Get this book',
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  

  }

  _createOrderRequest(
      BookProvider _bookProvider, Map<String, dynamic> requestInfo) {
    final _form = GlobalKey<FormState>();
    ThemeData _theme = Theme.of(context);
    showModalBottomSheet(
      barrierColor: ColorManager.blackWithLowOpacity,
      isDismissible: _bookProvider.postDetailsScreenIsRequestOnProcess ||
              _bookProvider.postDetailsScreenIsCartOnProcess ||
              _bookProvider.postDetailsScreenIsOrderPlacementOnProcess
          ? false
          : true,
      // isScrollControlled: true,
      isScrollControlled: _bookProvider.postDetailsScreenIsRequestOnProcess ||
              _bookProvider.postDetailsScreenIsCartOnProcess ||
              _bookProvider.postDetailsScreenIsOrderPlacementOnProcess
          ? false
          : true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r20),
          topRight: Radius.circular(
            AppRadius.r20,
          ),
        ),
      ),
      context: context,
      builder: (context) {
        // double bottomPadding = ScreenUtil().bottomBarHeight;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            // padding: EdgeInsets.only(bottom: bottomPadding),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.9,
              // height: 60.h,
              padding: EdgeInsets.only(
                left: AppPadding.p20,
                right: AppPadding.p20,
                bottom: AppPadding.p12,
              ),
              child: Column(
                children: [
                  // ----------------------    Name section starts here -----------------------------------

                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billing Information',
                          // style: getBoldStyle(
                          //   color: ColorManager.black,
                          //   fontSize: FontSize.s18,
                          // ),
                          style: _theme.textTheme.headlineLarge,
                        ),
                        SizedBox(
                          height: AppHeight.h4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: Colors.grey,
                              //   width: 1.0,
                              //   style: BorderStyle.solid,
                              // ),
                              ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _form,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                                // initialValue: _edittedUser.firstName,
                                                initialValue: _bookProvider
                                                        .billingInfo
                                                        .containsKey(
                                                            'first_name')
                                                    ? _bookProvider.billingInfo[
                                                        'first_name']
                                                    : null,
                                                // cursorColor: Theme.of(context)
                                                //     .primaryColor,
                                                focusNode: _bookProvider
                                                    .postDetailsPageCartBottomSheetFirstNameFocusNode,
                                                decoration: InputDecoration(
                                                  labelText: 'First Name',
                                                  focusColor: Colors.redAccent,
                                                ),
                                                textInputAction:
                                                    TextInputAction.next,
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .requestFocus(_bookProvider
                                                          .postDetailsPageCartBottomSheetLastNameFocusNode);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please provide the first name';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _bookProvider.billingInfo[
                                                          'first_name'] =
                                                      value.toString();
                                                }),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              initialValue: _bookProvider
                                                      .billingInfo
                                                      .containsKey('last_name')
                                                  ? _bookProvider
                                                      .billingInfo['last_name']
                                                  : null,
                                              keyboardType: TextInputType.text,
                                              // cursorColor: Theme.of(context)
                                              //     .primaryColor,
                                              focusNode: _bookProvider
                                                  .postDetailsPageCartBottomSheetLastNameFocusNode,
                                              decoration: InputDecoration(
                                                labelText: 'Last Name',
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              onFieldSubmitted: (_) {
                                                FocusScope.of(context)
                                                    .requestFocus(_bookProvider
                                                        .postDetailsPageCartBottomSheetEmailFocusNode);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please provide the last name';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _bookProvider.billingInfo[
                                                        'last_name'] =
                                                    value.toString();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          initialValue: _bookProvider
                                                  .billingInfo
                                                  .containsKey('email')
                                              ? _bookProvider
                                                  .billingInfo['email']
                                              : null,
                                          focusNode: _bookProvider
                                              .postDetailsPageCartBottomSheetEmailFocusNode,
                                          keyboardType: TextInputType.text,
                                          // cursorColor:
                                          //     Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _bookProvider
                                                    .postDetailsPageCartBottomSheetPhoneNumberFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide email to receive notifications';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _bookProvider.billingInfo['email'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                          initialValue: _bookProvider
                                                  .billingInfo
                                                  .containsKey('phone')
                                              ? _bookProvider
                                                  .billingInfo['phone']
                                              : null,
                                          focusNode: _bookProvider
                                              .postDetailsPageCartBottomSheetPhoneNumberFocusNode,
                                          keyboardType: TextInputType.number,
                                          // cursorColor:
                                          //     Theme.of(context).primaryColor,
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          onFieldSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _bookProvider
                                                    .postDetailsPageCartBottomSheetSideNoteFocusNode);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please provide the phone number to be contacted';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _bookProvider.billingInfo['phone'] =
                                                value.toString();
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        // initialValue: _edittedUser.description,
                                        focusNode: _bookProvider
                                            .postDetailsPageCartBottomSheetSideNoteFocusNode,
                                        keyboardType: TextInputType.multiline,
                                        // cursorColor:
                                        //     Theme.of(context).primaryColor,
                                        decoration: InputDecoration(
                                          labelText: 'Side Note',
                                        ),
                                        textInputAction:
                                            TextInputAction.newline,
                                        autovalidateMode:
                                            AutovalidateMode.always,
                                        minLines: 3,
                                        maxLines: 7,
                                        // onFieldSubmitted: (_) {
                                        //   FocusScope.of(context)
                                        //       .requestFocus(_classFocusNode);
                                        // },
                                        // validator: (value) {
                                        //   if (value!.length < 15) {
                                        //     return 'Please provide a big description';
                                        //   }
                                        //   return null;
                                        // },
                                        onSaved: (value) {
                                          _bookProvider
                                                  .billingInfo['side_note'] =
                                              value.toString();
                                        },
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
                  // ----------------------    Name section ends here -----------------------------------
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
                          // style: getBoldStyle(
                          //   color: ColorManager.black,
                          //   fontSize: FontSize.s18,
                          // ),
                          style: _theme.textTheme.headlineLarge,
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
                                // style: getBoldStyle(color: ColorManager.black),
                                value: _bookProvider
                                    .billingInfo['convenient_location'],
                                // value: _locationOptions[0],
                                items: _bookProvider.locationOptions
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

                                  _bookProvider.setBillingInfoLocationData(
                                      value as String);
                                  // });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ----------------------    Sort by location section ends here -----------------------------------

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: Consumer<BookProvider>(
                            builder: (context, bookProvider, child) =>
                                ElevatedButton.icon(
                              icon: bookProvider
                                      .postDetailsScreenIsRequestOnProcess
                                  ? SizedBox(
                                      height: AppHeight.h20,
                                      width: AppHeight.h20,
                                      child: CircularProgressIndicator.adaptive(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        backgroundColor: ColorManager.primary,
                                      ),
                                    )
                                  : Container(),
                              onPressed: bookProvider
                                      .postDetailsScreenIsRequestOnProcess
                                  ? null
                                  : () async {
                                      bookProvider
                                          .postDetailsScreenSetIsRequestOnProcess(
                                              true);

                                      // I had to use the same code two times for direct order placement and indirect order placement so i just check the flag and show the notification of either success or failure
                                      // bool _orderPlacedSuccessfully = false;

                                      final _isValid =
                                          _form.currentState!.validate();
                                      if (!_isValid) {
                                        return;
                                      }
                                      _form.currentState!.save();

                                      requestInfo["billing_info"] = json.decode(
                                          json.encode(
                                              _bookProvider.billingInfo));

                                      if (await Provider.of<
                                                  OrderRequestProvider>(context,
                                              listen: false)
                                          .createOrderRequest(
                                              Provider.of<SessionProvider>(
                                                      context,
                                                      listen: false)
                                                  .session as Session,
                                              requestInfo)) {
                                        bookProvider
                                            .postDetailsScreenSetIsRequestOnProcess(
                                                false);
                                        AlertHelper.showToastAlert(
                                            'Request has been sent successfully');
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // Navigator.pop(context);
                                      } else {
                                        AlertHelper.showToastAlert(
                                            'Something went wrong');
                                      }
                                      bookProvider
                                          .postDetailsScreenSetEnableRequestButton(
                                              false);
                                      bookProvider
                                          .postDetailsScreenSetIsRequestOnProcess(
                                              false);
                                    },
                              label: bookProvider
                                      .postDetailsScreenIsRequestOnProcess
                                  ? LoadingHelper.showTextLoading('Requesting')
                                  : Text(
                                      'Request Now',
                                      // style: getBoldStyle(
                                      //   color: ColorManager.black,
                                      //   fontSize: FontSize.s18,
                                      // ),
                                      style: _theme.textTheme.headlineLarge,
                                    ),
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: ColorManager.primary,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppPadding.p12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailsPageImageGallery extends StatefulWidget {
  DetailsPageImageGallery({
    Key? key,
  }) : super(key: key);

  @override
  State<DetailsPageImageGallery> createState() =>
      _DetailsPageImageGalleryState();
}

class _DetailsPageImageGalleryState extends State<DetailsPageImageGallery> {
  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _bookProvider.postDetailsScreenSelectedBook.images!.isEmpty
                    ? Container()
                    : Image.network(
                        // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                        _bookProvider
                            .postDetailsScreenSelectedBook
                            .images![
                                _bookProvider.postDetailsScreenMainImageIndex]
                            .image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: AppPadding.p8,
                      bottom: AppPadding.p24,
                      left: AppPadding.p4,
                      right: AppPadding.p4,
                    ),
                    // padding: EdgeInsets.symmetric(
                    //   vertical: AppPadding.p8,
                    //   horizontal: AppPadding.p4,
                    // ),
                    color: ColorManager.blackWithLowOpacity,
                    child: SizedBox(
                      height: AppHeight.h60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _bookProvider
                            .postDetailsScreenSelectedBook.images!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (() {
                              // setState(() {
                              // _bookProvider.mainImageIndex = index;
                              _bookProvider
                                  .postDetailsScreenSetMainImageIndex(0);
                              // });
                            }),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2),
                              child: Container(
                                padding: EdgeInsets.all(0),
                                decoration: _bookProvider
                                            .postDetailsScreenMainImageIndex ==
                                        index
                                    ? BoxDecoration(
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.r12),
                                      )
                                    : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    // 'https://images.unsplash.com/photo-1679499067430-106da3ba663a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                    _bookProvider.postDetailsScreenSelectedBook
                                        .images![index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ItemCounter extends StatefulWidget {
//   ItemCounter({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ItemCounter> createState() => _ItemCounterState();
// }

// class _ItemCounterState extends State<ItemCounter> {
//   @override
//   Widget build(BuildContext context) {
//     BookProvider _bookProvider = context.watch<BookProvider>();
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ButtonBar(
//         buttonPadding: EdgeInsets.zero,
//         children: [
//           SizedBox(
//             width: 40,
//             child: IconButton(
//               color: Colors.black,
//               padding: EdgeInsets.zero,
//               disabledColor: Colors.grey,
//               onPressed: _bookProvider.itemCount > 1
//                   ? () {
//                       // setState(() {

//                       _bookProvider.setItemCount(_bookProvider.itemCount--);
//                       // });
//                     }
//                   : null,
//               icon: Icon(Icons.remove),
//             ),
//           ),
//           Text(
//             // '1',
//             _bookProvider.itemCount.toString(),
//             textAlign: TextAlign.center,
//             style: getBoldStyle(
//               color: ColorManager.black,
//               fontSize: FontSize.s17,
//             ),
//           ),
//           SizedBox(
//             width: AppSize.s40,
//             // height: AppSize.s20,
//             child: IconButton(
//               color: Colors.black,
//               // padding: EdgeInsets.all(2.0),
//               padding: EdgeInsets.zero,
//               onPressed: () {
//                 // setState(() {

//                 _bookProvider.setItemCount(_bookProvider.itemCount++);
//                 // });
//               },
//               icon: Icon(Icons.add),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
