import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:theatrical_plays/pages/home/LoginScreen.dart';
import 'package:theatrical_plays/using/Constants.dart';
import 'package:theatrical_plays/using/MyColors.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Create a new User',
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
                      'Sign in',
                      style: TextStyle(color: MyColors().cyan),
                    ),
                    onPressed: () {
                      doSignIn(emailController.text, passwordController.text);
                    },
                  )),
              Row(
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: MyColors().white),
                  ),
                  TextButton(
                    child: Text(
                      'Log in',
                      style: TextStyle(fontSize: 20, color: MyColors().cyan),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          )),
    );
  }

  doSignIn(email, password) async {
    try {
      if (email.toString().isNotEmpty &&
          email != null &&
          password.toString().isNotEmpty &&
          password != null) {
        Uri uri =
            Uri.parse("http://${Constants().hostName}:8080/api/users/register");
        final json = jsonEncode({
          "email": "$email",
          "password": "$password",
          "authorities": ["USER"]
        });
        Response response = await post(uri,
            headers: {
              "Accept": "application/json",
              "content-type": "application/json"
            },
            body: json);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Succesfull Sign in"),
          ));
          Navigator.pop(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else {
          print(response.statusCode);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Not valid credentials")));
        }
      } else {
        print("Empty Field");
      }
    } on Exception {
      print('error to sign in');
    }
  }
}
