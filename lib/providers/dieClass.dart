import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DieItem with ChangeNotifier {
  final String id;
  final String jobId;
  final String machine;
  final String status = 'Die-Cutting';
  final int quantity;
  final String startDateTime;
  final String endDateTime;
  final int waitingHours;
  final int reworkQuantity;
  final String comments;

  DieItem(
      {@required this.id,
      @required this.jobId,
      @required this.machine,
      @required this.quantity,
      @required this.startDateTime,
      @required this.endDateTime,
      @required this.waitingHours,
      @required this.reworkQuantity,
      @required this.comments});
}

class Diess with ChangeNotifier {
  List<DieItem> _items = [];

  List<DieItem> get items {
    return [..._items];
  }

  DieItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addNewDie(DieItem diee) async {
    const url = 'https://productionapp-73d41.firebaseio.com/dieing.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'jobId': diee.jobId,
            'machine': diee.machine,
            'status': diee.status,
            'quantity': diee.quantity,
            'startDateTime': diee.startDateTime,
            'endDateTime': diee.endDateTime,
            'waitingHours': diee.waitingHours,
            'reworkQuantity': diee.reworkQuantity,
            'comments': diee.comments
          }));
      final newDie = DieItem(
          id: json.decode(response.body)['name'],
          jobId: diee.jobId,
          machine: diee.machine,
          quantity: diee.quantity,
          startDateTime: diee.startDateTime,
          endDateTime: diee.endDateTime,
          waitingHours: diee.waitingHours,
          reworkQuantity: diee.reworkQuantity,
          comments: diee.comments);

      _items.add(newDie);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/dieing.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<DieItem> loadeddie = [];
      extractedData.forEach((dieId, dieData) {
        loadeddie.add(DieItem(
            id: dieId,
            jobId: dieData['jobId'],
            machine: dieData['machine'],
            quantity: dieData['quantity'],
            startDateTime: dieData['startDateTime'],
            endDateTime: dieData['endDateTime'],
            waitingHours: dieData['waitingHours'],
            reworkQuantity: dieData['reworkQuantity'],
            comments: dieData['comments']));
      });
      //print(json.decode(response.body));
      _items = loadeddie;
      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }

  void deleteDie(String id) {
    _items.removeWhere((element) => element.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/dieing/$id.json';
    http.delete(url);
    notifyListeners();
  }

  Future<void> updateDie(String id, DieItem diee) async {
    final dieIndex = _items.indexWhere((e) => e.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/dieing/$id.json';
    await http.patch(url,
        body: json.encode({
          'jobId': diee.jobId,
          'status': diee.status,
          'quantity': diee.quantity,
          'startDateTime': diee.startDateTime,
          'endDateTime': diee.endDateTime,
          'waitingHours': diee.waitingHours,
          'reworkQuantity': diee.reworkQuantity,
          'comments': diee.comments
        }));
    _items[dieIndex] = diee;
    notifyListeners();
  }
}
