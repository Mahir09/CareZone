import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/providers/medicine.dart';
import '/providers/medicine_list.dart';
import '/services/notifications.dart';
import '../providers/MedicineType.dart';
import '../widgets/medicine_type_card.dart';

class AddMedicine extends StatefulWidget {
  static const routeName = '/add-medicine';

  @override
  _AddMedicineState createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  var _isLoading = false;
  final _descriptionFN = FocusNode();
  final _quantityFN = FocusNode();
  final _form = GlobalKey<FormState>();
  TimeOfDay selectedTime;
  var pickedImage;
  var _editedMedicine = Medicine(
    id: null,
    title: '',
    description: '',
    alarmTime: null,
    imageurl: null,
    quantity: 0,
    typeIndex: 0,
  );

  void _presentTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((pickedTime) {
      if (pickedTime == null) return;

      setState(() {
        selectedTime = pickedTime;
        _editedMedicine = Medicine(
          id: null,
          title: _editedMedicine.title,
          description: _editedMedicine.description,
          alarmTime: selectedTime,
          imageurl: _editedMedicine.imageurl,
          quantity: _editedMedicine.quantity,
          typeIndex: _editedMedicine.typeIndex,
        );
      });
    });
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Reference storageReference = FirebaseStorage.instance.ref();

  void medicineTypeClick(MedicineType medicine) {
    setState(() {
      medicineTypes.forEach((medicineType) => medicineType.isChoose = false);
      medicineTypes[medicineTypes.indexOf(medicine)].isChoose = true;
      _editedMedicine = Medicine(
        id: null,
        title: _editedMedicine.title,
        description: _editedMedicine.description,
        alarmTime: selectedTime,
        imageurl: _editedMedicine.imageurl,
        quantity: _editedMedicine.quantity,
        typeIndex: medicineTypes.indexOf(medicine),
      );
    });
  }

  @override
  void dispose() {
    _descriptionFN.dispose();
    _quantityFN.dispose();
    super.dispose();
  }

  void _saveForm(Notifications manager) {
    Random random = new Random();
    setState(() {
      _isLoading = true;
    });
    final _isValid = _form.currentState.validate();
    if (_isValid) {
      _form.currentState.save();
      print(_editedMedicine.alarmTime);
      print(_editedMedicine.title);
      manager.showNotificationDaily(
          random.nextInt(100),
          "Time for your medicines! Name: ${_editedMedicine.title}",
          "Description: ${_editedMedicine.description}",
          _editedMedicine.alarmTime.hour,
          _editedMedicine.alarmTime.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    var notifications = Provider.of<Notifications>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medicine"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 30.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.medical_services_outlined),
                          labelText: 'Enter your medicine name',
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descriptionFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a name";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedMedicine = Medicine(
                            id: null,
                            title: value,
                            description: _editedMedicine.description,
                            alarmTime: _editedMedicine.alarmTime,
                            imageurl: _editedMedicine.imageurl,
                            quantity: _editedMedicine.quantity,
                            typeIndex: _editedMedicine.typeIndex,
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 30.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.description_outlined),
                          labelText: 'Enter your description',
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _descriptionFN,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_quantityFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a description";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedMedicine = Medicine(
                            id: null,
                            title: _editedMedicine.title,
                            description: value,
                            alarmTime: _editedMedicine.alarmTime,
                            imageurl: _editedMedicine.imageurl,
                            quantity: _editedMedicine.quantity,
                            typeIndex: _editedMedicine.typeIndex,
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 30.0,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          icon: Icon(Icons.lock_outlined),
                          labelText: 'Enter your medicine quantity',
                          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _quantityFN,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter a number";
                          }
                          if (int.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (int.parse(value) <= 0) {
                            return "Please enter a number greater than zero";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedMedicine = Medicine(
                            id: null,
                            title: _editedMedicine.title,
                            description: _editedMedicine.description,
                            alarmTime: _editedMedicine.alarmTime,
                            imageurl: _editedMedicine.imageurl,
                            quantity: int.parse(value),
                            typeIndex: _editedMedicine.typeIndex,
                          );
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 30.0,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: FittedBox(
                            child: Text(
                              "Medicine form",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 100,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            ...medicineTypes.map((type) =>
                                MedicineTypeCard(type, medicineTypeClick))
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(selectedTime == null
                              ? "No time selected"
                              : formatTimeOfDay(selectedTime)),
                          FlatButton(
                            onPressed: () {
                              _presentTimePicker();
                            },
                            child: Text("Select Time"),
                            textColor: Colors.white,
                            color: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                          )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60.0,
                      ),
                      FlatButton(
                        onPressed: () {
                          _saveForm(notifications);
                          Provider.of<MedicineList>(context, listen: false)
                              .addItem(_editedMedicine)
                              .catchError((err) {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('An error occured'),
                                content: Text(err.toString()),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Ok"),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  )
                                ],
                              ),
                            );
                          }).then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                          });
                        },
                        child: Text('Save'),
                        height: 50.0,
                        textColor: Colors.white,
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
