import 'package:flutter/material.dart';

class ProgramList with ChangeNotifier{
  final String SysProgramId;
  final String ProgramCode;
  final String ProgramName;
  final String SystemgroupID;

  ProgramList({
    required this.SysProgramId,
    required this.ProgramCode,
    required this.ProgramName,
    required this.SystemgroupID,
  });

  factory ProgramList.fromJSON(Map<String, dynamic> json) {

    return ProgramList(
        SysProgramId: json['SysProgramId']==null? "" : json['SysProgramId'],
        ProgramCode: json['ProgramCode']==null? "" : json['ProgramCode'],
      ProgramName: json['ProgramName']==null? "" : json['ProgramName'],
      SystemgroupID: json['SystemgroupID']==null? "" : json['SystemgroupID'],
    );
  }
}