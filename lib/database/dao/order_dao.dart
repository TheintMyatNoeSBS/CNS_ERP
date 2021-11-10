import 'package:cns/database/entity/order_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class OrderDao{
  @Query('select * from OrderTable')
  Future<List<OrderTable>> getAllOrder();

  @Query('select * from OrderTable where orderDate =:orderDate order by requestNo desc')
  Future<List<OrderTable>> getByDate(String orderDate);

  @Query('select * from OrderTable where orderDate =:orderDate and station=:station order by requestNo desc')
  Future<List<OrderTable>> getByStation(String orderDate,String station);

  @Query('select * from OrderTable where orderId =:orderId')
  Future<List<OrderTable>> getByOrderId(String orderId);

  @Query('delete from OrderTable where orderId =:orderId')
  Future<void> deleteByOrderId(String orderId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addOrder(OrderTable orders);

  @delete
  Future<void> deleteOrder(OrderTable orders);

  @update
  Future<void>updateOrder(OrderTable orders);
}