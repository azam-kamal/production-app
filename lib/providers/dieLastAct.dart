import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LastActivity with ChangeNotifier {
  final String id;
  final String jobId;
  final String startDateTime;
  final String endDateTime;

  LastActivity(
      {@required this.id,
      @required this.jobId,
      @required this.startDateTime,
      @required this.endDateTime});
}

class LastActFunc3 with ChangeNotifier {
  List<LastActivity> _actItems = [];

  List<LastActivity> get actItems {
    return [..._actItems];
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/dieing.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<LastActivity> loadedPlan = [];
      extractedData.forEach((planId, planData) {
        loadedPlan.add(LastActivity(
          id: planId,
          jobId: planData['jobId'],
          startDateTime: planData['startDateTime'],
          endDateTime: planData['endDateTime'],
        ));
      });

      _actItems = loadedPlan;
      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }
}
