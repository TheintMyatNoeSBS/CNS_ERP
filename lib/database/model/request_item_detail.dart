import 'package:flutter/material.dart';

class RequestItemDetail with ChangeNotifier{
  final String MRItemID;
  final String MRID;
  final String ItemID;
  final String ItemName;
  final String GenericID;
  final String RequestQty;
  final String IssueQty;
  final String RemainQty;
  final String TotalRemainQty;
  final String Remark;
  final String UnitID;
  final String UomLabel;
  final String GenericName;
  final String LocationID;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;

  RequestItemDetail({
    required this.MRItemID, required this.MRID,
    required this.ItemID, required this.GenericID,
    required this.RequestQty, required this.IssueQty,
    required this.RemainQty, required this.TotalRemainQty,
    required this.Remark, required this.UnitID,
    required this.LocationID, required this.CreatedBy,
    required this.CreatedOn, required this.ModifiedBy,
    required this.ModifiedOn, required this.ItemName,
    required this.UomLabel, required this.GenericName,
  });

  factory RequestItemDetail.fromJSON(Map<String, dynamic> json) {

    return RequestItemDetail(
      MRItemID: json['MRItemID']==null? "": json['MRItemID'],
      MRID: json['MRID']==null? "": json['MRID'],
      ItemID: json['ItemID']==null? "": json['ItemID'],
      GenericID: json['GenericID']==null? "": json['GenericID'],
      RequestQty: json['RequestQty']==null? "": json['RequestQty'].toString(),
      IssueQty: json['IssueQty']==null? "": json['IssueQty'].toString(),
      RemainQty: json['RemainQty']==null? "": json['RemainQty'].toString(),
      TotalRemainQty: json['TotalRemainQty']==null? "": json['TotalRemainQty'].toString(),
      Remark: json['Remark']==null? "": json['Remark'],
      UnitID: json['UnitID']==null? "": json['UnitID'],
      LocationID: json['LocationID']==null? "": json['LocationID'],
      ItemName: json['ItemName']==null? "": json['ItemName'],
      UomLabel: json['UomLabel']==null? "": json['UomLabel'],
      GenericName: json['GenericName']==null? "": json['GenericName'],
      CreatedBy: json['CreatedBy']==null? "": json['CreatedBy'],
      CreatedOn: json['CreatedOn']==null? "": json['CreatedOn'],
      ModifiedBy: json['ModifiedBy']==null? "": json['ModifiedBy'],
      ModifiedOn: json['ModifiedOn']==null? "": json['ModifiedOn'],
    );
  }

}