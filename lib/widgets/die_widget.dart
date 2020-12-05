import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../screens/addDie.dart';
import '../providers/dieClass.dart';

class DieWidget extends StatelessWidget {
  final String id;
  final String jobId;
  final String machine;
  final String status;
  final int quantity;
  final String startDateTime;
  final String endDateTime;
  final int waitingHours;
  final int reworkQuantity;
  final String comments;

  DieWidget(
      this.id,
      this.jobId,
      this.machine,
      this.status,
      this.quantity,
      this.startDateTime,
      this.endDateTime,
      this.waitingHours,
      this.reworkQuantity,
      this.comments);

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
              children: <Widget>[
                Icon(Icons.track_changes),
                Text("Machine : "),
                Text(
                  machine,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                            .pushNamed(AddDie.routeName, arguments: id);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () {
                        Provider.of<Diess>(context, listen: false)
                            .deleteDie(id);
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.timelapse),
                    Text("Waiting Hours : "),
                    Text(
                      waitingHours.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.queue),
                    Text("Rework Quantity : "),
                    Text(
                      reworkQuantity.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
            Row(children:<Widget> [
                Icon(Icons.queue),
                    Text("Comment : "),
                    Text(
                      comments,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )
            ],),
          ],
        ),
      ),
    );
  }
}
