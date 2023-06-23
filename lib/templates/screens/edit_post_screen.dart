import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/post_category.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/book_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/widgets/image_gallery.dart';

import '../managers/routes_manager.dart';
import '../utils/alert_helper.dart';

class EditPostScreen extends StatefulWidget {
  // static const routeName = '/edit-post';

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<BookProvider>(context, listen: false)
        .bindEditPostScreenViewModel(context);
  }

  @override
  void dispose() {
    Provider.of<BookProvider>(context, listen: false)
        .unbindEditPostScreenViewModel();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   final args = ModalRoute.of(context)!.settings.arguments as Map;
  //   String bookId = args['bookId'];
  //   if (bookId.isNotEmpty) {
  //     _bookProvider.editPostScreenEdittedBook =
  //         Provider.of<BookProvider>(context, listen: false).getBookById(bookId);
  //     _bookProvider.editPostScreenIspostType = _bookProvider.editPostScreenEdittedBook.postType == 'S' ? true : false;
  //     _bookProvider.editPostScreenPostTypeSelling = [_bookProvider.editPostScreenIspostType, !_bookProvider.editPostScreenIspostType];
  //     if (_first) _retrieveImage(_bookProvider.editPostScreenEdittedBook);
  //   } else
  //     print('Book Id Is Empty');
  //   _bookProvider.editPostScreenDatePickercontroller.text =
  //       DateFormat('yyyy-MM-dd').format(_bookProvider.editPostScreenEdittedBook.boughtDate).toString();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    BookProvider _bookProvider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        actions: <Widget>[
          _bookProvider.userProvider.user!.id ==
                  _bookProvider.editPostScreenEdittedBook.userId
              ? IconButton(
                  icon: Icon(Icons.delete),
                  
                  onPressed: () async {
                    // setState(() => _bookProvider.editPostScreenShowLoading = true);
                    _bookProvider.setEditPostScreenShowLoading(true);

                    if (_bookProvider.editPostScreenShowLoading) {
                      AlertHelper.showLoading();
                    }

                    if (await Provider.of<BookProvider>(context, listen: false)
                        .deletePost(
                            _bookProvider.sessionProvider.session as Session,
                            _bookProvider.editPostScreenEdittedBook.id)) {
                      setState(() =>
                          _bookProvider.editPostScreenShowLoading = false);
                      AlertHelper.showToastAlert(
                          'Post has been deleted successfully');

                      Navigator.pushReplacementNamed(
                          context, RoutesManager.homeScreenNewRoute);
                    } else {
                      AlertHelper.showToastAlert('Something went wrong');

                      setState(() =>
                          _bookProvider.editPostScreenShowLoading = false);
                    }
                  },
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
          ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                    initialValue:
                        _bookProvider.editPostScreenEdittedBook.bookName,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      labelText: 'bookName',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(
                          _bookProvider.editPostScreenAuthorFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide the bookName';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _bookProvider.editPostScreenEdittedBook =
                          Book.withPoperty(
                              _bookProvider.editPostScreenEdittedBook,
                              {'bookName': value as String});
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            initialValue:
                                _bookProvider.editPostScreenEdittedBook.author,
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode:
                                _bookProvider.editPostScreenAuthorFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Author',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(
                                  _bookProvider.editPostScreenDateFocusNode);
                            },
                            onSaved: (value) {
                              _bookProvider.editPostScreenEdittedBook =
                                  Book.withPoperty(
                                      _bookProvider.editPostScreenEdittedBook, {
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
                              _bookProvider.editPostScreenDatePickercontroller,
                          focusNode: _bookProvider.editPostScreenDateFocusNode,
                          keyboardType: TextInputType.datetime,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Bought Date',
                            suffix: IconButton(
                              icon: Icon(Icons.calendar_today),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                _bookProvider.editPostScreenShowPicker(context);

                                // _bookProvider.editPostScreenDatePickercontroller.text = _boughtDate.toString();
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                                _bookProvider.editPostScreenPriceFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide bought date';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _bookProvider.editPostScreenEdittedBook =
                                Book.withPoperty(
                                    _bookProvider.editPostScreenEdittedBook, {
                              'boughtDate':
                                  picker.NepaliDateTime.parse(value as String)
                            });
                          },
                        ),
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
                            initialValue: _bookProvider
                                .editPostScreenEdittedBook.price
                                .toString(),
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode:
                                _bookProvider.editPostScreenPriceFocusNode,
                            decoration: InputDecoration(
                              prefix: Text('Rs. '),
                              labelText: 'Price',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_bookProvider
                                  .editPostScreenBooksCountFocusNode);
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
                              _bookProvider.editPostScreenEdittedBook =
                                  Book.withPoperty(
                                      _bookProvider.editPostScreenEdittedBook,
                                      {'price': double.parse(value as String)});
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _bookProvider
                              .editPostScreenEdittedBook.bookCount
                              .toString(),
                          focusNode:
                              _bookProvider.editPostScreenBooksCountFocusNode,
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Number of Books',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(
                                _bookProvider.editPostScreenDescFocusNode);
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
                            _bookProvider.editPostScreenEdittedBook =
                                Book.withPoperty(
                                    _bookProvider.editPostScreenEdittedBook,
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
                      initialValue:
                          _bookProvider.editPostScreenEdittedBook.description,
                      focusNode: _bookProvider.editPostScreenDescFocusNode,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelText: 'Book description',
                      ),
                      textInputAction: TextInputAction.newline,
                      autovalidateMode: AutovalidateMode.always,
                      minLines: 3,
                      maxLines: 7,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            _bookProvider.editPostScreenCateFocusNode);
                      },
                      validator: (value) {
                        if (value!.length < 50) {
                          return 'Please provide a big description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _bookProvider.editPostScreenEdittedBook =
                            Book.withPoperty(
                                _bookProvider.editPostScreenEdittedBook,
                                {'description': value as String});
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  child: _bookProvider.editPostScreenEdittedBook.category ==
                          null
                      ? Container()
                      : FutureBuilder(
                          future: _bookProvider.categoryProvider
                              .getCategoryById(
                                  _bookProvider.sessionProvider.session
                                      as Session,
                                  _bookProvider
                                      .editPostScreenEdittedBook.category!.id),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: ColorManager.secondary,
                                ),
                              );
                            } else {
                              if (snapshot.hasError) {
                                return Text(
                                    'Error fetching data, please try again');
                              } else {
                                if (snapshot.data is CategoryError) {
                                  CategoryError error =
                                      snapshot.data as CategoryError;
                                  return Text(error.message as String);
                                } else {
                                  _bookProvider.editPostScreenSelectedCategory =
                                      snapshot.data as PostCategory;

                                  return Container(
                                    padding: EdgeInsets.only(
                                      left: AppPadding.p8,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    )),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: _bookProvider
                                            .editPostScreenSelectedCategory,
                                        items: _bookProvider
                                            .editPostScreenCategories
                                            .map((option) => DropdownMenuItem(
                                                  value: option,
                                                  child: ListTile(
                                                    selected: option ==
                                                        _bookProvider
                                                            .editPostScreenSelectedCategory,
                                                    selectedColor:
                                                        ColorManager.black,
                                                    selectedTileColor:
                                                        ColorManager.primary,
                                                    // tileColor: ColorManager.grey1,
                                                    title: Text(option.name),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _bookProvider
                                                    .editPostScreenSelectedCategory =
                                                value as PostCategory;
                                          });
                                          // print(_bookProvider.editPostScreenSelectedCategory);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          }),

                  //
                ),
                Container(
                  child: ToggleButtons(
                    isSelected: _bookProvider.editPostScreenPostTypeSelling,
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
                                    .editPostScreenPostTypeSelling.length;
                            i++) {
                          if (i == index)
                            _bookProvider.editPostScreenPostTypeSelling[i] =
                                true;
                          else
                            _bookProvider.editPostScreenPostTypeSelling[i] =
                                false;
                        }

                        _bookProvider.editPostScreenIspostType =
                            _bookProvider.editPostScreenPostTypeSelling[0];
                      });
                    },
                  ),
                ),
                _bookProvider.editPostScreenActualImages.isNotEmpty
                    ? ImageGallery(
                        true,
                        // images: _bookProvider.editPostScreenEdittedBook.pictures,
                        images: _bookProvider.editPostScreenActualImages,
                        isErasable: true,
                        eraseImage: _bookProvider.editPostScreenEraseImage,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Center(
                          child: Text(
                            "No Images",
                            style: getBoldStyle(
                              fontSize: FontSize.s16,
                              color: ColorManager.primary,
                            ),
                          ),
                        ),
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
                              _bookProvider.editPostScreenGetPicture();
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // ElevatedButton(
                          //   child: Text('From Camera'),
                          //   style: ButtonStyle(),
                          //   onPressed: () {
                          //     _takePicture();
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      setState(
                          () => _bookProvider.editPostScreenShowLoading = true);

                      if (_bookProvider.editPostScreenShowLoading) {
                        AlertHelper.showLoading();
                      }
                      if (await _bookProvider.editPostScreenUpdatePost(_form)) {
                        setState(() =>
                            _bookProvider.editPostScreenShowLoading = false);
                        AlertHelper.showToastAlert(
                            'Posted Updated Successfully');

                        Navigator.pushReplacementNamed(
                          context,
                          RoutesManager.homeScreenNewRoute,
                        );
                      }
                    },
                    child: Text(
                      'Update Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
