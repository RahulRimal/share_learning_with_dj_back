import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';

// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:share_learning/templates/widgets/image_gallery.dart';

import '../../view_models/providers/user_provider.dart';
import '../managers/color_manager.dart';
import '../managers/values_manager.dart';
import '../utils/alert_helper.dart';
import '../utils/loading_helper.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/add-post';

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Provider.of<BookProvider>(context, listen: false)
        .bindAddPostScreenViewModel(context);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Added this line to save the reference of provider so it doesn't throw an exception on dispose
  //   bookProvider = Provider.of<BookProvider>(context, listen: false);
  // }

  @override
  void dispose() {
    super.dispose();
    Provider.of<BookProvider>(context, listen: false)
        .unbindAddPostScreenViewModel();
  }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (await _bookProvider.addPostScreenSavePost(_form)) {
                AlertHelper.showToastAlert('Your book has been posted!');
              } else {
                AlertHelper.showToastAlert(
                    'Couldn\'t post your book, plase try again!');
                Navigator.pushReplacementNamed(
                  context,
                  HomeScreenNew.routeName,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      labelText: 'Book Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                          _bookProvider.addPostScreenAuthorFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide the bookName';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _bookProvider.addPostScreenEdittedBook = Book(
                      //   id: _bookProvider.addPostScreenEdittedBook.id,
                      //   author: _bookProvider.addPostScreenEdittedBook.author,
                      //   bookName: value as String,
                      //   userId: _bookProvider.addPostScreenEdittedBook.userId,
                      //   postType: _bookProvider.addPostScreenEdittedBook.postType,
                      //   boughtDate: _bookProvider.addPostScreenEdittedBook.boughtDate,
                      //   description: _bookProvider.addPostScreenEdittedBook.description,
                      //   wishlisted: _bookProvider.addPostScreenEdittedBook.wishlisted,
                      //   price: _bookProvider.addPostScreenEdittedBook.price,
                      //   bookCount: _bookProvider.addPostScreenEdittedBook.bookCount,
                      //   postedOn: _bookProvider.addPostScreenEdittedBook.postedOn,
                      //   postRating: _bookProvider.addPostScreenEdittedBook.postRating,
                      // );
                      _bookProvider.addPostScreenEdittedBook = Book.withPoperty(
                          _bookProvider.addPostScreenEdittedBook,
                          {'bookName': value as String});
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode:
                                _bookProvider.addPostScreenAuthorFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Author',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                  _bookProvider.addPostScreenDateFocusNode);
                            },
                            onSaved: (value) {
                              // _bookProvider.addPostScreenEdittedBook = Book(
                              //   id: _bookProvider.addPostScreenEdittedBook.id,
                              //   author: value!.isEmpty ? 'Unknown' : value,
                              //   bookName: _bookProvider.addPostScreenEdittedBook.bookName,
                              //   userId: _bookProvider.addPostScreenEdittedBook.userId,
                              //   postType: _bookProvider.addPostScreenEdittedBook.postType,
                              //   boughtDate: _bookProvider.addPostScreenEdittedBook.boughtDate,
                              //   description: _bookProvider.addPostScreenEdittedBook.description,
                              //   wishlisted: _bookProvider.addPostScreenEdittedBook.wishlisted,
                              //   price: _bookProvider.addPostScreenEdittedBook.price,
                              //   bookCount: _bookProvider.addPostScreenEdittedBook.bookCount,
                              //   postedOn: _bookProvider.addPostScreenEdittedBook.postedOn,
                              //   postRating: _bookProvider.addPostScreenEdittedBook.postRating,
                              // );
                              _bookProvider.addPostScreenEdittedBook =
                                  Book.withPoperty(
                                      _bookProvider.addPostScreenEdittedBook, {
                                'author': value!.isEmpty ? 'Unknown' : value
                              });
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller:
                                _bookProvider.addPostScreenDatePickercontroller,
                            focusNode: _bookProvider.addPostScreenDateFocusNode,
                            keyboardType: TextInputType.datetime,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              labelText: 'Bought Date',
                              suffix: IconButton(
                                icon: Icon(Icons.calendar_today),
                                tooltip: 'Tap to open date picker',
                                onPressed: () {
                                  _bookProvider
                                      .addPostScreenShowPicker(context);
                                },
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                  _bookProvider.addPostScreenPriceFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please provide bought date';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _bookProvider.addPostScreenEdittedBook =
                                  Book.withPoperty(
                                      _bookProvider.addPostScreenEdittedBook, {
                                'boughtDate':
                                    picker.NepaliDateTime.parse(value as String)
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode:
                                _bookProvider.addPostScreenPriceFocusNode,
                            decoration: InputDecoration(
                              prefix: Text('Rs. '),
                              labelText: 'Price',
                              focusColor: Colors.redAccent,
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_bookProvider
                                  .addPostScreenBooksCountFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Price can\'t be empty';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _bookProvider.addPostScreenEdittedBook =
                                  Book.withPoperty(
                                      _bookProvider.addPostScreenEdittedBook,
                                      {'price': double.parse(value as String)});
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode:
                              _bookProvider.addPostScreenBooksCountFocusNode,
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Number of Books',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                                _bookProvider.addPostScreenDescFocusNode);
                          },
                          validator: (value) {
                            if (double.tryParse(value as String) == null) {
                              return 'Invalid Number';
                            }

                            if (double.parse(value) < 1) {
                              return 'Book count must be at least 1';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bookProvider.addPostScreenEdittedBook =
                                Book.withPoperty(
                                    _bookProvider.addPostScreenEdittedBook,
                                    {'bookCount': int.parse(value as String)});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: _bookProvider.addPostScreenDescFocusNode,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      labelText: 'Book description',
                    ),
                    textInputAction: TextInputAction.newline,
                    autovalidateMode: AutovalidateMode.always,
                    minLines: 3,
                    maxLines: 7,
                    // onFieldSubmitted: (_) {
                    //   FocusScope.of(context).requestFocus(_bookProvider.addPostScreenDescFocusNode);
                    // },
                    validator: (value) {
                      if (value!.length < 50) {
                        return 'Please provide a big description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _bookProvider.addPostScreenEdittedBook = Book.withPoperty(
                          _bookProvider.addPostScreenEdittedBook,
                          {'description': value as String});
                    },
                  ),
                ),
                Container(
                  child: ToggleButtons(
                    isSelected: _bookProvider.addPostScreenPostTypeSelling,
                    color: Colors.grey,
                    selectedColor: Colors.white,
                    fillColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Selling',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Buying',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0;
                            i <
                                _bookProvider
                                    .addPostScreenPostTypeSelling.length;
                            i++) {
                          if (i == index)
                            _bookProvider.addPostScreenPostTypeSelling[i] =
                                true;
                          else
                            _bookProvider.addPostScreenPostTypeSelling[i] =
                                false;
                        }
                        _bookProvider.addPostScreenIsPostType =
                            _bookProvider.addPostScreenPostTypeSelling[0];
                      });
                    },
                  ),
                ),
                Container(
                  height: 150,
                  width: 150,
                  child: _bookProvider.addPostScreenStoredImages != null
                      ? ImageGallery(
                          false,
                          images: _bookProvider.addPostScreenSctualImages,
                          isErasable: true,
                          eraseImage: _bookProvider.addPostScreenEraseImage,
                        )
                      : Text('No Image'),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Add Images',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text('From Gallery'),
                            style: ButtonStyle(),
                            onPressed: () {
                              _bookProvider.addPostScreenGetPicture();
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<BookProvider>(
                    builder: (context, bookProvider, child) =>
                        ElevatedButton.icon(
                      icon: bookProvider.addPostScreenIsPostingNewBook
                          ? SizedBox(
                              height: AppHeight.h20,
                              width: AppHeight.h20,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: ColorManager.primary,
                              ),
                            )
                          : Container(),
                      onPressed: bookProvider.addPostScreenIsPostingNewBook
                          ? null
                          : () async {
                              bookProvider
                                  .setAddPostScreenIsPostingNewBook(true);

                              var result = await bookProvider
                                  .addPostScreenSavePost(_form);

                              if (result == null) {
                                AlertHelper.showToastAlert('Fields not valid');
                                bookProvider
                                    .setAddPostScreenIsPostingNewBook(false);

                                return;
                              }
                              if (result) {
                                AlertHelper.showToastAlert(
                                    'Your book has been posted!');

                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreenNew.routeName,
                                );
                              } else {
                                AlertHelper.showToastAlert(
                                    'Couldn\'t post your book, please try again!');

                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreenNew.routeName,
                                );
                              }
                              bookProvider
                                  .setAddPostScreenIsPostingNewBook(false);
                            },
                      label: bookProvider.addPostScreenIsPostingNewBook
                          ? LoadingHelper.showTextLoading('Posting your book')
                          : Text(
                              'Add this Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
