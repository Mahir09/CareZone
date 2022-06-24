import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './medicine.dart';
import '../widgets/custom_exceptions.dart';

class MedicineList with ChangeNotifier {
  List<Medicine> _items = [];

  final String authToken;
  final String userId;

  MedicineList(this.authToken, this.userId, this._items);

  var showMorningOnly = false;
  var showAfternoonOnly = false;
  var showEveningOnly = false;

  List<Medicine> get items {
    return [..._items];
  }

  Medicine findById(String id) {
    return _items.firstWhere((med) => med.id == id, orElse: () => null);
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  Future<String> fetchUser() async {
    const url =
        'https://flutter-carezone-default-rtdb.firebaseio.com/users.json';
    try {
      final response = await http.get(Uri.parse(url));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      String userid = fetchedData['id'];
      print(userid);
      return userid;
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetMedicines() async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/medicines.json?auth=$authToken&orderBy="userId"&equalTo="$userId"';
    try {
      final response = await http.get(Uri.parse(url));
      print("Response : " + response.body);
      final List<Medicine> loadedMeds = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print("Null");
        return;
      }
      extractedData.forEach((medID, medData) {
        loadedMeds.add(Medicine(
          id: medID,
          title: medData['title'],
          alarmTime: stringToTimeOfDay(medData['alarmTime']),
          imageurl: medData['imageUrl'],
          description: medData['description'],
          quantity: medData['quantity'],
          typeIndex: medData['typeIndex'],
          //userId: medData['userId'],
        ));
      });
      _items = loadedMeds;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Medicine med) async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/medicines.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': med.title,
          'description': med.description,
          'alarmTime': formatTimeOfDay(med.alarmTime)?.toString(),
          'quantity': med.quantity,
          'imageUrl': med.imageurl,
          'userId': userId,
          'typeIndex': med.typeIndex,
        }),
      );
      final newMed = Medicine(
        id: json.decode(response.body)['name'],
        title: med.title,
        description: med.description,
        alarmTime: med.alarmTime,
        imageurl: med.imageurl,
        quantity: med.quantity,
        typeIndex: med.typeIndex,
      );
      _items.add(newMed);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteItem(String id) async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/medicines/$id.json?auth=$authToken';
    final existingMedIndex = _items.indexWhere((med) => med.id == id);
    var existingMed = _items[existingMedIndex];

    _items.removeAt(existingMedIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingMedIndex, existingMed);
      notifyListeners();
      throw CustomExceptions('Something went wrong, Could not delete');
    }
    existingMed = null;
  }

  Future<void> editAndSetMedicines(String id, Medicine editedMed) async {
    final medIndex = _items.indexWhere((med) => med.id == id);
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/medicines/$id.json?auth=$authToken';
    if (medIndex >= 0) {
      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': editedMed.title,
              'quantity': editedMed.quantity,
              'alarmTime': formatTimeOfDay(editedMed.alarmTime),
              'description': editedMed.description,
              'typeIndex': editedMed.typeIndex,
            }));
        _items[medIndex] = editedMed;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }
}
