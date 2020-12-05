import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_app/screens/addFinish.dart';
import 'package:provider/provider.dart';
import '../providers/finishClass.dart';
import '../widgets/finish_widget.dart';


class FinishPage extends StatelessWidget {
  static const routeName='/finish-page';
  Future<void> _refreshData(BuildContext context) async {
      Provider.of<Finishs>(context,listen: false).fetchItems();
    }
  @override
  Widget build(BuildContext context) {
    final finishData=Provider.of<Finishs>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Finishing'),
          actions: <Widget>[
            Row(
              children: [
                Text('Add New Finishing'),
                IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AddFinish.routeName))
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: finishData.items.length,
            itemBuilder: (_, i) => Column(children: <Widget>[
              FinishWidget(
                  finishData.items[i].id,
                  finishData.items[i].jobId,
                  finishData.items[i].machine,
                  finishData.items[i].status,
                  finishData.items[i].quantity,
                  finishData.items[i].startDateTime,
                  finishData.items[i].endDateTime,
                  finishData.items[i].waitingHours,
                  finishData.items[i].reworkQuantity,
                  finishData.items[i].comments,
              ),
             // Divider(),
            ]
            ),
          ),
        ),
        ));
  }
}
