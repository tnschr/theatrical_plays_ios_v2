import 'dart:convert';

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
          Uri.parse("http://${Constants().hostName}:8080/api/productions");
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
  }

  // ignore: missing_return
  Future<List<Actor>> loadHomeActors() async {
    // loadHomeMovies();
    // loadHomeTheaters();
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/people");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
            "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);

        int counter = 0;
        for (var oldActor in jsonData['data']['content']) {
          if (oldActor['image'] != '' && oldActor['image'] != null) {
            if (counter < 6 && oldActor['id'] != 1908) {
              Actor actor = new Actor(
                  oldActor['image'], oldActor['id'], oldActor['fullName']);
              if (RegExp(
                      r"^\s*([A-Za-zα-ωΑ-Ω]{1,}([\.,] |[-']| ))+[A-Za-zΑ-Ωα-ω]+\.?\s*$")
                  .hasMatch(actor.fullName)) {
                actors.add(actor);
                counter++;
              }
            }
          }
        }
        print("actors: " + actors[0].fullName);
        return actors;
      } else {
        print("Api status code error");
      }
    } on Exception catch (e) {
      print('error data: $e');
    }
    throw '';
  }

  // ignore: missing_return
  Future<List<Theater>> loadHomeTheaters() async {
    Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
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
