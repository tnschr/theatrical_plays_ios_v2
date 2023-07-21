import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:theatrical_plays/pages/home/LoadingHomeScreen.dart';
import 'package:theatrical_plays/pages/home/LoginScreen.dart';
import 'package:theatrical_plays/pages/theaters/LoadingTheaters.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/MyColors.dart';

import 'actors/LoadingActors.dart';
import 'movies/LoadingMovies.dart';

class Home extends StatefulWidget {
  static _HomeState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeState>();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //sbake bottom nav bar options initiallization
  SnakeShape snakeShape = SnakeShape.indicator;
  int? _selectedItemPosition = 0;
  //bottom nav bar screens
  final List<Widget> screens = [
    LoadingHomeScreen(),
    LoadingActors(),
    LoadingMovies(),
    LoadingTheaters()
  ];

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //colors for letters in notification bar
      backgroundColor: Colors.white,
      //initiallize appbar options and colors
      appBar: AppBar(
        // ignore: deprecated_member_use
        title: Text(
          'Theatrical analytics',
          style: TextStyle(color: MyColors().cyan),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, color: MyColors().white),
              onPressed: () {
                logout();
              })
        ],
        backgroundColor: MyColors().black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      //bottom navigation bar size colors an snake shape
      bottomNavigationBar: SnakeNavigationBar.color(
        height: 60,
        backgroundColor: MyColors().black,
        snakeShape: snakeShape,
        snakeViewColor: MyColors().cyan,
        selectedItemColor: SnakeShape.indicator == SnakeShape.indicator
            ? MyColors().cyan
            : null,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _selectedItemPosition!,
        onTap: (index) {
          setState(() {
            _selectedItemPosition = index;
            controller.jumpToPage(index);
          });
        },
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Actors'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.movie_outlined), label: 'Movies'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.theaters_outlined), label: 'Theaters')
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
      body: PageView(
          controller: controller,
          children: screens,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              _selectedItemPosition = index;
            });
          }),
    );
  }

  void setBottomNav(page) {
    int? index;
    if (page == 'Actors') {
      index = 1;
    } else if (page == 'Movies') {
      index = 2;
    } else if (page == 'Theaters') {
      index = 3;
    }
    setState(() {
      _selectedItemPosition = index;
      controller.jumpToPage(index!);
    });
  }

  void logout() {
    AuthorizationStore.deleteAllValuesFromStore();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
