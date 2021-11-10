import 'package:floor/floor.dart';

@entity
class StationTable{
  @primaryKey
  final String StationID;
  final String StationName;
  final String Address;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;
  final String StationCode;
  final String Remark;
  final String CreatedByCode;
  final String ModifiedByCode;

  StationTable(this.StationID, this.StationName, this.Address, this.Active,
      this.CreatedBy, this.CreatedOn, this.ModifiedBy, this.ModifiedOn,
      this.LastAction, this.StationCode, this.Remark, this.CreatedByCode,
      this.ModifiedByCode);
}