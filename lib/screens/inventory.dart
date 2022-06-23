import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/inventory_item.dart';
import '/providers/medicine_list.dart';

class Inventory extends StatelessWidget {
  static const routeName = '/inventory';

  Future<void> _refreshMeds(BuildContext context) async {
    await Provider.of<MedicineList>(context, listen: false)
        .fetchAndSetMedicines();
  }

  @override
  Widget build(BuildContext context) {
    final medlist = Provider.of<MedicineList>(context);
    final medicines = medlist.items;
    return RefreshIndicator(
      onRefresh: () => _refreshMeds(context),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Medicine Name',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quantity',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    child: InventoryItem(),
                    value: medicines[i],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
