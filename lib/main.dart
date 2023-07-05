import 'package:fl_wms/library/interceptor/injector.dart';
import 'package:fl_wms/screen/brand/bloc/brand_bloc.dart';
import 'package:fl_wms/screen/category/bloc/category_bloc.dart';
import 'package:fl_wms/screen/uom/bloc/uom_bloc.dart';
import 'package:fl_wms/screen/warehouse/bloc/warehouse_bloc.dart';
import 'package:fl_wms/service/router_go.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BrandBloc>(create: (__) => BrandBloc()),
        BlocProvider<CategoryBloc>(create: (__) => CategoryBloc()),
        BlocProvider<UomBloc>(create: (__) => UomBloc()),
        BlocProvider<WarehouseBloc>(create: (__) => WarehouseBloc()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: RouteNavigation.router,
      ),
    );
  }
}
