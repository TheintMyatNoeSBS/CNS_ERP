import 'dart:convert';

import 'package:cns/database/entity/order_item_table.dart';
import 'package:cns/database/entity/order_table.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../appdatabase.dart';
import 'request_item_detail.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class RequestDetailModel with ChangeNotifier{
  final String MRID;
  final String MRNo;
  final String MRDate;
  final String MRType;
  final String RequestByID;
  final String RequestToID;
  final String StationID;
  final String MRStatus;
  final String ApprovedBy;
  final String SuperApprovedBy;
  final String ApprovedRemark;
  final String StatusRemark;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final List<RequestItemDetail> ItemDetail;

  RequestDetailModel({
    required this.MRID,
    required this.MRNo,
    required this.MRDate,
    required this.MRType,
    required this.RequestByID,
    required this.RequestToID,
    required this.StationID,
    required this.MRStatus,
    required this.ApprovedBy,
    required this.SuperApprovedBy,
    required this.ApprovedRemark,
    required this.StatusRemark,
    required this.CreatedBy,
    required this.CreatedOn,
    required this.ModifiedBy,
    required this.ModifiedOn,
    required this.ItemDetail
  });

  Map<String, dynamic> toJson(RequestDetailModel request) => {
    '\"MRID\"': "\"${request.MRID}\"",
    '\"MRNo\"': "\"${request.MRNo}\"",
    '\"MRDate\"': "\"${request.MRDate}\"",
    '\"MRType\"': "\"${request.MRType}\"",
    '\"RequestByID\"': "\"${request.RequestByID}\"",
    '\"RequestToID\"': "\"${request.RequestToID}\"",
    '\"StationID\"': "\"${request.StationID}\"",
    '\"MRStatus\"': "\"${request.MRStatus}\"",
    '\"ApprovedBy\"': "\"${request.ApprovedBy}\"",
    '\"SuperApprovedBy\"': "\"${request.SuperApprovedBy}\"",
    '\"ApprovedRemark\"': "\"${request.ApprovedRemark}\"",
    '\"StatusRemark\"': "\"${request.StatusRemark}\"",
    '\"CreatedBy\"': "\"${request.CreatedBy}\"",
    '\"CreatedOn\"': "\"${request.CreatedOn}\"",
    '\"ModifiedBy\"': "\"${request.ModifiedBy}\"",
    '\"ModifiedOn\"': "\"${request.ModifiedOn}\"",
  };

  factory RequestDetailModel.fromJSON(Map<String, dynamic> json) {

    List<RequestItemDetail> itemlist = [];
    var list = json['ItemDetail'] as List;

    print("DetailList"+list.toString());

    if(list.length>0){
      itemlist.clear();
      for(int i=0;i<list.length;i++){
        Map<String, dynamic> map = list[i];
        var postData = RequestItemDetail.fromJSON(map);
        itemlist.add(postData);
      }
    }

    return RequestDetailModel(
      MRID: json['MRID']==null? "": json['MRID'],
      MRNo: json['MRNo']==null? "": json['MRNo'],
      MRDate: json['MRDate']==null? "": json['MRDate'],
      MRType: json['MRType']==null? "": json['MRType'].toString(),
      RequestByID: json['RequestByID']==null? "": json['RequestByID'],
      RequestToID: json['RequestToID']==null? "": json['RequestToID'],
      StationID: json['StationID']==null? "": json['StationID'],
      MRStatus: json['MRStatus']==null? "": json['MRStatus'],
      ApprovedBy: json['ApprovedBy']==null? "": json['ApprovedBy'],
      SuperApprovedBy: json['SuperApprovedBy']==null? "": json['SuperApprovedBy'],
      ApprovedRemark: json['ApprovedRemark']==null? "": json['ApprovedRemark'],
      StatusRemark: json['StatusRemark']==null? "": json['StatusRemark'],
      CreatedBy: json['CreatedBy']==null? "": json['CreatedBy'],
      CreatedOn: json['CreatedOn']==null? "": json['CreatedOn'],
      ModifiedBy: json['ModifiedBy']==null? "": json['ModifiedBy'],
      ModifiedOn: json['ModifiedOn']==null? "": json['ModifiedOn'],
      ItemDetail: itemlist,
    );
  }

}

