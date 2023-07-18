import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/pages/theaters/TheaterMovieSection.dart';
import 'package:theatrical_plays/pages/theaters/TheaterProfile.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';
import 'package:theatrical_plays/using/MyColors.dart';

class TheaterInfo extends StatefulWidget {
  final int theaterId;
  TheaterInfo(this.theaterId);
  @override
  State<TheaterInfo> createState() => _TheaterInfoState(theaterId: theaterId);
}

class _TheaterInfoState extends State<TheaterInfo> {
  _TheaterInfoState({this.theaterId});
  int theaterId;
  Theater theater;

  // ignore: missing_return
  Future<Theater> loadTheater() async {
    try {
      Uri uri = Uri.parse(
          "http://${Constants().hostName}:8080/api/venues/$theaterId");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
            "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      var jsonData = jsonDecode(data.body);

      return theater = new Theater(jsonData['data']['id'],
          jsonData['data']['title'], jsonData['data']['address'], false);
    } on Exception {
      print('error data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // ignore: deprecated_member_use
          brightness: Brightness.dark,
          title: Text(
            'Theater Info',
            style: TextStyle(color: MyColors().cyan),
          ),
          backgroundColor: MyColors().black,
        ),
        backgroundColor: MyColors().black,
        //call the method to load actor and show
        body: FutureBuilder(
            future: loadTheater(),
            builder: (BuildContext context, AsyncSnapshot<Theater> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading",
                    style: TextStyle(color: MyColors().cyan));
              } else {
                return ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    TheaterProfile(theater: theater),
                    Divider(color: MyColors().gray),
                    Center(
                        child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                      child: Text('Related Movies',
                          style:
                              TextStyle(color: MyColors().cyan, fontSize: 20)),
                    )),
                    TheaterMovieSection(theaterId)
                  ],
                );
              }
            }));
  }
}
