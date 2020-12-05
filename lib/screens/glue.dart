import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:production_app/screens/addGlue.dart';
import 'package:provider/provider.dart';
import '../providers/glueClass.dart';
import '../widgets/glue_widget.dart';


class GluePage extends StatelessWidget {
  static const routeName='/glue-page';
  Future<void> _refreshData(BuildContext context) async {
      Provider.of<Glues>(context,listen: false).fetchItems();
    }
  @override
  Widget build(BuildContext context) {
    final glueData=Provider.of<Glues>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Glueing'),
          actions: <Widget>[
            Row(
              children: [
                Text('Add New Glueing'),
                IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AddGlue.routeName))
              ],
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: glueData.items.length,
            itemBuilder: (_, i) => Column(children: <Widget>[
              PrintWidget(
                  glueData.items[i].id,
                  glueData.items[i].jobId,
                  glueData.items[i].machine,
                  glueData.items[i].status,
                  glueData.items[i].quantity,
                  glueData.items[i].startDateTime,
                  glueData.items[i].endDateTime,
                  glueData.items[i].waitingHours,
                  glueData.items[i].reworkQuantity,
                  glueData.items[i].comments,
              ),
             // Divider(),
            ]
            ),
          ),
        ),
        ));
  }
}
