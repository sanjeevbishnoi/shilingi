import 'package:flutter/material.dart';
import 'package:shilingi/src/pages/login/register.dart';

import './login.dart';
import './register.dart';
import './routepath.dart';

class LoginInformationParser extends RouteInformationParser<LoginRoutePath> {
  @override
  Future<LoginRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    if (routeInformation.location == null) {
      return const LoginRoutePath.login();
    }

    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.length == 1 && uri.pathSegments[0] == '/register') {
      return const LoginRoutePath.register();
    }
    return const LoginRoutePath.login();
  }

  @override
  RouteInformation? restoreRouteInformation(LoginRoutePath configuration) {
    switch (configuration.route) {
      case LoginRoute.login:
        return const RouteInformation(location: '/');
      case LoginRoute.register:
        return const RouteInformation(location: 'register');
    }
  }
}

class LoginRouteDelegate extends RouterDelegate<LoginRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<LoginRoutePath> {
  LoginRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  LoginRoute route = LoginRoute.login;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  LoginRoutePath? get currentConfiguration {
    return LoginRoutePath(route: route);
  }

  @override
  Future<void> setNewRoutePath(LoginRoutePath configuration) async {
    route = configuration.route;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
            child: LoginPage(
              goTo: (LoginRoute route) {
                this.route = route;
                notifyListeners();
              },
            ),
            key: const ValueKey('login')),
        if (route == LoginRoute.register)
          const MaterialPage(
              child: RegistrationPage(), key: ValueKey('authorize')),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        this.route = LoginRoute.login;
        notifyListeners();
        return true;
      },
    );
  }
}
