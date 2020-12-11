import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlanItem with ChangeNotifier {
  final String id;
  final String jobId;
  final String status = 'Planned';
  final int quantity;
  final String startDateTime;
  final String endDateTime;

  PlanItem(
      {@required this.id,
      @required this.jobId,
      @required this.quantity,
      @required this.startDateTime,
      @required this.endDateTime});
}

class Plans with ChangeNotifier {
  List<PlanItem> _items = [];

  List<PlanItem> get items {
    return [..._items];
  }

  PlanItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addNewPlan(PlanItem plan) async {
    const url = 'https://productionapp-73d41.firebaseio.com/planning.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'jobId': plan.jobId,
            'status': plan.status,
            'quantity': plan.quantity,
            'startDateTime': plan.startDateTime,
            'endDateTime': plan.endDateTime
          }));
      final newPlan = PlanItem(
          id: json.decode(response.body)['name'],
          jobId: plan.jobId,
          quantity: plan.quantity,
          startDateTime: plan.startDateTime,
          endDateTime: plan.endDateTime);

      _items.add(newPlan);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/planning.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<PlanItem> loadedPlan = [];
      extractedData.forEach((planId, planData) {
        loadedPlan.add(PlanItem(
          id: planId,
          jobId: planData['jobId'],
          quantity: planData['quantity'],
          startDateTime: planData['startDateTime'],
          endDateTime: planData['endDateTime'],
        ));
      });
      // print(json.decode(response.body));
      _items = loadedPlan;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deletePlan(String id) {
    _items.removeWhere((element) => element.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/planning/$id.json';
    http.delete(url);
    notifyListeners();
  }

  Future<void> updatePlan(String id, PlanItem plan) async {
    final planIndex = _items.indexWhere((e) => e.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/planning/$id.json';
    await http.patch(url,
        body: json.encode({
          'jobId': plan.jobId,
          'status': plan.status,
          'quantity': plan.quantity,
          'startDateTime': plan.startDateTime,
          'endDateTime': plan.endDateTime
        }));
    _items[planIndex] = plan;
    notifyListeners();
  }

  Future<List> getJobId() async {
    const url = 'https://productionapp-73d41.firebaseio.com/planning.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final loadedData = [];
      extractedData.forEach((id, data) {
        loadedData.add(data['jobId']);
      });
      return loadedData;
    } catch (error) {
      throw error;
    }
  }
}
