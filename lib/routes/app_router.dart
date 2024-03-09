import 'package:flutter_app_familia/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/family/:id',
    name: FamiliarScreen.routeName,
    builder: (context, state) => FamiliarScreen(
      familyId: state.pathParameters['id']??'1',
    )
  ),
  GoRoute(
    path: '/budget',
    name: PresupuestoScreen.routeName,
    builder: (context, state) => const PresupuestoScreen(),
  ),
  GoRoute(
      path: '/spends',
      name: SpendsScreen.routeName,
      builder: (context, state) => const SpendsScreen()),
]);
