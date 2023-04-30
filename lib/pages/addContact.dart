import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yellow_app/constants/baseUrl.dart';
import 'contacts.dart';
import 'loginPage.dart';

class AddContact extends StatefulWidget {
  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  // const AddContact({super.key});
  String name = "";

  String phone = "";

  String user_id = "";

  var errorName = false;

  var descName = "";

  var errorPhone = false;

  var descPhone = "";

  bool isLoading = false;

  // AddContact({super.key, required this.id});
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
                          name = value;
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
                          phone = value;
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
                      if (name.length < 1) {
                        errorName = true;
                        descName = "Enter Name";
                      } else {
                        errorName = false;
                        descName = "";
                      }

                      if (phone.length == 10) {
                        errorPhone = false;
                        descPhone = '';
                      } else {
                        errorPhone = true;
                        descPhone = "Phone number must have 10 digits";
                      }

                      if (name.length > 1 && phone.length == 10) {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final String? user_id = prefs.getString('user_id');
                        final http.Response response;
                        response = await http.post(
                          Uri.parse("${baseUrl}/contacts"), // api
                          headers: header,
                          body: jsonEncode(
                            <String, String>{
                              "name": name,
                              "phone": phone,
                              "user_id": user_id.toString()
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
