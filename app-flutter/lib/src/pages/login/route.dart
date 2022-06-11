import 'package:flutter/material.dart';

import './login.dart';
import './authorize.dart';

class LoginRoutePath {
  const LoginRoutePath({this.isAuthorize = false});

  final bool isAuthorize;
}

class LoginInformationParser extends RouteInformationParser<LoginRoutePath> {
  @override
  Future<LoginRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return const LoginRoutePath();
    }

    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == '/authorize') {
      return const LoginRoutePath(isAuthorize: true);
    }
    return const LoginRoutePath();
  }

  @override
  RouteInformation? restoreRouteInformation(LoginRoutePath configuration) {
    if (configuration.isAuthorize) {
      return const RouteInformation(location: '/authorize');
    }

    return const RouteInformation(location: '/');
  }
}

class LoginRouteDelegate extends RouterDelegate<LoginRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<LoginRoutePath> {
  LoginRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  bool isAuthorize = false;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  LoginRoutePath? get currentConfiguration {
    if (isAuthorize) {
      return const LoginRoutePath(isAuthorize: true);
    }
    return const LoginRoutePath();
  }

  @override
  Future<void> setNewRoutePath(LoginRoutePath configuration) async {
    if (configuration.isAuthorize) {
      isAuthorize = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        const MaterialPage(child: LoginPage(), key: ValueKey('login')),
        if (isAuthorize)
          const MaterialPage(
              child: AuthorizePage(), key: ValueKey('authorize')),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        isAuthorize = false;
        notifyListeners();
        return true;
      },
    );
  }
}
