import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/order_request.dart';
import '../models/session.dart';
import '../templates/utils/alert_helper.dart';
import 'base_view_model.dart';

mixin OrderRequestScreenViewModel on BaseViewModel {
  final orderRequestScreenSearchController = TextEditingController();

  bindOrderRequestViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  unBindOrderRequestViewModel() {
    orderRequestScreenSearchController.dispose();
  }

  Future<bool> orderRequestScreenRemoveOrderRequest(
      String orderRequestId) async {
    if (await orderRequestProvider.deleteOrderRequest(
      orderRequestProvider.sessionProvider.session as Session,
      orderRequestId,
    )) {
      AlertHelper.showToastAlert('Request for the book has been deleted');
      return true;
    }
    AlertHelper.showToastAlert('Something went wrong, Please try again!');
    return false;
  }
}

mixin OrderRequestDetailsScreenViewModel on BaseViewModel {
  late OrderRequest _requestItem;
  late Book _requestedProduct;

  bool _showRequestButton = false;
  bool _showOrderButton = false;
  double _newRequestPrice = 0;

  OrderRequest get orderRequestDetailsScreenViewModelRequestItem =>
      _requestItem;
  Book get orderRequestDetailsScreenViewModelRequestedProduct =>
      _requestedProduct;

  set orderRequestDetailsScreenViewModelRequestItem(OrderRequest request) =>
      _requestItem = request;
  set orderRequestDetailsScreenViewModelRequestedProduct(Book product) =>
      _requestedProduct = product;

  bool get orderRequestDetailsScreenViewModelShowRequestButton =>
      _showRequestButton;
  bool get orderRequestDetailsScreenViewModelShowOrderButton =>
      _showOrderButton;
  double get orderRequestDetailsScreenViewModelNewRequestPrice =>
      _newRequestPrice;

  set orderRequestDetailsScreenViewModelShowOrderButton(bool value) {
    _showOrderButton = value;
  }

  set orderRequestDetailsScreenViewModelShowRequestButton(bool value) {
    _showRequestButton = value;
  }

  set orderRequestDetailsScreenViewModelNewRequestPrice(double value) {
    _newRequestPrice = value;
  }

  void bindOrderRequestDetailsScreenViewModel(BuildContext context) {
    bindBaseViewModal(context);
  }

  void unBindOrderRequestDetailsScreenViewModel() {}

  orderRequestDetailsScreenViewModelShouldShowRequestButton(
      double requestPrice) {
    if (_newRequestPrice == 0) {
      _showRequestButton = false;
      _showOrderButton = false;
      notifyListeners();
      return;
    }
    if (_newRequestPrice != requestPrice) {
      _showOrderButton = false;
      _showRequestButton = true;
      notifyListeners();
      return;
    }
    _showRequestButton = false;
    _showOrderButton = false;
    notifyListeners();
  }

  orderRequestDetailsScreenViewModelShouldShowOrderButton(
      OrderRequest requestItem) {
    if (_newRequestPrice == double.parse(requestItem.product.unitPrice)) {
      _showRequestButton = false;
      _showOrderButton = true;
      return;
    }
    _showOrderButton = false;
  }

  Future<bool> orderRequestDetailsScreenViewModelUpdateRequestPrice(
      BuildContext context,
      {required bool changedBySeller}) async {
    await orderRequestProvider
        .updateRequestPrice(_requestItem.id, _newRequestPrice, changedBySeller)
        .then(
      (value) {
        if (value) {
          AlertHelper.showToastAlert('Request price changed');

          _showRequestButton = false;
          Navigator.of(context).pop();
        } else
          AlertHelper.showToastAlert("Something went wrong, Please try again!");
      },
    );

    return true;
  }
}

