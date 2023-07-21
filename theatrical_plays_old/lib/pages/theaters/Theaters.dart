import 'package:flutter/material.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/using/MyColors.dart';
import 'package:theatrical_plays/using/SearchWidget.dart';

import 'CompareTheaters.dart';
import 'TheaterInfo.dart';

// ignore: must_be_immutable
class Theaters extends StatefulWidget {
  List<Theater> theaters = [];
  Theaters(this.theaters);
  @override
  _TheatersState createState() => _TheatersState(theaters: theaters);
}

class _TheatersState extends State<Theaters> {
  List<Theater> theaters = [];
  _TheatersState({this.theaters});
  String query = '';
  List<Theater> theatersToSearch = [];
  List<Theater> selectedTheaters = [];
  void initState() {
    theatersToSearch = List.from(theaters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().black,
      body: Container(
        child: Column(
          children: [
            SearchWidget(
                text: query,
                hintText: 'Theater name',
                onChanged: searchTheaters),
            Expanded(
              child: ListView.builder(
                  itemCount: theaters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            //open the tapped item
                            MaterialPageRoute(
                                builder: (context) =>
                                    TheaterInfo(theaters[index].id)));
                      },
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              'https://thumbs.dreamstime.com/z/location-pin-icon-165980583.jpg'),
                        ),
                      ),
                      title: Text(
                        theaters[index].title,
                        style: TextStyle(color: MyColors().cyan),
                      ),
                      subtitle: Text(
                        theaters[index].address,
                        style: TextStyle(color: MyColors().white),
                      ),
                      trailing: theaters[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: MyColors().cyan,
                            )
                          : Icon(
                              Icons.check_circle_outline,
                              color: MyColors().gray,
                            ),
                      onLongPress: () {
                        setState(() {
                          theaters[index].isSelected =
                              !theaters[index].isSelected;
                          print("Clicked");
                          if (theaters[index].isSelected == true) {
                            selectedTheaters.add(theaters[index]);
                          } else if (theaters[index].isSelected == false) {
                            selectedTheaters.removeWhere(
                                (element) => element.id == theaters[index].id);
                          }
                        });
                      },
                    );
                  }),
            ),
            selectedTheaters.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors()
                                    .gray, // Set the background color of the button
                              ),
                              child: Text(
                                "Compare (${selectedTheaters.length})",
                                style: TextStyle(
                                    color: MyColors().cyan, fontSize: 18),
                              ),
                              onPressed: () {
                                // print("Compare Click");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompareTheaters(selectedTheaters)));
                              },
                            )),
                        SizedBox(
                            width: double.infinity,
                            // ignore: deprecated_member_use
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColors()
                                    .gray, // Set the background color of the button
                              ),
                              child: Text(
                                "Clear",
                                style: TextStyle(
                                    color: MyColors().cyan, fontSize: 18),
                              ),
                              onPressed: () {
                                setState(() {
                                  List<Theater> removeList = [];
                                  selectedTheaters.forEach((item) {
                                    removeList.add(item);
                                  });
                                  removeList.forEach((removeItem) {
                                    for (var theater in theaters) {
                                      if (theater.id == removeItem.id) {
                                        theater.isSelected =
                                            !theater.isSelected;
                                      }
                                    }
                                  });
                                  selectedTheaters.clear();
                                });
                              },
                            ))
                      ],
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  Future searchTheaters(String query) async {
    final search = theatersToSearch.where((theater) {
      final searchActors = theater.title.toLowerCase();
      final searchLower = query.toLowerCase();

      return searchActors.contains(searchLower);
    }).toList();
    if (query.isEmpty) {
      setState(() {
        this.query = "";
        this.theaters = theatersToSearch;
      });
    } else {
      setState(() {
        this.query = query;
        this.theaters = search;
      });
    }
  }
}
