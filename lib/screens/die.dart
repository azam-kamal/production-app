import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_app/screens/addDie.dart';
import 'package:provider/provider.dart';
import '../providers/dieClass.dart';
import '../widgets/die_widget.dart';
import 'dashboard.dart';

class DiePage extends StatelessWidget {
  static const routeName = '/die-page';
  Future<void> _refreshData(BuildContext context) async {
    Provider.of<Diess>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final dieData = Provider.of<Diess>(context);
    return WillPopScope(
        onWillPop: () =>
            Navigator.pushReplacementNamed(context, Dashboard.routeName),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Dieing'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Dashboard.routeName);
                  }),
              actions: <Widget>[
                Row(
                  children: [
                    Text('Add New Dieing'),
                    IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AddDie.routeName))
                  ],
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: dieData.items.length,
                  itemBuilder: (_, i) => Column(children: <Widget>[
                    DieWidget(
                      dieData.items[i].id,
                      dieData.items[i].jobId,
                      dieData.items[i].machine,
                      dieData.items[i].status,
                      dieData.items[i].quantity,
                      dieData.items[i].startDateTime,
                      dieData.items[i].endDateTime,
                      dieData.items[i].waitingHours,
                      dieData.items[i].reworkQuantity,
                      dieData.items[i].comments,
                    ),
                    // Divider(),
                  ]),
                ),
              ),
            )));
  }
}
