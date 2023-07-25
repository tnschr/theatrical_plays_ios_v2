import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/pages/Home.dart';
import 'package:theatrical_plays/using/AuthorizationStore.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/MyColors.dart';

import 'SignInScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        title: Text(
          'Theatrical analytics',
          style: TextStyle(color: MyColors().cyan),
        ),
        backgroundColor: MyColors().black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: MyColors().black,
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              // Container(
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.all(10),
              //     child: Text(
              //       'Theatrical analytics',
              //       style: TextStyle(
              //           color: MyColors().cyan,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 20),
              //     )),
              // Divider(color: MyColors().white),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Log in with a user',
                    style: TextStyle(fontSize: 20, color: MyColors().cyan),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: MyColors().cyan),
                  controller: emailController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: MyColors().cyan),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors().cyan)),
                      labelText: 'Username',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: MyColors().cyan))),
                  cursorColor: MyColors().cyan,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  style: TextStyle(color: MyColors().cyan),
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: MyColors().cyan),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors().cyan)),
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: MyColors().cyan))),
                  cursorColor: MyColors().cyan,
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors().gray,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(color: MyColors().cyan)),
                        textStyle: TextStyle(color: MyColors().cyan)),
                    child: Text(
                      'Login',
                      style: TextStyle(color: MyColors().cyan),
                    ),
                    onPressed: () {
                      doLogin(emailController.text, passwordController.text);
                    },
                  )),
              Row(
                children: <Widget>[
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: MyColors().white),
                  ),
                  TextButton(
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20, color: MyColors().cyan),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          )),
    );
  }

  doLogin(email, password) async {
    try {
      Uri uri =
          Uri.parse("https://${Constants().hostName}:7042/api/user/login");
      // Create a new HttpClient and allow self-signed certificates (for debugging only)
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

// Prepare the request body
      Map<String, dynamic> requestBody = {
        'email': email,
        'password': password,
      };

      // Convert the request body to a JSON string
      String requestBodyJson = jsonEncode(requestBody);

      // Make the POST request using the custom HttpClient
      HttpClientRequest request = await httpClient.postUrl(uri);
      request.headers.add('Content-Type', 'application/json');
      request.write(requestBodyJson);

      // Send the request and get the response
      HttpClientResponse response = await request.close();

      // Read the response
      if (response.statusCode == 200) {
        AuthorizationStore.writeToStore(
            'authorization', response.headers['authorization']);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Wrong credentials",
            textAlign: TextAlign.center,
          ),
        ));
      }
      // ignore: nullable_type_in_catch_clause
    } on HttpException catch (e) {
      // Handle HttpException
      print("HttpException occurred: $e");
      // } on Exception {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       "Error to login. Check internet connection and VPN.",
      //       textAlign: TextAlign.center,
      //     ),
    } catch (e) {
      // Handle any exception that occurred during the execution of the try block
      // Print the exception message to see the details
      print("Exception occurred: $e");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "An unexpected error occurred. Please try again later.",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }
}
