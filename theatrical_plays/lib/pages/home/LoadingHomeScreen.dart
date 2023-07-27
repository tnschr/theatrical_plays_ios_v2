import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Actor.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/pages/home/HomeScreen.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';

class LoadingHomeScreen extends StatefulWidget {
  @override
  _LoadingHomeScreenState createState() => _LoadingHomeScreenState();
}

class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
  List<Movie> movies = [];
  List<Actor> actors = [];
  List<Theater> theaters = [];
  //load latest movies data from api
  // ignore: missing_return
  Future<List<Movie>> loadHomeMovies() async {
    loadHomeActors();
    loadHomeTheaters();
    try {
      Uri uri =
          Uri.parse("https://${Constants().hostName}:7042/api/productions");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
            "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      var jsonData = jsonDecode(data.body);

      int counter = 0;
      for (var oldMovie in jsonData['data']['content']) {
        if (oldMovie['mediaURL'] != "" && oldMovie['mediaURL'] != null) {
          Movie movie = new Movie(
              oldMovie['id'],
              oldMovie['title'],
              oldMovie['ticketUrl'],
              oldMovie['producer'],
              oldMovie['mediaURL'],
              oldMovie['duration'],
              oldMovie['description'],
              false);
          if (counter < 6) {
            movies.add(movie);
            counter++;
          }
        }
      }
      print("movies: " + movies[0].title!);
      return movies;
    } on Exception {
      print('error data');
    }
    return movies;
  }

  // ignore: missing_return
  // Future<List<Actor>> loadHomeActors() async {
  //   // loadHomeMovies();
  //   // loadHomeTheaters();
  //   try {
  //     final uri = Uri.parse("https://${Constants().hostName}:7042/api/people");

  //     // Create a custom HttpClient with the bad certificate callback to ignore self-signed certificates
  //     final httpClient = HttpClient()
  //       ..badCertificateCallback =
  //           (X509Certificate cert, String host, int port) => true;

  //     // Convert the HttpClient request to a http.Request object
  //     // ignore: close_sinks
  //     final request = await httpClient.getUrl(uri);

  //     // Add headers to the request
  //     request.headers["Accept"] = "application/json";
  //     request.headers["authorization"] =
  //         await AuthorizationStore.getStoreValue("authorization");

  //     final response = await http.get(uri, headers: headers);

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       final List<Actor> actors = [];

  //       for (var actorData in jsonData['data']['results']) {
  //         final actor = Actor(
  //           actorData['id'],
  //           actorData['fullname'],
  //         );
  //         actors.add(actor);
  //       }

  //       print("actors: ${actors[0].fullName}");
  //       return actors;
  //     } else {
  //       print("API status code error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print('error data: $e');
  //   }
  //   throw '';
  // }

  Future<List<Actor>> loadHomeActors() async {
    try {
      final uri = Uri.parse("https://${Constants().hostName}:7042/api/people");

      final headers = {
        "Accept": "application/json",
        "authorization":
            await AuthorizationStore.getStoreValue("authorization"),
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<Actor> actors = [];

        for (var actorData in jsonData['data']['results']) {
          final actor = Actor(
            actorData['id'],
            actorData['fullname'],
          );
          actors.add(actor);
        }

        print("actors: ${actors[0].fullName}");
        return actors;
      } else {
        print("API status code error: ${response.statusCode}");
      }
    } catch (e) {
      print('error data: $e');
    }
    throw '';
  }

  // ignore: missing_return
  Future<List<Theater>> loadHomeTheaters() async {
    Uri uri = Uri.parse("https://${Constants().hostName}:7042/api/venues");
    Response data = await get(uri, headers: {
      "Accept": "application/json",
      "authorization":
          "${await AuthorizationStore.getStoreValue("authorization")}"
    });
    var jsonData = jsonDecode(data.body);
    int counter = 0;
    try {
      for (var oldTheater in jsonData['data']['content']) {
        if (oldTheater['title'] != null &&
            oldTheater['address'] != null &&
            counter < 6) {
          Theater theater = new Theater(oldTheater['id'], oldTheater['title'],
              oldTheater['address'], false);

          theaters.add(theater);
          counter++;
        }
      }
      print("theaters: " + theaters[0].title!);
      return theaters;
    } on Exception {
      print('error data');
    }
    throw '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: loadHomeMovies(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading");
              } else {
                return HomeScreen(movies, actors, theaters);
              }
            }));
  }
}
