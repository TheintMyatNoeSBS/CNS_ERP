import 'dart:convert';

import 'package:cns/database/entity/item_table.dart';
import 'package:cns/database/model/item_detail_model.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../appdatabase.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class ItemModel with ChangeNotifier{
  final String ItemID;
  final String ItemNo;
  final String ItemName;
//  final String ItemGroupID;
//  final String DefaultItemPrice;
//  final String Remark;
//  final String Active;
//  final String CreatedBy;
  final String CreatedOn;
//  final String ModifiedBy;
  final String ModifiedOn;
//  final String LastAction;
//  final String ShortCode;
//  final String Status;
//  final String InventUOMID;
//  final String ShowSeq;
//  final String CreatedByCode;
//  final String ModifiedByCode;
//  final String ItemGroupName;
//  final String UomLabel;
//  final String itemGroupType;
//  final String AlertNote;
  final String GenericName;
  final String GenericID;


  ItemModel({
    required this.ItemID,
    required this.ItemNo,
    required this.ItemName,
    required this.CreatedOn,
    required this.ModifiedOn,
    required this.GenericName,
    required this.GenericID
  });

  factory ItemModel.fromJSON(Map<String, dynamic> json) {
    return ItemModel(
      ItemID: json['ItemID']==null? " ": json['ItemID'],
      ItemNo: json['ItemNo']==null? " ": json['ItemNo'],
      ItemName: json['ItemName']==null? " ": json['ItemName'],
      CreatedOn: json['CreatedOn']==null? " ": json['CreatedOn'],
      ModifiedOn: json['ModifiedOn']==null? " ": json['ModifiedOn'],
      GenericName: json['GenericName']==null? " ": json['GenericName'],
      GenericID: json['GenericID']==null? " ": json['GenericID'],
    );
  }

}

class ItemProvider with ChangeNotifier{
  List<ItemModel> _genericList = [];
  String responseCode = "";
  String responseMessage = "";
  String modifyOn = "";

  Future<void> callItemDownload(String sign) async {
    final database = await Common.instance.getAppDatabase();
    List<ItemModel> dataList = [];

    List<ItemTable> items = await database.itemDao.getAllItem();
    if(items.length>0){
      modifyOn = items[0].ModifiedOn;
    }

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetAll_Items xmlns="http://tempuri.org/">
      <sign>$sign</sign>
      <modifiedOn>$modifyOn</modifiedOn>
    </GetAll_Items>
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
      print("DATAItems=" + genericMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result = jsonDecode(jsonData["ResponseData"]);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAItem =" + jsonData.toString());

      print("DATAItem=" + result.toString());
      print("DATAItemSize=" + result.length.toString());
      if (result.length > 0) {
        print("DATAItem=" + result.toString());
        for (int i = 0; i < result.length; i++) {
          if(result[i]!=null){
            Map<String, dynamic> map = result[i];
            print("DATAmap=" + map.toString());

            var postData = ItemModel.fromJSON(map);
            dataList.add(postData);

            await database.itemDao.addItem(
                ItemTable(
                    postData.ItemID,
                    postData.ItemNo,
                    postData.ItemName,
                    postData.CreatedOn,
                    postData.ModifiedOn,
                    postData.GenericName,
                    postData.GenericID
                ));
          }

        }

        List<ItemTable> items = await database.itemDao.getAllItem();

        print("ItemList :"+ items.length.toString());

        notifyListeners();
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
        if(responseMessage=='Success'){
          Fluttertoast.showToast(
              msg: 'Item download success',
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