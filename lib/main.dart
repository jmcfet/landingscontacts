
import 'package:Contacts/utils/constants.dart';
import 'package:Contacts/pages/contacts_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new ContactsApp());

class ContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: DrawerTitles.CONTACTS,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ContactsPage(),
    );
  }
}
