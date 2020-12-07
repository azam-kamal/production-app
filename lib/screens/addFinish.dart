import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/finishClass.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import '../providers/planClass.dart';

class AddFinish extends StatefulWidget {
  static const routeName = '/add-finish';

  @override
  _AddFinishState createState() => _AddFinishState();
}

class _AddFinishState extends State<AddFinish> {
  final _jobIdFocus = FocusNode();
  final _statusFocus = FocusNode();
  final _quantityFocus = FocusNode();
  final _date1Focus = FocusNode();
  final _date2Focus = FocusNode();
  final _time1Focus = FocusNode();
  final _time2Focus = FocusNode();
  var _dateTimeController = TextEditingController();
  final _timeController1 = TextEditingController();
  final _timeController2 = TextEditingController();
  var _dateTimeController2 = TextEditingController();
  final _form = GlobalKey<FormState>();

   String _myActivity;
  String _myActivity2;
  // ignore: unused_field
  String _myActivityResult;

  @override
  void dispose() {
    _dateTimeController.dispose();
    _timeController1.dispose();
    _dateTimeController2.dispose();
    _timeController2.dispose();
    _jobIdFocus.dispose();
    _statusFocus.dispose();
    _quantityFocus.dispose();
    _date1Focus.dispose();
    _date2Focus.dispose();
    _time1Focus.dispose();
    _time2Focus.dispose();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  var _isInit = true;
  var onlyInit = true;
  @override
  void initState() {
    super.initState();
    _myActivity = '';
     _myActivity2 = '';
    _myActivityResult = '';
    if (onlyInit==true) {
      itemss();
      onlyInit = false;
    }
  }

  var jobIdDropDown;
  var jobIds = [];

  void itemss() async {
    jobIdDropDown = await Provider.of<Plans>(context, listen: false).getJobId();
    for (int i = 0; i < jobIdDropDown.length; i++) {
      jobIds.add({'display': jobIdDropDown[i], 'value': jobIdDropDown[i]});
    }
    print(jobIds);
  }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final finishId = ModalRoute.of(context).settings.arguments as String;
      if (finishId != null) {
        _editedFinish =
            Provider.of<Finishs>(context, listen: false).findById(finishId);
        _initValues = {
          'jobId': _editedFinish.jobId,
          'quantity': _editedFinish.quantity.toString(),
          'waitingHours':_editedFinish.waitingHours.toString(),
          'reworkQuantity':_editedFinish.reworkQuantity.toString(),
          'comments':_editedFinish.comments,
        };
        _dateTimeController.text = _editedFinish.startDateTime.substring(0, 12);
        _dateTimeController2.text = _editedFinish.endDateTime.substring(0, 12);
        _timeController1.text = _editedFinish.startDateTime.substring(12);
        _timeController2.text = _editedFinish.endDateTime.substring(11);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectDateP1() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2040))
        .then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _dateTimeController.text =
            DateFormat.yMMMd().format(selectedDate).toString();
      });
    });
  }

  void _selectDateP2() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2040))
        .then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _dateTimeController2.text =
            DateFormat.yMMMd().format(selectedDate).toString();
      });
    });
  }

  var _editedFinish = FinishItem(
    id: null,
    jobId: '',
    machine: '',
    quantity: 0,
    startDateTime: '',
    endDateTime: '',
    waitingHours: 0,
    reworkQuantity: 0,
    comments: '',
  );
  var _initValues = {
    'jobId': '',
    'quantity': '',
    'startDate': '',
    'startTime': '',
    'endDate': '',
    'endTime': '',
    'waitingHours':'',
    'reworkQuantity':'',
    'comments':''
  };

  // ignore: unused_field
  var _isLoading = false;
  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_editedFinish.id != null) {
      Provider.of<Finishs>(context, listen: false)
          .updateFinish(_editedFinish.id, _editedFinish);
    } else {
      try {
        await Provider.of<Finishs>(context, listen: false)
            .addNewFinish(_editedFinish);
      } catch (error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error Occurred'),
                  content: Text('Something Went Wrong'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
      // finally {
      //   Scaffold.of(context).showSnackBar(SnackBar(
      //     content: Text('New Finish Added Successfully'),
      //   ));
      // }
      setState(() {
        _isLoading = false;
        _myActivityResult = _myActivity;
      });
      Navigator.of(context).pop();
    }
  }

  void _selectTimeP1() {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((selectedTime) {
      if (selectedTime == null) {
        return;
      }
      setState(() {
        _timeController1.text = selectedTime.format(context).toString();
      });
    });
  }

  void _selectTimeP2() {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    ).then((selectedTime) {
      if (selectedTime == null) {
        return;
      }
      setState(() {
        _timeController2.text = selectedTime.format(context).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Finish-Cutting'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                DropDownFormField(
                  titleText: 'Machine',
                  hintText: 'Choose one',
                  value: _myActivity,
                  onSaved: (value) {
                    setState(() {
                      _myActivity = value;
                    });

                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: value,
                        quantity: _editedFinish.quantity,
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: _editedFinish.comments);
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity = value;
                    });
                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: value,
                        quantity: _editedFinish.quantity,
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: _editedFinish.comments);
                  },
                  dataSource: [
                    {
                      "display": "Manual Packaging",
                      "value": "Manual Packaging",
                    },
                    {
                      "display": "Carton Errecting",
                      "value": "Carton Errecting",
                    },
                    {
                      "display": "Pasaban",
                      "value": "Pasaban",
                    },

                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
                DropDownFormField(
                  titleText: 'Job-Id',
                  hintText: 'Choose one',
                  value: _myActivity2,
                  onSaved: (value) {
                    setState(() {
                      _myActivity2 = value;
                    });

                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: _editedFinish.machine,
                        quantity: _editedFinish.quantity,
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: _editedFinish.comments);
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity2 = value;
                    });
                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: value,
                        quantity: _editedFinish.quantity,
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: _editedFinish.comments);
                  },
                  dataSource: jobIds,
                  textField: 'display',
                  valueField: 'value',
                ),
                TextFormField(
                  initialValue: 'Finishing',
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Status'),
                  textInputAction: TextInputAction.next,
                  focusNode: _statusFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_quantityFocus);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                TextFormField(
                  initialValue: _initValues['quantity'],
                  decoration: InputDecoration(labelText: 'Finishning Quantity'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _quantityFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_quantityFocus);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: _editedFinish.machine,
                        quantity: int.parse(value),
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: _editedFinish.comments);
                  },
                ),
                SizedBox(),
                Text('Start Date Time:'),
                SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //initialValue: _initValues['startDate'],
                        // showCursor: true,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Select Date'),
                        textInputAction: TextInputAction.next,
                        focusNode: _date1Focus,
                        //keyboardType: TextInputType.datetime,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_time1Focus);
                        },
                        onTap: () => _selectDateP1(),
                        controller: _dateTimeController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Select Date';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime: value,
                              endDateTime: _editedFinish.endDateTime,
                              waitingHours: _editedFinish.waitingHours,
                              reworkQuantity: _editedFinish.reworkQuantity,
                              comments: _editedFinish.comments);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        //initialValue: _initValues['startTime'],
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Select Time'),
                        textInputAction: TextInputAction.next,
                        focusNode: _time1Focus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_date2Focus);
                        },
                        onTap: () => _selectTimeP1(),
                        controller: _timeController1,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Select Time';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime:
                                  _editedFinish.startDateTime + ' ' + value,
                              endDateTime: _editedFinish.endDateTime,
                              waitingHours: _editedFinish.waitingHours,
                              reworkQuantity: _editedFinish.reworkQuantity,
                              comments: _editedFinish.comments);
                        },
                      ),
                    )
                  ],
                ),
                Text('End Date Time:'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //initialValue: _initValues['endDate'],
                        // showCursor: true,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Select Date'),
                        textInputAction: TextInputAction.next,
                        focusNode: _date2Focus,
                        //keyboardType: TextInputType.datetime,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_time2Focus);
                        },
                        onTap: () => _selectDateP2(),
                        controller: _dateTimeController2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Select Date';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime: _editedFinish.startDateTime,
                              endDateTime: value,
                              waitingHours: _editedFinish.waitingHours,
                              reworkQuantity: _editedFinish.reworkQuantity,
                              comments: _editedFinish.comments);
                        },
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        //initialValue: _initValues['endDate'],
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Select Time'),
                        textInputAction: TextInputAction.next,
                        focusNode: _time2Focus,
                        onFieldSubmitted: (_) {
                          //Saveform
                        },
                        onTap: () => _selectTimeP2(),
                        controller: _timeController2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Select Time';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime: _editedFinish.startDateTime,
                              endDateTime:
                                  _editedFinish.endDateTime + ' ' + value,
                              waitingHours: _editedFinish.waitingHours,
                              reworkQuantity: _editedFinish.reworkQuantity,
                              comments: _editedFinish.comments);
                        },
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                        initialValue: _initValues['waitingHours'],
                        decoration: InputDecoration(labelText: 'Waiting Hours'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        //focusNode: _quantityFocus,
                        onFieldSubmitted: (_) {
                         // FocusScope.of(context).requestFocus(_quantityFocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime: _editedFinish.startDateTime,
                              endDateTime: _editedFinish.endDateTime,
                              waitingHours: int.parse(value),
                              reworkQuantity: _editedFinish.reworkQuantity,
                              comments: _editedFinish.comments);
                        },
                      ),
                    ),
                    Expanded(
                        child: TextFormField(
                        initialValue: _initValues['reworkQuantity'],
                        decoration: InputDecoration(labelText: 'Rework Quantity'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        //focusNode: _quantityFocus,
                        onFieldSubmitted: (_) {
                         // FocusScope.of(context).requestFocus(_quantityFocus);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedFinish = FinishItem(
                              id: _editedFinish.id,
                              jobId: _editedFinish.jobId,
                              machine: _editedFinish.machine,
                              quantity: _editedFinish.quantity,
                              startDateTime: _editedFinish.startDateTime,
                              endDateTime: _editedFinish.endDateTime,
                              waitingHours: _editedFinish.waitingHours,
                              reworkQuantity: int.parse(value),
                              comments: _editedFinish.comments);
                        },
                      ),
                    ),
                  ],
                ),
                  TextFormField(
                  initialValue: _initValues['comments'],
                  decoration: InputDecoration(labelText: 'Comment'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onFieldSubmitted: (_) {
                    //FocusScope.of(context).requestFocus(_jobIdFocus);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                          return 'Please enter a commentn.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                  },
                  onSaved: (value) {
                    _editedFinish = FinishItem(
                        id: _editedFinish.id,
                        jobId: _editedFinish.jobId,
                        machine: _editedFinish.machine,
                        quantity: _editedFinish.quantity,
                        startDateTime: _editedFinish.startDateTime,
                        endDateTime: _editedFinish.endDateTime,
                        waitingHours: _editedFinish.waitingHours,
                        reworkQuantity: _editedFinish.reworkQuantity,
                        comments: value);
                  },
                ),
                
                RaisedButton(
                  onPressed: () {
                    _saveForm();
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                  color: Colors.black,
                  textColor: Colors.white,
                )
              ],
            ),
          ),
        ));
  }
}
