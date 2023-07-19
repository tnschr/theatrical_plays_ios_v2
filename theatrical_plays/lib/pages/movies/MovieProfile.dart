import 'package:flutter/material.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/using/MyColors.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class MovieProfile extends StatefulWidget {
  Movie movie;
  MovieProfile(this.movie);
  @override
  _MovieProfile createState() => _MovieProfile(movie: movie);
}

class _MovieProfile extends State<MovieProfile> {
  Movie movie;
  _MovieProfile({required this.movie});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildImage(),
      Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text(
            movie.title,
            style: TextStyle(color: MyColors().cyan, fontSize: 20),
          ),
        ),
      ),
      Divider(color: MyColors().gray),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 0, 15),
        child: Text('Description',
            style: TextStyle(color: MyColors().cyan, fontSize: 20)),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
        child: Text(
          movie.description,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      Divider(color: MyColors().gray),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          movie.duration.isNotEmpty
              ? RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Duration: ",
                        style: TextStyle(color: MyColors().cyan, fontSize: 18)),
                    TextSpan(
                        text: movie.duration,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ]),
                )
              : Container(),
          movie.producer.isNotEmpty
              ? RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Producer: ",
                        style: TextStyle(color: MyColors().cyan, fontSize: 18)),
                    TextSpan(
                        text: movie.producer.trim(),
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ]),
                )
              : Container()
        ]),
      ),
      FloatingActionButton.extended(
        label: Text('Trailer',
            style: TextStyle(color: MyColors().cyan, fontSize: 18)), // <-- Text
        backgroundColor: MyColors().gray,
        onPressed: () {
          _launchURL(movie.title);
        },
      ),
    ]);
  }

  Widget buildImage() {
    // ignore: unused_local_variable
    final image =
        NetworkImage("https://thumbs.dreamstime.com/z/print-178440812.jpg");

    return FadeInImage(
      placeholder: NetworkImage(
          'https://www.creativefabrica.com/wp-content/uploads/2021/01/14/theater-mask-actor-logo-vector-Graphics-7777527-1-1-580x387.jpg'),
      image: NetworkImage(movie.mediaUrl),
      width: 200, // set the desired width
      height: 200, // set the desired height
    );
  }

  _launchURL(String query) async {
    final url = 'https://www.youtube.com/results?search_query=$query';
    // ignore: deprecated_member_use, unnecessary_null_comparison
    if (await canLaunch(url) != null) {
      // ignore: deprecated_member_use
      launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
