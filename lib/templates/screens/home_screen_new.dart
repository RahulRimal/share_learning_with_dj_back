import 'package:flutter/material.dart';
import 'package:share_learning/templates/managers/assets_manager.dart';
import 'package:share_learning/templates/managers/color_manager.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: ColorManager.primary,
                  ),
                  
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 75,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.abc),
                      ),
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          ImageAssets.noProfile,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: Container(
                    // width: 1000,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        
                        // key: _form,
                        child: TextFormField(
                          cursorColor: ColorManager.white,
                          decoration: InputDecoration(
                            fillColor: ColorManager.white,
                            focusColor: ColorManager.white,
                            labelText: 'bookName',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.redAccent,
                                color:  ColorManager.white
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please provide the bookName';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
