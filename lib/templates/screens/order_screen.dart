// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:share_learning/models/order_item.dart';

// import '../../models/session.dart';
// import '../../providers/carts.dart';
// import '../../providers/orders.dart';
// import '../managers/assets_manager.dart';
// import '../managers/color_manager.dart';
// import '../managers/font_manager.dart';
// import '../managers/style_manager.dart';
// import '../managers/values_manager.dart';
// import '../widgets/cart_item.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({Key? key}) : super(key: key);
//   static final routeName = '/order-list';

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   final _form = GlobalKey<FormState>();
//   final _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)!.settings.arguments as Map;

//     final Session authendicatedSession = args['loggedInUserSession'] as Session;

//     // Carts carts = context.watch<Carts>();
//     // Carts carts = Provider.of<Carts>(context, listen: false);
//     Orders orders = Provider.of<Orders>(context, listen: false);

//     return Scaffold(
//       // appBar: AppBar(),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: AppHeight.h20,
//               ),
//               Form(
//                 key: _form,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: AppPadding.p20),
//                   child: TextFormField(
//                     controller: _searchController,
//                     // focusNode: _searchFocusNode,
//                     keyboardType: TextInputType.text,
//                     cursorColor: Theme.of(context).primaryColor,
//                     style: getBoldStyle(
//                         fontSize: FontSize.s14, color: ColorManager.black),
//                     textInputAction: TextInputAction.next,
//                     autovalidateMode: AutovalidateMode.always,
//                     decoration: InputDecoration(
//                       hintText: 'Find your order',
//                       hintStyle: getBoldStyle(
//                           fontSize: FontSize.s17,
//                           color: ColorManager.primaryOpacity70),
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: ColorManager.primaryOpacity70,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           Icons.send,
//                           color: ColorManager.primaryOpacity70,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                     onFieldSubmitted: (_) {
//                       // FocusScope.of(context)
//                       //     .requestFocus(_priceFocusNode);
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: AppHeight.h20,
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
//                 height: AppHeight.h150,
//                 decoration: BoxDecoration(
//                   color: ColorManager.lightPrimary,
//                   borderRadius: BorderRadius.circular(AppRadius.r20),
//                 ),
//                 child: Row(
//                   children: [
//                     SvgPicture.asset(
//                       "$IMAGE_PATH/education.svg",
//                       // width: AppSize.s100,
//                       height: AppHeight.h140,
//                     ),
//                     Flexible(
//                       child: Text(
//                         'Free Shipping inside the Valley',
//                         style: getBoldStyle(
//                             fontSize: FontSize.s20, color: ColorManager.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: OrderList(
//                     carts: orders, authendicatedSession: authendicatedSession),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OrderList extends StatelessWidget {
//   const OrderList({
//     Key? key,
//     required this.orders,
//     required this.authendicatedSession,
//   }) : super(key: key);

//   final Orders orders;
//   final Session authendicatedSession;

//   @override
//   Widget build(BuildContext context) {
//     return orders.orderItems.length > 0
//         ? ListView.builder(
//             itemCount: orders.orderItems.length,
//             itemBuilder: (context, index) {
//               return CartItem(
//                 cartItem: orders.orderItems[index],
//               );
//             },
//           )
//         : FutureBuilder(
//             future: carts.getUserCart(authendicatedSession),
//             // builder: carts.getUserCart(authendicatedSession),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Error',
//                     ),
//                   );
//                 } else {
//                   return Consumer<Carts>(
//                     builder: (ctx, cartItems, child) {
//                       return carts.cartItems.length <= 0
//                           ? Center(
//                               child: Text(
//                                 'No Item in the cart',
//                                 style: getBoldStyle(
//                                     fontSize: FontSize.s20,
//                                     color: ColorManager.primary),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemCount: carts.cartItems.length,
//                               itemBuilder: (ctx, index) {
//                                 return CartItem(
//                                   cartItem: carts.cartItems[index],
//                                 );
//                               },
//                             );
//                     },
//                   );
//                 }
//               }
//             },
//           );
//   }
// }
