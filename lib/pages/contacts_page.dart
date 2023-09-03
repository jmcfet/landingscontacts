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
import 'package:Contacts/common_widgets/no_content_found.dart';
import 'package:Contacts/common_widgets/progress_dialog.dart';
import 'package:Contacts/models/base/event_object.dart';
import 'package:Contacts/models/contact.dart';
import 'package:Contacts/pages/contact_details.dart';
import 'package:Contacts/pages/edit_contact_page.dart';
import 'package:Contacts/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../futures/api.dart';
import '../models/association.dart';

class ContactsPage extends StatefulWidget {
  
  ContactPageState? _contactPageState;

  ContactsPage();

  @override
  createState() =>
      _contactPageState = new ContactPageState();

  
}

class ContactPageState extends State<ContactsPage> {
  static final globalKey = new GlobalKey<ScaffoldState>();

  Widget progressDialog = ProgressDialog.getProgressDialog(
      ProgressDialogTitles.LOADING_CONTACTS, false);

  RectTween _createRectTween(Rect begin, Rect end) {
    return new MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static const opacityCurve =
      const Interval(0.0, 0.75, curve: Curves.fastOutSlowIn);

  List<Contact> contactList = [];
  List<Dismissible> dismissible = [];

  ContactPageState();

  Widget? contactListWidget;
  List<Association> associations = [];
  String selectedassoc = 'Carriagehouse I';
  String assnCode = 'ALL';
  void initState() {
    super.initState();
    
     getAssoc();
     getPeopleAssociations( 'ALL');
    
  }

  Future<EventObject> getAssoc() async {
    EventObject eventObject = await getAssociations();
    setState(() {
      selectedassoc = 'ALL';
      associations = eventObject.object as List<Association>;
      associations.insert(0, Association(AssnCode:'ALL',AssnShortName: 'ALL'));
    });
    
    return eventObject;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return new Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
           //   color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
              border: Border.all(
                color: Colors.red[500]!,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: 
                  DropdownButton<String>(
              dropdownColor: Colors.grey[200],
              value: selectedassoc,
              
              onChanged: (newValue) {
                setState(() {
                  selectedassoc = newValue!;
                  assnCode = associations.where((element) => element.AssnShortName == newValue).first.AssnCode!;
                  getPeopleAssociations( assnCode);
                });
              },
              items: associations.map((assoc) {
                return DropdownMenuItem<String>(
                  value: assoc.AssnShortName,
                  child: Text(assoc.AssnShortName!),
                );
              }).toList(),
            ),
            ),
            SizedBox(width: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
              child: TextField(
                //  controller : textController,
                onSubmitted: (value) => {getSearchContacts(value, assnCode)},
                decoration: InputDecoration(
                    hintText: 'Search by last name',
                    prefixIcon: Icon(Icons.search),
                   
                  ),
              ),
              ),
            ),
          ],
        ),
      ),
      body: loadList(),
      backgroundColor: Colors.grey[150],
    );
  }

  Widget loadList() {
    if (contactList != null && contactList.isNotEmpty) {
      contactListWidget = _buildContactList();
    } else {
      contactListWidget =
          NoContentFound(Texts.STARTINFO, Icons.account_circle);
    }
    return new Stack(
      children: <Widget>[contactListWidget!, progressDialog],
    );
  }

  Widget _buildContactList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildContactRow(contactList[i]);
      },
      itemCount: contactList.length,
    );
  }

  Widget _buildContactRow(Contact contact) {
    return new Dismissible(
      key: Key(contact.id.toString()),
      child: new GestureDetector(
        onTap: () {
          _heroAnimation(contact);
        },
        child: new Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // You can also set borders here
          ),
          color: Colors.black,
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    //          contactAvatar(contact),
                    contactDetails(contact)
                  ],
                ),
              ],
            ),
            margin: EdgeInsets.all(10.0),
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          if (direction == DismissDirection.endToStart) {
   //         progressDialog
 //               .showProgressWithText(ProgressDialogTitles.DELETING_CONTACT);
 //           deleteContact(contact);
            contactList.remove(contact);
          } else {
            _navigateToEditContactPage(context, contact);
            contactList.remove(contact);
          }
        });
      },
      direction: DismissDirection.horizontal,
      background: dismissContainerEdit(),
      secondaryBackground: dismissContainerDelete(),
    );
  }

  void _navigateToEditContactPage(BuildContext context, Contact contact) async {
    int contactUpdateStatus = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new EditContactPage(contact)),
    );
    setState(() {
      switch (contactUpdateStatus) {
        case Events.CONTACT_WAS_UPDATED_SUCCESSFULLY:
//          reloadContacts();
          showSnackBar(SnackBarText.CONTACT_WAS_UPDATED_SUCCESSFULLY);
          break;
        case Events.UNABLE_TO_UPDATE_CONTACT:
          contactList.add(contact);
          showSnackBar(SnackBarText.UNABLE_TO_UPDATE_CONTACT);
          break;
        case Events.NO_CONTACT_WITH_PROVIDED_ID_EXIST_IN_DATABASE:
          contactList.add(contact);
          showSnackBar(
              SnackBarText.NO_CONTACT_WITH_PROVIDED_ID_EXIST_IN_DATABASE);
          break;
        case Events.USER_HAS_NOT_PERFORMED_UPDATE_ACTION:
          contactList.add(contact);
          showSnackBar(SnackBarText.USER_HAS_NOT_PERFORMED_EDIT_ACTION);
          break;
        default:
          contactList.add(contact);
          break;
      }
    });
  }

  Widget dismissContainerEdit() {
    return new Card(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Container(
        alignment: Alignment.centerLeft,
        color: Colors.green[400],
        child: new Container(
          padding: EdgeInsets.only(left: 20.0),
          child: new Icon(
            Icons.edit,
            size: 40.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget dismissContainerDelete() {
    return new Card(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Container(
        alignment: Alignment.centerRight,
        color: Colors.red[400],
        child: new Container(
          padding: EdgeInsets.only(right: 20.0),
          child: new Icon(
            Icons.delete,
            size: 40.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  doSearch(value) {
    print(value);
  }

  Widget contactAvatar(Contact contact) {
    return new Hero(
      tag: contact.id ?? 'default',
      child: new Avatar(
        contactImage: contact.contactImage,
      ),
   //   createRectTween: _createRectTween,
    );
  }

  Widget contactDetails(Contact contact) {
    return new Flexible(
        child: new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          textContainer(contact.name ?? '', Colors.amberAccent),
          textContainer(contact.Phone1 ?? '', Colors.amberAccent),
          textContainer(contact.email ?? '', Colors.amberAccent),
        ],
      ),
      margin: EdgeInsets.only(left: 20.0),
    ));
  }

  Widget textContainer(String string, Color color) {
    return new Container(
      child: new Text(
        string,
        style: TextStyle(
            color: color, fontWeight: FontWeight.normal, fontSize: 16.0),
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      margin: EdgeInsets.only(bottom: 10.0),
    );
  }

  void _heroAnimation(Contact contact) {
    Navigator.of(context).push(
      new PageRouteBuilder<Null>(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return new AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return  Opacity(
                  opacity: opacityCurve.transform(animation.value),
                  child: ContactDetails(contact),
                );
              });
        },
      ),
    );
  }

  

  void getSearchContacts(searchtoken, categogy) {
    setState(() {
 //     progressDialog
  //        .showProgressWithText(ProgressDialogTitles.LOADING_CONTACTS);
      loadContacts2(searchtoken, categogy);
    });
  }

  void getPeopleAssociations(name) async {
    EventObject eventObject = await getAssociationResidents(name);
    setState(() {
 //     progressDialog
  //        .showProgressWithText(ProgressDialogTitles.LOADING_CONTACTS);

  //    progressDialog.hide();
      contactList = eventObject.object as List<Contact>;
    });
  }

  void getListofAssociations(name) async {
    EventObject eventObject = await getAssociations();
    setState(() {
  //    progressDialog
  //        .showProgressWithText(ProgressDialogTitles.LOADING_CONTACTS);

 //     progressDialog.hide();
      contactList = eventObject.object as List<Contact>;
    });
  }

  void loadContacts2(search, cat) async {
    EventObject eventObject = await getSearchResults(search, cat);
    if (this.mounted) {
      setState(() {
 //       progressDialog.hide();
        switch (eventObject.id) {
          case Events.READ_CONTACTS_SUCCESSFUL:
            contactList = eventObject.object as List<Contact>;
            showSnackBar(SnackBarText.CONTACTS_LOADED_SUCCESSFULLY);
            break;

          case Events.NO_CONTACTS_FOUND:
            contactList = eventObject.object as List<Contact>;
            showSnackBar(SnackBarText.NO_CONTACTS_FOUND);
            break;

          case Events.NO_INTERNET_CONNECTION:
            contactListWidget = NoContentFound(
                SnackBarText.NO_INTERNET_CONNECTION, Icons.signal_wifi_off);
            showSnackBar(SnackBarText.NO_INTERNET_CONNECTION);
            break;
        }
      });
    }
  }

  

  

  void showSnackBar(String textToBeShown) {
    ScaffoldMessenger.of(context)
      ..showSnackBar(new SnackBar(
        content: new Text(textToBeShown),
      ));
  }
}
