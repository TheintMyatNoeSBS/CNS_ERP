import 'package:floor/floor.dart';

@entity
class ItemUnitTable{
  @primaryKey
  final String ItemUOMID;
  final String UomLabel;
  final String CreatedOn;
  final String ModifiedOn;
  final String ItemID;

  ItemUnitTable(this.ItemUOMID, this.UomLabel,
      this.CreatedOn,  this.ModifiedOn,
      this.ItemID,
      );
}