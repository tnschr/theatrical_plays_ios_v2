import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Actor.dart';
import 'package:theatrical_plays/pages/actors/Actors.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';

class LoadingActors extends StatefulWidget {
  @override
  _LoadingActorsState createState() => _LoadingActorsState();
}

class _LoadingActorsState extends State<LoadingActors> {
  List<Actor> actors = [];
  //load actos data from api
  // ignore: missing_return
  Future<List<Actor>> loadActors() async {
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/people");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization":
            "${await AuthorizationStore.getStoreValue("authorization")}"
      });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);

        for (var oldActor in jsonData['data']['content']) {
          if (oldActor['image'] == null || oldActor['image'] == '') {
            oldActor['image'] =
                'http://www.macunepimedium.com/wp-content/uploads/2019/04/male-icon.jpg';
          }
          Actor actor = new Actor(
              oldActor['image'], oldActor['id'], oldActor['fullName']);
          if (RegExp(
                  r"^\s*([A-Za-zα-ωΑ-Ω]{1,}([\.,] |[-']| ))+[A-Za-zΑ-Ωα-ω]+\.?\s*$")
              .hasMatch(actor.fullName)) {
            actors.add(actor);
          }
        }

        return actors;
      } else {
        print("Api status code error");
      }
    } on Exception catch (e) {
      print('error data: $e');
    }
    throw '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            // call and show the actors
            future: loadActors(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading");
              } else {
                return Actors(actors);
              }
            }));
  }
}
