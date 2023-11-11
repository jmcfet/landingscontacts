import 'dart:html';


import 'package:Contacts/utils/constants.dart';
import 'package:Contacts/pages/contacts_page.dart';
import 'package:flutter/material.dart';

/*
git add .
git commit -m "first commit"
git push 
*/
String getParams() {
  var uri = Uri.dataFromString(window.location.href);
  Map<String, String> params = uri.queryParameters;
  String? userid = params['userid'];
  userid ??= 'jmcfet@icloud.com';
  // String userid = params['origin'] as String ?? 'test';
  print(userid);
  return userid;
}

String userid = 'jmcfet@icloud.com';
bool? _filter1 = false;
bool? _filter2 = false;
bool? _filter3 = false;
// State for dropdown
String? _dropdownValue = 'All';
List<String> _dropdownItems = [
  'All',
  'Landings South 1',
  'Landings South 2',
  'Landings South 3 ',
  'Landings South 4 '
];

void main() {
  userid = getParams();
  runApp(new ContactsApp());
}

class ContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: DrawerTitles.CONTACTS,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Dummy contact list
  final List<String> contacts = ['John', 'Jane', 'Doe', 'Smith'];
  bool? _filter1 = false;
  bool? _filter2 = false;
  bool? _filter3 = false;
  ContactsPage test = ContactsPage(userid: userid);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Manager'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              //    _showDialog();
            },
          ),
        ],
      ),
      body: ContactsPage(userid : userid),
      
      
    );
  }
}
