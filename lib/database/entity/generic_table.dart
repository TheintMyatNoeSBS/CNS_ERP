import 'package:floor/floor.dart';

@entity
class GenericTable{
  @primaryKey
  final String GenericID;
  final String GenericName;
  final String Description;
  final String Active;
  final String CreatedBy;
  final String CreatedOn;
  final String ModifiedBy;
  final String ModifiedOn;
  final String LastAction;

  GenericTable(this.GenericID, this.GenericName, this.Description, this.Active,
      this.CreatedBy, this.CreatedOn, this.ModifiedBy, this.ModifiedOn,
      this.LastAction);

}