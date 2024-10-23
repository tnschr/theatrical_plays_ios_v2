import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/pages/movies/MovieProfile.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';
import 'package:theatrical_plays/using/MyColors.dart';

import 'MoviePeopleSection.dart';

// ignore: must_be_immutable
// class MovieInfo extends StatefulWidget {
//   final int movieId;
//   MovieInfo(this.movieId);
//   @override
//   State<MovieInfo> createState() => _MovieInfoState(movieId: movieId);
// }
//
// class _MovieInfoState extends State<MovieInfo> {
//   int movieId;
//   Movie movie;
//   _MovieInfoState({this.movieId});
//
//   // method for load the actor with the id
//   // ignore: missing_return
//   Future<Movie> loadMovie() async {
//     try {
//       Uri uri = Uri.parse(
//           "http://${Constants().hostName}:8080/api/productions/$movieId");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization":
//             "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//       if (jsonData['data']['mediaURL'] == "") {
//         jsonData['data']['mediaURL'] = "Not found";
//       }
//       return movie = new Movie(
//           jsonData['data']['id'],
//           jsonData['data']['title'],
//           jsonData['data']['url'],
//           jsonData['data']['producer'],
//           jsonData['data']['mediaURL'],
//           jsonData['data']['duration'],
//           jsonData['data']['description'],
//           false);
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
//             'Movie Info',
//             style: TextStyle(color: MyColors().cyan),
//           ),
//           backgroundColor: MyColors().black,
//         ),
//         backgroundColor: MyColors().black,
//         //call the method to load actor and show
//         body: FutureBuilder(
//             future: loadMovie(),
//             builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
//               if (!snapshot.hasData) {
//                 return Loading();
//               } else if (snapshot.hasError) {
//                 return Text("error loading",
//                     style: TextStyle(color: MyColors().cyan));
//               } else {
//                 return ListView(
//                   physics: BouncingScrollPhysics(),
//                   children: [
//                     MovieProfile(movie),
//                     Divider(color: MyColors().gray),
//                     Center(
//                         child: Padding(
//                       padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
//                       child: Text('Relateded Actors',
//                           style:
//                               TextStyle(color: MyColors().cyan, fontSize: 20)),
//                     )),
//                     MoviePeopleSection(movie.id),
//                   ],
//                 );
//               }
//             }));
//   }
// }
class MovieInfo extends StatefulWidget {
  final int movieId;
  MovieInfo(this.movieId);

  @override
  State<MovieInfo> createState() => _MovieInfoState(movieId: movieId);
}

class _MovieInfoState extends State<MovieInfo> {
  final int movieId;
  Movie? movie; // Movie is nullable until it's loaded

  _MovieInfoState({required this.movieId});

  // Method to load the movie by its ID
  Future<Movie?> loadMovie() async {
    try {
      Uri uri = Uri.parse(
          "http://${Constants().hostName}:8080/api/productions/$movieId");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
        "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      var jsonData = jsonDecode(data.body);
      if (jsonData['data']['mediaURL'] == "") {
        jsonData['data']['mediaURL'] = "Not found";
      }

      // movie = Movie(
      //   jsonData['data']['id'] ?? 0,
      //   jsonData['data']['title'] ?? 'Unknown Title', // Provide fallback for null title
      //   jsonData['data']['url'],
      //   jsonData['data']['producer'] ?? 'Unknown Producer', // Fallback for producer
      //   jsonData['data']['mediaURL'],
      //   jsonData['data']['duration'],
      //   jsonData['data']['description'] ?? 'No description available', // Fallback for description
      //   false, // Default value for isSelected
      // );
      movie = Movie(
       id:  jsonData['data']['id'] ?? 0, // Fallback for id, assuming 0 as a default if null
       title:  jsonData['data']['title'] ?? 'Unknown Title', // Fallback for null title
      ticketUrl:   jsonData['data']['url'] ?? '', // Fallback for url, assuming empty string if null
      producer:   jsonData['data']['producer'] ?? 'Unknown Producer', // Fallback for producer
      mediaUrl:   jsonData['data']['mediaURL'] ?? 'No media URL available', // Fallback for media URL
      duration:   jsonData['data']['duration'] ?? 'Unknown Duration', // Fallback for duration
       description:  jsonData['data']['description'] ?? 'No description available', // Fallback for description
       isSelected:  false, // Default value for isSelected
      );


      return movie;
    } catch (e) {
      print('Error loading movie: $e');
      return null; // Return null in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Movie Info',
            style: TextStyle(color: MyColors().cyan),
          ),
          backgroundColor: MyColors().black, systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        backgroundColor: MyColors().black,
        // Call the method to load the movie and show it
        body: FutureBuilder<Movie?>(
            future: loadMovie(),
            builder: (BuildContext context, AsyncSnapshot<Movie?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading(); // Show loading while waiting for data
              } else if (snapshot.hasError) {
                return Text(
                  "Error loading movie",
                  style: TextStyle(color: MyColors().cyan),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text(
                  "No movie data available",
                  style: TextStyle(color: MyColors().cyan),
                );
              } else {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    MovieProfile(movie:snapshot.data!, ), // Pass the movie data
                    Divider(color: MyColors().gray),
                    Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                          child: Text('Related Actors',
                              style: TextStyle(color: MyColors().cyan, fontSize: 20)),
                        )),
                    MoviePeopleSection(snapshot.data!.id), // Movie ID is used for related actors
                  ],
                );
              }
            }));
  }
}
