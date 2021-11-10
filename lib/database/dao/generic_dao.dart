import 'package:cns/database/entity/generic_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class GenericDao{
  @Query('select * from GenericTable order by ModifiedOn desc')
  Future<List<GenericTable>> getAllGeneric();

  @Query('select * from GenericTable where GenericID =:genericID')
  Future<List<GenericTable>> getById(String genericID);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addGeneric(GenericTable generic);

  @delete
  Future<void> deleteGeneric(GenericTable generic);

  @update
  Future<void>updateGeneric(GenericTable generic);
}