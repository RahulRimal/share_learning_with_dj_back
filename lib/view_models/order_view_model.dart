import 'package:flutter/cupertino.dart';

import '../models/book.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/session.dart';
import 'base_view_model.dart';

// Old Widget
mixin OrdersScreenViewModel on BaseViewModel {
  final ordersScreenSearchController = TextEditingController();

  bindOrdersScreenViewModel(BuildContext context) {}

  unbindOrdersScreenViewModel() {}
}
mixin OrdersScreenNewViewModel on BaseViewModel {
  final ordersScreenSearchController = TextEditingController();

  bindOrdersScreenNewViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unBindOrdersScreenNewViewModel() {}
}

mixin OrdersItemWidgetViewModel on BaseViewModel {
  // late Book ordersItemWidgetOrderItemBook;
  // Book? ordersItemWidgetOrderItemBook;
  // late OrderItem ordersItemWidgetEdittedItem;

  bindOrdersItemWidgetViewModel(BuildContext context, OrderItem item) {
    bindBaseViewModal(context);
    // ordersItemWidgetEdittedItem = item;
  }

  orderItemWidgetGetOrdersItemBook(String bookId) async {
    // Book? product = bookProvider.books.firstWhereOrNull(
    //   (book) => book.id == ordersItemWidgetEdittedItem.productId.toString(),
    // );
    // if (product != null) {
    //   return product;
    // }
    return await orderProvider.getOrderItemBookByIdFromServer(
        sessionProvider.session as Session, bookId) as Book;

    // return product;
  }

  unbindOrdersItemWidgetViewModel() {}
}

mixin OrderDetailsScreenViewModel on BaseViewModel {
  late Order _order;

  Order get orderDetailsScreenOrder => _order;

  set orderDetailsScreenOrder(Order value) {
    _order = value;
    notifyListeners();
  }

  bindOrderDetailsScreenViewModel(BuildContext context) {}

  unbindOrderDetailsScreenViewModel() {}
}
