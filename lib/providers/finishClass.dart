import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinishItem with ChangeNotifier {
  final String id;
  final String jobId;
  final String machine;
  final String status = 'Finish-Cutting';
  final int quantity;
  final String startDateTime;
  final String endDateTime;
  final int waitingHours;
  final int reworkQuantity;
  final String comments;

  FinishItem(
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

class Finishs with ChangeNotifier {
  List<FinishItem> _items = [];

  List<FinishItem> get items {
    return [..._items];
  }

  FinishItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addNewFinish(FinishItem finishe) async {
    const url = 'https://productionapp-73d41.firebaseio.com/finishing.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'jobId': finishe.jobId,
            'machine': finishe.machine,
            'status': finishe.status,
            'quantity': finishe.quantity,
            'startDateTime': finishe.startDateTime,
            'endDateTime': finishe.endDateTime,
            'waitingHours': finishe.waitingHours,
            'reworkQuantity': finishe.reworkQuantity,
            'comments': finishe.comments
          }));
      final newFinish = FinishItem(
          id: json.decode(response.body)['name'],
          jobId: finishe.jobId,
          machine: finishe.machine,
          quantity: finishe.quantity,
          startDateTime: finishe.startDateTime,
          endDateTime: finishe.endDateTime,
          waitingHours: finishe.waitingHours,
          reworkQuantity: finishe.reworkQuantity,
          comments: finishe.comments);

      _items.add(newFinish);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/finishing.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<FinishItem> loadedfinish = [];
      extractedData.forEach((finishId, finishData) {
        loadedfinish.add(FinishItem(
            id: finishId,
            jobId: finishData['jobId'],
            machine: finishData['machine'],
            quantity: finishData['quantity'],
            startDateTime: finishData['startDateTime'],
            endDateTime: finishData['endDateTime'],
            waitingHours: finishData['waitingHours'],
            reworkQuantity: finishData['reworkQuantity'],
            comments: finishData['comments']));
      });
      print(json.decode(response.body));
      _items = loadedfinish;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deleteFinish(String id) {
    _items.removeWhere((element) => element.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/finishing/$id.json';
    http.delete(url);
    notifyListeners();
  }

  Future<void> updateFinish(String id, FinishItem finishe) async {
    final finishIndex = _items.indexWhere((e) => e.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/finishing/$id.json';
    await http.patch(url,
        body: json.encode({
          'jobId': finishe.jobId,
          'status': finishe.status,
          'quantity': finishe.quantity,
          'startDateTime': finishe.startDateTime,
          'endDateTime': finishe.endDateTime,
          'waitingHours': finishe.waitingHours,
          'reworkQuantity': finishe.reworkQuantity,
          'comments': finishe.comments
        }));
    _items[finishIndex] = finishe;
    notifyListeners();
  }
}
