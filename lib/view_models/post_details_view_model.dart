import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/view_models/base_view_model.dart';

import '../models/book.dart';

mixin PostDetailsViewModel on BaseViewModel {
  // int itemCount = 1;
  late int itemCount;
  double expectedUnitPrice = 0;
  int mainImageIndex = 0;

  bool isRequestOnProcess = false;
  bool isCartOnProcess = false;
  bool isOrderPlacementOnProcess = false;
  bool enableRequestButton = false;

  late GlobalKey<FormState> postDetailsPageCreateOrderRequestBototmSheetForm;
  late GlobalKey<FormState> postDetailsPageBototmSheetForm;
  late Book selectedBook;
  late NepaliDateTime initDate;
  late NepaliDateTime? buyerExpectedDeadline;
  late TextEditingController datePickercontroller;

  late FocusNode postDetailsPageCartBottomSheetBuyerDateFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerPriceFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerBooksCountFocusNode;

  // These focus nodes are for order request billing info fields
  late FocusNode postDetailsPageCartBottomSheetFirstNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetLastNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetEmailFocusNode;
  late FocusNode postDetailsPageCartBottomSheetPhoneNumberFocusNode;
  late FocusNode postDetailsPageCartBottomSheetSideNoteFocusNode;

  setSelectedBook(Book book) {
    selectedBook = book;
  }

  setMainImageIndex(int value) {
    mainImageIndex = value;
    // notifyListeners();
  }

  setEnableRequestButton(bool value) {
    enableRequestButton = value;
    // notifyListeners();
  }

  setExpectedUnitPrice(double value) {
    expectedUnitPrice = value;
    // notifyListeners();
  }

  setIsRequestOnProcess(bool value) {
    isRequestOnProcess = value;
    // notifyListeners();
  }

  setIsCartOnProcess(bool value) {
    isCartOnProcess = value;
    // notifyListeners();
  }

  setIsOrderPlacementOnProcess(bool value) {
    isOrderPlacementOnProcess = value;
    // notifyListeners();
  }

  setItemCount(int value) {
    itemCount = value;
  }

  getTomorrowDate() {
    NepaliDateTime initDate = NepaliDateTime.now();
    NepaliDateTime tomorrow =
        NepaliDateTime(initDate.year, initDate.month, initDate.day + 1);
    return tomorrow;
  }

  showPicker(BuildContext context) async {
    buyerExpectedDeadline = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: getTomorrowDate(),
      firstDate: getTomorrowDate(),
      lastDate: NepaliDateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );
    if (buyerExpectedDeadline != null) {
      datePickercontroller.text = DateFormat('yyyy-MM-dd')
          .format(buyerExpectedDeadline as DateTime)
          .toString();
    }
  }

  bindPostDetailsScreen(BuildContext context) {
    bindBaseViewModal(context);

    postDetailsPageCreateOrderRequestBototmSheetForm = GlobalKey<FormState>();
    postDetailsPageBototmSheetForm = GlobalKey<FormState>();
    setBillingInfo();
    initDate = NepaliDateTime.now();
    datePickercontroller = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
          NepaliDateTime.now().year,
          NepaliDateTime.now().month,
          NepaliDateTime.now().day + 1)),
    );
    itemCount = 1;

    postDetailsPageCartBottomSheetBuyerDateFocusNode = FocusNode();
    postDetailsPageCartBottomSheetBuyerPriceFocusNode = FocusNode();
    postDetailsPageCartBottomSheetBuyerBooksCountFocusNode = FocusNode();
    postDetailsPageCartBottomSheetFirstNameFocusNode = FocusNode();
    postDetailsPageCartBottomSheetLastNameFocusNode = FocusNode();
    postDetailsPageCartBottomSheetEmailFocusNode = FocusNode();
    postDetailsPageCartBottomSheetPhoneNumberFocusNode = FocusNode();
    postDetailsPageCartBottomSheetSideNoteFocusNode = FocusNode();
  }

  unBindPostDetailsScreen() {}
}
