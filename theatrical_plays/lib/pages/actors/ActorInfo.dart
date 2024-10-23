import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Actor.dart';
import 'package:theatrical_plays/pages/actors/BodyProfileWidget.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';
import 'package:theatrical_plays/using/MyColors.dart';
import 'package:theatrical_plays/pages/actors/ProfileWidget.dart';

// ignore: must_be_immutable
// class ActorInfo extends StatefulWidget {
//   int actorId;
//   ActorInfo(this.actorId);
//   @override
//   _ActorInfoState createState() => _ActorInfoState(actorId: actorId);
// }
//
// class _ActorInfoState extends State<ActorInfo> {
//   int actorId;
//   Actor actor;
//   _ActorInfoState({this.actorId});
//
//   // method for load the actor with the id
//   // ignore: missing_return
//   Future<Actor> loadActor() async {
//     try {
//       Uri uri =
//           Uri.parse("http://${Constants().hostName}:8080/api/people/$actorId");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization":
//             "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//       if (jsonData['data']['image'] == null ||
//           jsonData['data']['image'] == '') {
//         jsonData['data']['image'] =
//             'http://www.macunepimedium.com/wp-content/uploads/2019/04/male-icon.jpg';
//       }
//       return actor = new Actor(jsonData['data']['image'],
//           jsonData['data']['id'], jsonData['data']['fullName']);
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           // ignore: deprecated_member_use
//           brightness: Brightness.dark,
//           title: Text(
//             'Actor Info',
//             style: TextStyle(color: MyColors().cyan),
//           ),
//           backgroundColor: MyColors().black,
//         ),
//         backgroundColor: MyColors().black,
//         //call the method to load actor and show
//         body: FutureBuilder(
//             future: loadActor(),
//             builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
//               if (!snapshot.hasData) {
//                 return Loading();
//               } else if (snapshot.hasError) {
//                 return Text("error loading");
//               } else {
//                 return ListView(
//                   physics: BouncingScrollPhysics(),
//                   children: [
//                     ProfileWidget(
//                         imagePath: actor.image, actorName: actor.fullName),
//                     Center(
//                         child: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
//                       child: Text('Biography',
//                           style:
//                               TextStyle(color: MyColors().cyan, fontSize: 18)),
//                     )),
//                     Container(
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
//                         child: Text(
//                           "${actor.fullName} γεννήθηκε το 1959 στην Ορεστιάδα. " +
//                               "Σπούδασε Πολιτικές Επιστήμες στο Πάντειο Πανεπιστήμιο (χωρίς όμως να αποφοιτήσει) και στη Σχολή Κινηματογράφου και Τηλεόρασης του Λυκούργου Σταυράκου. Πριν ασχοληθεί με τη συγγραφή ήθελε να γίνει αθλητικογράφος.",
//                           style: TextStyle(color: Colors.white, fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     Divider(color: MyColors().gray),
//                     Center(
//                         child: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
//                       child: Text('Relateded Productions',
//                           style:
//                               TextStyle(color: MyColors().cyan, fontSize: 18)),
//                     )),
//                     BodyProfileWidget(actor.id)
//                   ],
//                 );
//               }
//             }));
//   }
// }
class ActorInfo extends StatefulWidget {
  final int actorId;
  ActorInfo(this.actorId);

  @override
  _ActorInfoState createState() => _ActorInfoState(actorId: actorId);
}

class _ActorInfoState extends State<ActorInfo> {
  final int actorId;
  Actor? actor;

  _ActorInfoState({required this.actorId});

  // method for loading the actor with the id
  Future<Actor?> loadActor() async {
    try {
      Uri uri =
      Uri.parse("http://${Constants().hostName}:8080/api/people/$actorId");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
        "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      var jsonData = jsonDecode(data.body);

      // Assign default image if null or empty
      if (jsonData['data']['image'] == null || jsonData['data']['image'] == '') {
        jsonData['data']['image'] =
        'http://www.macunepimedium.com/wp-content/uploads/2019/04/male-icon.jpg';
      }

      actor = Actor(jsonData['data']['image'], jsonData['data']['id'], jsonData['data']['fullName']);
      return actor;
    } on Exception {
      print('Error fetching actor data');
      return null; // Return null in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // brightness: Brightness.dark,
          title: Text(
            'Actor Info',
            style: TextStyle(color: MyColors().cyan),
          ),
          backgroundColor: MyColors().black,
        ),
        backgroundColor: MyColors().black,
        body: FutureBuilder<Actor?>(
            future: loadActor(),
            builder: (BuildContext context, AsyncSnapshot<Actor?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading(); // Show loading while fetching data
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading data"));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text("No actor data found"));
              } else {
                Actor actorData = snapshot.data!;
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ProfileWidget(
                        imagePath: actorData.image, actorName: actorData.fullName),
                    Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                          child: Text('Biography',
                              style: TextStyle(color: MyColors().cyan, fontSize: 18)),
                        )),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                        child: Text(
                          "${actorData.fullName} γεννήθηκε το 1959 στην Ορεστιάδα. " +
                              "Σπούδασε Πολιτικές Επιστήμες στο Πάντειο Πανεπιστήμιο (χωρίς όμως να αποφοιτήσει) και στη Σχολή Κινηματογράφου και Τηλεόρασης του Λυκούργου Σταυράκου. Πριν ασχοληθεί με τη συγγραφή ήθελε να γίνει αθλητικογράφος.",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    Divider(color: MyColors().gray),
                    Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                          child: Text('Related Productions',
                              style: TextStyle(color: MyColors().cyan, fontSize: 18)),
                        )),
                    BodyProfileWidget(actorData.id)
                  ],
                );
              }
            }));
  }
}