class RequestDetailProvider with ChangeNotifier{
  String responseCode = "";
  String responseMessage = "";
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");

  Future<void> callDownloadRequest(String sign,String request,String orderDate,String userName) async {
    print("UserName"+userName);

    final database = await Common.instance.getAppDatabase();


    List<RequestDetailModel> dataList = [];
    print("request=" + request);

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Get_MR_ByMRNo xmlns="http://tempuri.org/">
      <sign>$sign</sign>
      <requestNo>$request</requestNo>
    </Get_MR_ByMRNo>
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
      var result1 = jsonDecode(jsonData["ResponseData"]);
      print("DATAUser =" + jsonData.toString());
      String ApprovedBy= " ",SuperApprovedBy=" ";
      if(result1.length>0){
        if(result1['MRID']!=null){
          String MRID = result1['MRID']==null? "": result1['MRID'];
          String MRNo = result1['MRNo']==null? "": result1['MRNo'];
          String MRDate =result1['MRDate']==null? "": result1['MRDate'];
          String MRType =result1['MRType']==null? "": result1['MRType'].toString();
          String RequestByID= result1['RequestByID']==null? "": result1['RequestByID'];
          String RequestToID= result1['RequestToID']==null? "": result1['RequestToID'];
          String StationID= result1['StationID']==null? "": result1['StationID'];
          String MRStatus =result1['MRStatus']==null? "": result1['MRStatus'];
          if(result1['ApprovedBy']==null && result1['ApprovedBy']==""){
            ApprovedBy= "";
          }
          else{
            ApprovedBy= result1['ApprovedBy'];
          }

          if(result1['SuperApprovedBy']==null && result1['SuperApprovedBy']==""){
            SuperApprovedBy= "";
          }
          else{
            SuperApprovedBy= result1['SuperApprovedBy'];
          }

          String ApprovedRemark= result1['ApprovedRemark']==null? "": result1['ApprovedRemark'];
          String StatusRemark =result1['StatusRemark']==null? "": result1['StatusRemark'];
          String CreatedBy= result1['CreatedBy']==null? "": result1['CreatedBy'];
          String CreatedOn= result1['CreatedOn']==null? "": result1['CreatedOn'];
          String ModifiedBy =result1['ModifiedBy']==null? "": result1['ModifiedBy'];
          String ModifiedOn= result1['ModifiedOn']==null? "": result1['ModifiedOn'];

          List<RequestItemDetail> itemlist = [];
          var list = result1['ItemDetail'] as List;

          print("DetailList"+list.toString());

          if(list.length>0){
            database.orderItemDao.deleteByOrderID(request);
            itemlist.clear();
            for(int i=0;i<list.length;i++){
              Map<String, dynamic> map = list[i];
              var postData = RequestItemDetail.fromJSON(map);

              database.orderItemDao.addOrderItem(
                  OrderItemTable(
                      postData.MRItemID,
                      postData.MRID,
                      postData.ItemID,
                      postData.ItemName,
                      postData.GenericID,
                      postData.GenericName,
                      postData.UnitID,
                      postData.UomLabel,
                      postData.RequestQty,
                      postData.Remark,
                      ModifiedBy,
                      dateFormat.format(DateTime.now()),
                      CreatedBy,
                      dateFormat.format(DateTime.now())
                  )
              );

              itemlist.add(postData);
            }
          }

          database.orderDao.addOrder(
              OrderTable(
                MRID,
                MRNo,
                MRDate,
                MRStatus,
                MRType,
                RequestByID,
                RequestToID,
                StationID,
                ApprovedRemark,
                StatusRemark,
                ApprovedBy,
                SuperApprovedBy,
                CreatedBy,
                CreatedOn,
                ModifiedBy,
                ModifiedOn,
                'True',
                orderDate,
                userName
              )
          );
        }
        else{
          database.orderDao.deleteByOrderId(request);
        }

      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage=="Success"){

      }
      else{
        print(responseMessage);
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

}