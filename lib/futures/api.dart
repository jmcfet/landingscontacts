
import 'dart:async';
import 'dart:convert';

import 'package:Contacts/models/base/event_object.dart';
import 'package:Contacts/models/contact.dart';
import 'package:Contacts/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../models/association.dart';


Future<EventObject> getAssociations() async {
  try {
    
  
   
    final response = await http.get(Uri.parse(APIConstants.READ_ASSOCS));
   
      if (response.statusCode == APIResponseCode.SC_OK) {
        final responseJson = json.decode(response.body);
        List<Association> contactList = await Association.fromContactJson(responseJson);
        return new EventObject(
            id: Events.READ_CONTACTS_SUCCESSFUL, object: contactList);
      } else {
        return new EventObject(id: Events.NO_CONTACTS_FOUND);
      }
    
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}
Future<EventObject> getAssociationResidents(assoc) async {
  try {
      
    
    final response = await http.get(Uri.parse(APIConstants.READ_CONTACTS + assoc));
    
      if (response.statusCode == APIResponseCode.SC_OK) {
        final responseJson = json.decode(response.body);
        List<Contact> contactList = await Contact.fromContactJson(responseJson);
        return new EventObject(
            id: Events.READ_CONTACTS_SUCCESSFUL, object: contactList);
      } else {
        return new EventObject(id: Events.NO_CONTACTS_FOUND);
      }
    
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}

Future<EventObject> getSearchResults(search,cat) async {
  try {
    
       
    final response = await http.get( Uri.parse(APIConstants.SEARCH_CONTACT + search + "&cat=" + cat));
   
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK) {
        final responseJson = json.decode(response.body);
        List<Contact> contactList = await Contact.fromContactJson(responseJson);
        return new EventObject(
            id: Events.READ_CONTACTS_SUCCESSFUL, object: contactList);
      } else {
        return new EventObject(id: Events.NO_CONTACTS_FOUND);
      }
    } else {
      return new EventObject();
    }
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}





Future<EventObject> saveContactUsingRestAPI(Contact contact) async {
  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;

    final response = await http.post(Uri.parse(APIConstants.CREATE_CONTACT),
     //   body: json.encode(contact.toJson()),
        encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_CREATED) {
        return new EventObject(id: Events.CONTACT_WAS_CREATED_SUCCESSFULLY);
      } else {
        return new EventObject(id: Events.UNABLE_TO_CREATE_CONTACT);
      }
    } else {
      return new EventObject();
    }
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}


Future<EventObject> updateContactUsingRestAPI(Contact contact) async {
  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(Uri.parse(APIConstants.UPDATE_CONTACT),
   //     body: json.encode(contact.toJson()),
        encoding: Encoding.getByName(encoding));

    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK) {
        return new EventObject(id: Events.CONTACT_WAS_UPDATED_SUCCESSFULLY);
      } else if (response.statusCode ==
          APIResponseCode.SC_INTERNAL_SERVER_ERROR) {
        return new EventObject(
            id: Events.NO_CONTACT_WITH_PROVIDED_ID_EXIST_IN_DATABASE);
      } else {
        return new EventObject(id: Events.UNABLE_TO_UPDATE_CONTACT);
      }
    } else {
      return new EventObject();
    }
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}

Future<EventObject> searchContactsUsingRestAPI(String searchQuery) async {
  try {
    final response = await http.get(Uri.parse(APIConstants.SEARCH_CONTACT + searchQuery));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK) {
        final responseJson = json.decode(response.body);
        List<Contact> searchedContactList =
            await Contact.fromContactJson(responseJson);
        return new EventObject(
            id: Events.SEARCH_CONTACTS_SUCCESSFUL, object: searchedContactList);
      } else {
        return new EventObject(
            id: Events.NO_CONTACT_FOUND_FOR_YOUR_SEARCH_QUERY);
      }
    } else {
      return new EventObject();
    }
  } catch (e) {
    print(e.toString());
    return new EventObject();
  }
}
