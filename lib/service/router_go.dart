import 'package:fl_wms/screen/category/screen/category_screen.dart';
import 'package:fl_wms/screen/dashboard/screen/dashboard_screen.dart';
import 'package:fl_wms/main_layout/parent_layout.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen.dart';
import 'package:fl_wms/screen/uom/screen/uom_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'dashboard');
final GlobalKey<NavigatorState> _shellNavigatorKey =
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
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(menu: "master", child: child);
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/brand',
            name: "brand",
            builder: (context, state) => const BrandScreen(),
            // pageBuilder: (context, state) {
            //   return NoTransitionPage(
            //     arguments: {"name": state.path},
            //     name: "brand-in",
            //     child: const BrandScreen(),
            //   );
            // },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
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
            parentNavigatorKey: _shellNavigatorKey,
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
