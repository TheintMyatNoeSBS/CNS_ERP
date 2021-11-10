import 'package:cns/database/model/item_detail_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/widget/item_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemListModel with ChangeNotifier{
  final String ItemName;
  final String GenericName;
  final String RefNo;
  final String Manufacture;
  final String Country;
  final String BarCode;
  final String TotalQty;
  final List<ItemDetailModel> Item_Detail;

  ItemListModel({
    required this.ItemName,
    required this.GenericName,
    required this.RefNo,
    required this.Manufacture,
    required this.TotalQty,
    required this.Country,
    required this.BarCode,
    required this.Item_Detail
  });

  factory ItemListModel.fromJSON(Map<String, dynamic> json) {

    List<ItemDetailModel> itemlist = [];
    var list = json['ItemDetail'] as List;

    print("DetailList"+list.toString());

    if(list.length>0){
      itemlist.clear();
      for(int i=0;i<list.length;i++){
        Map<String, dynamic> map = list[i];
        var postData = ItemDetailModel.fromJSON(map);
        itemlist.add(postData);
      }
    }

    var str = json['TotalQty'];

    var parts = str.split('.');
    var prefix = parts[0].trim();

    return ItemListModel(
        ItemName: json['ItemName'],
        GenericName: json['GenericName'],
        RefNo: json['RefNo'],
        Manufacture: json['Manufacture']==null? "-": json['Manufacture'],
        TotalQty: prefix,
        Country: json['Country']==null? "-": json['Country'],
        BarCode: json['BarCode']==null? "": json['BarCode'],
        Item_Detail: itemlist
    );
  }
}