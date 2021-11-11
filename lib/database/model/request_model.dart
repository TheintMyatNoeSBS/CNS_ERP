import 'dart:convert';

import 'package:cns/database/entity/order_table.dart';
import 'package:cns/database/model/order_model.dart';
import 'package:cns/util/common.dart';
import 'package:cns/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import '../appdatabase.dart';

class Request with ChangeNotifier{
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

  Request({
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
    required this.ModifiedOn
});

  Map<String, dynamic> toJson(Request request) => {
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

  factory Request.fromJSON(Map<String, dynamic> json) {

    List<Request> requestList = [];

    return Request(
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
    );
  }

}

class RequestProvider with ChangeNotifier{
  List<Request> _genericList = [];
  String responseCode = "";
  String responseMessage = "";

  Future<void> callUploadRequest(String sign,Request request,OrderModel orderModel) async {
    final database = await Common.instance.getAppDatabase();

    print(request.toJson(request));

    List<Request> dataList = [];

    try{
      var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Save_MR_Request xmlns="http://tempuri.org/">
      <info>${request.toJson(request)}</info>
      <sign>$sign</sign>
    </Save_MR_Request>
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

      }
      else{
        Fluttertoast.showToast(
            msg: responseMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
      }

    }catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
      throw (error);
    }

  }

  Future<void> callDownloadRequest(String sign,String request,String orderDate,String userName) async {
    final database = await Common.instance.getAppDatabase();


    List<Request> dataList = [];

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

        print("OrderID"+MRID);
      }

      if(result2.length>0){
        responseCode = result2['Code'];
        responseMessage = result2['Message'];
      }

      if(responseMessage=="Success"){

      }
      else{
        Fluttertoast.showToast(
            msg: responseMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1
        );
      }

    }catch (error) {
      print(error);
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1
      );
      throw (error);
    }

  }


}