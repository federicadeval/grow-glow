import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/dashboard_screen.dart';
import '../../features/fitness/presentation/screens/fitness_screen.dart';
import '../../features/fitness/presentation/screens/workout_screen.dart';
import '../../features/fitness/presentation/screens/diet_screen.dart';
import '../../features/beauty/presentation/screens/beauty_screen.dart';
import '../../features/beauty/presentation/screens/routine_detail_screen.dart';
import '../../features/todo/presentation/screens/todo_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/supplements/presentation/screens/supplement_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/fitness',
            builder: (context, state) => const FitnessScreen(),
            routes: [
              GoRoute(
                path: 'workout',
                builder: (context, state) => const WorkoutScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/diet',
            builder: (context, state) => const DietScreen(),
          ),
          GoRoute(
            path: '/beauty',
            builder: (context, state) => const BeautyScreen(),
            routes: [
              GoRoute(
                path: 'routine/:id',
                builder: (context, state) => RoutineDetailScreen(
                  routineId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/todo',
            builder: (context, state) => const TodoScreen(),
          ),
          GoRoute(
            path: '/supplements',
            builder: (context, state) => const SupplementScreen(),
          ),
        ],
      ),
    ],
  );
});
