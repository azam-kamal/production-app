import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/planClass.dart';

class AddPlan extends StatefulWidget {
  static const routeName = '/add-plan';

  @override
  _AddPlanState createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final planId = ModalRoute.of(context).settings.arguments as String;
      if (planId != null) {
        _editedPlan =
            Provider.of<Plans>(context, listen: false).findById(planId);
        _initValues = {
          'jobId': _editedPlan.jobId,
          'quantity': _editedPlan.quantity.toString(),
        };
        _dateTimeController.text = _editedPlan.startDateTime.substring(0, 12);
        _dateTimeController2.text = _editedPlan.endDateTime.substring(0, 12);
        _timeController1.text = _editedPlan.startDateTime.substring(13);
        _timeController2.text = _editedPlan.endDateTime.substring(13);
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

  var _editedPlan = PlanItem(
    id: null,
    jobId: '',
    quantity: 0,
    startDateTime: '',
    endDateTime: '',
  );
  var _initValues = {
    'jobId': '',
    'quantity': '',
    'startDate': '',
    'startTime': '',
    'endDate': '',
    'endTime': '',
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

    if (_editedPlan.id != null) {
      Provider.of<Plans>(context, listen: false)
          .updatePlan(_editedPlan.id, _editedPlan);
          
    } else {
      try {
        await Provider.of<Plans>(context, listen: false)
            .addNewPlan(_editedPlan);
          
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
        //     content: Text('New Plan Added Successfully'),
        //   ));
      // }
      setState(() {
        _isLoading = false;
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
          title: Text('New Plan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['jobId'],
                  decoration: InputDecoration(labelText: 'Job-ID'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_jobIdFocus);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide Job ID value.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedPlan = PlanItem(
                        id: _editedPlan.id,
                        jobId: value,
                        quantity: _editedPlan.quantity,
                        startDateTime: _editedPlan.startDateTime,
                        endDateTime: _editedPlan.endDateTime);
                  },
                ),
                TextFormField(
                  initialValue: 'Planned',
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
                  decoration: InputDecoration(labelText: 'Planning Quantity'),
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
                    _editedPlan = PlanItem(
                        id: _editedPlan.id,
                        jobId: _editedPlan.jobId,
                        quantity: int.parse(value),
                        startDateTime: _editedPlan.startDateTime,
                        endDateTime: _editedPlan.endDateTime);
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
                          _editedPlan = PlanItem(
                              id: _editedPlan.id,
                              jobId: _editedPlan.jobId,
                              quantity: _editedPlan.quantity,
                              startDateTime: value,
                              endDateTime: _editedPlan.endDateTime);
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
                          _editedPlan = PlanItem(
                              id: _editedPlan.id,
                              jobId: _editedPlan.jobId,
                              quantity: _editedPlan.quantity,
                              startDateTime:
                                  _editedPlan.startDateTime + ' ' + value,
                              endDateTime: _editedPlan.endDateTime);
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
                          _editedPlan = PlanItem(
                              id: _editedPlan.id,
                              jobId: _editedPlan.jobId,
                              quantity: _editedPlan.quantity,
                              startDateTime: _editedPlan.startDateTime,
                              endDateTime: value);
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
                          _editedPlan = PlanItem(
                              id: _editedPlan.id,
                              jobId: _editedPlan.jobId,
                              quantity: _editedPlan.quantity,
                              startDateTime: _editedPlan.startDateTime,
                              endDateTime:
                                  _editedPlan.endDateTime + ' ' + value);
                        },
                      ),
                    )
                  ],
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
