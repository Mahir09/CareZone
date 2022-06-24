import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './medicine_item.dart';
import '../providers/medicine_list.dart';

class MedicineGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicineData = Provider.of<MedicineList>(context);
    final medicines = medicineData.items;
    if (medicines == null)
      return Center(
        child: Text(
          "No medicines added yet!",
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07),
        ),
      );
    return medicines == null
        ? Center(
            child: Text(
              "No medicines added yet!",
              style:
                  TextStyle(fontSize: MediaQuery.of(context).size.width * 0.07),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: medicines.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              child: MedicineItem(),
              value: medicines[i],
            ),
          );
  }
}
