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
class MovieInfo extends StatefulWidget {
  final int? movieId;
  MovieInfo(this.movieId);
  @override
  State<MovieInfo> createState() => _MovieInfoState(movieId: movieId);
}

class _MovieInfoState extends State<MovieInfo> {
  int? movieId;
  Movie? movie;
  _MovieInfoState({this.movieId});

  // method for load the actor with the id
  // ignore: missing_return
  Future<Movie> loadMovie() async {
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
      return movie = new Movie(
          jsonData['data']['id'],
          jsonData['data']['title'],
          jsonData['data']['url'],
          jsonData['data']['producer'],
          jsonData['data']['mediaURL'],
          jsonData['data']['duration'],
          jsonData['data']['description'],
          false);
    } on Exception {
      print('error data');
    }
    throw '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ignore: deprecated_member_use
          title: Text(
            'Movie Info',
            style: TextStyle(color: MyColors().cyan),
          ),
          backgroundColor: MyColors().black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: MyColors().black,
        //call the method to load actor and show
        body: FutureBuilder(
            future: loadMovie(),
            builder: (BuildContext context, AsyncSnapshot<Movie> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading",
                    style: TextStyle(color: MyColors().cyan));
              } else {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    MovieProfile(movie),
                    Divider(color: MyColors().gray),
                    Center(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                      child: Text('Relateded Actors',
                          style:
                              TextStyle(color: MyColors().cyan, fontSize: 20)),
                    )),
                    MoviePeopleSection(movie!.id),
                  ],
                );
              }
            }));
  }
}
