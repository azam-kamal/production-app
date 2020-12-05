import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrintItem with ChangeNotifier {
  final String id;
  final String jobId;
  final String machine;
  final String status = 'Printed';
  final int quantity;
  final String startDateTime;
  final String endDateTime;
  final int waitingHours;
  final int reworkQuantity;
  final String comments;

  PrintItem(
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

class Prints with ChangeNotifier {
  List<PrintItem> _items = [];

  List<PrintItem> get items {
    return [..._items];
  }

  PrintItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addNewPrint(PrintItem printt) async {
    const url = 'https://productionapp-73d41.firebaseio.com/printing.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'jobId': printt.jobId,
            'machine': printt.machine,
            'status': printt.status,
            'quantity': printt.quantity,
            'startDateTime': printt.startDateTime,
            'endDateTime': printt.endDateTime,
            'waitingHours': printt.waitingHours,
            'reworkQuantity': printt.reworkQuantity,
            'comments': printt.comments
          }));
      final newPrint = PrintItem(
          id: json.decode(response.body)['name'],
          jobId: printt.jobId,
          machine: printt.machine,
          quantity: printt.quantity,
          startDateTime: printt.startDateTime,
          endDateTime: printt.endDateTime,
          waitingHours: printt.waitingHours,
          reworkQuantity: printt.reworkQuantity,
          comments: printt.comments);

      _items.add(newPrint);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/printing.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<PrintItem> loadedprint = [];
      extractedData.forEach((printId, printData) {
        loadedprint.add(PrintItem(
            id: printId,
            jobId: printData['jobId'],
            machine: printData['machine'],
            quantity: printData['quantity'],
            startDateTime: printData['startDateTime'],
            endDateTime: printData['endDateTime'],
            waitingHours: printData['waitingHours'],
            reworkQuantity: printData['reworkQuantity'],
            comments: printData['comments']));
      });
      print(json.decode(response.body));
      _items = loadedprint;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void deletePrint(String id) {
    _items.removeWhere((element) => element.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/printing/$id.json';
    http.delete(url);
    notifyListeners();
  }

  Future<void> updatePrint(String id, PrintItem printt) async {
    final printIndex = _items.indexWhere((e) => e.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/printing/$id.json';
    await http.patch(url,
        body: json.encode({
          'jobId': printt.jobId,
          'status': printt.status,
          'quantity': printt.quantity,
          'startDateTime': printt.startDateTime,
          'endDateTime': printt.endDateTime,
          'waitingHours': printt.waitingHours,
          'reworkQuantity': printt.reworkQuantity,
          'comments': printt.comments
        }));
    _items[printIndex] = printt;
    notifyListeners();
  }
}
