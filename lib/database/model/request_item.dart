import 'dart:convert';

import 'package:cns/database/entity/order_item_table.dart';
import 'package:cns/database/model/order_item_model.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import '../appdatabase.dart';

class RequestItem with ChangeNotifier{
  final String MRItemID;
  final String MRID;
  final String ItemID;
  final String GenericID;
  final String RequestQty;
  final String IssueQty;
  final String RemainQty;
  final String TotalRemainQty;
  final String Remark;
  final String UnitID;
  final String LocationID;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;

  RequestItem({
    required this.MRItemID, required this.MRID,
    required this.ItemID, required this.GenericID,
    required this.RequestQty, required this.IssueQty,
    required this.RemainQty, required this.TotalRemainQty,
    required this.Remark, required this.UnitID,
    required this.LocationID, required this.CreatedBy,
    required this.CreatedOn, required this.ModifiedBy,
    required this.ModifiedOn,
  });

  Map<String, dynamic> toJson(RequestItem requestItem) => {
    '\"MRItemID\"': "\"${requestItem.MRItemID}\"",
    '\"MRID\"': "\"${requestItem.MRID}\"",
    '\"ItemID\"': "\"${requestItem.ItemID}\"",
    '\"GenericID\"': "\"${requestItem.GenericID}\"",
    '\"RequestQty\"': "\"${requestItem.RequestQty}\"",
    '\"IssueQty\"': "\"${requestItem.IssueQty}\"",
    '\"RemainQty\"': "\"${requestItem.RemainQty}\"",
    '\"TotalRemainQty\"': "\"${requestItem.TotalRemainQty}\"",
    '\"Remark\"': "\"${requestItem.Remark}\"",
    '\"UnitID\"': "\"${requestItem.UnitID}\"",
    '\"LocationID\"': "\"${requestItem.LocationID}\"",
    '\"CreatedBy\"': "\"${requestItem.CreatedBy}\"",
    '\"CreatedOn\"': "\"${requestItem.CreatedOn}\"",
    '\"ModifiedBy\"': "\"${requestItem.ModifiedBy}\"",
    '\"ModifiedOn\"': "\"${requestItem.ModifiedOn}\"",
  };

//  Map toJson(RequestItem requestItem) {
////    Map author =
////    this.MRItemID != null ? this.MRItemID.toJson() : null;
//
//    return {
//
//    };
//  }
}

class RequestItemProvider with ChangeNotifier{
  List<RequestItem> _genericList = [];
  String responseCode = "";
  String responseMessage = "";

  Future<void> callUploadRequestItem(String sign,RequestItem requestItem,OrderItemModel orderItemModel) async {
    final database = await Common.instance.getAppDatabase();

//    final obj = RequestItem();
    print(requestItem.toJson(requestItem));
//    String info = RequestItem.toJson

    List<RequestItem> dataList = [];

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Save_MR_RequestItem xmlns="http://tempuri.org/">
      <info>${requestItem.toJson(requestItem)}</info>
      <sign>1B2M2Y8AsgTpgAmY7PhCfg==</sign>
    </Save_MR_RequestItem>
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
      Map cityMap = json.decode(parsedXml.text);
      print("DATAUser=" + cityMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUser =" + jsonData.toString());

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage=="Success"){
        database.orderItemDao.addOrderItem(
            OrderItemTable(
                orderItemModel.orderItemId,
                orderItemModel.orderId,
                orderItemModel.itemId,
                orderItemModel.itemName,
                orderItemModel.genericId,
                orderItemModel.genericName,
                orderItemModel.unitId,
                orderItemModel.unitName,
                orderItemModel.qty,
                orderItemModel.remark,
                orderItemModel.modifyBy,
                orderItemModel.modifyOn,
                orderItemModel.createdBy,
                orderItemModel.createdOn
            )
        );
        Fluttertoast.showToast(
            msg: "Save Item Success",
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

  Future<void> callUpdateRequestItemApi(String sign,RequestItem requestItem,OrderItemModel orderItemModel) async {
    final database = await Common.instance.getAppDatabase();

//    final obj = RequestItem();
    print(requestItem.toJson(requestItem));
//    String info = RequestItem.toJson

    List<RequestItem> dataList = [];

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Save_MR_RequestItem xmlns="http://tempuri.org/">
      <info>${requestItem.toJson(requestItem)}</info>
      <sign>1B2M2Y8AsgTpgAmY7PhCfg==</sign>
    </Save_MR_RequestItem>
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
      Map cityMap = json.decode(parsedXml.text);
      print("DATAUser=" + cityMap.toString());


      var jsonData = jsonDecode(parsedXml.text);
      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      print("DATAUser =" + jsonData.toString());

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage=="Success"){
        Fluttertoast.showToast(
            msg: "Update Item Success",
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


  Future<void> callDeleteRequestItemApi(String sign,RequestItem requestItem,OrderItemModel orderItemModel) async {
    final database = await Common.instance.getAppDatabase();

//    final obj = RequestItem();
    print(requestItem.toJson(requestItem));
//    String info = RequestItem.toJson

    List<RequestItem> dataList = [];

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Delete_MR_RequestItem xmlns="http://tempuri.org/">
      <info>${requestItem.toJson(requestItem)}</info>
      <sign>$sign</sign>
    </Delete_MR_RequestItem>
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
//      Map cityMap = json.decode(parsedXml.text);
//      print("DATAUser=" + cityMap.toString());


//      var jsonData = jsonDecode(parsedXml.text);
//      var result2 = jsonDecode(jsonData["ResponseInfo"]);
      /*print("DATAUser =" + jsonData.toString());

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage=="Success"){
        Fluttertoast.showToast(
            msg: "Save Success",
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
      }*/
      Fluttertoast.showToast(
          msg: "Delete Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1
      );


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