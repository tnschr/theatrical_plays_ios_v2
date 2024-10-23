import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/models/Production.dart';
import 'package:theatrical_plays/pages/movies/MovieInfo.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/MyColors.dart';
import 'package:theatrical_plays/using/SmallLoading.dart';

// class BodyProfileWidget extends StatefulWidget {
//   final int actorId;
//   BodyProfileWidget(this.actorId);
//
//   @override
//   _BodyProfileWidgetState createState() => _BodyProfileWidgetState(actorId);
// }
//
// class _BodyProfileWidgetState extends State<BodyProfileWidget> {
//   int actorId;
//   List<Production> productions = [];
//   List<Movie> movies = [];
//   _BodyProfileWidgetState(this.actorId);
//
//   // method for load the relative productions by actorId
//   // ignore: missing_return
//   Future<List<Production>> loadProductions() async {
//     try {
//       Uri uri = Uri.parse(
//           "http://${Constants().hostName}:8080/api/people/$actorId/productions");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization":
//             "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//
//       for (var oldProduction in jsonData['data']['content']) {
//         Production production = new Production(
//             oldProduction['role'],
//             oldProduction['productionId'],
//             oldProduction['title'],
//             oldProduction['ticketUrl'],
//             oldProduction['producer'],
//             oldProduction['mediaURL'],
//             oldProduction['duration'],
//             oldProduction['description']);
//
//         Movie movie = new Movie(
//             oldProduction['productionId'],
//             oldProduction['title'],
//             oldProduction['ticketUrl'],
//             oldProduction['producer'],
//             oldProduction['mediaURL'],
//             oldProduction['duration'],
//             oldProduction['description'],
//             false);
//
//         productions.add(production);
//         movies.add(movie);
//       }
//       return productions;
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         // call method for load the relative production with the actor id and show at the body of page
//         future: loadProductions(),
//         builder:
//             (BuildContext context, AsyncSnapshot<List<Production>> snapshot) {
//           if (!snapshot.hasData) {
//             return SmallLoading();
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("error loading",
//                   style: TextStyle(color: MyColors().cyan, fontSize: 22)),
//             );
//           } else {
//             return Center(
//                 child: ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: productions.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       MovieInfo(movies[index].id)));
//                         },
//                         leading: Padding(
//                           padding:
//                               const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
//                           child: CircleAvatar(
//                             radius: 30.0,
//                             backgroundImage:
//                                 NetworkImage(productions[index].mediaUrl),
//                           ),
//                         ),
//                         title: Text(
//                           productions[index].title +
//                               " - " +
//                               productions[index].role,
//                           style: TextStyle(color: MyColors().cyan),
//                         ),
//                       );
//                     }));
//           }
//         });
//   }
// }
class BodyProfileWidget extends StatefulWidget {
  final int actorId;
  BodyProfileWidget(this.actorId);

  @override
  _BodyProfileWidgetState createState() => _BodyProfileWidgetState(actorId);
}

class _BodyProfileWidgetState extends State<BodyProfileWidget> {
  final int actorId;
  List<Production> productions = [];
  List<Movie> movies = [];

  _BodyProfileWidgetState(this.actorId);

  // method to load the related productions by actorId
  Future<List<Production>> loadProductions() async {
    try {
      Uri uri = Uri.parse(
          "http://${Constants().hostName}:8080/api/people/$actorId/productions");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
        "${await AuthorizationStore.getStoreValue("authorization")}"
      });

      var jsonData = jsonDecode(data.body);

      // Iterate through the production data and add to lists
      for (var oldProduction in jsonData['data']['content']) {
        Production production = Production(
            oldProduction['role'] ?? '',
            oldProduction['productionId'] ?? 0,
            oldProduction['title'] ?? '',
            oldProduction['ticketUrl'] ?? '',
            oldProduction['producer'] ?? '',
            oldProduction['mediaURL'] ?? '',
            oldProduction['duration'] ?? '',
            oldProduction['description'] ?? '');

        // Movie movie = Movie(
        //     oldProduction['productionId'] ?? 0,
        //     oldProduction['title'] ?? '',
        //     oldProduction['ticketUrl'] ?? '',
        //     oldProduction['producer'] ?? '',
        //     oldProduction['mediaURL'] ?? '',
        //     oldProduction['duration'] ?? '',
        //     oldProduction['description'] ?? '',
        //     false);
        Movie movie = Movie(
          id: oldProduction['productionId'] ?? 0, // Provide fallback for id
          title: oldProduction['title'] ?? 'Unknown Title', // Provide fallback for title
          ticketUrl: oldProduction['ticketUrl'], // Nullable, no need for fallback
          producer: oldProduction['producer'] ?? 'Unknown Producer', // Provide fallback for producer
          mediaUrl: oldProduction['mediaURL'], // Nullable, no need for fallback
          duration: oldProduction['duration'], // Nullable, no need for fallback
          description: oldProduction['description'] ?? 'No description available', // Provide fallback for description
          isSelected: false, // Default value
        );

        productions.add(production);
        movies.add(movie);
      }
      return productions;
    } on Exception {
      print('Error fetching production data');
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Production>>(
      // Call method to load the related productions with the actor id and show them in the body of the page
        future: loadProductions(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Production>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SmallLoading(); // Show loading while fetching data
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading",
                  style: TextStyle(color: MyColors().cyan, fontSize: 22)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No productions available",
                  style: TextStyle(color: MyColors().cyan, fontSize: 22)),
            );
          } else {
            return Center(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: productions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MovieInfo(movies[index].id)));
                        },
                        leading: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                productions[index].mediaUrl ),
                          ),
                        ),
                        title: Text(
                          "${productions[index].title} - ${productions[index].role}",
                          style: TextStyle(color: MyColors().cyan),
                        ),
                      );
                    }));
          }
        });
  }
}
