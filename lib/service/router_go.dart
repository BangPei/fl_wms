import 'package:fl_wms/library/interceptor/navigation_service.dart';
import 'package:fl_wms/screen/category/screen/category_screen.dart';
import 'package:fl_wms/screen/dashboard/screen/dashboard_screen.dart';
import 'package:fl_wms/main_layout/parent_layout.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen.dart';
import 'package:fl_wms/screen/login/screen/login_screen.dart';
import 'package:fl_wms/screen/product/screen/product_form.dart';
import 'package:fl_wms/screen/product/screen/product_screen.dart';
import 'package:fl_wms/screen/uom/screen/uom_screen.dart';
import 'package:fl_wms/screen/warehouse/screen/warehouse_form_screen.dart';
import 'package:fl_wms/screen/warehouse/screen/warehouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../library/interceptor/injector.dart';

final NavigationService _nav = locator<NavigationService>();
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _productNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> _warehouseNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteNavigation {
  static final GoRouter router = GoRouter(
    navigatorKey: _nav.navKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        // parentNavigatorKey: _dashboardNavigatorKey,
        path: '/auth',
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: LoginScreen(),
          );
        },
      ),
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
          ),
          GoRoute(
            parentNavigatorKey: _warehouseNavigatorKey,
            path: '/warehouse/form',
            name: "add-warehouse",
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: WarehouseFormScreen(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _warehouseNavigatorKey,
            path: '/warehouse/form/:id',
            name: "edit-warehouse",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: WarehouseFormScreen(
                  warehouseId: int.parse(state.pathParameters['id']!),
                ),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        restorationScopeId: "",
        navigatorKey: _productNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(
            menu: "product",
            child: child,
          );
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _productNavigatorKey,
            path: '/product',
            name: "product",
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: ProductScreen(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _productNavigatorKey,
            path: '/product/form',
            name: "add-product",
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: ProductForm(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _productNavigatorKey,
            path: '/product/form/:id',
            name: "edit-product",
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: ProductForm(
                  id: int.parse(state.pathParameters['id']!),
                ),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _productNavigatorKey,
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
            parentNavigatorKey: _productNavigatorKey,
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
            parentNavigatorKey: _productNavigatorKey,
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
