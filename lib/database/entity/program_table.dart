import 'package:floor/floor.dart';

@entity
class ProgramTable {
  @primaryKey
  final String SysProgramId;
  final String ProgramCode;
  final String ProgramName;
  final String SystemgroupID;
  final String userID;

  ProgramTable(this.SysProgramId, this.ProgramCode, this.ProgramName,
      this.SystemgroupID,this.userID);
}