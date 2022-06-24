import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/medicine_list.dart';
import '../screens/add_medicine.dart';
import '../widgets/medicine_grid.dart';

class MedicineOverview extends StatefulWidget {
  static const routeName = '/medicine-overview';

  @override
  _MedicineOverviewState createState() => _MedicineOverviewState();
}

class _MedicineOverviewState extends State<MedicineOverview> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<MedicineList>(context, listen: false)
          .fetchAndSetMedicines()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: MedicineGrid(),
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Medicine',
        onPressed: () {
          Navigator.of(context).pushNamed(AddMedicine.routeName);
        },
        child: Icon(Icons.add),
        elevation: 5.0,
      ),
    );
  }
}
