import 'package:flutter/cupertino.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/base_view_model.dart';

import '../models/cart_item.dart';
import '../templates/utils/alert_helper.dart';

mixin CartScreenViewModel on BaseViewModel{

late TextEditingController searchController;

bindCartScreenViewModel(BuildContext context){
  bindBaseViewModal(context);

  searchController = TextEditingController();
  

}

unBindCartScreenViewModel(){
  searchController.dispose();
}


}


// mixin CartItemWidgetViewModel on BaseViewModel {

//   late CartItem cartItem;
//   late ValueNotifier<bool> cartItemChanged;
//   late ValueNotifier<int> quantity;
//   late CartItem edittedItem;

//   bindCartItemWidgetViewModel(BuildContext context, CartItem cartItem)
//   {
//     bindBaseViewModal(context);
//     this.cartItem = cartItem;
//     edittedItem = cartItem;
//     cartItemChanged = ValueNotifier<bool>(false);
//     quantity = ValueNotifier<int>(cartItem.quantity);
//   }

//   unbindCartItemWidgetViewModel(){
//   }
  

//   // ifCartItemChanged(CartItem cartItem) {
//   //   if (quantity.value != cartItem.quantity) {
//   //     cartItemChanged.value = true;
//   //     return;
//   //   }

//   //   cartItemChanged.value = false;
//   // }
//   ifCartItemChanged() {
//     if (quantity.value != cartItem.quantity) {
//       cartItemChanged.value = true;
//       return;
//     }

//     cartItemChanged.value = false;
//   }


//   Future<bool> updateItemOnTheCart() async {
//     edittedItem.quantity = quantity.value;

//     await cartProvider
//         .updateCartItem(cartProvider.cart!.id, edittedItem)
//         .then(
//       (value) {
//         if (value) {
//           AlertHelper.showToastAlert('Cart Item updated');

//           cartItemChanged.value = false;
//         } else
//           AlertHelper.showToastAlert("Something went wrong, Please try again!");
//       },
//     );

//     return true;
//   }

//   // removeItemFromCart(CartItem cartItem) async {
//   //   bool value = await cartProvider
//   //       .deleteCartItem(sessionProvider.session as Session, cartProvider.cart!.id, cartItem.id.toString());
//   //   if (value) {
//   //     AlertHelper.showToastAlert('Book deleted from the cart');
//   //   } else
//   //     AlertHelper.showToastAlert('Something went wrong, Please try again!');
//   // }
//   removeItemFromCart() async {
//     bool value = await cartProvider
//         .deleteCartItem(sessionProvider.session as Session, cartProvider.cart!.id, cartItem.id.toString());
//     if (value) {
//       AlertHelper.showToastAlert('Book deleted from the cart');
//     } else
//       AlertHelper.showToastAlert('Something went wrong, Please try again!');
//   }


// }