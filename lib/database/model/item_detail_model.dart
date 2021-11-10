import 'package:flutter/cupertino.dart';

class ItemDetailModel with ChangeNotifier{
  final String Location;
  final String Balance;

  ItemDetailModel({required this.Location, required this.Balance});

  factory ItemDetailModel.fromJSON(Map<String, dynamic> json) {

    var str = json['Balance'];

    var parts = str.split('.');
    String prefix = parts[0].trim();

    return ItemDetailModel(
        Location: json['Location'],
        Balance: prefix.contains('-')? "($prefix)" : prefix
    );
  }
}