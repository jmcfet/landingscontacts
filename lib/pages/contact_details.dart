/*
 * Copyright 2018 Harsh Sharma
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:Contacts/common_widgets/avatar.dart';
import 'package:Contacts/models/contact.dart';
import 'package:Contacts/utils/constants.dart';
import 'package:Contacts/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;

  ContactDetails(this.contact);

  @override
  createState() => new ContactDetailsPageState(contact);
}

class ContactDetailsPageState extends State<ContactDetails> {
  final globalKey = new GlobalKey<ScaffoldState>();

  RectTween _createRectTween(Rect begin, Rect end) {
    return new MaterialRectCenterArcTween(begin: begin, end: end);
  }

  final Contact contact;

  ContactDetailsPageState(this.contact);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: globalKey,
      appBar: new AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(
          Texts.CONTACT_DETAILS,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _contactDetails(),
    );
  }

  Widget _contactDetails() {
    return ListView(
      children: <Widget>[
         SizedBox(

          height: 20.0,
        ),
        listTile(contact.name!, Icons.account_circle, Texts.NAME),
        listTile(contact.Phone1!, Icons.phone, Texts.PHONE),
        listTile(contact.email!, Icons.email, Texts.EMAIL),
        listTile(contact.address!, Icons.location_on, Texts.ADDRESS),
        
      ],
    );
  }

  Widget listTile(String text, IconData icon, String tileCase) {
    return new GestureDetector(
      onTap: () {
        switch (tileCase) {
          case Texts.NAME:
            break;
          case Texts.PHONE:
            _launch("tel:" + contact.Phone1!);
            break;
          case Texts.EMAIL:
            _launch("mailto:${contact.email}?");
            break;
          
          
        }
      },
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(
              text,
              style: new TextStyle(
                color: Colors.blueGrey[400],
                fontSize: 20.0,
              ),
            ),
            leading: new Icon(
              icon,
              color: Colors.blue[400],
            ),
          ),
          new Container(
            height: 0.3,
            color: Colors.blueGrey[400],
          )
        ],
      ),
    );
  }

  void _launch(String launchThis) async {
    try {
      String url = launchThis;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print("Unable to launch $launchThis");
//        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
