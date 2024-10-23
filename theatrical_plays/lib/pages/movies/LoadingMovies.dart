import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/pages/movies/Movies.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';

// class LoadingMovies extends StatefulWidget {
//   @override
//   _LoadingMoviesState createState() => _LoadingMoviesState();
// }
//
// class _LoadingMoviesState extends State<LoadingMovies> {
//   List<Movie> movies = [];
//
// //fetch data from api
//   // ignore: missing_return
//   Future<List<Movie>> loadMovies() async {
//     Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/productions");
//     Response data = await get(uri, headers: {
//       "Accept": "application/json",
//       "authorization":
//           "${await AuthorizationStore.getStoreValue("authorization")}"
//     });
//     var jsonData = jsonDecode(data.body);
//
//     try {
//       for (var oldMovie in jsonData['data']['content']) {
//         if (oldMovie['mediaURL'] == null || oldMovie['mediaURL'] == '') {
//           oldMovie['mediaURL'] =
//               'https://thumbs.dreamstime.com/z/print-178440812.jpg';
//         }
//         Movie movie = new Movie(
//             oldMovie['id'],
//             oldMovie['title'],
//             oldMovie['ticketUrl'],
//             oldMovie['producer'],
//             oldMovie['mediaURL'],
//             oldMovie['duration'],
//             oldMovie['description'],
//             false);
//
//         movies.add(movie);
//       }
//       return movies;
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//             future: loadMovies(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
//               if (!snapshot.hasData) {
//                 return Loading();
//               } else if (snapshot.hasError) {
//                 return Text("error loading");
//               } else {
//                 return Movies(movies);
//               }
//             }));
//   }
// }
class LoadingMovies extends StatefulWidget {
  @override
  _LoadingMoviesState createState() => _LoadingMoviesState();
}

class _LoadingMoviesState extends State<LoadingMovies> {
  List<Movie> movies = [];

// Fetch data from API
  Future<List<Movie>> loadMovies() async {
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/productions");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
        "${await AuthorizationStore.getStoreValue("authorization")}"
      });

      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);

        for (var oldMovie in jsonData['data']['content']) {
          // Fallback for missing or empty mediaURL
          String mediaUrl = oldMovie['mediaURL'] ??
              'https://thumbs.dreamstime.com/z/print-178440812.jpg';

          Movie movie = Movie(
            id: oldMovie['id'],
            title: oldMovie['title'] ?? 'Unknown Title', // Fallback for title
            ticketUrl: oldMovie['ticketUrl'],
            producer: oldMovie['producer'] ?? 'Unknown Producer', // Fallback for producer
            mediaUrl: mediaUrl,
            duration: oldMovie['duration'],
            description: oldMovie['description'] ?? 'No description available', // Fallback for description
            isSelected: false, // Default value
          );

          movies.add(movie);
        }
        return movies;
      } else {
        print("API error: ${data.statusCode}");
        return []; // Return an empty list if there’s an error
      }
    } catch (e) {
      print('Error fetching data: $e');
      return []; // Return an empty list on exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Movie>>(
            future: loadMovies(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading(); // Show loading while data is being fetched
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading movies"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No movies available"));
              } else {
                return Movies(snapshot.data!); // Pass the fetched movies
              }
            }));
  }
}
