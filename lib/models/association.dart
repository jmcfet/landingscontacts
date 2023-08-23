import 'dart:async';

import 'package:Contacts/utils/constants.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'contact.g.dart';

@JsonSerializable()
class Association {
  String AssnCode;
  String AssnName;
  String AssnShortName;

  Association({
    this.AssnCode,
    this.AssnName,
    this.AssnShortName,
  });

  static Future<List<Association>> fromContactJson(List<dynamic> json) async {
    print("json " + json.toString());
    List<Association> assocList = [];

    for (var assoc in json) {
      assocList.add(new Association(
        AssnCode: assoc['assnCode'],
        AssnName: assoc['assnName'] ?? '',
        AssnShortName: assoc['assnShortName'] ?? '',
      ));
    }
    return assocList;
  }
}
