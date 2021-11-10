import 'package:cns/database/model/generic_model.dart';
import 'package:cns/database/model/item_model.dart';
import 'package:cns/database/model/item_unit_model.dart';
import 'package:cns/database/model/request_item.dart';
import 'package:cns/database/model/station_model.dart';
import 'package:cns/screen/change_password_screen.dart';
import 'package:cns/screen/home_screen.dart';
import 'package:cns/screen/inventory_screen.dart';
import 'package:cns/screen/item_detail_screen.dart';
import 'package:cns/screen/login_screen.dart';
import 'package:cns/screen/order_detail_screen.dart';
import 'package:cns/screen/ordering_list_screen.dart';
import 'package:cns/screen/splash_screen.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database/model/item_list_model.dart';
import 'database/model/request_detail_model.dart';
import 'database/model/request_model.dart';
import 'database/model/user_model.dart';
import 'screen/about_us_screen.dart';

// @dart=2.9
Future<void> main() async {
  GestureBinding.instance?.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
//  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final ItemListModel _itemDetailModel;
  static const primaryColor = const Color(0xFF1268A7);

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: GenericProvider()),
        ChangeNotifierProvider.value(value: ItemProvider()),
        ChangeNotifierProvider.value(value: ItemUnitProvider()),
        ChangeNotifierProvider.value(value: StationProvider()),
        ChangeNotifierProvider.value(value: RequestItemProvider()),
        ChangeNotifierProvider.value(value: RequestProvider()),
        ChangeNotifierProvider.value(value: RequestDetailProvider()),

      ],
      child: MaterialApp(
        initialRoute: SplashScreen.routeName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
        ),
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          InventoryScreen.routeName: (context) => InventoryScreen(),
          ItemDetailScreen.routeName: (context) => ItemDetailScreen(_itemDetailModel),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
          OrderListScreen.routeName: (context) => OrderListScreen(),
          OrderDetailScreen.routeName: (context) => OrderDetailScreen(),
          AboutUsScreen.routeName: (context) => AboutUsScreen(),
        },
      ),
    );
  }
}


