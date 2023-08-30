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

import 'dart:async';

import 'package:Contacts/common_widgets/no_content_found.dart';
import 'package:Contacts/common_widgets/progress_dialog.dart';
import 'package:Contacts/models/base/event_object.dart';
import 'package:Contacts/pages/contacts_page.dart';
import 'package:Contacts/pages/create_contact_page.dart';
import 'package:Contacts/pages/deleted_Contacts_page.dart';
import 'package:Contacts/pages/logs_page.dart';
import 'package:Contacts/pages/navigation_item.dart';
import 'package:Contacts/pages/search_Contacts_page.dart';
import 'package:Contacts/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class DashBoardPage extends StatefulWidget {
  @override
  createState() => new DashBoardPageState();
}

class DashBoardPageState extends State<DashBoardPage> {
  static final globalKey = new GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog = ProgressDialog.getProgressDialog(
      ProgressDialogTitles.LOADING_CONTACTS, true);
  Widget dashBoardWidget = new Container();
  String title = DrawerTitles.CONTACTS;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await initContacts();
  }

  Future<void> initContacts() async {
    //  EventObject eventObjectInitContacts = await getContacts();
    EventObject eventObjectInitContacts;
    eventsCapturing(eventObjectInitContacts);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new Scaffold(
      key: globalKey,
      appBar: new AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        title: new Text(title),
      ),
      body: _apiHomePage(),
      drawer: _navigationDrawer(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _apiHomePage() {
    return new Stack(
      children: <Widget>[dashBoardWidget, progressDialog],
    );
  }

  Widget _floatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: new FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      // transitions to the new route using a platform-specific animation.
                      builder: (context) => SearchContactsPage()));
              //                     navigateToPage(new SearchContactsPage());
            },
            heroTag: DrawerTitles.SEARCH_CONTACTS,
            tooltip: DrawerTitles.SEARCH_CONTACTS,
            child: new Icon(
              Icons.search,
            ),
          ),
        ),
        new FloatingActionButton(
          onPressed: () {
            _navigateToCreateContactPage(context);
          },
          child: new Icon(
            Icons.add,
          ),
          heroTag: DrawerTitles.CREATE_CONTACT,
          tooltip: DrawerTitles.CREATE_CONTACT,
        ),
      ],
    );
  }

  void _navigateToCreateContactPage(BuildContext context) async {
    int contactCreationStatus = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new CreateContactPage()),
    );
    setState(() {
      switch (contactCreationStatus) {
        case Events.CONTACT_WAS_CREATED_SUCCESSFULLY:
          handleNavigationDrawerClicks(DrawerTitles.CONTACTS, false);
          showSnackBar(SnackBarText.CONTACT_WAS_CREATED_SUCCESSFULLY);
          break;
        case Events.UNABLE_TO_CREATE_CONTACT:
          showSnackBar(SnackBarText.UNABLE_TO_CREATE_CONTACT);
          break;
        case Events.USER_HAS_NOT_CREATED_ANY_CONTACT:
          showSnackBar(SnackBarText.USER_HAS_NOT_PERFORMED_ANY_ACTION);
          break;
      }
    });
  }

  List<NavigationItem> navigationData;

  Widget _navigationDrawer() {
    return new Drawer(child: _navigationData());
  }

  Widget _navigationData() {
    navigationData = <NavigationItem>[
      new HeaderItem(_getHeaderItem()),
      new SimpleItem(
          leadingIconData: Icons.account_circle, title: DrawerTitles.CONTACTS),
/*
      new SimpleItem(
          leadingIconData: Icons.add, title: DrawerTitles.CREATE_CONTACT),
*/
      new SimpleItem(
          leadingIconData: Icons.delete, title: DrawerTitles.DELETED_CONTACTS),
/*
      new SimpleItem(
          leadingIconData: Icons.search, title: DrawerTitles.SEARCH_CONTACTS),
*/
      new SimpleItem(leadingIconData: Icons.list, title: DrawerTitles.LOGS),
      new SimpleItem(
          leadingIconData: Icons.subdirectory_arrow_left,
          title: DrawerTitles.GO_BACK),
    ];
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final item = navigationData[index];
          if (item is HeaderItem) {
            return item.gestureDetector;
          } else if (item is SimpleItem) {
            return _simpleItem(item);
          }
        },
        itemCount: navigationData.length);
  }

  Widget _getHeaderItem() {
    return _drawerHeader(Icons.description, Ways.API);
  }

  Widget _drawerHeader(IconData icon, String way) {
    return new GestureDetector(
      onTap: () {
        handleNavigationDrawerClicks(DrawerTitles.TAPPED_ON_HEADER, true);
      },
      child: new DrawerHeader(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Icon(
                  icon,
                  size: 75.0,
                  color: Colors.white,
                ),
                new Container(
                  child: new Text(
                    way,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 26.0),
                  ),
                  margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                ),
              ],
            )
          ],
        ),
        /*new Text('Drawer Header')*/
        decoration: new BoxDecoration(color: Colors.blue[400]),
      ),
    );
  }

  Widget _simpleItem(SimpleItem simpleItem) {
    return new ListTile(
        onTap: () {
          handleNavigationDrawerClicks(simpleItem.title, true);
        },
        leading: new Icon(
          simpleItem.leadingIconData,
          size: 25.0,
          color: Colors.blueGrey[400],
        ),
        title: new Text(
          simpleItem.title,
          style: new TextStyle(
              color: Colors.blueGrey[400],
              fontWeight: FontWeight.normal,
              fontSize: 18.0),
        ));
  }

  void handleNavigationDrawerClicks(String whatToDo, bool closeDrawer) {
    setState(() {
      if (closeDrawer) {
        Navigator.pop(context);
      }
      if (whatToDo != DrawerTitles.TAPPED_ON_HEADER) {
        Type type = dashBoardWidget.runtimeType;
        if (title == whatToDo) {
          if (type == ContactsPage) {
            ContactsPage contactPage = dashBoardWidget as ContactsPage;
            //          contactPage.reloadContactList();
          } else if (type == DeletedContactsPage) {
            DeletedContactsPage deletedContactsPage =
                dashBoardWidget as DeletedContactsPage;
            deletedContactsPage.reloadDeletedContacts();
          } else if (type == LogsPage) {
            LogsPage logsPage = dashBoardWidget as LogsPage;
            logsPage.reloadLogs();
          }
        } else {
          title = whatToDo;
          switch (title) {
/*
            case DrawerTitles.CREATE_CONTACT:
              _navigateToCreateContactPage(context);
              break;
*/
            case DrawerTitles.CONTACTS:
              progressDialog
                  .showProgressWithText(ProgressDialogTitles.LOADING_CONTACTS);
              loadContacts();
              break;
            case DrawerTitles.DELETED_CONTACTS:
              progressDialog.showProgressWithText(
                  ProgressDialogTitles.LOADING_DELETED_CONTACTS);
              loadDeletedContacts();
              break;
/*
            case DrawerTitles.SEARCH_CONTACTS:
              navigateToPage(new SearchContactsPage());
              break;
*/
            case DrawerTitles.LOGS:
              progressDialog
                  .showProgressWithText(ProgressDialogTitles.LOADING_LOGS);
              loadLogs();
              break;
            case DrawerTitles.GO_BACK:
              Navigator.pop(context);
              break;
          }
        }
      } else {
        showSnackBar(SnackBarText.TAPPED_ON_API_HEADER);
      }
    });
  }

  void loadContacts() async {
    //  EventObject eventObjectContacts = await getContacts();
    EventObject eventObjectContacts;
    eventsCapturing(eventObjectContacts);
  }

  void loadDeletedContacts() async {
    //   EventObject eventObjectDeleteContacts = await getDeletedContacts();
    EventObject eventObjectDeleteContacts;
    eventsCapturing(eventObjectDeleteContacts);
  }

  void loadLogs() async {
    //  EventObject eventObjectLogs = await getLogs();
    EventObject eventObjectLogs;
    eventsCapturing(eventObjectLogs);
  }

  void eventsCapturing(EventObject eventObject) {
    if (this.mounted) {
      setState(() {
        progressDialog.hide();
        switch (eventObject.id) {
          case Events.READ_CONTACTS_SUCCESSFUL:
            dashBoardWidget = new ContactsPage();
            showSnackBar(SnackBarText.CONTACTS_LOADED_SUCCESSFULLY);
            break;
          case Events.NO_CONTACTS_FOUND:
            dashBoardWidget = new ContactsPage();
            showSnackBar(SnackBarText.NO_CONTACTS_FOUND);
            break;

          case Events.READ_LOGS_SUCCESSFUL:
            dashBoardWidget = new LogsPage(logs: eventObject.object);
            showSnackBar(SnackBarText.LOGS_LOADED_SUCCESSFULLY);
            break;
          case Events.NO_LOGS_FOUND:
            dashBoardWidget = new LogsPage();
            showSnackBar(SnackBarText.NO_LOGS_FOUND);
            break;

          case Events.READ_DELETED_CONTACTS_SUCCESSFUL:
            dashBoardWidget =
                new DeletedContactsPage(deletedContacts: eventObject.object);
            showSnackBar(SnackBarText.DELETED_CONTACTS_LOADED_SUCCESSFULLY);
            break;
          case Events.NO_DELETED_CONTACTS_FOUND:
            dashBoardWidget = new DeletedContactsPage();
            showSnackBar(SnackBarText.NO_DELETED_CONTACTS_FOUND);
            break;

          case Events.NO_INTERNET_CONNECTION:
            dashBoardWidget = NoContentFound(
                SnackBarText.NO_INTERNET_CONNECTION, Icons.signal_wifi_off);
            showSnackBar(SnackBarText.NO_INTERNET_CONNECTION);
        }
      });
    }
  }

  void showSnackBar(String textToBeShown) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(textToBeShown),
    ));
  }

  void navigateToPage(StatefulWidget statefulWidget) {
    if (this.mounted) {
      setState(() {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => statefulWidget),
        );
      });
    }
  }
}
