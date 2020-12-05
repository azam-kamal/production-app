import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../screens/addPlan.dart';
import '../providers/planClass.dart';

class PlanWidget extends StatelessWidget {
  final String id;
  final String jobId;
  final String status;
  final int quantity;
  final String startDateTime;
  final String endDateTime;

  PlanWidget(this.id, this.jobId, this.status, this.quantity,
      this.startDateTime, this.endDateTime);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      color: Colors.blueGrey[100],
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.work,
                  size: 35,
                ),
                Text(
                  "Job-ID : ",
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  jobId,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(Icons.perm_data_setting),
                  Text("Status : "),
                  Text(
                    status,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddPlan.routeName, arguments: id);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () {
                        Provider.of<Plans>(context,listen: false).deletePlan(id);
                      },
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.assessment),
                Text("Quantity : "),
                Text(
                  quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.alarm),
                Text("From : "),
                Text(
                  startDateTime,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.alarm_on),
                Text("Till : "),
                Text(
                  endDateTime,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
