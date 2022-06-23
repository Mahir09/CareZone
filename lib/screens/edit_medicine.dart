import 'package:carezone/providers/medicine.dart';
import 'package:carezone/widgets/tabbar_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/MedicineType.dart';
import '../providers/medicine_list.dart';
import '../widgets/medicine_type_card.dart';

class EditMedicine extends StatefulWidget {
  static const routeName = '/editMedicine';

  @override
  _EditMedicineState createState() => _EditMedicineState();
}

class _EditMedicineState extends State<EditMedicine> {
  TimeOfDay _selectedTime;

  final _form = GlobalKey<FormState>();

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  var _editedMedicine = Medicine(
    id: null,
    title: '',
    description: '',
    quantity: 0,
    alarmTime: null,
    imageurl: '',
    typeIndex: 0,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'alarmTime': '',
    'typeIndex': 0,
  };

  @override
  void didChangeDependencies() {
    final medID = ModalRoute.of(context).settings.arguments as String;
    if (medID != null) {
      _editedMedicine = Provider.of<MedicineList>(context).findById(medID);
      _initValues = {
        'title': _editedMedicine.title,
        'description': _editedMedicine.description,
        'quantity': _editedMedicine.quantity.toString(),
        'imageUrl': _editedMedicine.imageurl,
        'alarmTime': formatTimeOfDay(_editedMedicine.alarmTime),
        'typeIndex': _editedMedicine.typeIndex,
      };
    }
    super.didChangeDependencies();
  }

  void medicineTypeClick(MedicineType medicine) {
    setState(() {
      medicineTypes.forEach((medicineType) => medicineType.isChoose = false);
      medicineTypes[medicineTypes.indexOf(medicine)].isChoose = true;
      _editedMedicine = Medicine(
        id: _editedMedicine.id,
        title: _editedMedicine.title,
        description: _editedMedicine.description,
        alarmTime: _editedMedicine.alarmTime,
        imageurl: _editedMedicine.imageurl,
        quantity: _editedMedicine.quantity,
        typeIndex: medicineTypes.indexOf(medicine),
      );
    });
  }

  void _saveForm() {
    _form.currentState.save();
    if (_editedMedicine.id != null) {
      Provider.of<MedicineList>(context, listen: false)
          .editAndSetMedicines(_editedMedicine.id, _editedMedicine);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TabBarScreen()),
    );
  }

  void _presentTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((pickedTime) {
      if (pickedTime == null) return;

      setState(() {
        _selectedTime = pickedTime;
        _editedMedicine = Medicine(
            id: _editedMedicine.id,
            title: _editedMedicine.title,
            description: _editedMedicine.description,
            alarmTime: _selectedTime,
            imageurl: _editedMedicine.imageurl,
            quantity: _editedMedicine.quantity,
          typeIndex: _editedMedicine.typeIndex,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: _saveForm, //BUG: Bad state error
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    helperText: 'Medicine Name',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  style: TextStyle(fontSize: 20),
                  onSaved: (value) {
                    _editedMedicine = Medicine(
                        id: _editedMedicine.id,
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
                  height: 20,
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(
                    helperText: 'Description',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  maxLines: 5,
                  style: TextStyle(fontSize: 20),
                  onSaved: (value) {
                    _editedMedicine = Medicine(
                        id: _editedMedicine.id,
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
                  height: 20,
                ),
                TextFormField(
                  initialValue: _initValues['quantity'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    helperText: 'Quantity',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  style: TextStyle(fontSize: 20),
                  onSaved: (value) {
                    _editedMedicine = Medicine(
                        id: _editedMedicine.id,
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(_selectedTime == null
                        ? formatTimeOfDay(_editedMedicine.alarmTime)
                        : formatTimeOfDay(_selectedTime)),
                    FlatButton(
                      onPressed: _presentTimePicker,
                      child: Text("Select Time"),
                      textColor: Colors.white,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                    )
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 20,
                ),Container(
                  width: double.infinity,
                  height: 130,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ...medicineTypes.map(
                              (type) => MedicineTypeCard(type, medicineTypeClick))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
