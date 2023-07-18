import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/pages/movies/MovieInfo.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/MyColors.dart';

class TheaterMovieSection extends StatefulWidget {
  final int theaterId;
  TheaterMovieSection(this.theaterId);
  @override
  State<TheaterMovieSection> createState() =>
      _TheaterMovieSectionState(theaterId);
}

class _TheaterMovieSectionState extends State<TheaterMovieSection> {
  int theaterId;
  List<Movie> relatedMovies = [];
  _TheaterMovieSectionState(this.theaterId);

  // ignore: missing_return
  Future<List<Movie>> loadRelatedMovies() async {
    try {
      Uri uri = Uri.parse(
          "http://${Constants().hostName}:8080/api/venues/$theaterId/productions");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
            "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      var jsonData = jsonDecode(data.body);

      for (var oldRelatedMovie in jsonData['data']['content']) {
        if (oldRelatedMovie['mediauURL'] == null ||
            oldRelatedMovie['mediauURL'] == '') {
          oldRelatedMovie['mediauURL'] =
              'https://thumbs.dreamstime.com/z/print-178440812.jpg';
        }
        Movie relatedMovie = new Movie(
            oldRelatedMovie['id'],
            oldRelatedMovie['title'],
            oldRelatedMovie['url'],
            oldRelatedMovie['producer'],
            oldRelatedMovie['mediaURL'],
            oldRelatedMovie['duration'],
            oldRelatedMovie['description'],
            false);
        relatedMovies.add(relatedMovie);
      }
      return relatedMovies;
    } on Exception {
      print('error data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // call method for load the relative production with the actor id and show at the body of page
        future: loadRelatedMovies(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                  child: Text(
                'There is no availiable actors',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              )),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("error loading",
                  style: TextStyle(color: MyColors().cyan, fontSize: 22)),
            );
          } else {
            return Center(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: relatedMovies.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MovieInfo(relatedMovies[index].id)));
                        },
                        leading: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage(relatedMovies[index].mediaUrl),
                          ),
                        ),
                        title: Text(
                          relatedMovies[index].title,
                          style: TextStyle(color: MyColors().cyan),
                        ),
                      );
                    }));
          }
        });
  }
}
