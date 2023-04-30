import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/baseUrl.dart';
import 'contacts.dart';
import 'loginPage.dart';

class EditContact extends StatefulWidget {
  final id;

  EditContact({super.key, required this.id});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  // const EditContact({super.key});
  String editName = "";

  String editPhone = "";
  var errorName = false;

  var descName = "";

  var errorPhone = false;

  var descPhone = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          editName = value;
                        },
                        decoration: const InputDecoration(
                          // fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  (errorName)
                      ? Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            descName,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          editPhone = value;
                        },
                        decoration: const InputDecoration(
                          // fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  (errorPhone)
                      ? Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Text(
                            descPhone,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      if (editName.length < 1) {
                        errorName = true;
                        descName = "Enter Name";
                      } else {
                        errorName = false;
                        descName = "";
                      }

                      if (editPhone.length == 10) {
                        errorPhone = false;
                        descPhone = '';
                      } else {
                        errorPhone = true;
                        descPhone = "Phone number must have 10 digits";
                      }

                      if (editName.length > 1 && editPhone.length == 10) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String? user_id = prefs.getString('user_id');
                        final http.Response response;
                        response = await http.put(
                          Uri.parse("${baseUrl}/contacts/${widget.id}"), // api
                          headers: header,
                          body: jsonEncode(
                            <String, String>{
                              "name": editName,
                              "phone": editPhone
                            },
                          ),
                        );

                        final http.Response responseNew;
                        responseNew = await http.get(
                          Uri.parse("${baseUrl}/contacts"), // api
                          headers: header,
                        );
                        var ll = jsonDecode(responseNew.body);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Contacts(
                                    list: ll,
                                    user_id: user_id.toString(),
                                  )),
                        );
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text("Submit"),
                  )
                ],
              ),
            ),
    );
  }
}
