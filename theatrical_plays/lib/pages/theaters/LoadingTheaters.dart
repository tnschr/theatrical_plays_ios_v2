import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';

import 'Theaters.dart';

// class LoadingTheaters extends StatefulWidget {
//   @override
//   _LoadingTheatersState createState() => _LoadingTheatersState();
// }
//
// class _LoadingTheatersState extends State<LoadingTheaters> {
//   List<Theater> theaters = [];
//
//   //fetch data from the api
//   // ignore: missing_return
//   Future<List<Theater>> loadTheaters(String query) async {
//     Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
//     Response data = await get(uri, headers: {
//       "Accept": "application/json",
//       "authorization":
//           "${await AuthorizationStore.getStoreValue("authorization")}"
//     });
//     var jsonData = jsonDecode(data.body);
//
//     try {
//       for (var oldTheater in jsonData['data']['content']) {
//         Theater theater = new Theater(oldTheater['id'], oldTheater['title'],
//             oldTheater['address'], false);
//
//         theaters.add(theater);
//       }
//       return theaters.where((theater) {
//         final movietitleToLowerCase = theater.title.toLowerCase();
//         final queryToLowerCase = query.toLowerCase();
//
//         return movietitleToLowerCase.contains(queryToLowerCase);
//       }).toList();
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//             future: loadTheaters(''),
//             builder:
//                 (BuildContext context, AsyncSnapshot<List<Theater>> snapshot) {
//               if (!snapshot.hasData) {
//                 return Loading();
//               } else if (snapshot.hasError) {
//                 return Text("error loading");
//               } else {
//                 return Theaters(theaters);
//               }
//             }));
//   }
// }
class LoadingTheaters extends StatefulWidget {
  @override
  _LoadingTheatersState createState() => _LoadingTheatersState();
}

class _LoadingTheatersState extends State<LoadingTheaters> {
  List<Theater> theaters = [];

  // Fetch data from the API
  Future<List<Theater>?> loadTheaters(String query) async {
    Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
    try {
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization": "${await AuthorizationStore.getStoreValue("authorization")}"
      });

      var jsonData = jsonDecode(data.body);

      theaters.clear(); // Clear theaters before loading new data
      for (var oldTheater in jsonData['data']['content']) {
        Theater theater = Theater(
          id: oldTheater['id'] ?? 0,
          title: oldTheater['title'] ?? 'Unknown Title',
          address: oldTheater['address'] ?? 'Unknown Address',
          isSelected: false,
        );

        theaters.add(theater);
      }

      return theaters.where((theater) {
        final theaterTitleToLowerCase = theater.title.toLowerCase();
        final queryToLowerCase = query.toLowerCase();
        return theaterTitleToLowerCase.contains(queryToLowerCase);
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return null; // Return null in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Theater>?>(
        future: loadTheaters(''),
        builder: (BuildContext context, AsyncSnapshot<List<Theater>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); // Display loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No theaters available"));
          } else {
            return Theaters(snapshot.data!); // Safely pass data to Theaters widget
          }
        },
      ),
    );
  }
}
