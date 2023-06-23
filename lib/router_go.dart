import 'package:fl_wms/home_screen.dart';
import 'package:fl_wms/main_layout/parent_layout.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteNavigation {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ParentLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const DashboardScreen();
            },
          ),
          GoRoute(
            path: '/brand',
            builder: (BuildContext context, GoRouterState state) {
              return const BrandScreen2();
            },
            // routes: <RouteBase>[
            //   GoRoute(
            //     path: 'brand',
            //     pageBuilder: (context, state) {
            //       return CustomTransitionPage(
            //         key: state.pageKey,
            //         child: BrandScreen(),
            //         transitionsBuilder:
            //             (context, animation, secondaryAnimation, child) {
            //           return FadeTransition(
            //             opacity: CurveTween(curve: Curves.easeInOutCirc)
            //                 .animate(animation),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ],
          ),
          GoRoute(
            path: '/category',
            builder: (BuildContext context, GoRouterState state) {
              return BrandScreen();
            },
            // routes: <RouteBase>[
            //   GoRoute(
            //     path: 'brand',
            //     pageBuilder: (context, state) {
            //       return CustomTransitionPage(
            //         key: state.pageKey,
            //         child: BrandScreen(),
            //         transitionsBuilder:
            //             (context, animation, secondaryAnimation, child) {
            //           return FadeTransition(
            //             opacity: CurveTween(curve: Curves.easeInOutCirc)
            //                 .animate(animation),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ],
          ),
        ],
      ),
    ],
  );
}
