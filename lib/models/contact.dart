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


import 'package:json_annotation/json_annotation.dart';

//part 'contact.g.dart';

@JsonSerializable()
class Contact  {
  int? id;
  String? name;

  String? email;
  String? address;
  bool? IncludeEmail;
  bool? IncludePhone;
  String? Phone1;
  String? Phone1Type;
  String? Phone2;
  String? Phone2Type;
  String? association;
//  bool? lrcMember;
  String? contactImage;

  Contact(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.IncludeEmail,
      this.IncludePhone,
      this. Phone1,
      this.Phone1Type,
      this. Phone2,
      this. Phone2Type,
   //   this.lrcMember,
      this.association,
      this.contactImage});

  static Future<List<Contact>> fromContactJson(List<dynamic> json) async {
    print("json " + json.toString());
    List<Contact> contactList =  [];

    for (var contact in json) {
      contactList.add(new Contact(
        id: contact['personId'],
        name: contact['name'] ?? '',
        Phone1: contact['phone1'] ?? '',
        email: contact['emailAddress'] ?? '',
        address: contact['address'] ?? '',
        Phone2: contact['phone2'] ?? '',
        Phone1Type: contact['phone1Type'] ?? '',
        Phone2Type: contact['phone2Type'] ?? '',
        IncludeEmail: contact['includeEmail'] ?? false,
        IncludePhone: contact['includePhone'] ?? false,
        association: contact['association'] ?? '',
     //   lrcMember: contact['lrcMember'] ?? '',
      ));
    }
    return contactList;
  }

  

  

  
}
