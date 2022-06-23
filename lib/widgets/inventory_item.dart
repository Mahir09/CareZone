import '/providers/medicine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final med = Provider.of<Medicine>(context);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Color(0xf2fff7)),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  child: Text(
                med.title,
                style: TextStyle(fontSize: 20.0),
              )),
              Text(
                med.quantity.toString(),
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Divider(thickness: 1),
        ),
      ],
    );
  }
}
