import 'package:cns/database/entity/station_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class StationDao{
  @Query('select * from StationTable')
  Future<List<StationTable>> getAllStation();

  @Query('select * from StationTable where StationName =:stationName')
  Future<List<StationTable>> getByName(String stationName);

  @Query('select * from StationTable where StationID =:stationID')
  Future<List<StationTable>> getByID(String stationID);

//  @Query('select * from OrderItemTable where orderId =:orderId')
//  Future<List<StationTable>> getByOrderId(String orderId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addStation(StationTable stations);

  @delete
  Future<void> deleteStation(StationTable stations);

  @update
  Future<void>updateStation(StationTable stations);
}