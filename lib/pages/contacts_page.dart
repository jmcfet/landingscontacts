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

import 'package:Contacts/common_widgets/no_content_found.dart';
import 'package:Contacts/common_widgets/progress_dialog.dart';
import 'package:Contacts/models/base/event_object.dart';
import 'package:Contacts/models/contact.dart';
import 'package:Contacts/pages/contact_details.dart';
import 'package:Contacts/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../futures/api.dart';
import '../models/association.dart';

class ContactsPage extends StatefulWidget {
  ContactPageState? _contactPageState;

  ContactsPage({required this.userid});
  final String userid;
  @override
  createState() => _contactPageState = new ContactPageState();
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
  bool bFirst = true;

  ContactPageState();

  Widget? contactListWidget;
  List<Association> associations = [];
  String selectedassoc = 'Carriagehouse I';
  String assnCode = 'ALL';
  void initState() {
    super.initState();

    getAssoc();
  //  getPeopleAssociations('ALL');
  }

  Future<EventObject> getAssoc() async {
    EventObject eventObject = await getAssociations();
    setState(() {
      selectedassoc = 'ALL';
      associations = eventObject.object as List<Association>;
      associations.insert(
          0, Association(AssnCode: 'ALL', AssnShortName: 'ALL'));
    });

    return eventObject;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;
    return Row(
      children: [
        // Left pane for filters
        Container(
            width: 250,
            //       color: Colors.grey[200],
            decoration: BoxDecoration(
              // Using BoxDecoration to set the border
              border: Border.all(color: Colors.black),
            ),
            child: leftPane()),
        // Right pane for the list of contacts
        Expanded(
            child: Scaffold(
          key: globalKey,
          body: loadList(),
          backgroundColor: Colors.grey[150],
        ))
      ],
    );
  }

  Widget loadList() {
    if (contactList.isNotEmpty  ) {
      contactListWidget = _buildContactList();
      
    } else {
      contactListWidget = NoContentFound(Texts.STARTINFO, Icons.account_circle);
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
          _navigateToEditContactPage(context, contact);
        },
        child: new Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            // You can also set borders here
          ),
          color: Colors.white,
          child: new Container(
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[contactDetails(contact)],
                ),
              ],
            ),
            margin: EdgeInsets.all(10.0),
          ),
        ),
      ),
      direction: DismissDirection.horizontal,
    );
  }
    bool? lastNameChecked = false;
    bool? firstNameChecked = false;
    bool? addressChecked = false;

    String filterLast = '0';
    String filterfirst = '0';
    String filteraddress = '0';

    Widget leftPane() {
    TextEditingController textController = TextEditingController();

        return Container(
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              // Label for 'Associations'
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Search',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                
              ),
              Text(
                  'leave ALL for all associations or select one to restrict search',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 10),
              
              // DropdownButton
              DropdownButton<String>(
                dropdownColor: Colors.grey[200],
                value: selectedassoc,
                onChanged: (newValue) {
                  setState(() {
                    selectedassoc = newValue!;
                    assnCode = associations
                        .where((element) => element.AssnShortName == newValue)
                        .first
                        .AssnCode!;
                        print(assnCode.toString());
    //                getPeopleAssociations(assnCode);
                  });
                },
                items: associations.map((assoc) {
                  return DropdownMenuItem<String>(
                    value: assoc.AssnShortName,
                    child: Text(assoc.AssnShortName!),
                  );
                }).toList(),
              ),

              SizedBox(height: 8.0),
              CheckboxListTile(
                title: Text('last name'),
                value: lastNameChecked,
                onChanged: (bool? value) {
                  setState(() {
                    lastNameChecked = value;
                    filterLast = '0';
                    if (lastNameChecked! == true)
                    {
                        
                        firstNameChecked = false;
                         addressChecked = false;
                         
                    }
                      
                  });
                },
              ),
              CheckboxListTile(
                title: Text('first Name'),
                value: firstNameChecked,
                onChanged: (bool? value) {
                  setState(() {
                    firstNameChecked = value;
                     filterfirst = '0';
                    if (firstNameChecked! == true)
                    {
                        
                        lastNameChecked = false;
                        addressChecked = false;
                    }
                      
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Address'),
                value: addressChecked,
                onChanged: (bool? value) {
                  setState(() {
                    addressChecked = value;
                    filteraddress = '0';
                    if (addressChecked! == true)
                    {
                        
                        firstNameChecked = false;
                        lastNameChecked = false;
                    }
                      
                  });
                },
              ),
              SizedBox(height: 8.0),
              // Text Input Box
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Filter by',
                  
                ),
              ),
              // Save Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    filterLast = filteraddress = filterfirst = '0';
                    if (lastNameChecked! == true)
                        filterLast = '1';
                    if (firstNameChecked! == true)
                        filterfirst = '1';
                    if (addressChecked! == true)
                        filteraddress = '1';
                    
                   
                    String filter = assnCode + ';' + filterLast  + ';' + filterfirst + ';' + filteraddress + ';' + textController.text;
                    getSearchContacts(filter, 'string');
                    bFirst = false;
                  },
                  child: Text('GO'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      lastNameChecked = false;
                      firstNameChecked = false;
                      addressChecked = false;
                      
                      String filter = "ALL" + ';' + '0'  + ';' + '0' + ';' + '0' + ';' + '';
                      selectedassoc = 'ALL';
                      contactList.clear();
                    });
                  },
                  child: Text('Clear'),
                ),
              ),
            ],
          ),
        );
  }

  void _navigateToEditContactPage(BuildContext context, Contact contact) async {
    int contactUpdateStatus = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new ContactDetails(contact, widget.userid)),
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

  doSearch(value) {
    print(value);
  }

  Widget contactDetails(Contact contact) {
    return new Flexible(
        child: new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Expanded(
                flex: 2,
                child: textContainer(contact.name ?? '', Colors.black)),
            Expanded(
                flex: 1,
                child: textContainer(contact.association ?? '', Colors.black)),
          ]),
          Row(children: [
            Expanded(
                flex: 2,
                child: textContainer(contact.Phone1 ?? '', Colors.black)),
            Expanded(
                flex: 1,
                child: textContainer(contact.address ?? '', Colors.black)),
          ]),
          textContainer(contact.email ?? '', Colors.black),
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
                return Opacity(
                  opacity: opacityCurve.transform(animation.value),
                  child: ContactDetails(contact, widget.userid),
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
