import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:solution_challenge_project/core/routing/go_router_refresh_stream.dart';
import 'package:solution_challenge_project/core/routing/not_found_screen.dart';
import 'package:solution_challenge_project/feautre/authentication/data/firebase_auth_repository.dart';
import 'package:solution_challenge_project/feautre/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:solution_challenge_project/feautre/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:solution_challenge_project/feautre/home/home_page.dart';

enum AppRoute {
  home,
 
  signIn,
 }

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository =  ref.watch(firebaseAuthRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        if (state.location == '/signIn') {
          return '/';
        }
      } else {
                  return '/signIn';

        if (state.location == '/account' || state.location == '/orders') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.userStream()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const HomePage(),
        routes: [
     

          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
