import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/book.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/providers/books.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/font_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/screens/home_screen.dart';
import 'package:share_learning/templates/utils/system_helper.dart';
import 'package:share_learning/templates/widgets/image_gallery.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = '/edit-post';

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  bool _first = true;
  bool _presentInFile = true;

  final _form = GlobalKey<FormState>();

  final _authorFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _booksCountFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  List<bool> postTypeSelling = [true, false];

  List<XFile>? _storedImages;
  List<BookImage> actualImages = [];

  List<BookImage> _imagesToDelete = [];

  ImagePicker imagePicker = ImagePicker();

  var _edittedBook = Book(
    id: '',
    author: '',
    bookName: '',
    userId: '',
    // postType: false,
    postType: 'B',
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    wishlisted: false,
    price: 0,
    bookCount: 1,
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

  bool ispostType = true;

  NepaliDateTime? _boughtDate;

  final _datePickercontroller = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(NepaliDateTime.now()).toString(),
  );

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String bookId = args['bookId'];
    if (bookId.isNotEmpty) {
      _edittedBook =
          Provider.of<Books>(context, listen: false).getBookById(bookId);

      ispostType = _edittedBook.postType == 'S' ? true : false;
      postTypeSelling = [ispostType, !ispostType];
      if (_first) _retrieveImage(_edittedBook);
    } else
      print('Book Id Is Empty');

    _datePickercontroller.text =
        DateFormat('yyyy-MM-dd').format(_edittedBook.boughtDate).toString();

    super.didChangeDependencies();
  }

  _retrieveImage(Book post) {
    if (post.images != null) {
      for (int i = 0; i < post.images!.length; i++) {
        // actualImages.add(post.images![i]['image']);
        actualImages.add(post.images![i]);
      }
      // print(actualImages);
    }

    // actualImages.addAll(post.pictures);
  }

  Future<void> _getPicture() async {
    final imageFiles =
        await imagePicker.pickMultiImage(maxWidth: 770, imageQuality: 100);

    if (imageFiles == null) return;

    // _storedImages = imageFiles;

    if (_storedImages == null) {
      _storedImages = [];
    }

    _storedImages!.addAll(imageFiles);

    List<String> imagesName = [];

    setState(() {
      for (int i = 0; i < _storedImages!.length; i++) {
        // actualImages.add(_storedImages![i].path);
        actualImages.add(BookImage(id: null, image: _storedImages![i].path));
      }
    });

    _first = false;
  }

  eraseImage(dynamic image) {
    // Null Id means it is a XFile
    // if (image is XFile) {
    if (image.id == null) {
      setState(() {
        _storedImages?.remove(image);
        actualImages.remove(image);
      });
    } else {
      // print('here');
      setState(() {
        // if (_storedImages != null) {
        if (actualImages != null) {
          // print('here');
          // XFile? imageToRemove;

          // try {

          //   imageToRemove = _storedImages!.firstWhere(
          //     (element) => element.path == image,
          //   );
          // } on StateError {
          //   imageToRemove = null;
          // }
          // if (imageToRemove != null) _storedImages?.remove(imageToRemove);
          // List<BookImage>? imagesToRemove = [];

          try {
            _imagesToDelete.add(
                actualImages.firstWhere((element) => element.id == image.id));
            actualImages.remove(image);
          } on StateError {
            // imagesToRemove = null;
            print('here');
          }

          // print(_imagesToDelete);
        }

        // actualImages.remove(image);
        // if (_edittedBook.pictures!.contains(image)) _imagesToDelete.add(image);
      });
    }
  }

  Future<void> _showPicker(BuildContext context) async {
    _boughtDate = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: _edittedBook.boughtDate,
      firstDate: picker.NepaliDateTime(2070),
      lastDate: picker.NepaliDateTime.now(),
    );
    _datePickercontroller.text =
        DateFormat('yyyy-MM-dd').format(_boughtDate as DateTime).toString();
  }
  // Map<String, dynamic> _getBookWithEdittedFields (Book book1, Book book2) {
  //   final map1 = SystemHelper.convertKeysToSnakeCase(book1.toMap());
  //   map1['bought_date'] = DateFormat('yyyy-MM-dd').format(book1.boughtDate);
  //   final map2 = SystemHelper.convertKeysToSnakeCase(book2.toMap());
  //   map2['bought_date'] = DateFormat('yyyy-MM-dd').format(book1.boughtDate);
  //   final differentFields = Map<String, dynamic>.from({});
  //    map1.forEach((key, value) {
  //   if (map2[key] != value) {
  //     differentFields[key] = value;
  //   }
  // });
  // differentFields.remove("pictures");
  // return differentFields;
  // // return Book.fromMap(differentFields);
  // }

  Future<bool> _updatePost(
      Session loggedInUserSession, Book edittedBook) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return false;
    }
    _form.currentState!.save();
    _edittedBook.postType = ispostType ? 'S' : 'B';
    // _edittedBook.pictures = _storedImages;

    if (await Provider.of<Books>(context, listen: false)
        .updatePost(loggedInUserSession, _edittedBook)) {
      if (_imagesToDelete.isNotEmpty) {
        if (await Provider.of<Books>(context, listen: false).deletePictures(
            loggedInUserSession, _edittedBook.id, _imagesToDelete)) {
          if (_storedImages != null) {
            if (_storedImages!.isNotEmpty) {
              _edittedBook.images = _storedImages;
              if (await Provider.of<Books>(context, listen: false)
                  .updatePictures(loggedInUserSession, _edittedBook)) {
                    BotToast.showSimpleNotification(
      title: 'Post has been successfully updated',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );
                  }
            }
          }
        }
      }
    }
    if(Provider.of<Books>(context,listen: false).bookError != null)
    {
      BotToast.showSimpleNotification(
      title: Provider.of<Books>(context, listen: false).bookError!.message.toString(),
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );
    }

    BotToast.showSimpleNotification(
      title: 'Something went wrong, please try again',
      duration: Duration(seconds: 3),
      backgroundColor: ColorManager.primary,
      titleStyle: getBoldStyle(color: ColorManager.white),
      align: Alignment(1, 1),
    );

    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    // showUpdateSnackbar(context);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    // String bookId = args['id'];
    final Session loggedInUserSession = args['loggedInUserSession'] as Session;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        actions: <Widget>[
          // loggedInUserSession.userId == _edittedBook.userId
          '1' == _edittedBook.userId
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () async {
                    if (await _updatePost(loggedInUserSession, _edittedBook))
                      // _showUpdateSnackbar(context);
                      // BotToast.showSimpleNotification(
                      //   title: 'Posted Updated Successfully',
                      //   duration: Duration(seconds: 3),
                      //   backgroundColor: ColorManager.primary,
                      //   titleStyle: getBoldStyle(color: ColorManager.white),
                      //   align: Alignment(0, 1),
                      //   hideCloseButton: true,
                      // );

                      Navigator.pushReplacementNamed(context, HomeScreen.routeName, arguments: {
                        'authSession': loggedInUserSession
                      });
                    
                  },
                  // onPressed: _updatePost,
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
            color: Colors.white,
          ),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                    initialValue: _edittedBook.bookName,
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
                      FocusScope.of(context).requestFocus(_authorFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide the bookName';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _edittedBook = Book(
                        id: _edittedBook.id,
                        author: _edittedBook.author,
                        bookName: value as String,
                        userId: _edittedBook.userId,
                        postType: _edittedBook.postType,
                        boughtDate: _edittedBook.boughtDate,
                        description: _edittedBook.description,
                        wishlisted: _edittedBook.wishlisted,
                        price: _edittedBook.price,
                        bookCount: _edittedBook.bookCount,
                        postedOn: _edittedBook.postedOn,
                        postRating: _edittedBook.postRating,
                      );
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            initialValue: _edittedBook.author,
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode: _authorFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Author',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_dateFocusNode);
                            },
                            onSaved: (value) {
                              _edittedBook = Book(
                                id: _edittedBook.id,
                                author: value!.isEmpty ? 'Unknown' : value,
                                bookName: _edittedBook.bookName,
                                userId: _edittedBook.userId,
                                postType: _edittedBook.postType,
                                boughtDate: _edittedBook.boughtDate,
                                description: _edittedBook.description,
                                wishlisted: _edittedBook.wishlisted,
                                price: _edittedBook.price,
                                bookCount: _edittedBook.bookCount,
                                postedOn: _edittedBook.postedOn,
                                postRating: _edittedBook.postRating,
                              );
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          // initialValue: _edittedBook.boughtDate.toIso8601String(),
                          controller: _datePickercontroller,
                          focusNode: _dateFocusNode,
                          // initialValue:
                          //     DateFormat('yyyy/MM/dd').format(DateTime.now()),
                          keyboardType: TextInputType.datetime,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Bought Date',
                            // suffix: IconButton(
                            //   // onPressed: _showPicker,
                            //   tooltip: 'Tap to open datePicker',
                            //   onPressed: () {
                            //     DatePickerDialog(
                            //       initialDate: DateTime.now(),
                            //       firstDate: DateTime(2000),
                            //       lastDate: DateTime(2025),
                            //     );
                            //   },
                            //   icon: Icon(Icons.calendar_view_day_rounded),
                            // ),
                            suffix: IconButton(
                              icon: Icon(Icons.calendar_today),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                _showPicker(context);

                                // _datePickercontroller.text = _boughtDate.toString();
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide bought date';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            // print(DateFormat.yMd());
                            _edittedBook = Book(
                              id: _edittedBook.id,
                              author: _edittedBook.author,
                              bookName: _edittedBook.bookName,
                              userId: _edittedBook.userId,
                              postType: _edittedBook.postType,
                              // boughtDate: (DateFormat("yyyy/MM/dd")
                              //         .parse(value as String))
                              //     .toNepaliDateTime(),
                              boughtDate: NepaliDateTime.parse(value as String),

                              description: _edittedBook.description,
                              wishlisted: _edittedBook.wishlisted,
                              price: _edittedBook.price,
                              bookCount: _edittedBook.bookCount,
                              postedOn: _edittedBook.postedOn,
                              postRating: _edittedBook.postRating,
                            );
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
                            initialValue: _edittedBook.price.toString(),
                            cursorColor: Theme.of(context).primaryColor,
                            focusNode: _priceFocusNode,
                            decoration: InputDecoration(
                              prefix: Text('Rs. '),
                              labelText: 'Price',
                              focusColor: Colors.redAccent,
                            ),
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.always,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_booksCountFocusNode);
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
                              _edittedBook = Book(
                                id: _edittedBook.id,
                                author: _edittedBook.author,
                                bookName: _edittedBook.bookName,
                                userId: _edittedBook.userId,
                                postType: _edittedBook.postType,
                                boughtDate: _edittedBook.boughtDate,
                                description: _edittedBook.description,
                                wishlisted: _edittedBook.wishlisted,
                                price: double.parse(value as String),
                                bookCount: _edittedBook.bookCount,
                                postedOn: _edittedBook.postedOn,
                                postRating: _edittedBook.postRating,
                              );
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _edittedBook.bookCount.toString(),
                          focusNode: _booksCountFocusNode,
                          keyboardType: TextInputType.number,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelText: 'Number of Books',
                          ),
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.always,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_descFocusNode);
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
                            _edittedBook = Book(
                              id: _edittedBook.id,
                              author: _edittedBook.author,
                              bookName: _edittedBook.bookName,
                              userId: _edittedBook.userId,
                              postType: _edittedBook.postType,
                              boughtDate: _edittedBook.boughtDate,
                              description: _edittedBook.description,
                              wishlisted: _edittedBook.wishlisted,
                              price: _edittedBook.price,
                              bookCount: int.parse(value as String),
                              postedOn: _edittedBook.postedOn,
                              postRating: _edittedBook.postRating,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: _edittedBook.description,
                      focusNode: _descFocusNode,
                      keyboardType: TextInputType.number,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelText: 'Book description',
                      ),
                      textInputAction: TextInputAction.newline,
                      autovalidateMode: AutovalidateMode.always,
                      minLines: 3,
                      maxLines: 7,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_descFocusNode);
                      // },
                      validator: (value) {
                        if (value!.length < 50) {
                          return 'Please provide a big description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edittedBook = Book(
                          id: _edittedBook.id,
                          author: _edittedBook.author,
                          bookName: _edittedBook.bookName,
                          userId: _edittedBook.userId,
                          postType: _edittedBook.postType,
                          boughtDate: _edittedBook.boughtDate,
                          description: value as String,
                          wishlisted: _edittedBook.wishlisted,
                          price: _edittedBook.price,
                          bookCount: _edittedBook.bookCount,
                          postedOn: _edittedBook.postedOn,
                          postRating: _edittedBook.postRating,
                        );
                      }),
                ),
                Container(
                  child: ToggleButtons(
                    isSelected: postTypeSelling,
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
                        for (int i = 0; i < postTypeSelling.length; i++) {
                          if (i == index)
                            postTypeSelling[i] = true;
                          else
                            postTypeSelling[i] = false;
                        }
                        ispostType = postTypeSelling[0];
                      });
                    },
                  ),
                ),
                actualImages.isNotEmpty
                    ? ImageGallery(
                        true,
                        // images: _edittedBook.pictures,
                        images: actualImages,
                        isErasable: true,
                        eraseImage: eraseImage,
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
                              _getPicture();
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
                    // onPressed: _savePost,
                    onPressed: () async {
                      if (await _updatePost(loggedInUserSession, _edittedBook))
                        // _showUpdateSnackbar(context);
                        BotToast.showSimpleNotification(
                          title: 'Posted Updated Successfully',
                          duration: Duration(seconds: 3),
                          backgroundColor: ColorManager.primary,
                          titleStyle: getBoldStyle(color: ColorManager.white),
                          align: Alignment(1, 1),
                        );
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
