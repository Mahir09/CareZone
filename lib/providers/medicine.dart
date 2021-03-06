import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Medicine with ChangeNotifier {
  String id;
  String title;
  String description;
  TimeOfDay alarmTime;
  var imageurl;

  int quantity;
  bool isTaken;
  bool isMorning;
  bool isAfternoon;
  bool isEvening;
  String userId;
  int typeIndex;

  Medicine({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.alarmTime,
    @required this.imageurl,
    @required this.quantity,
    this.userId,
    this.isTaken = false,
    this.isMorning = false,
    this.isAfternoon = false,
    this.isEvening = false,
    @required this.typeIndex,
  });

  Future<void> updateCount(String id, String token) async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/medicines/$id.json?auth=$token';
    try {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'quantity': quantity - 1,
          }));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}