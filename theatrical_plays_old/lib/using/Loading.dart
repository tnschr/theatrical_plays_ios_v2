import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:theatrical_plays/using/MyColors.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().black,
      body: Center(
        child: SpinKitWave(
          color: MyColors().cyan,
          size: 40.0,
        ),
      ),
    );
  }
}
