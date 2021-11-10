import 'dart:convert';

import 'package:cns/database/entity/item_unit_table.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../appdatabase.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class ItemUnitModel with ChangeNotifier{
  final String ItemUOMID;
  final String UomLabel;
  final String CreatedOn;
  final String ModifiedOn;
  final String ItemID;

  ItemUnitModel({
    required this.ItemUOMID, required this.UomLabel,
    required this.CreatedOn,
    required this.ModifiedOn,
    required this.ItemID,
  });

  factory ItemUnitModel.fromJSON(Map<String, dynamic> json) {

    List<ItemUnitModel> genericList = [];

    return ItemUnitModel(
      ItemUOMID: json['ItemUOMID']==null? "-": json['ItemUOMID'],
      UomLabel: json['UomLabel']==null? "-": json['UomLabel'],
      CreatedOn: json['CreatedOn']==null? "-": json['CreatedOn'],
      ModifiedOn: json['ModifiedOn']==null? "": json['ModifiedOn'],
      ItemID: json['ItemID']==null? "-": json['ItemID'],
    );
  }

}

class ItemUnitProvider with ChangeNotifier{
  List<ItemUnitModel> _genericList = [];
  String responseCode = "";
  String responseMessage = "";
  String modifyOn = "";

  Future<void> callItemUnitDownload(String sign) async {
    final database =
    await $FloorAppDatabase.databaseBuilder('cns.db').build();
    List<ItemUnitModel> dataList = [];

    List<ItemUnitTable> itemUnit = await database.itemUnitDao.getAllItemUnit();
    if(itemUnit.length>0){
      modifyOn = itemUnit[0].ModifiedOn;
    }

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAll_ItemsUnit xmlns="http://tempuri.org/">
      <sign>$sign</sign>
      <modifiedOn>$modifyOn</modifiedOn>
    </GetAll_ItemsUnit>
  </soap:Body>
</soap:Envelope>
''';

      http.Response response = await http.post(
          Uri.parse(Constants.url),
          headers: {
            "Content-Type": "text/xml; charset=utf-8",
          },
          body: envelope);

      var rawXmlResponse = response.body;

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);

      print("DATAResult=" + response.body);
      //parse the string and return the json object =>json.decode
      Map genericMap = json.decode(parsedXml.text);
      print("DATAItemUnit=" + genericMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUnit =" + jsonData.toString());

      print("DATAUnit=" + result.toString());
      print("DATAUnit=" + result.length.toString());
      if (result.length > 0) {

        for (int i = 0; i < result.length; i++) {
          Map<String, dynamic> map = result[i];

          var postData = ItemUnitModel.fromJSON(map);
          dataList.add(postData);

          /*String GenericID = json['GenericID']==null? "-": json['GenericID'];
          String GenericName = json['GenericName']==null? "-": json['GenericName'];
          String Description = json['Description']==null? "-": json['Description'];
          String Active = json['Active']==null? "-": json['Active'].toString();
          String CreatedBy = json['CreatedBy']==null? "-": json['CreatedBy'];
          String CreatedOn = json['CreatedOn']==null? "-": json['CreatedOn'];
          String ModifiedBy = json['ModifiedBy']==null? "": json['ModifiedBy'];
          String ModifiedOn = json['ModifiedOn']==null? "": json['ModifiedOn'];
          String LastAction = json['LastAction']==null? "-": json['LastAction'];*/

          await database.itemUnitDao.addItemUnit(
              ItemUnitTable(
                  postData.ItemUOMID,
                  postData.UomLabel,
                  postData.CreatedOn,
                  postData.ModifiedOn,
                  postData.ItemID,
              ));

        }

        List<ItemUnitTable> units = await database.itemUnitDao.getAllItemUnit();

        print("GenecicList :"+ units.length.toString());

        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];

        if(responseMessage=='Success'){
          Fluttertoast.showToast(
              msg: 'Unit download success',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
        else{
          Fluttertoast.showToast(
              msg: responseMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1
          );
        }
      }

//      Fluttertoast.showToast(
//          msg: responseMessage,
//          toastLength: Toast.LENGTH_SHORT,
//          gravity: ToastGravity.BOTTOM,
//          timeInSecForIosWeb: 1
//      );

    }catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );
      throw (error);
    }

  }
}