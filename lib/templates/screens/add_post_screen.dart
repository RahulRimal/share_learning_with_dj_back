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
import '../utils/alert_helper.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = '/add-post';

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<XFile>? _storedImages;
  List<BookImage> actualImages = [];
  ImagePicker imagePicker = ImagePicker();

  final _form = GlobalKey<FormState>();
  bool showSpinner = false;

  late FocusNode _authorFocusNode;
  late FocusNode _dateFocusNode;
  late FocusNode _priceFocusNode;
  late FocusNode _booksCountFocusNode;
  late FocusNode _descFocusNode;

  List<bool> postTypeSelling = [true, false];

  bool ispostType = true;

  picker.NepaliDateTime? _boughtDate;

  eraseImage(dynamic image) {
    if (image is XFile) {
      setState(() {
        _storedImages?.remove(image);
        actualImages.remove(image.path);
      });
    } else {
      setState(() {
        XFile imageToRemove =
            _storedImages!.firstWhere((element) => element.path == image.image);
        _storedImages?.remove(imageToRemove);
        actualImages.remove(image);
      });
    }
  }

  Future<void> _getPicture() async {
    final imageFiles =
        await imagePicker.pickMultiImage(maxWidth: 770, imageQuality: 100);

    // if (imageFiles == null) return;

    _storedImages = imageFiles;

    // final appDir = await syspaths.getApplicationDocumentsDirectory();

    setState(() {
      for (int i = 0; i < _storedImages!.length; i++) {
        actualImages.add(BookImage(id: null, image: _storedImages![i].path));
      }
    });
  }

  var _edittedBook = Book(
    id: '',
    author: 'Unknown',
    bookName: '',
    userId: '1',
    postType: 'B',
    category: null,
    boughtDate: DateTime.now().toNepaliDateTime(),
    description: '',
    // wishlisted: false,
    price: 0,
    bookCount: 1,
    images: [],
    postedOn: DateTime.now().toNepaliDateTime(),
    postRating: 0.0,
  );

  final _datePickercontroller = TextEditingController(
    text:
        DateFormat('yyyy-MM-dd').format(picker.NepaliDateTime.now()).toString(),
  );

  @override
  void initState() {
    _authorFocusNode = FocusNode();
    _dateFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    _booksCountFocusNode = FocusNode();
    _descFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _authorFocusNode.dispose();
    _dateFocusNode.dispose();
    _priceFocusNode.dispose();
    _booksCountFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showPicker(BuildContext context) async {
    _boughtDate = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: picker.NepaliDateTime.now(),
      firstDate: picker.NepaliDateTime(2070),
      lastDate: picker.NepaliDateTime.now(),
    );

    _datePickercontroller.text =
        DateFormat('yyyy-MM-dd').format(_boughtDate as DateTime).toString();
  }

  _savePost(Session loggedInUser) async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      // return false;
      return;
    }

    setState(() {
      showSpinner = true;
    });

    _form.currentState!.save();
    _edittedBook.postType = ispostType ? 'S' : 'B';
    // _edittedBook.pictures = _storedImages;
    _edittedBook.postRating = 0.0;
    _edittedBook.userId =
        Provider.of<UserProvider>(context, listen: false).user!.id;
    BookProvider books = Provider.of<BookProvider>(context, listen: false);

    if (await books.createPost(loggedInUser, _edittedBook)) {
      if (_storedImages != null) {
        _edittedBook = books.books.last;
        _edittedBook.images = _storedImages;

        if (await books.updatePictures(loggedInUser, _edittedBook)) {
          showSpinner = false;
          return true;
        } else {
          showSpinner = false;
          return false;
        }
      }
    }
    showSpinner = false;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;
    // final Session loggedInUserSession = args['loggedInUserSession'] as Session;
    Session loggedInUserSession =
        Provider.of<SessionProvider>(context).session as Session;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Post'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (await _savePost(loggedInUserSession)) {
                // final snackBar = SnackBar(
                //   content: Text(
                //     'Posted Successfully',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 13,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // );
                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                AlertHelper.showToastAlert('Your book has been posted!');
                // BotToast.showSimpleNotification(
                //   title: 'Your book has been posted!!',
                //   duration: Duration(seconds: 3),
                //   backgroundColor: ColorManager.primary,
                //   titleStyle: getBoldStyle(color: ColorManager.white),
                //   align: Alignment(1, 1),
                // );
              } else {
                // BotToast.showSimpleNotification(
                //   title: 'Couldn\'t post your book, plase try again!!',
                //   duration: Duration(seconds: 3),
                //   backgroundColor: ColorManager.primary,
                //   titleStyle: getBoldStyle(color: ColorManager.white),
                //   align: Alignment(1, 1),
                //   hideCloseButton: true,
                // );
                AlertHelper.showToastAlert(
                    'Couldn\'t post your book, plase try again!');
                // Navigator.pushReplacementNamed(context, HomeScreen.routeName,
                //     arguments: {'authSession': loggedInUserSession});
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
                      FocusScope.of(context).requestFocus(_authorFocusNode);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide the bookName';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _edittedBook = Book(
                      //   id: _edittedBook.id,
                      //   author: _edittedBook.author,
                      //   bookName: value as String,
                      //   userId: _edittedBook.userId,
                      //   postType: _edittedBook.postType,
                      //   boughtDate: _edittedBook.boughtDate,
                      //   description: _edittedBook.description,
                      //   wishlisted: _edittedBook.wishlisted,
                      //   price: _edittedBook.price,
                      //   bookCount: _edittedBook.bookCount,
                      //   postedOn: _edittedBook.postedOn,
                      //   postRating: _edittedBook.postRating,
                      // );
                      _edittedBook = Book.withPoperty(
                          _edittedBook, {'bookName': value as String});
                    }),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                              // _edittedBook = Book(
                              //   id: _edittedBook.id,
                              //   author: value!.isEmpty ? 'Unknown' : value,
                              //   bookName: _edittedBook.bookName,
                              //   userId: _edittedBook.userId,
                              //   postType: _edittedBook.postType,
                              //   boughtDate: _edittedBook.boughtDate,
                              //   description: _edittedBook.description,
                              //   wishlisted: _edittedBook.wishlisted,
                              //   price: _edittedBook.price,
                              //   bookCount: _edittedBook.bookCount,
                              //   postedOn: _edittedBook.postedOn,
                              //   postRating: _edittedBook.postRating,
                              // );
                              _edittedBook = Book.withPoperty(_edittedBook, {
                                'author': value!.isEmpty ? 'Unknown' : value
                              });
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
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
                              // _edittedBook = Book(
                              //   id: _edittedBook.id,
                              //   author: _edittedBook.author,
                              //   bookName: _edittedBook.bookName,
                              //   userId: _edittedBook.userId,
                              //   postType: _edittedBook.postType,
                              //   // boughtDate: (DateFormat("yyyy/MM/dd")
                              //   //         .parse(value as String))
                              //   //     .toNepaliDateTime(),
                              //   boughtDate:
                              //       NepaliDateTime.parse(value as String),

                              //   description: _edittedBook.description,
                              //   wishlisted: _edittedBook.wishlisted,
                              //   price: _edittedBook.price,
                              //   bookCount: _edittedBook.bookCount,
                              //   postedOn: _edittedBook.postedOn,
                              //   postRating: _edittedBook.postRating,
                              // );
                              _edittedBook = Book.withPoperty(_edittedBook, {
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
                            focusNode: _priceFocusNode,
                            decoration: InputDecoration(
                              prefix: Text('Rs. '),
                              labelText: 'Price',
                              focusColor: Colors.redAccent,
                            ),
                            keyboardType: TextInputType.number,
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
                              // _edittedBook = Book(
                              //   id: _edittedBook.id,
                              //   author: _edittedBook.author,
                              //   bookName: _edittedBook.bookName,
                              //   userId: _edittedBook.userId,
                              //   postType: _edittedBook.postType,
                              //   boughtDate: _edittedBook.boughtDate,
                              //   description: _edittedBook.description,
                              //   wishlisted: _edittedBook.wishlisted,
                              //   price: double.parse(value as String),
                              //   bookCount: _edittedBook.bookCount,
                              //   postedOn: _edittedBook.postedOn,
                              //   postRating: _edittedBook.postRating,
                              // );

                              _edittedBook = Book.withPoperty(_edittedBook,
                                  {'price': double.parse(value as String)});
                            }),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode: _booksCountFocusNode,
                          initialValue: '1',
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
                            // _edittedBook = Book(
                            //   id: _edittedBook.id,
                            //   author: _edittedBook.author,
                            //   bookName: _edittedBook.bookName,
                            //   userId: _edittedBook.userId,
                            //   postType: _edittedBook.postType,
                            //   boughtDate: _edittedBook.boughtDate,
                            //   description: _edittedBook.description,
                            //   wishlisted: _edittedBook.wishlisted,
                            //   price: _edittedBook.price,
                            //   bookCount: int.parse(value as String),
                            //   postedOn: _edittedBook.postedOn,
                            //   postRating: _edittedBook.postRating,
                            // );
                            _edittedBook = Book.withPoperty(_edittedBook,
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
                    focusNode: _descFocusNode,
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
                    //   FocusScope.of(context).requestFocus(_descFocusNode);
                    // },
                    validator: (value) {
                      if (value!.length < 50) {
                        return 'Please provide a big description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _edittedBook = Book(
                      //   id: _edittedBook.id,
                      //   author: _edittedBook.author,
                      //   bookName: _edittedBook.bookName,
                      //   userId: _edittedBook.userId,
                      //   postType: _edittedBook.postType,
                      //   boughtDate: _edittedBook.boughtDate,
                      //   description: value as String,
                      //   wishlisted: _edittedBook.wishlisted,
                      //   price: _edittedBook.price,
                      //   bookCount: _edittedBook.bookCount,
                      //   // pictures: actualImages,
                      //   postedOn: _edittedBook.postedOn,
                      //   postRating: _edittedBook.postRating,
                      // );
                      _edittedBook = Book.withPoperty(
                          _edittedBook, {'description': value as String});
                    },
                  ),
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
                Container(
                  height: 150,
                  width: 150,
                  // child: _storedImage != null
                  //     ? kIsWeb
                  //         ? Image.network(_storedImage!.path)
                  //         : Image.file(File(_storedImage!.path))
                  //     : Text('No Image'),
                  // child: _storedImages != null
                  //     ? kIsWeb
                  //         ? Image.network(_storedImages!.path)
                  //         : Image.file(File(_storedImage!.path))
                  child: _storedImages != null
                      ?
                      // ImageGallery(null, _storedImages)
                      // ImageGallery(false, null, actualImages)
                      ImageGallery(
                          false,
                          images: actualImages,
                          isErasable: true,
                          eraseImage: eraseImage,
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
                          showSpinner
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
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
                    onPressed: () async {
                      var result = await _savePost(loggedInUserSession);
                      // if (await _savePost(loggedInUserSession)) {
                      if (result == null) {
                        AlertHelper.showToastAlert('Fields not valid');
                        // BotToast.showSimpleNotification(
                        //   title: 'Fields not valid',
                        //   duration: Duration(seconds: 3),
                        //   backgroundColor: ColorManager.primary,
                        //   titleStyle: getBoldStyle(color: ColorManager.white),
                        //   align: Alignment(1, 1),
                        //   hideCloseButton: true,
                        // );
                        return;
                      }
                      if (result) {
                        AlertHelper.showToastAlert(
                            'Your book has been posted!');
                        // BotToast.showSimpleNotification(
                        //   title: 'Your book has been posted!!',
                        //   duration: Duration(seconds: 3),
                        //   backgroundColor: ColorManager.primary,
                        //   titleStyle: getBoldStyle(color: ColorManager.white),
                        //   align: Alignment(1, 1),
                        // );

                        Navigator.pushReplacementNamed(
                          context,
                          HomeScreenNew.routeName,
                        );
                      } else {
                        AlertHelper.showToastAlert(
                            'Couldn\'t post your book, please try again!');
                        // BotToast.showSimpleNotification(
                        //   title: 'Couldn\'t post your book, please try again!!',
                        //   duration: Duration(seconds: 3),
                        //   backgroundColor: ColorManager.primary,
                        //   titleStyle: getBoldStyle(color: ColorManager.white),
                        //   align: Alignment(1, 1),
                        //   hideCloseButton: true,
                        // );

                        Navigator.pushReplacementNamed(
                          context,
                          HomeScreenNew.routeName,
                        );
                      }
                    },
                    child: Text(
                      'Add this Post',
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
