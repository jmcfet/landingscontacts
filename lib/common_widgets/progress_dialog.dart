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
 *
 */

import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  Color backgroundColor;
  Color color;
  Color containerColor;
  double borderRadius;
  String text;
  bool opacity;
  ProgressDialogState? progressDialogState;

  ProgressDialog(
      {this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text = "",
      this.opacity = false});

  @override
  createState() => progressDialogState = new ProgressDialogState(
      backgroundColor: this.backgroundColor,
      color: this.color,
      containerColor: this.containerColor,
      borderRadius: this.borderRadius,
      text: this.text,
      opacity: this.opacity);

  void hide() {
    progressDialogState!.hide();
  }

  void show() {
    progressDialogState!.show();
  }

  void showProgressWithText(String title) {
    progressDialogState!.showProgressWithText(title);
  }

  static Widget getProgressDialog(String title, bool opacity) {
    return new ProgressDialog(
        backgroundColor: Colors.black12,
        color: Colors.white,
        containerColor: Colors.blueGrey,
        borderRadius: 5.0,
        text: title,
        opacity: opacity);
  }
}

class ProgressDialogState extends State<ProgressDialog> {
  Color backgroundColor;
  Color color;
  Color containerColor;
  double borderRadius;
  String text ;
  bool opacity = true;

  ProgressDialogState(
      {this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text = "",
      this.opacity = false});

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: !opacity
            ? null
            : new Opacity(
                opacity: opacity ? 1.0 : 0.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                      child: new Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: new BoxDecoration(
                            color: containerColor,
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(borderRadius))),
                      ),
                    ),
                    new Center(
                      child: _getCenterContent(),
                    )
                  ],
                ),
              ));
  }

  Widget _getCenterContent() {
    if (text == null || text!.isEmpty) {
      return _getCircularProgress();
    }

    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCircularProgress(),
          new Container(
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: new Text(
              text,
              style: new TextStyle(color: color),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation(color));
  }

  void hide() {
    setState(() {
      opacity = false;
    });
  }

  void show() {
    setState(() {
      opacity = true;
    });
  }

  void showProgressWithText(String title) {
    setState(() {
      opacity = true;
      text = title;
    });
  }
}
