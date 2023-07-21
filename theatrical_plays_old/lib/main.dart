import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:theatrical_plays/pages/home/LoginScreen.dart';
import 'package:theatrical_plays/using/MyColors.dart';

void main() {
  runApp(MaterialApp(
    home: AnimatedSplashScreen(
        splash: Container(
          child: Center(
            child: Column(
              children: [
                Text("Theatrical",
                    style: TextStyle(
                      color: MyColors().cyan,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                    )),
                Text(
                  "analytics",
                  style: TextStyle(
                    color: MyColors().cyan,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          ),
        ),
        duration: 3000,
        backgroundColor: MyColors().black,
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: LoginScreen()),
  ));
}
