import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yellow_app/pages/addContact.dart';

import '../constants/baseUrl.dart';
import 'editContact.dart';
import 'loginPage.dart';

class Contacts extends StatefulWidget {
  List<dynamic> list;
  String? user_id;

  Contacts({super.key, required this.list, this.user_id});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<dynamic> ll = [];
  @override
  Widget build(BuildContext context) {
    ll = widget.list;
    // user_id = widget.user_id!;
    // if (user_id == null) getUserId();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Contacts",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.orange),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your onPressed code here!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddContact()),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            SizedBox(
              height: 5,
            ),
            for (int i = 0; i < ll.length; i++) ...[
              if (ll[i]["user_id"] == widget.user_id) ...[
                Container(
                  margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(21),
                    ),
                    leading: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditContact(
                                      id: ll[i]["_id"],
                                    )),
                          );
                          // setState(() {});
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                    trailing: GestureDetector(
                        onTap: () async {
                          var id = ll[i]["_id"];
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Color(0xfffee440),
                              ));
                            },
                          );
                          final http.Response response;
                          response = await http.delete(
                            Uri.parse("${baseUrl}/contacts/$id"), // api
                            headers: header,
                          );
                          final http.Response responseNew;
                          responseNew = await http.get(
                            Uri.parse("${baseUrl}/contacts"), // api
                            headers: header,
                          );
                          widget.list = jsonDecode(responseNew.body);
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    title: Text(
                      ll[i]["name"],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                    subtitle: Text(
                      ll[i]["phone"],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                )
              ]
            ]
          ],
        ),
      ),
    );
  }
}
