// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../../auth/presentation/auth_page.dart' as _i3;
import '../../../auth/presentation/sign_in_page.dart' as _i2;
import '../../../repos/presentations/starred_repos_page.dart' as _i4;
import '../../../splash/presentation/splash_page.dart' as _i1;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashPage());
    },
    SignInRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.SignInPage());
    },
    AuthRoute.name: (routeData) {
      final args = routeData.argsAs<AuthRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.AuthPage(
              key: args.key,
              authUri: args.authUri,
              redirectUriCallback: args.redirectUriCallback));
    },
    StarredReposRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.StarredReposPage());
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(SplashRoute.name, path: '/'),
        _i5.RouteConfig(SignInRoute.name, path: '/sign-in'),
        _i5.RouteConfig(AuthRoute.name, path: '/auth'),
        _i5.RouteConfig(StarredReposRoute.name, path: '/starred')
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.SignInPage]
class SignInRoute extends _i5.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/sign-in');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.AuthPage]
class AuthRoute extends _i5.PageRouteInfo<AuthRouteArgs> {
  AuthRoute(
      {_i6.Key? key,
      required Uri authUri,
      required void Function(Uri) redirectUriCallback})
      : super(AuthRoute.name,
            path: '/auth',
            args: AuthRouteArgs(
                key: key,
                authUri: authUri,
                redirectUriCallback: redirectUriCallback));

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs(
      {this.key, required this.authUri, required this.redirectUriCallback});

  final _i6.Key? key;

  final Uri authUri;

  final void Function(Uri) redirectUriCallback;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, authUri: $authUri, redirectUriCallback: $redirectUriCallback}';
  }
}

/// generated route for
/// [_i4.StarredReposPage]
class StarredReposRoute extends _i5.PageRouteInfo<void> {
  const StarredReposRoute() : super(StarredReposRoute.name, path: '/starred');

  static const String name = 'StarredReposRoute';
}
