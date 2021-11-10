import 'package:cns/database/entity/item_unit_table.dart';
import 'package:floor/floor.dart';


@dao
abstract class ItemUnitDao{
  @Query('select * from ItemUnitTable order by ModifiedOn desc')
  Future<List<ItemUnitTable>> getAllItemUnit();

  @Query('select * from ItemUnitTable where ItemID =:itemID')
  Future<List<ItemUnitTable>> getById(String itemID);

  @Query('select * from ItemUnitTable where ItemUOMID =:uomID')
  Future<List<ItemUnitTable>> getByUOMId(String uomID);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addItemUnit(ItemUnitTable items);

  @delete
  Future<void> deleteItemUnit(ItemUnitTable items);

  @update
  Future<void>updateItemUnit(ItemUnitTable items);

  @Query("delete from ItemUnitTable")
  Future<void> deleteAll();
}