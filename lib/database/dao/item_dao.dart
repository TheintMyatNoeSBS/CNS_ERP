import 'package:cns/database/entity/item_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class ItemDao{
  @Query('select * from ItemTable order by ModifiedOn desc')
  Future<List<ItemTable>> getAllItem();

  @Query('select * from ItemTable where ItemID =:itemID')
  Future<List<ItemTable>> getById(String itemID);

  @Query('select * from ItemTable where GenericID =:genericID')
  Future<List<ItemTable>> getByGenericId(String genericID);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addItem(ItemTable items);

  @delete
  Future<void> deleteItem(ItemTable items);

  @update
  Future<void>updateItem(ItemTable items);
}