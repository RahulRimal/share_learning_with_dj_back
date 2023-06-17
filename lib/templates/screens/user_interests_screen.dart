// import 'package:flutter/material.dart';
// class UserInterestsScreen extends StatefulWidget {
//   @override
//   _UserInterestsScreenState createState() => _UserInterestsScreenState();
//   static const routeName = '/user-interests';
// }
// class _UserInterestsScreenState extends State<UserInterestsScreen> {
//   List<String> interests = [
//     'Cooking',
//     'Sports',
//     'Traveling',
//     'Music',
//     'Art',
//     'Reading',
//     'Writing',
//     'Gardening',
//     'Fashion',
//     'Dancing',
//   ];
//   List<String> hobbies = [
//     'Video games',
//     'Watching TV',
//     'Playing sports',
//     'Photography',
//     'Baking',
//     'Watching movies',
//     'Painting',
//     'Gardening',
//     'Collecting',
//     'Listening to music',
//   ];
//   List<String> selectedInterests = [];
//   List<String> selectedHobbies = [];
//   void handleInterestSelect(String interest) {
//     setState(() {
//       if (_userProvider.userInterestsScreenViewModelSelectedInterests.contains(interest)) {
//         _userProvider.userInterestsScreenViewModelSelectedInterests.remove(interest);
//       } else {
//         _userProvider.userInterestsScreenViewModelSelectedInterests.add(interest);
//       }
//     });
//   }
//   void handleHobbySelect(String hobby) {
//     setState(() {
//       if (_userProvider.userInterestsScreenViewModelSelectedHobbies.contains(hobby)) {
//         _userProvider.userInterestsScreenViewModelSelectedHobbies.remove(hobby);
//       } else {
//         _userProvider.userInterestsScreenViewModelSelectedHobbies.add(hobby);
//       }
//     });
//   }
//   void handleNextButtonPress() {
//     // This is where you would navigate to the next page and pass
//     // the selected interests and hobbies to it, in order to display
//     // information on the types of books the user might like.
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Your Interests'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Choose your interests:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: interests
//                   .map((interest) => FilterChip(
//                         label: Text(interest),
//                         selected: _userProvider.userInterestsScreenViewModelSelectedInterests.contains(interest),
//                         onSelected: (selected) {
//                           handleInterestSelect(interest);
//                         },
//                       ))
//                   .toList(),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Choose your hobbies:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: hobbies
//                   .map((hobby) => FilterChip(
//                         label: Text(hobby),
//                         selected: _userProvider.userInterestsScreenViewModelSelectedHobbies.contains(hobby),
//                         onSelected: (selected) {
//                           handleHobbySelect(hobby);
//                         },
//                       ))
//                   .toList(),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed:
//                   _userProvider.userInterestsScreenViewModelSelectedInterests.isNotEmpty && _userProvider.userInterestsScreenViewModelSelectedHobbies.isNotEmpty
//                       ? handleNextButtonPress
//                       : null,
//               child: Text('Next'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/models/session.dart';
import 'package:share_learning/view_models/providers/session_provider.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:share_learning/templates/managers/values_manager.dart';
import 'package:share_learning/templates/screens/home_screen_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../view_models/providers/user_provider.dart';
import '../utils/alert_helper.dart';

class UserInterestsScreen extends StatefulWidget {
  @override
  _UserInterestsScreenState createState() => _UserInterestsScreenState();

  static const routeName = '/user-interests';
}

class _UserInterestsScreenState extends State<UserInterestsScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider _userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Interests'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose your interests:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _userProvider.userInterestsScreenViewModelInterests
                    .map((interest) => FilterChip(
                          label: Text(interest),
                          selected: _userProvider
                              .userInterestsScreenViewModelSelectedInterests
                              .contains(interest),
                          onSelected: (selected) {
                            _userProvider
                                .userInterestsScreenViewModelHandleInterestSelect(
                                    interest);
                          },
                          // backgroundColor: Theme.of(context).primaryColor,
                          // selectedColor: Colors.white,
                          // checkmarkColor: Theme.of(context).primaryColor,
                          // labelStyle: TextStyle(
                          //   color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          // ),

                          selectedColor: ColorManager.primary,
                          selectedShadowColor: ColorManager.grey,

                          checkmarkColor: ColorManager.white,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Choose your hobbies:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _userProvider.userInterestsScreenViewModelHobbies
                    .map((hobby) => FilterChip(
                          label: Text(hobby),
                          selected: _userProvider
                              .userInterestsScreenViewModelSelectedHobbies
                              .contains(hobby),
                          onSelected: (selected) {
                            _userProvider
                                .userInterestsScreenViewModelHandleHobbySelect(
                                    hobby);
                          },
                          // backgroundColor: Theme.of(context).primaryColor,
                          // backgroundColor: ColorManager.grey,
                          // selectedColor: Colors.white,
                          selectedColor: ColorManager.primary,
                          // checkmarkColor: Theme.of(context).primaryColor,
                          checkmarkColor: ColorManager.white,
                          labelStyle: TextStyle(
                            // color: Colors.white,
                            // color: ColorManager.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                icon: _userProvider.userInterestsScreenViewModelIsLoading
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
                onPressed: _userProvider
                            .userInterestsScreenViewModelSelectedInterests
                            .isNotEmpty &&
                        _userProvider
                            .userInterestsScreenViewModelSelectedHobbies
                            .isNotEmpty
                    ? () => _userProvider
                        .userInterestsScreenViewModelHandleNextButtonPress(
                            context, mounted)
                    // ? () async {
                    //     if (await _handleNextButtonPress() == true) {
                    //       print('success');
                    //       Navigator.of(context).pushNamed(
                    //         HomeScreen.routeName,
                    //       );
                    //     }
                    //   }
                    : null,
                label: Text(
                  'Next',
                  style: getBoldStyle(color: ColorManager.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
