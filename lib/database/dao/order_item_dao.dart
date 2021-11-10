import 'package:cns/database/entity/order_item_table.dart';
import 'package:floor/floor.dart';

@dao
abstract class OrderItemDao{
  @Query('select * from OrderItemTable')
  Future<List<OrderItemTable>> getAllOrderItem();

  @Query('select * from OrderItemTable where orderItemId =:orderItemId')
  Future<List<OrderItemTable>> getById(String orderItemId);

  @Query('select * from OrderItemTable where orderId =:orderId')
  Future<List<OrderItemTable>> getByOrderId(String orderId);

  @Query('delete from OrderItemTable where orderItemId =:orderItemId')
  Future<void> deleteItem(String orderItemId);

  @Query('delete from OrderItemTable where orderId =:orderId')
  Future<void> deleteByOrderID(String orderId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addOrderItem(OrderItemTable orderItems);

  @delete
  Future<void> deleteOrderItem(OrderItemTable orderItems);

  @update
  Future<void>updateOrderItem(OrderItemTable orderItems);
}