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

import 'package:Contacts/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'contact.g.dart';

@JsonSerializable()
class Contact  {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  
  String? contactImage;

  Contact(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.address,
      
      this.contactImage});

  static Future<List<Contact>> fromContactJson(List<dynamic> json) async {
    print("json " + json.toString());
    List<Contact> contactList =  [];

    for (var contact in json) {
      contactList.add(new Contact(
        id: contact['personId'],
        name: contact['name'] ?? '',
        phone: contact['phone1'] ?? '',
        email: contact['emailAddress'] ?? '',
        address: contact['address'] ?? '',
        
        
      ));
    }
    return contactList;
  }

  

  Map toMap() {
    Map<String, dynamic> contactMap = <String, dynamic>{
      ContactTable.NAME: name,
      ContactTable.PHONE: phone,
      ContactTable.EMAIL: email,
      ContactTable.ADDRESS: address,
      ContactTable.CONTACT_IMAGE: contactImage,
    };

    return contactMap;
  }

  
}
