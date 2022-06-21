import 'package:carezone/providers/auth.dart';
import 'package:carezone/providers/medicine_list.dart';
import 'package:carezone/screens/auth_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/medicine.dart';
import '../screens/inventory.dart';
import '../screens/logbook_screen.dart';
//import 'package:provider/provider.dart';

import '../screens/medicine_overview.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    // final medicineData = Provider.of<MedicineList>(context);
    // final meds = Provider.of<Medicine>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 50.0,
              ),
              CircleAvatar(
                radius: 60.0,
                backgroundColor: Colors.black,
                backgroundImage: NetworkImage(
                    'https://image.shutterstock.com/image-vector/user-login-authenticate-icon-human-260nw-1365533969.jpg'),
              ),
              Text(
                'User Name',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(''),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SwitchListTile(
                    onChanged: (bool v) {
                      // medicineData.toggleMorningStatus();
                      // medicineData.showMorningOnly = true;
                      // medicineData.notifyListeners();
                      // if (toDouble(meds.alarmTime) >= 6.00 && toDouble(meds.alarmTime) < 12.00)
                      //   meds.isMorning = !meds.isMorning;
                      // meds.notifyListeners();
                    },
                    value: false,
                    title: const Text("Morning"),
                    secondary: Icon(Icons.wb_sunny),
                  ),
                  SwitchListTile(
                    onChanged: (bool v) {
                      // medicineData.showAfternoonOnly = true;
                      // medicineData.notifyListeners();
                      // if (toDouble(meds.alarmTime) >= 12.00 && toDouble(meds.alarmTime) < 4.00)
                      //   meds.isAfternoon = !meds.isAfternoon;
                      // meds.notifyListeners();
                    },
                    value: false,
                    title: const Text("Afternoon"),
                    secondary: Icon(Icons.wb_sunny),
                  ),
                  SwitchListTile(
                    onChanged: (bool v) {
                      // medicineData.showEveningOnly = true;
                      // medicineData.notifyListeners();
                      // if (toDouble(meds.alarmTime) >= 4.00 && toDouble(meds.alarmTime) < 6.00)
                      //   meds.isEvening = !meds.isEvening;
                      // meds.notifyListeners();
                      },
                    value: false,
                    title: const Text("Evening"),
                    secondary: Icon(Icons.nightlight_round),
                  ),
                ],
              )
            ],
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false).logout();
                    //Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                ),
              ]),
            ),
          ],
          title: Text('CareZone'),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text(
                'List',
                style: TextStyle(fontSize: 20.0),
              )),
              Tab(
                  child: Text(
                'Inventory',
                style: TextStyle(fontSize: 20.0),
              )),
              Tab(
                  child: Text(
                'Med Log',
                style: TextStyle(fontSize: 20.0),
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            MedicineOverview(),
            Inventory(),
            LogbookScreen(),
          ],
        ),
      ),
    );
  }
}
