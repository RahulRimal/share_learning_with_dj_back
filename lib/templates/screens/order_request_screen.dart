import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_learning/models/order_request.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/cart_provider.dart';
import 'package:share_learning/view_models/providers/order_request_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';

import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';

import 'package:share_learning/templates/utils/alert_helper.dart';

import '../../models/book.dart';
import '../../models/cart.dart';

import '../managers/routes_manager.dart';
import '../utils/loading_helper.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'order_request_details_screen.dart';

class OrderRequestScreen extends StatefulWidget {
  const OrderRequestScreen({Key? key}) : super(key: key);
  // static final routeName = '/order-request-list';

  @override
  State<OrderRequestScreen> createState() => _OrderRequestScreenState();
}

class _OrderRequestScreenState extends State<OrderRequestScreen> {
  OrderRequestProvider? orderRequestProvider;
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    orderRequestProvider =
        Provider.of<OrderRequestProvider>(context, listen: false);

    orderRequestProvider!.bindOrderRequestViewModel(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Added this line to save the reference of provider so it doesn't throw an exception on dispose
    orderRequestProvider =
        Provider.of<OrderRequestProvider>(context, listen: false);
  }

  @override
  void dispose() {
    orderRequestProvider!.unBindOrderRequestViewModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: AppHeight.h20,
              ),
              Form(
                key: form,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                  child: TextFormField(
                    controller: _orderRequestProvider
                        .orderRequestScreenSearchController,
                    // focusNode: _searchFocusNode,
                    keyboardType: TextInputType.text,
                    cursorColor: Theme.of(context).primaryColor,
                    style: getBoldStyle(
                        fontSize: FontSize.s14, color: ColorManager.black),
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      hintText: 'Find your order request',
                      hintStyle: getBoldStyle(
                          fontSize: FontSize.s17,
                          color: ColorManager.primaryOpacity70),
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorManager.primaryOpacity70,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: ColorManager.primaryOpacity70,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    onFieldSubmitted: (_) {
                      // FocusScope.of(context)
                      //     .requestFocus(_priceFocusNode);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: AppHeight.h20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
                height: AppHeight.h150,
                decoration: BoxDecoration(
                  color: ColorManager.lightPrimary,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "$IMAGE_PATH/education.svg",
                      // width: AppSize.s100,
                      height: AppHeight.h140,
                    ),
                    Flexible(
                      child: Text(
                        'Free Shipping inside the Valley',
                        style: getBoldStyle(
                            fontSize: FontSize.s20, color: ColorManager.white),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder(
                future: _orderRequestProvider.getOrderRequestsByUser(
                    _orderRequestProvider.sessionProvider.session as Session),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: ColorManager.secondary,
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      if (snapshot.data is OrderRequestError) {
                        OrderRequestError error =
                            snapshot.data as OrderRequestError;
                        return Text(error.message as String);
                      } else {
                        List<OrderRequest> data =
                            snapshot.data as List<OrderRequest>;
                        return data.length <= 0
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: AppPadding.p45),
                                  child: Text(
                                    'No request for the order found',
                                    style: getBoldStyle(
                                      fontSize: FontSize.s20,
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: OrderRequestList(),
                              );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 3,
      ),
    );
  }
}

class OrderRequestList extends StatelessWidget {
  const OrderRequestList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();
    return ListView.builder(
      itemCount: _orderRequestProvider.orderRequestsByUser.length,
      itemBuilder: (context, index) {
        return OrderRequestItemWidget(
          requestedItem: _orderRequestProvider.orderRequestsByUser[index],
        );
      },
    );
  }
}

class OrderRequestItemWidget extends StatefulWidget {
  const OrderRequestItemWidget({Key? key, required this.requestedItem})
      : super(key: key);

  final OrderRequest requestedItem;

  @override
  State<OrderRequestItemWidget> createState() => _OrderRequestItemWidgetState();
}

class _OrderRequestItemWidgetState extends State<OrderRequestItemWidget> {
  @override
  Widget build(BuildContext context) {
    OrderRequest requestedItem = widget.requestedItem;
    Session authendicatedSession =
        Provider.of<SessionProvider>(context).session as Session;

    OrderRequestProvider _orderRequestProvider =
        context.watch<OrderRequestProvider>();

    ThemeData _theme = Theme.of(context);

    return FutureBuilder(
        future: _orderRequestProvider.getRequestedItemBook(
            authendicatedSession, widget.requestedItem.product.id.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else {
              if (snapshot.data is Book) {
                final Book requestedBook = snapshot.data as Book;
                return Container(
                  margin: EdgeInsets.all(AppMargin.m8),
                  padding: EdgeInsets.all(AppPadding.p8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(
                      5.00,
                    ),
                    border: Border.all(
                      color: ColorManager.primary,
                      width: 1.00,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: AppPadding.p14),
                            child: Image.network(
                              requestedBook.images![0].image,
                              width: 25.w,
                              // height: 100.0,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          requestedBook.bookName,
                                          maxLines: null,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: Colors.indigo,
                                          //   fontSize: 12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style:
                                              _theme.textTheme.headlineMedium,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        bool userConfirmed = false;
                                        showGeneralDialog(
                                          barrierDismissible: true,
                                          barrierLabel:
                                              'Delete order request dilaog dismissed',
                                          context: context,
                                          pageBuilder: (ctx, a1, a2) {
                                            return Container();
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                          transitionBuilder:
                                              (ctx, a1, a2, child) {
                                            var curve = Curves.easeInOut
                                                .transform(a1.value);
                                            return Transform.scale(
                                              scale: curve,
                                              child: AlertDialog(
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                  'The request will be deleted forever',
                                                  // style: getRegularStyle(
                                                  //   fontSize: FontSize.s16,
                                                  //   color: ColorManager.black,
                                                  // ),
                                                  style: _theme
                                                      .textTheme.bodyLarge,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      'Yes',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s16,
                                                        color: ColorManager
                                                            .primary,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      userConfirmed = true;
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      'No',
                                                      style: getBoldStyle(
                                                        fontSize: FontSize.s16,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).then((_) {
                                          if (userConfirmed) {
                                            _orderRequestProvider
                                                .orderRequestScreenRemoveOrderRequest(
                                              widget.requestedItem.id
                                                  .toString(),
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // --------------------------Original Unit Price starts here-----------------------
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Unit Price",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: ColorManager.black,
                                          //   fontSize: FontSize.s12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          "Rs. ${widget.requestedItem.product.unitPrice}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: Colors.lightBlue,
                                          //   fontSize: FontSize.s14,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                    // --------------------------Original Unit Price ends here-----------------------

                                    SizedBox(
                                      height: AppHeight.h8,
                                    ),

                                    // --------------------------Expected Unit Price starts here-----------------------
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Requested unit price",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: ColorManager.black,
                                          //   fontSize: FontSize.s12,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.bodyMedium,
                                        ),
                                        Text(
                                          "Rs. ${widget.requestedItem.requestedPrice}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          // style: TextStyle(
                                          //   color: Colors.lightBlue,
                                          //   fontSize: FontSize.s14,
                                          //   fontFamily: 'Poppins',
                                          //   fontWeight: FontWeight.w700,
                                          //   letterSpacing: 0.50,
                                          // ),
                                          style: _theme.textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                    // --------------------------Expected Unit Price ends here-----------------------

                                    // --------------------------Change Request Price starts here-----------------------

                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //     top: AppPadding.p8,
                                    //   ),
                                    //   child: TextFormField(
                                    //     keyboardType: TextInputType.number,
                                    //     cursorColor:
                                    //         Theme.of(context).primaryColor,
                                    //     decoration: InputDecoration(
                                    //       labelText: 'Change requst price',
                                    //       focusedBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //           color: Colors.redAccent,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     textInputAction: TextInputAction.done,
                                    //     onChanged: (value) {
                                    //       _newRequestPrice =
                                    //           double.parse(value);
                                    //       _shouldShowRequestButton();
                                    //       _shouldShowOrderButton();
                                    //     },
                                    //     // onFieldSubmitted: (_) {
                                    //     //   FocusScope.of(context).requestFocus(_authorFocusNode);
                                    //     // },
                                    //     validator: (value) {
                                    //       if (value!.isEmpty) {
                                    //         return 'Please provide the bookName';
                                    //       }
                                    //       return null;
                                    //     },
                                    //     onSaved: (value) {},
                                    //   ),
                                    // ),
                                    // ValueListenableBuilder(
                                    //   valueListenable: _showRequestButton,
                                    //   builder: (BuildContext context,
                                    //       bool showRequestButton,
                                    //       Widget? child) {
                                    //     return showRequestButton
                                    //         ? ElevatedButton(
                                    //             onPressed: () =>
                                    //                 _updateRequestPrice(
                                    //                     requestedItem.id,
                                    //                     _newRequestPrice),
                                    //             // child: Text('Update Request Price'),
                                    //             child: Text(
                                    //                 'Request for this price'),
                                    //           )
                                    //         : Container();
                                    //   },
                                    // ),
                                    // ValueListenableBuilder(
                                    //   valueListenable: _showOrderButton,
                                    //   builder: (BuildContext context,
                                    //       bool showOrderButton,
                                    //       Widget? child) {
                                    //     return showOrderButton
                                    //         ? ElevatedButton(
                                    //             onPressed: () async {
                                    //               Carts carts = Provider.of(
                                    //                   context,
                                    //                   listen: false);
                                    //               setState(() {
                                    //                 _isLoading = true;
                                    //               });
                                    //               var tempCart = await carts
                                    //                   .createTemporaryCart(
                                    //                       Provider.of<SessionProvider>(
                                    //                                   context,
                                    //                                   listen:
                                    //                                       false)
                                    //                               .session
                                    //                           as Session);
                                    //               if (tempCart is CartError) {
                                    //                 _showToastNotification(
                                    //                     'Something went wrong');
                                    //               }
                                    //               if (tempCart is Cart) {
                                    //                 CartItem edittedItem =
                                    //                     new CartItem(
                                    //                   id: 0,
                                    //                   product: new Product(
                                    //                     id: int.parse(
                                    //                         requestedBook.id),
                                    //                     bookName:
                                    //                         requestedBook
                                    //                             .bookName,
                                    //                     unitPrice:
                                    //                         requestedBook
                                    //                             .price
                                    //                             .toString(),
                                    //                   ),
                                    //                   negotiatedPrice:
                                    //                       _newRequestPrice,
                                    //                   quantity: requestedItem
                                    //                       .quantity,
                                    //                   totalPrice: 0,
                                    //                 );
                                    //                 if (await carts
                                    //                     .addItemToTemporaryCart(
                                    //                         tempCart,
                                    //                         edittedItem)) {
                                    //                   return showModalBottomSheet(
                                    //                     barrierColor: ColorManager
                                    //                         .blackWithLowOpacity,
                                    //                     isScrollControlled:
                                    //                         true,
                                    //                     shape:
                                    //                         RoundedRectangleBorder(
                                    //                       borderRadius:
                                    //                           BorderRadius
                                    //                               .only(
                                    //                         topLeft: Radius
                                    //                             .circular(
                                    //                                 AppRadius
                                    //                                     .r20),
                                    //                         topRight: Radius
                                    //                             .circular(
                                    //                           AppRadius.r20,
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                     context: context,
                                    //                     builder: (context) {
                                    //                       return Container(
                                    //                         height: MediaQuery.of(
                                    //                                     context)
                                    //                                 .size
                                    //                                 .height *
                                    //                             0.9,
                                    //                         padding: EdgeInsets
                                    //                             .symmetric(
                                    //                           horizontal:
                                    //                               AppPadding
                                    //                                   .p20,
                                    //                         ),
                                    //                         child: BillingInfo(
                                    //                             cartId:
                                    //                                 tempCart
                                    //                                     .id),
                                    //                       );
                                    //                     },
                                    //                   );
                                    //                 }
                                    //               } else {
                                    //                 // print('here');
                                    //                 _showToastNotification(
                                    //                     'Something went wrong');
                                    //               }
                                    //             },
                                    //             child: Text(
                                    //                 'Order this book now'),
                                    //           )
                                    //         : Container();
                                    //   },
                                    // ),

                                    // --------------------------Change Request Price ends here-----------------------
                                    SizedBox(
                                      height: AppHeight.h4,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          _orderRequestProvider
                                                  .orderRequestDetailsScreenViewModelRequestItem =
                                              requestedItem;
                                          _orderRequestProvider
                                                  .orderRequestDetailsScreenViewModelRequestedProduct =
                                              requestedBook;

                                          Navigator.of(context).pushNamed(
                                              RoutesManager
                                                  .orderRequestDetailsScreenRoute,
                                              arguments: {
                                                'requestItem': requestedItem,
                                                'requestedProduct':
                                                    requestedBook
                                              });
                                        },
                                        child: Text('Show request details'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else if (snapshot.data is CartError) {
                Center(
                    child: Container(
                  child: Text((snapshot.data as CartError).message.toString()),
                ));
              }
              return Container();
            }
          }
        });
  }
}
