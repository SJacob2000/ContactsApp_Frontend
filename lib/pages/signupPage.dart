import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yellow_app/pages/loginPage.dart';

import '../constants/baseUrl.dart';
import 'contacts.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email = "", _password = "";
  var errorEmail = false;
  var descEmail = "";

  var errorPassword = false;
  var descPassword = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                        image: const DecorationImage(
                          image: AssetImage("assets/welcome.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          _email = value;
                        },
                        decoration: const InputDecoration(
                          // fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  (errorEmail)
                      ? Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            descEmail,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        obscureText: true,
                        obscuringCharacter: "*",
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          _password = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  (errorPassword)
                      ? Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            descPassword,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already Signed Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (isEmailValid(_email)) {
                        errorEmail = false;
                        descEmail = '';
                      } else {
                        errorEmail = true;
                        descEmail = "Please Enter the valid email";
                      }

                      if (_password.length >= 6) {
                        errorPassword = false;
                        descPassword = '';
                      } else {
                        errorPassword = true;
                        descPassword = "Password must contain 6 characters";
                      }

                      if (isEmailValid(_email) && _password.length >= 6) {
                        final http.Response response;
                        response = await http.post(
                          Uri.parse(baseUrl + "/api/register"), // api
                          headers: header,
                          body: jsonEncode(
                            <String, dynamic>{
                              "email": _email,
                              "password": _password
                            },
                          ),
                        );

                        if (response.statusCode == 200) {
                          var jsonNew = jsonDecode(response.body);
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('user_id', jsonNew["_id"]);
                          String? s = prefs.getString('user_id');
                          final http.Response responseNew;
                          responseNew = await http.get(
                            Uri.parse("${baseUrl}/contacts"), // api
                            headers: header,
                          );
                          var jsonNew1 = jsonDecode(responseNew.body);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Contacts(
                                      list: jsonNew1,
                                      user_id: s.toString(),
                                    )),
                          );
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
    );
  }

  bool isEmailValid(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}

Map<String, String> header = {
  "ngrok-skip-browser-warning": "value",
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
  "Access-Control-Allow-Headers":
      "Origin, X-Requested-With, Content-Type, Accept"
};
