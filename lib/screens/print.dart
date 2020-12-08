import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_app/screens/addPrint.dart';
import 'package:provider/provider.dart';
import '../providers/printClass.dart';
import '../widgets/print_widget.dart';
import 'dashboard.dart';

class PrintPage extends StatelessWidget {
  static const routeName = '/print-page';
  Future<void> _refreshData(BuildContext context) async {
    Provider.of<Prints>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final printData = Provider.of<Prints>(context);
    return WillPopScope(
        onWillPop:(){
              Navigator.pushReplacementNamed(context,Dashboard.routeName);
                return Future.value(true);
                },
                child: Scaffold(
            appBar: AppBar(
              title: Text('Print'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Dashboard.routeName);
                  }),
              actions: <Widget>[
                Row(
                  children: [
                    Text('Add New Print'),
                    IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AddPrint.routeName))
                  ],
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => _refreshData(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: printData.items.length,
                  itemBuilder: (_, i) => Column(children: <Widget>[
                    PrintWidget(
                      printData.items[i].id,
                      printData.items[i].jobId,
                      printData.items[i].machine,
                      printData.items[i].status,
                      printData.items[i].quantity,
                      printData.items[i].startDateTime,
                      printData.items[i].endDateTime,
                      printData.items[i].waitingHours,
                      printData.items[i].reworkQuantity,
                      printData.items[i].comments,
                    ),
                    // Divider(),
                  ]),
                ),
              ),
            )));
  }
}
