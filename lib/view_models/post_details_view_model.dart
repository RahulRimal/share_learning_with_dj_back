import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:share_learning/view_models/base_view_model.dart';

import '../models/book.dart';

mixin PostDetailsViewModel on BaseViewModel {
  late int postDetailsScreenItemCount;
  double postDetailsScreenExpectedUnitPrice = 0;
  int postDetailsScreenMainImageIndex = 0;

  bool postDetailsScreenIsRequestOnProcess = false;
  bool postDetailsScreenIsCartOnProcess = false;
  bool postDetailsScreenIsOrderPlacementOnProcess = false;
  bool postDetailsScreenEnableRequestButton = false;

  late Book postDetailsScreenSelectedBook;
  late NepaliDateTime postDetailsScreenInitDate;
  late NepaliDateTime? postDetailsScreenBuyerExpectedDeadline;
  // late TextEditingController postDetailsScreenDatePickercontroller;
  TextEditingController postDetailsScreenDatePickercontroller =
      TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
        NepaliDateTime.now().year,
        NepaliDateTime.now().month,
        NepaliDateTime.now().day + 1)),
  );

  late FocusNode postDetailsPageCartBottomSheetBuyerDateFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerPriceFocusNode;
  late FocusNode postDetailsPageCartBottomSheetBuyerBooksCountFocusNode;

  // These focus nodes are for order request billing info fields
  late FocusNode postDetailsPageCartBottomSheetFirstNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetLastNameFocusNode;
  late FocusNode postDetailsPageCartBottomSheetEmailFocusNode;
  late FocusNode postDetailsPageCartBottomSheetPhoneNumberFocusNode;
  late FocusNode postDetailsPageCartBottomSheetSideNoteFocusNode;

  postDetailsScreenSetSelectedBook(Book book) {
    postDetailsScreenSelectedBook = book;
  }

  postDetailsScreenSetMainImageIndex(int value) {
    postDetailsScreenMainImageIndex = value;
    notifyListeners();
  }

  postDetailsScreenSetEnableRequestButton(bool value) {
    postDetailsScreenEnableRequestButton = value;
    notifyListeners();
  }

  postDetailsScreenSetExpectedUnitPrice(double value) {
    postDetailsScreenExpectedUnitPrice = value;
    notifyListeners();
  }

  postDetailsScreenSetIsRequestOnProcess(bool value) {
    postDetailsScreenIsRequestOnProcess = value;
    notifyListeners();
  }

  postDetailsScreenSetIsCartOnProcess(bool value) {
    postDetailsScreenIsCartOnProcess = value;
    notifyListeners();
  }

  postDetailsScreenSetIsOrderPlacementOnProcess(bool value) {
    postDetailsScreenIsOrderPlacementOnProcess = value;
    notifyListeners();
  }

  postDetailsScreenSetItemCount(int value) {
    postDetailsScreenItemCount = value;
    notifyListeners();
  }

  postDetailsScreenGetTomorrowDate() {
    NepaliDateTime initDate = NepaliDateTime.now();
    NepaliDateTime tomorrow =
        NepaliDateTime(initDate.year, initDate.month, initDate.day + 1);
    return tomorrow;
  }

  postDetailsScreenShowPicker(BuildContext context) async {
    postDetailsScreenBuyerExpectedDeadline =
        await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: postDetailsScreenGetTomorrowDate(),
      firstDate: postDetailsScreenGetTomorrowDate(),
      lastDate: NepaliDateTime.now().add(
        const Duration(
          days: 365,
        ),
      ),
    );
    if (postDetailsScreenBuyerExpectedDeadline != null) {
      postDetailsScreenDatePickercontroller.text = DateFormat('yyyy-MM-dd')
          .format(postDetailsScreenBuyerExpectedDeadline as DateTime)
          .toString();
    }
  }

  postDetailsScreenBindPostDetailsScreen(BuildContext context) {
    bindBaseViewModal(context);

    setBillingInfo();
    postDetailsScreenInitDate = NepaliDateTime.now();
    // postDetailsScreenDatePickercontroller = TextEditingController(
    //   text: DateFormat('yyyy-MM-dd').format(NepaliDateTime(
    //       NepaliDateTime.now().year,
    //       NepaliDateTime.now().month,
    //       NepaliDateTime.now().day + 1)),
    // );
    postDetailsScreenItemCount = 1;

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
