import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:theatrical_plays/models/ChartCompMovie.dart';
import 'package:theatrical_plays/models/CompMovie.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';
import 'package:theatrical_plays/using/MyColors.dart';

// ignore: must_be_immutable
class CompareMovies extends StatefulWidget {
  List<Movie> selectedMovies = [];
  CompareMovies(this.selectedMovies);
  @override
  State<CompareMovies> createState() =>
      _CompareMoviesState(selectedMovies: this.selectedMovies);
}

class _CompareMoviesState extends State<CompareMovies> {
  List<Movie>? selectedMovies = [];
  _CompareMoviesState({this.selectedMovies});

  List<CompMovie?> compareMovies = [];
  CompMovie? compareMovie;

  List<ChartCompMovie> chartMovies = [];
  // ignore: missing_return
  Future<List<CompMovie?>> loadCompareMovie() async {
    int? movieId;
    try {
      for (var item in selectedMovies!) {
        movieId = item.id;
        print(item.id);
        Uri uri = Uri.parse(
            "http://${Constants().hostName}:8080/api/productions/$movieId/events");
        Response data = await get(uri, headers: {
          "Accept": "application/json",
          "authorization":
              "${await AuthorizationStore.getStoreValue("authorization")}"
        });
        var jsonData = jsonDecode(data.body);

        if (jsonData['data'].toString() == '[]') {
          print("Null data");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(item.title! + " has no event."),
          ));
          break;
        } else {
          compareMovie = new CompMovie(
              item.id, item.title, jsonData['data'][0]['priceRange']);
          compareMovies.add(compareMovie);
        }
      }
      return compareMovies;
    } on Exception {
      print('error data');
    }
    throw '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: loadCompareMovie(),
            builder: (BuildContext context,
                AsyncSnapshot<List<CompMovie?>> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading");
              } else {
                if (snapshot.data!.isNotEmpty) {
                  castPrice(compareMovies);
                  return chartBuilder();
                } else {
                  Navigator.pop(context);
                  return Container();
                }
              }
            }));
  }

  Widget chartBuilder() {
    print(chartMovies[0].title);
    print(chartMovies[0].priceRange.toString());
    print(compareMovies[0]!.priceRange.toString());
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        title: Text(
          'Ticket prices',
          style: TextStyle(color: MyColors().cyan),
        ),
        backgroundColor: MyColors().black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: MyColors().black,
      body: Container(
        child: SfCartesianChart(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
            series: <ChartSeries>[
              ColumnSeries<ChartCompMovie, String>(
                  dataSource: chartMovies,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  pointColorMapper: (ChartCompMovie movie, _) =>
                      movie.columnColor,
                  xValueMapper: (ChartCompMovie movie, _) => movie.title,
                  yValueMapper: (ChartCompMovie movie, _) => movie.priceRange)
            ],
            tooltipBehavior: TooltipBehavior(
                enable: true, header: 'Movie', format: 'point.x: point.y€'),
            primaryXAxis: CategoryAxis(
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0),
                maximumLabelWidth: 90.0,
                labelIntersectAction: AxisLabelIntersectAction.wrap),
            backgroundColor: MyColors().black),
      ),
    );
  }

  castPrice(List<CompMovie?> compareMovies) {
    var doubleRE = RegExp(r"-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?");
    var clearPrice;
    var colors = [Colors.red, Colors.teal, Colors.orange, Colors.brown];
    var colorCounter = 0;
    print("Clear price values");
    for (var item in compareMovies) {
      //clear the number values from priceRenge
      item!.priceRange = item.priceRange!.replaceAll(',', '.');
      var numbers = doubleRE
          .allMatches(item.priceRange!)
          .map((m) => double.parse(m[0]!))
          .toList();
      if (numbers.isNotEmpty) {
        clearPrice = numbers.reduce(max);
      } else {
        clearPrice = 12.0;
      }
      if (clearPrice == null) {
        clearPrice = 11.0;
      }

      ChartCompMovie chartCompMovie = new ChartCompMovie(
          item.id, item.title, clearPrice, item.title, colors[colorCounter]);
      chartMovies.add(chartCompMovie);
      colorCounter += 1;
    }
  }
}
