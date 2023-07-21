import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:theatrical_plays/using/MyColors.dart';

class SmallLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: MyColors().cyan,
      size: 40.0,
    );
  }
}
