import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_exceptions.dart';

class LogbookItem {
  final String id;
  final String title;
  final DateTime day;

  LogbookItem({
    @required this.id,
    @required this.title,
    @required this.day,
  });
}

class LogBookProvider with ChangeNotifier {
  List<LogbookItem> _items = [];
  final String authToken;
  final String userID;

  LogBookProvider(this.authToken, this.userID, this._items);

  List<LogbookItem> get items {
    return [..._items];
  }

  int get medCount {
    return _items.length;
  }

  Future<void> fetchAndSetLogItems() async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/logitems/$userID.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<LogbookItem> _loadedLogItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((logID, logData) => {
          _loadedLogItems.add(LogbookItem(
              day: DateTime.parse(logData['dateTime']),
              id: logID,
              title: logData['title']))
        });
    _items = _loadedLogItems.reversed.toList();
  }

  Future<void> addItem(String id, String title, DateTime dateTime) async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/logitems/$userID.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': title,
            'dateTime': DateTime(dateTime.month, dateTime.day, dateTime.hour,
                    dateTime.minute)
                .toIso8601String(), //FIX this
          }));
      _items.add(LogbookItem(
          id: json.decode(response.body)['name'],
          title: title,
          day: json.decode(response.body)['dateTime']));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteLogItem(String id) async {
    final url =
        'https://medrem-38ff2-default-rtdb.firebaseio.com/logitems/$userID/$id.json?auth=$authToken';
    final existingLogIndex = _items.indexWhere((log) => log.id == id);
    var existingLog = _items[existingLogIndex];

    _items.removeAt(existingLogIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingLogIndex, existingLog);
      notifyListeners();
      throw CustomExceptions('Something went wrong, Could not delete');
    }
    existingLog = null;
  }
}
