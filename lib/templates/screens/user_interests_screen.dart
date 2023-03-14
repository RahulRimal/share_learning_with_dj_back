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
//       if (selectedInterests.contains(interest)) {
//         selectedInterests.remove(interest);
//       } else {
//         selectedInterests.add(interest);
//       }
//     });
//   }

//   void handleHobbySelect(String hobby) {
//     setState(() {
//       if (selectedHobbies.contains(hobby)) {
//         selectedHobbies.remove(hobby);
//       } else {
//         selectedHobbies.add(hobby);
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
//                         selected: selectedInterests.contains(interest),
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
//                         selected: selectedHobbies.contains(hobby),
//                         onSelected: (selected) {
//                           handleHobbySelect(hobby);
//                         },
//                       ))
//                   .toList(),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed:
//                   selectedInterests.isNotEmpty && selectedHobbies.isNotEmpty
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

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_learning/models/api_status.dart';
import 'package:share_learning/providers/sessions.dart';
import 'package:share_learning/templates/managers/color_manager.dart';
import 'package:share_learning/templates/managers/style_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../providers/users.dart';
import 'home_screen.dart';

class UserInterestsScreen extends StatefulWidget {
  @override
  _UserInterestsScreenState createState() => _UserInterestsScreenState();

  static const routeName = '/user-interests';
}

class _UserInterestsScreenState extends State<UserInterestsScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<String> interests = [
    'Cooking',
    'Sports',
    'Traveling',
    'Music',
    'Art',
    'Reading',
    'Writing',
    'Gardening',
    'Fashion',
    'Dancing',
  ];

  List<String> hobbies = [
    'Video games',
    'Watching TV',
    'Playing sports',
    'Photography',
    'Baking',
    'Watching movies',
    'Painting',
    'Gardening',
    'Collecting',
    'Listening to music',
  ];

  List<String> selectedInterests = [];
  List<String> selectedHobbies = [];

  void handleInterestSelect(String interest) async {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  void handleHobbySelect(String hobby) {
    setState(() {
      if (selectedHobbies.contains(hobby)) {
        selectedHobbies.remove(hobby);
      } else {
        selectedHobbies.add(hobby);
      }
    });
  }

  // Future<bool> _handleNextButtonPress() {
  _handleNextButtonPress() async {
    Users users = Provider.of<Users>(context, listen: false);
    SharedPreferences prefs = await _prefs;

    Map<String, List<String>> userData = {
      'interests': selectedInterests,
      'hobbies': selectedHobbies,
    };

    userData.forEach((key, value) async {
      var response = await users.updateUserData(users.user!.id, key, value);
      // print(response);
      if (response is Success) {
        BotToast.showSimpleNotification(
          // title: (response as Map)['message'],
          title: response.response.toString(),
          duration: Duration(seconds: 3),
          backgroundColor: ColorManager.primary,
          titleStyle: getBoldStyle(color: ColorManager.white),
          align: Alignment(1, 1),
        );
        // return Future.value(true);
        prefs.setBool('isFirstTime', false);

        Navigator.of(context)
            .pushReplacementNamed(HomeScreen.routeName, arguments: {
          'authSession':
              Provider.of<SessionProvider>(context, listen: false).session,
        });
        // print('helo');
        // return true;
      }
      if (response is Failure) {
        BotToast.showSimpleNotification(
          // title: (response as Map)['message'],
          title: response.errorResponse.toString(),
          duration: Duration(seconds: 3),
          backgroundColor: ColorManager.primary,
          titleStyle: getBoldStyle(color: ColorManager.white),
          align: Alignment(1, 1),
        );
        // return Future.value(false);
      }
    });
    // return Future.value(false);
    // return false;

    // print(selectedInterests);
    // print(userData);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as Map;
    // final Session authenticatedSession = args['authSession'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Interests'),
      ),
      body: Padding(
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
              children: interests
                  .map((interest) => FilterChip(
                        label: Text(interest),
                        selected: selectedInterests.contains(interest),
                        onSelected: (selected) {
                          handleInterestSelect(interest);
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
              children: hobbies
                  .map((hobby) => FilterChip(
                        label: Text(hobby),
                        selected: selectedHobbies.contains(hobby),
                        onSelected: (selected) {
                          handleHobbySelect(hobby);
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
            ElevatedButton(
              onPressed:
                  selectedInterests.isNotEmpty && selectedHobbies.isNotEmpty
                      ? _handleNextButtonPress
                      // ? () async {
                      //     if (await _handleNextButtonPress() == true) {
                      //       print('success');
                      //       Navigator.of(context).pushNamed(
                      //         HomeScreen.routeName,
                      //       );
                      //     }
                      //   }
                      : null,
              child: Text(
                'Next',
                style: getBoldStyle(color: ColorManager.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
