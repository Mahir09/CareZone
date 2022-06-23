import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/providers/auth.dart';
import '/screens/auth_screen.dart';
import '../screens/inventory.dart';
import '../screens/logbook_screen.dart';
import '../screens/medicine_overview.dart';

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  var _prefs;
  var _userData;
  var _isLoading = false;

  @override
  initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () async {
      _prefs = await SharedPreferences.getInstance();
      _userData =
          json.decode(_prefs.getString('userData')) as Map<String, Object>;
      if (_userData != null) {
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Drawer(
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 100,
                      child: Icon(
                        Icons.account_circle,
                        size: 200,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      _userData['userName'] != null
                          ? _userData['userName']
                          : "Loading",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 15),
                    Text(
                      _userData['emailId'] != null
                          ? _userData['emailId']
                          : "Loading",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text("Do you want to logout?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Provider.of<Auth>(context, listen: false)
                                  .logout();
                              Navigator.of(context)
                                  .pushReplacementNamed(AuthScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          title: Text('CareZone'),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text(
                'Medicines',
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
