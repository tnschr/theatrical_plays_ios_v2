import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:theatrical_plays/models/ChartTheater.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';
import 'package:theatrical_plays/using/MyColors.dart';

// ignore: must_be_immutable
class CompareTheaters extends StatefulWidget {
  List<Theater> selectedTheaters = [];
  CompareTheaters(this.selectedTheaters);
  @override
  State<CompareTheaters> createState() =>
      _CompareTheatersState(selectedTheaters: selectedTheaters);
}

class _CompareTheatersState extends State<CompareTheaters> {
  List<Theater> selectedTheaters = [];
  _CompareTheatersState({this.selectedTheaters});

  List<ChartTheater> chartTheaters = [];
  ChartTheater chartTheater;

  // ignore: missing_return
  Future<List<ChartTheater>> loadChartTheaters() async {
    var theaterId;
    try {
      for (var item in selectedTheaters) {
        theaterId = item.id;
        print(item.id);
        Uri uri = Uri.parse(
            "http://${Constants().hostName}:8080/api/venues/$theaterId/productions");
        Response data = await get(uri, headers: {
          "Accept": "application/json",
          "authorization":
              "${await AuthorizationStore.getStoreValue("authorization")}"
        });
        var jsonData = jsonDecode(data.body);

        if (jsonData['data']['content'] == null) {
          print("Null data");
          break;
        } else {
          print(jsonData['data']['totalElements']);
          chartTheater = new ChartTheater(
              item.id, item.title, jsonData['data']['totalElements']);
          chartTheaters.add(chartTheater);
        }
      }
      return chartTheaters;
    } on Exception {
      print('error data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            future: loadChartTheaters(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ChartTheater>> snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("error loading");
              } else {
                return chartBuilder();
              }
            }));
  }

  Widget chartBuilder() {
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        brightness: Brightness.dark,
        title: Text(
          'Theater views',
          style: TextStyle(color: MyColors().cyan),
        ),
        backgroundColor: MyColors().black,
      ),
      backgroundColor: MyColors().black,
      body: SfCircularChart(
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(color: MyColors().white)),
        series: <CircularSeries>[
          PieSeries<ChartTheater, String>(
              dataSource: chartTheaters,
              xValueMapper: (ChartTheater theater, _) => theater.title,
              yValueMapper: (ChartTheater theater, _) => theater.eventsNumber,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(color: MyColors().white)))
        ],
      ),
    );
  }
}
