import 'package:flutter/cupertino.dart';

class MedicineType {
  String name;
  Widget image;
  bool isChoose;

  MedicineType(this.name, this.image, this.isChoose);
}

final List<MedicineType> medicineTypes = [
  MedicineType("Syrup", Image.asset("assets/images/syrup.png"), false),
  MedicineType("Pill", Image.asset("assets/images/pills.png"), false),
  MedicineType("Capsule", Image.asset("assets/images/capsule.png"), false),
  MedicineType("Cream", Image.asset("assets/images/cream.png"), false),
  MedicineType("Drops", Image.asset("assets/images/drops.png"), false),
  MedicineType("Syringe", Image.asset("assets/images/syringe.png"), false),
];
