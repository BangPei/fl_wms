import 'package:fl_wms/screen/category/screen/category_screen.dart';
import 'package:fl_wms/screen/dashboard/screen/dashboard_screen.dart';
import 'package:fl_wms/main_layout/parent_layout.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen.dart';
import 'package:fl_wms/screen/uom/screen/uom_screen.dart';
import 'package:fl_wms/screen/warehouse/screen/warehouse_form_screen.dart';
import 'package:fl_wms/screen/warehouse/screen/warehouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _masterNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> _warehouseNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteNavigation {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        restorationScopeId: "",
        navigatorKey: _dashboardNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(
            menu: "dashboard",
            child: child,
          );
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _dashboardNavigatorKey,
            path: '/',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: DashboardScreen(),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        restorationScopeId: "",
        navigatorKey: _warehouseNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(
            menu: "warehouse",
            child: child,
          );
        },
        routes: [
          GoRoute(
              parentNavigatorKey: _warehouseNavigatorKey,
              path: '/warehouse',
              name: "warehouse",
              pageBuilder: (context, state) {
                return const NoTransitionPage(
                  child: WarehouseScreen(),
                );
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: _warehouseNavigatorKey,
                  path: 'form',
                  name: "warehouse-form",
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      arguments: {"name": state.path},
                      name: "warehouse-form",
                      child: const WarehouseFormScreen(),
                    );
                  },
                ),
              ]),
        ],
      ),
      ShellRoute(
        navigatorKey: _masterNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(menu: "master", child: child);
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _masterNavigatorKey,
            path: '/brand',
            name: "brand",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                arguments: {"name": state.path},
                name: "brand",
                child: const BrandScreen(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _masterNavigatorKey,
            path: '/category',
            name: "category",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                arguments: {"name": state.path},
                name: "category",
                child: const CategoryScreen(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _masterNavigatorKey,
            path: '/uom',
            name: "uom",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                arguments: {"name": state.path},
                name: "uom",
                child: const UomScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
