import 'package:floor/floor.dart';

@entity
class ItemTable{
  @primaryKey
  final String ItemID;
  final String ItemNo;
  final String ItemName;
  final String CreatedOn;
  final String ModifiedOn;
  final String GenericName;
  final String GenericID;

  ItemTable(this.ItemID,
      this.ItemNo,
      this.ItemName,
      this.CreatedOn,
      this.ModifiedOn,
      this.GenericName,
      this.GenericID);
}