import 'package:cns/database/entity/program_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProgramDao{
  @Query('select * from ProgramTable')
  Future<List<ProgramTable>> getAllProgram();

  @Query('select * from ProgramTable where userID =:userID')
  Future<List<ProgramTable>> getByUserID(String userID);

  @Query('select * from ProgramTable where userID =:userID and ProgramCode=:programCode')
  Future<List<ProgramTable>> getPermission(String userID,String programCode);

  /*@Query('select * from ProgramTable where StationID =:stationID')
  Future<List<ProgramTable>> getByID(String stationID);*/

//  @Query('select * from OrderItemTable where orderId =:orderId')
//  Future<List<StationTable>> getByOrderId(String orderId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addStation(ProgramTable programs);

  @delete
  Future<void> deleteStation(ProgramTable programs);

  @update
  Future<void>updateStation(ProgramTable programs);
}