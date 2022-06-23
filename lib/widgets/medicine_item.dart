import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/providers/auth.dart';
import '../providers/logbook_provider.dart';
import '../providers/medicine.dart';
import '../screens/medicine_detail.dart';

class MedicineItem extends StatelessWidget {
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final med = Provider.of<Medicine>(context);
    final log = Provider.of<LogBookProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return GridTile(
      child: Center(
        child: Card(
          elevation: .0,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 2,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(35.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(MedicineDetail.routeName, arguments: med.id);
                  },
                  child: CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.black,
                    backgroundImage: med.typeIndex == 0
                        ? AssetImage("assets/images/syrup.png")
                        : med.typeIndex == 1
                            ? AssetImage("assets/images/pills.png")
                            : med.typeIndex == 2
                                ? AssetImage("assets/images/capsule.png")
                                : med.typeIndex == 3
                                    ? AssetImage("assets/images/cream.png")
                                    : med.typeIndex == 4
                                        ? AssetImage("assets/images/drops.png")
                                        : AssetImage(
                                            "assets/images/syringe.png"),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  med.title,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.alarm),
                    Text(formatTimeOfDay(med.alarmTime)),
                    IconButton(
                      onPressed: () {
                        log.addItem(med.id, med.title);
                        med.updateCount(med.id, auth.token);
                      },
                      icon: Icon(Icons.check),
                      color: Colors.lightBlueAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
