import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'plan.dart';
import 'finish.dart';
import 'print.dart';
import 'glue.dart';
import 'die.dart';
import '../providers/planClass.dart';
import '../providers/printClass.dart';
import '../providers/glueClass.dart';
import '../providers/finishClass.dart';
import '../providers/dieClass.dart';
import 'package:provider/provider.dart';
import '../providers/planLastAct.dart';
import '../providers/printLastAct.dart';
import '../providers/glueLastAct.dart';
import '../providers/dieLastAct.dart';
import '../providers/finishLastAct.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dash';
  @override
  _DashboardState createState() => _DashboardState();
}

var planCount = 0;
var printCount = 0;
var glueCount = 0;
var finishCount = 0;
var dieCount = 0;
var totalCount = 0;
var lastPlanid = '';

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  var _isInit = true;
  String lastActPlanId = 'loading...';
  String lastActPlanStart = 'loading...';
  String lastActPlanEnd = 'loading...';

  String lastActPrintId = 'loading...';
  String lastActPrintStart = 'loading...';
  String lastActPrintEnd = 'loading...';

  String lastActGlueId = 'loading...';
  String lastActGlueStart = 'loading...';
  String lastActGlueEnd = 'loading...';

  String lastActDieId = 'loading...';
  String lastActDieStart = 'loading...';
  String lastActDieEnd = 'loading...';

  String lastActFinishId = 'loading...';
  String lastActFinishStart = 'loading...';
  String lastActFinishEnd = 'loading...';
  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Plans>(context, listen: false).fetchItems();
      Provider.of<Prints>(
        context,
        listen: false,
      ).fetchItems();
      Provider.of<Diess>(context, listen: false).fetchItems();
      Provider.of<Glues>(
        context,
        listen: false,
      ).fetchItems();
      Provider.of<Finishs>(context, listen: false).fetchItems();
      Provider.of<LastActFunc>(context, listen: false).fetchItems();
      lastActCount =
          Provider.of<LastActFunc>(context, listen: false).actItems.length;
      var lst1 = Provider.of<LastActFunc>(context);
      Provider.of<LastActFunc>(context).fetchItems().then((_) {
        lastActPlanId = lst1.actItems[lst1.actItems.length - 1].jobId;
        lastActPlanStart = lst1.actItems[lst1.actItems.length - 1].startDateTime;
        lastActPlanEnd = lst1.actItems[lst1.actItems.length - 1].endDateTime;
      });

      var lst2 = Provider.of<LastActFunc2>(context);
      Provider.of<LastActFunc2>(context).fetchItems().then((_) {
        lastActPrintId = lst2.actItems[lst2.actItems.length - 1].jobId;
        lastActPrintStart = lst2.actItems[lst2.actItems.length - 1].startDateTime;
        lastActPrintEnd = lst2.actItems[lst2.actItems.length - 1].endDateTime;
      });

      var lst3 = Provider.of<LastActFunc3>(context);
      Provider.of<LastActFunc3>(context).fetchItems().then((_) {
        lastActDieId = lst3.actItems[lst3.actItems.length - 1].jobId;
        lastActDieStart = lst3.actItems[lst3.actItems.length - 1].startDateTime;
        lastActDieEnd = lst3.actItems[lst3.actItems.length - 1].endDateTime;
      });

      var lst4 = Provider.of<LastActFunc4>(context);
      Provider.of<LastActFunc4>(context).fetchItems().then((_) {
        lastActGlueId = lst4.actItems[lst4.actItems.length - 1].jobId;
        lastActGlueStart = lst4.actItems[lst4.actItems.length - 1].startDateTime;
        lastActGlueEnd = lst4.actItems[lst4.actItems.length - 1].endDateTime;
      });

      var lst5 = Provider.of<LastActFunc5>(context);
      Provider.of<LastActFunc5>(context).fetchItems().then((_) {
        lastActPlanId = lst5.actItems[lst5.actItems.length - 1].jobId;
        lastActFinishStart = lst5.actItems[lst5.actItems.length - 1].startDateTime;
        lastActFinishEnd = lst5.actItems[lst5.actItems.length - 1].endDateTime;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int lastActCount;
  @override
  Widget build(BuildContext context) {
    planCount = Provider.of<Plans>(context, listen: false).items.length;
    printCount = Provider.of<Prints>(context, listen: false).items.length;
    dieCount = Provider.of<Diess>(context, listen: false).items.length;
    glueCount = Provider.of<Glues>(context, listen: false).items.length;
    finishCount = Provider.of<Finishs>(context, listen: false).items.length;
    totalCount = planCount + printCount + dieCount + glueCount + finishCount;
    return Scaffold(
      body: Container(
        color: Colors.black87,
        // padding: EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(400),
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(10),
                ),
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 25),
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Production App',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Image.asset('assets/images/dashgear2.gif'),
                      ],
                    )),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Chip(
                      backgroundColor: Colors.black87,
                      elevation: 5,
                      label: Text(
                        'Total Jobs',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(totalCount.toString()),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(PlanPage.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white54,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Image.asset('assets/images/plan.png')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    child: Text(Provider.of<Plans>(context)
                                        .items
                                        .length
                                        .toString()),
                                  ),
                                  label: Text('Active'),
                                ),
                                Text(
                                  'Plan(s)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(children: [
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.blue,
                                      ),
                                      Text(
                                        'Last Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Job: ' + lastActPlanId),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text(
                                        'From: ' + lastActPlanStart,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Till: ' + lastActPlanEnd,
                                          style: TextStyle(fontSize: 12)),
                                    ]),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(PrintPage.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white54,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child:
                                      Image.asset('assets/images/print.png')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    child: Text(Provider.of<Prints>(context)
                                        .items
                                        .length
                                        .toString()),
                                  ),
                                  label: Text('Active'),
                                ),
                                Text(
                                  'Print(s)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(children: [
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.blue,
                                      ),
                                      Text(
                                        'Last Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Job: ' + lastActPrintId),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text(
                                        'From: ' + lastActPrintStart,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Till: ' + lastActPrintEnd,
                                          style: TextStyle(fontSize: 12)),
                                    ]),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(DiePage.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white54,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                      'assets/images/diecutting.png')),
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    child: Text(Provider.of<Diess>(context)
                                        .items
                                        .length
                                        .toString()),
                                  ),
                                  label: Text('Active'),
                                ),
                                Text(
                                  'Die-Cutting',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(children: [
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.blue,
                                      ),
                                      Text(
                                        'Last Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Job: ' + lastActDieId),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text(
                                        'From: ' + lastActDieStart,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Till: ' + lastActDieEnd,
                                          style: TextStyle(fontSize: 12)),
                                    ]),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(GluePage.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white54,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Image.asset('assets/images/glue.png')),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Chip(
                                  avatar: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    child: Text(Provider.of<Glues>(context)
                                        .items
                                        .length
                                        .toString()),
                                  ),
                                  label: Text('Active'),
                                ),
                                Text(
                                  'Glues',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(children: [
                                      CircleAvatar(
                                        radius: 8,
                                        backgroundColor: Colors.blue,
                                      ),
                                      Text(
                                        'Last Activity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Job: ' + lastActGlueId),
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text(
                                        'From: ' + lastActGlueStart,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                    Row(children: [
                                      // CircleAvatar(
                                      //   radius: 8,
                                      //   backgroundColor: Colors.green,
                                      // ),
                                      Text('Till: ' + lastActGlueEnd,
                                          style: TextStyle(fontSize: 12)),
                                    ]),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(FinishPage.routeName),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                            topLeft: Radius.circular(160),
                            bottomLeft: Radius.circular(10),
                          ),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        color: Colors.white54,
                                      ),
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                          'assets/images/finish.png')),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).errorColor,
                                        child: Text(
                                            Provider.of<Finishs>(context)
                                                .items
                                                .length
                                                .toString()),
                                      ),
                                      label: Text('Active'),
                                    ),
                                    Text(
                                      'Finishing(s)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(children: [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.blue,
                                          ),
                                          Text(
                                            'Last Activity',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ]),
                                        Row(children: [
                                          // CircleAvatar(
                                          //   radius: 8,
                                          //   backgroundColor: Colors.green,
                                          // ),
                                          Text('Job: ' + lastActFinishId),
                                        ]),
                                        Row(children: [
                                          // CircleAvatar(
                                          //   radius: 8,
                                          //   backgroundColor: Colors.green,
                                          // ),
                                          Text(
                                            'From: ' + lastActFinishStart,
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ]),
                                        Row(children: [
                                          // CircleAvatar(
                                          //   radius: 8,
                                          //   backgroundColor: Colors.green,
                                          // ),
                                          Text('Till: ' + lastActFinishEnd,
                                              style: TextStyle(fontSize: 12)),
                                        ]),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
