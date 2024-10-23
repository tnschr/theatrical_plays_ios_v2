import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/models/Actor.dart';
import 'package:theatrical_plays/models/Movie.dart';
import 'package:theatrical_plays/models/Theater.dart';
import 'package:theatrical_plays/pages/home/HomeScreen.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/Loading.dart';

// class LoadingHomeScreen extends StatefulWidget {
//   @override
//   _LoadingHomeScreenState createState() => _LoadingHomeScreenState();
// }
//
// class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
//   List<Movie> movies = [];
//   List<Actor> actors = [];
//   List<Theater> theaters = [];
//   //load latest movies data from api
//   // ignore: missing_return
//   Future<List<Movie>> loadHomeMovies() async {
//     loadHomeActors();
//     loadHomeTheaters();
//     try {
//       Uri uri =
//           Uri.parse("http://${Constants().hostName}:8080/api/productions");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization":
//             "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//
//       int counter = 0;
//       for (var oldMovie in jsonData['data']['content']) {
//         if (oldMovie['mediaURL'] != "" && oldMovie['mediaURL'] != null) {
//           Movie movie = new Movie(
//               oldMovie['id'],
//               oldMovie['title'],
//               oldMovie['ticketUrl'],
//               oldMovie['producer'],
//               oldMovie['mediaURL'],
//               oldMovie['duration'],
//               oldMovie['description'],
//               false);
//           if (counter < 6) {
//             movies.add(movie);
//             counter++;
//           }
//         }
//       }
//       print("movies: " + movies[0].title);
//       return movies;
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   // ignore: missing_return
//   Future<List<Actor>> loadHomeActors() async {
//     // loadHomeMovies();
//     // loadHomeTheaters();
//     try {
//       Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/people");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization":
//             "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       if (data.statusCode == 200) {
//         var jsonData = jsonDecode(data.body);
//
//         int counter = 0;
//         for (var oldActor in jsonData['data']['content']) {
//           if (oldActor['image'] != '' && oldActor['image'] != null) {
//             if (counter < 6 && oldActor['id'] != 1908) {
//               Actor actor = new Actor(
//                   oldActor['image'], oldActor['id'], oldActor['fullName']);
//               if (RegExp(
//                       r"^\s*([A-Za-zα-ωΑ-Ω]{1,}([\.,] |[-']| ))+[A-Za-zΑ-Ωα-ω]+\.?\s*$")
//                   .hasMatch(actor.fullName)) {
//                 actors.add(actor);
//                 counter++;
//               }
//             }
//           }
//         }
//         print("actors: " + actors[0].fullName);
//         return actors;
//       } else {
//         print("Api status code error");
//       }
//     } on Exception catch (e) {
//       print('error data: $e');
//     }
//   }
//
//   // ignore: missing_return
//   Future<List<Theater>> loadHomeTheaters() async {
//     Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
//     Response data = await get(uri, headers: {
//       "Accept": "application/json",
//       "authorization":
//           "${await AuthorizationStore.getStoreValue("authorization")}"
//     });
//     var jsonData = jsonDecode(data.body);
//     int counter = 0;
//     try {
//       for (var oldTheater in jsonData['data']['content']) {
//         if (oldTheater['title'] != null &&
//             oldTheater['address'] != null &&
//             counter < 6) {
//           Theater theater = new Theater(oldTheater['id'], oldTheater['title'],
//               oldTheater['address'], false);
//
//           theaters.add(theater);
//           counter++;
//         }
//       }
//       print("theaters: " + theaters[0].title);
//       return theaters;
//     } on Exception {
//       print('error data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//             future: loadHomeMovies(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
//               if (!snapshot.hasData) {
//                 return Loading();
//               } else if (snapshot.hasError) {
//                 return Text("error loading");
//               } else {
//                 return HomeScreen(movies, actors, theaters);
//               }
//             }));
//   }
// }
// class LoadingHomeScreen extends StatefulWidget {
//   @override
//   _LoadingHomeScreenState createState() => _LoadingHomeScreenState();
// }
//
// class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
//   List<Movie> movies = [];
//   List<Actor> actors = [];
//   List<Theater> theaters = [];
//
//   // Load latest movies data from API
//   Future<List<Movie>> loadHomeMovies() async {
//     await loadHomeActors();
//     await loadHomeTheaters();
//     try {
//       Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/productions");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization": "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//
//       int counter = 0;
//       for (var oldMovie in jsonData['data']['content']) {
//         if (oldMovie['mediaURL'] != null && oldMovie['mediaURL'] != "") {
//           Movie movie = Movie(
//               id: oldMovie['id'] ?? 0,
//               title: oldMovie['title'] ?? 'Unknown Title',
//               ticketUrl: oldMovie['ticketUrl'],
//               producer: oldMovie['producer'] ?? 'Unknown Producer',
//               mediaUrl: oldMovie['mediaURL'],
//               duration: oldMovie['duration'],
//               description: oldMovie['description'] ?? 'No description available',
//               isSelected: false);
//           if (counter < 6) {
//             movies.add(movie);
//             counter++;
//           }
//         }
//       }
//
//       if (movies.isNotEmpty) {
//         print("movies: " + movies[0].title);
//       }
//       return movies;
//     } catch (e) {
//       print('Error fetching movies: $e');
//       return [];
//     }
//   }
//
//   // Load latest actors data from API
//   Future<List<Actor>> loadHomeActors() async {
//     try {
//       Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/people");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization": "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//
//       if (data.statusCode == 200) {
//         var jsonData = jsonDecode(data.body);
//
//         int counter = 0;
//         for (var oldActor in jsonData['data']['content']) {
//           if (oldActor['image'] != null && oldActor['image'] != '') {
//             if (counter < 6 && oldActor['id'] != 1908) {
//               Actor actor = Actor(
//                   imagePath: oldActor['image'],
//                   id: oldActor['id'] ?? 0,
//                   fullName: oldActor['fullName'] ?? 'Unknown Name');
//               if (RegExp(
//                   r"^\s*([A-Za-zα-ωΑ-Ω]{1,}([\.,] |[-']| ))+[A-Za-zΑ-Ωα-ω]+\.?\s*$")
//                   .hasMatch(actor.fullName)) {
//                 actors.add(actor);
//                 counter++;
//               }
//             }
//           }
//         }
//
//         if (actors.isNotEmpty) {
//           print("actors: " + actors[0].fullName);
//         }
//         return actors;
//       } else {
//         print("API status code error");
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching actors: $e');
//       return [];
//     }
//   }
//
//   // Load latest theaters data from API
//   Future<List<Theater>> loadHomeTheaters() async {
//     try {
//       Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
//       Response data = await get(uri, headers: {
//         "Accept": "application/json",
//         "authorization": "${await AuthorizationStore.getStoreValue("authorization")}"
//       });
//       var jsonData = jsonDecode(data.body);
//
//       int counter = 0;
//       for (var oldTheater in jsonData['data']['content']) {
//         if (oldTheater['title'] != null && oldTheater['address'] != null && counter < 6) {
//           Theater theater = Theater(
//               id: oldTheater['id'] ?? 0,
//               title: oldTheater['title'] ?? 'Unknown Theater',
//               address: oldTheater['address'] ?? 'Unknown Address',
//               isSelected: false);
//           theaters.add(theater);
//           counter++;
//         }
//       }
//
//       if (theaters.isNotEmpty) {
//         print("theaters: " + theaters[0].title);
//       }
//       return theaters;
//     } catch (e) {
//       print('Error fetching theaters: $e');
//       return [];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<Movie>>(
//         future: loadHomeMovies(),
//         builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Loading(); // Show loading indicator while data is being fetched
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error loading data"));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             return HomeScreen(movies, actors, theaters); // Pass the fetched data to the HomeScreen widget
//           } else {
//             return Center(child: Text("No movies available"));
//           }
//         },
//       ),
//     );
//   }
// }
class LoadingHomeScreen extends StatefulWidget {
  @override
  _LoadingHomeScreenState createState() => _LoadingHomeScreenState();
}

