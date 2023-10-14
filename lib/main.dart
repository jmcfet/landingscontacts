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
      home: ContactsPage(userid : userid),
    );
  }
}
