import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GlueItem with ChangeNotifier {
  final String id;
  final String jobId;
  final String machine;
  final String status = 'Glueing';
  final int quantity;
  final String startDateTime;
  final String endDateTime;
  final int waitingHours;
  final int reworkQuantity;
  final String comments;

  GlueItem(
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

class Glues with ChangeNotifier {
  List<GlueItem> _items = [];

  List<GlueItem> get items {
    return [..._items];
  }

  GlueItem findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addNewGlue(GlueItem gl) async {
    const url = 'https://productionapp-73d41.firebaseio.com/glueing.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'jobId': gl.jobId,
            'machine': gl.machine,
            'status': gl.status,
            'quantity': gl.quantity,
            'startDateTime': gl.startDateTime,
            'endDateTime': gl.endDateTime,
            'waitingHours': gl.waitingHours,
            'reworkQuantity': gl.reworkQuantity,
            'comments': gl.comments
          }));
      final newGlue = GlueItem(
          id: json.decode(response.body)['name'],
          jobId: gl.jobId,
          machine: gl.machine,
          quantity: gl.quantity,
          startDateTime: gl.startDateTime,
          endDateTime: gl.endDateTime,
          waitingHours: gl.waitingHours,
          reworkQuantity: gl.reworkQuantity,
          comments: gl.comments);

      _items.add(newGlue);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchItems() async {
    const url = 'https://productionapp-73d41.firebaseio.com/glueing.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<GlueItem> loadedglue = [];
      extractedData.forEach((glueId, glueData) {
        loadedglue.add(GlueItem(
            id: glueId,
            jobId: glueData['jobId'],
            machine: glueData['machine'],
            quantity: glueData['quantity'],
            startDateTime: glueData['startDateTime'],
            endDateTime: glueData['endDateTime'],
            waitingHours: glueData['waitingHours'],
            reworkQuantity: glueData['reworkQuantity'],
            comments: glueData['comments']));
      });
     // print(json.decode(response.body));
      _items = loadedglue;
      notifyListeners();
    } catch (error) {
      //throw error;
    }
  }

  void deleteGlue(String id) {
    _items.removeWhere((element) => element.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/glueing/$id.json';
    http.delete(url);
    notifyListeners();
  }

  Future<void> updateGlue(String id, GlueItem gl) async {
    final glueIndex = _items.indexWhere((e) => e.id == id);
    final url = 'https://productionapp-73d41.firebaseio.com/glueing/$id.json';
    await http.patch(url,
        body: json.encode({
          'jobId': gl.jobId,
          'status': gl.status,
          'quantity': gl.quantity,
          'startDateTime': gl.startDateTime,
          'endDateTime': gl.endDateTime,
          'waitingHours': gl.waitingHours,
          'reworkQuantity': gl.reworkQuantity,
          'comments': gl.comments
        }));
    _items[glueIndex] = gl;
    notifyListeners();
  }
}
