import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_app/screens/dashboard.dart';
import 'addPlan.dart';
import 'package:provider/provider.dart';
import '../providers/planClass.dart';
import '../widgets/plan_widget.dart';

class PlanPage extends StatelessWidget {
  static const routeName = '/plan-page';
  Future<void> _refreshData(BuildContext context) async {
    Provider.of<Plans>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final planData = Provider.of<Plans>(context);
    return WillPopScope(
          onWillPop:(){
              Navigator.pushReplacementNamed(context,Dashboard.routeName);
                return Future.value(true);
                },
          child: Scaffold(
          appBar: AppBar(
            title: Text('Plan'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Dashboard.routeName);
                }),
            actions: <Widget>[
              Row(
                children: [
                  Text('Add New Plan'),
                  IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AddPlan.routeName))
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => _refreshData(context),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: planData.items.length,
                itemBuilder: (_, i) => Column(children: <Widget>[
                  PlanWidget(
                    planData.items[i].id,
                    planData.items[i].jobId,
                    planData.items[i].status,
                    planData.items[i].quantity,
                    planData.items[i].startDateTime,
                    planData.items[i].endDateTime,
                  ),
                  // Divider(),
                ]),
              ),
            ),
          )),
    );
  }
}
