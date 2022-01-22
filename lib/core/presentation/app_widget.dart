import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/auth/application/auth_notifier.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.gr.dart';

final initProvider = FutureProvider<Unit>((ref) async {
  print('initProvider');
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.updateAuthState();
  return unit;
});

class AppWidget extends StatelessWidget {
  final appRouter = AppRouter();

  AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: initProvider,
      onChange: (context, value) {},
      child: ProviderListener<AuthState>(
        provider: authNotifierProvider,
        onChange: (context, state) {
          print('auth state: $state');
          state.maybeMap(
            authenticated: (_) {
              appRouter.replaceAll([
                const StarredReposRoute(),
              ]);
            },
            unauthenticated: (_) {
              appRouter.replaceAll([
                const SignInRoute(),
              ]);
            },
            orElse: () {},
          );
        },
        child: MaterialApp.router(
          title: 'Repo Viewer',
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
