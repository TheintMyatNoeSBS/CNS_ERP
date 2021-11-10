import 'package:cns/database/dao/generic_dao.dart';
import 'package:cns/database/dao/item_dao.dart';
import 'package:cns/database/dao/item_unit_dao.dart';
import 'package:cns/database/dao/login_user_dao.dart';
import 'package:cns/database/dao/order_dao.dart';
import 'package:cns/database/dao/order_item_dao.dart';
import 'package:cns/database/dao/program_dao.dart';
import 'package:cns/database/dao/station_dao.dart';
import 'package:cns/database/entity/generic_table.dart';
import 'package:cns/database/entity/item_table.dart';
import 'package:cns/database/entity/item_unit_table.dart';
import 'package:cns/database/entity/login_user_table.dart';
import 'package:cns/database/entity/order_item_table.dart';
import 'package:cns/database/entity/order_table.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

import 'dao/user_dao.dart';
import 'entity/program_table.dart';
import 'entity/station_entity.dart';
import 'entity/user_table.dart';

part 'appdatabase.g.dart';
@Database(version: 6,entities: [UserTable,GenericTable,
  ItemTable,ItemUnitTable,OrderTable,OrderItemTable,StationTable,
  ProgramTable,LoginUserTable
])
abstract class AppDatabase extends FloorDatabase{
  UserDao get userDao;
  GenericDao get genericDao;
  ItemDao get itemDao;
  ItemUnitDao get itemUnitDao;
  OrderItemDao get orderItemDao;
  OrderDao get orderDao;
  StationDao get stationDao;
  ProgramDao get programDao;
  LoginUserDao get loginUserDao;

}