import 'package:fl_wms/screen/dashboard/screen/dashboard_screen.dart';
import 'package:fl_wms/main_layout/parent_layout.dart';
import 'package:fl_wms/screen/brand/screen/brand_screen.dart';
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
        // pageBuilder: (context, state, child) {
        //   return NoTransitionPage(child: ParentLayout(child: child));
        // },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: DashboardScreen(),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/brand',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: BrandScreen(),
              );
            },
            // pageBuilder: (context, state) {
            //   return CustomTransitionPage(
            //     // key: state.pageKey,
            //     child: const BrandScreen(),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) {
            //       return FadeTransition(
            //         opacity: CurveTween(curve: Curves.easeInOutCirc)
            //             .animate(animation),
            //       );
            //     },
            //   );
            // },
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