class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
  List<Movie> movies = [];
  List<Actor> actors = [];
  List<Theater> theaters = [];

  // Load latest movies data from API
  Future<List<Movie>> loadHomeMovies() async {
    await loadHomeActors();
    await loadHomeTheaters();
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/productions");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization": "${await AuthorizationStore.getStoreValue("authorization") ?? ''}"
      });
      var jsonData = jsonDecode(data.body);

      int counter = 0;
      for (var oldMovie in jsonData['data']['content']) {
        if (oldMovie['mediaURL'] != null && oldMovie['mediaURL'] != "") {
          Movie movie = Movie(
            id: oldMovie['id'] ?? 0,
            title: oldMovie['title'] ?? 'Unknown Title',
            ticketUrl: oldMovie['ticketUrl'],
            producer: oldMovie['producer'] ?? 'Unknown Producer',
            mediaUrl: oldMovie['mediaURL'],
            duration: oldMovie['duration'],
            description: oldMovie['description'] ?? 'No description available',
            isSelected: false,
          );
          if (counter < 6) {
            movies.add(movie);
            counter++;
          }
        }
      }

      if (movies.isNotEmpty) {
        print("movies: ${movies[0].title}");
      }
      return movies;
    } catch (e) {
      print('Error fetching movies: $e');
      return [];
    }
  }

  // Load latest actors data from API
  Future<List<Actor>> loadHomeActors() async {
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/people");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization": "${await AuthorizationStore.getStoreValue("authorization") ?? ''}"
      });

      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);

        int counter = 0;
        for (var oldActor in jsonData['data']['content']) {
          if (oldActor['image'] != null && oldActor['image'] != '') {
            if (counter < 6 && oldActor['id'] != 1908) {
              // Actor actor = Actor(
              //   imagePath: oldActor['image'],
              //   id: oldActor['id'] ?? 0,
              //   fullName: oldActor['fullName'] ?? 'Unknown Name',
              // );
              Actor actor = Actor(
                 oldActor['image'] ?? 'https://example.com/default-image.jpg', // Fallback for image
                 oldActor['id'] ?? 0, // Fallback for id
              oldActor['fullName'] ?? 'Unknown Name', // Fallback for full name
              );

              if (RegExp(
                  r"^\s*([A-Za-zα-ωΑ-Ω]{1,}([\.,] |[-']| ))+[A-Za-zΑ-Ωα-ω]+\.?\s*$")
                  .hasMatch(actor.fullName)) {
                actors.add(actor);
                counter++;
              }
            }
          }
        }

        if (actors.isNotEmpty) {
          print("actors: ${actors[0].fullName}");
        }
        return actors;
      } else {
        print("API status code error");
        return [];
      }
    } catch (e) {
      print('Error fetching actors: $e');
      return [];
    }
  }

  // Load latest theaters data from API
  Future<List<Theater>> loadHomeTheaters() async {
    try {
      Uri uri = Uri.parse("http://${Constants().hostName}:8080/api/venues");
      Response data = await get(uri, headers: {
        "Accept": "application/json",
        "authorization": "${await AuthorizationStore.getStoreValue("authorization") ?? ''}"
      });
      var jsonData = jsonDecode(data.body);

      int counter = 0;
      for (var oldTheater in jsonData['data']['content']) {
        if (oldTheater['title'] != null && oldTheater['address'] != null && counter < 6) {
          Theater theater = Theater(
            id: oldTheater['id'] ?? 0,
            title: oldTheater['title'] ?? 'Unknown Theater',
            address: oldTheater['address'] ?? 'Unknown Address',
            isSelected: false,
          );
          theaters.add(theater);
          counter++;
        }
      }

      if (theaters.isNotEmpty) {
        print("theaters: ${theaters[0].title}");
      }
      return theaters;
    } catch (e) {
      print('Error fetching theaters: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Movie>>(
        future: loadHomeMovies(),
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); // Show loading indicator while data is being fetched
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return HomeScreen(
              homeMovies: movies, // Pass the movies list as homeMovies
              homeActors: actors, // Pass the actors list as homeActors
              homeTheaters: theaters, // Pass the theaters list as homeTheaters
            ); // Pass the fetched data to the HomeScreen widget
          } else {
            return Center(child: Text("No movies available"));
          }
        },
      ),
    );
  }
}