mixin OrderRequestsScreenForSellerViewModle on BaseViewModel {
  late TextEditingController _searchController;
  late FocusNode _firstNameFocusNode;
  late FocusNode _lastNameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _phoneNumberFocusNode;
  late FocusNode _sideNoteFocusNode;
  bool _isRequestOnProcess = false;

  TextEditingController
      get orderRequestsScreenForSellerViewModleSearchController =>
          _searchController;
  set orderRequestsScreenForSellerViewModleSearchController(
          TextEditingController controller) =>
      _searchController = controller;

  FocusNode get orderRequestsScreenForSellerViewModleFirstNameFocusNode =>
      _firstNameFocusNode;

  set orderRequestsScreenForSellerViewModleFirstNameFocusNode(
          FocusNode focusNode) =>
      _firstNameFocusNode = focusNode;

  FocusNode get orderRequestsScreenForSellerViewModleLastNameFocusNode =>
      _lastNameFocusNode;
  set orderRequestsScreenForSellerViewModleLastNameFocusNode(
          FocusNode focusNode) =>
      _lastNameFocusNode = focusNode;

  FocusNode get orderRequestsScreenForSellerViewModleEmailFocusNode =>
      _emailFocusNode;
  set orderRequestsScreenForSellerViewModleEmailFocusNode(
          FocusNode orderRequest) =>
      _emailFocusNode = orderRequest;

  FocusNode get orderRequestsScreenForSellerViewModlePhoneNumberFocusNode =>
      _phoneNumberFocusNode;

  set orderRequestsScreenForSellerViewModlePhoneNumberFocusNode(
          FocusNode focusNode) =>
      _phoneNumberFocusNode = focusNode;

  FocusNode get orderRequestsScreenForSellerViewModleSideNoteFocusNode =>
      _sideNoteFocusNode;

  set orderRequestsScreenForSellerViewModleSideNoteFocusNode(
          FocusNode focusNode) =>
      _sideNoteFocusNode = focusNode;

  bool get orderRequestsScreenForSellerViewModleIsRequestOnProcess =>
      _isRequestOnProcess;

  set orderRequestsScreenForSellerViewModleIsRequestOnProcess(bool value) {
    _isRequestOnProcess = value;
    notifyListeners();
  }

  bindOrderRequestsScreenForSellerViewModle(BuildContext context) {
    bindBaseViewModal(context);
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _sideNoteFocusNode = FocusNode();
    _searchController = TextEditingController();
  }

  unBindOrderRequestsScreenForSellerViewModle() {
    unBindBaseViewModal();
  }
}

mixin OrderRequestForSellerDetailsScreenViewModel on BaseViewModel {
  // ValueNotifier<bool> _showRequestButton = ValueNotifier(false);

  late OrderRequest _item;
  late Book _requestProduct;

  bool _showRequestBtn = false;
  double _newSellerOfferPrice = 0;

  OrderRequest get orderRequestForSellerDetailsScreenViewModelRequestItem =>
      _item;
  Book get orderRequestForSellerDetailsScreenViewModelRequestedProduct =>
      _requestProduct;

  bool get orderRequestForSellerDetailsScreenViewModelShowRequestButton =>
      _showRequestBtn;

  double get orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice =>
      _newSellerOfferPrice;

  set orderRequestForSellerDetailsScreenViewModelNewSellerRequestPrice(
      double value) {
    _newSellerOfferPrice = value;
  }

  set orderRequestForSellerDetailsScreenViewModelRequestItem(
          OrderRequest request) =>
      _item = request;
  set orderRequestForSellerDetailsScreenViewModelRequestedProduct(
          Book product) =>
      _requestProduct = product;

  set orderRequestForSellerDetailsScreenViewModelShowRequestButton(
          bool value) =>
      this._showRequestBtn = value;

  bindOrderRequestForSellerDetailsScreenViewModel(BuildContext context) {}
  unbindOrderRequestForSellerDetailsScreenViewModel() {}

  orderRequestForSellerDetailsScreenViewModelShouldShowRequestButton(
      double requestPrice) {
    if (_newSellerOfferPrice == 0) {
      _showRequestBtn = false;
      notifyListeners();
      return;
    }
    if (_item.sellerOfferPrice != null) {
      if (_newSellerOfferPrice ==
          double.parse(_item.sellerOfferPrice.toString())) {
        _showRequestBtn = false;
        notifyListeners();
        return;
      }
    }

    if (_newSellerOfferPrice != requestPrice) {
      _showRequestBtn = true;
      notifyListeners();
      return;
    }
    _showRequestBtn = false;
    notifyListeners();
  }

  Future<bool>
      orderRequestForSellerDetailsScreenViewModelUpdateSellerOfferPrice(
          BuildContext context, String requestId) async {
    await orderRequestProvider
        .updateSellerOfferPrice(requestId, _newSellerOfferPrice)
        .then(
      (value) {
        if (value) {
          AlertHelper.showToastAlert('Request price changed');

          _showRequestBtn = false;
          Navigator.of(context).pop();
        } else
          AlertHelper.showToastAlert("Something went wrong, Please try again!");
      },
    );

    return true;
  }

  Future<bool>
      orderRequestForSellerDetailsScreenViewModelUpdateBuyerRequestPrice(
          BuildContext context,
          {required bool changedBySeller}) async {
    await orderRequestProvider
        .updateRequestPrice(_item.id, _newSellerOfferPrice, changedBySeller)
        .then(
      (value) {
        if (value) {
          AlertHelper.showToastAlert('Request price changed');

          _showRequestBtn = false;
          Navigator.of(context).pop();
          notifyListeners();
        } else
          AlertHelper.showToastAlert("Something went wrong, Please try again!");
      },
    );

    return true;
  }
}
