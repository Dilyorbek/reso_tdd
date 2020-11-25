import 'package:flutter/material.dart';

Widget buildWidgetWrapper(Widget testWidget, {bool isPage = false}) =>  new MaterialApp(home: isPage ? testWidget : Scaffold(body:
    testWidget));