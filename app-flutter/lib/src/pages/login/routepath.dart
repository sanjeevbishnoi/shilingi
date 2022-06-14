enum LoginRoute {
  login,
  register,
}

class LoginRoutePath {
  const LoginRoutePath({required this.route});

  const LoginRoutePath.login() : this(route: LoginRoute.login);
  const LoginRoutePath.register() : this(route: LoginRoute.register);

  final LoginRoute route;

  bool get isLogin => route == LoginRoute.login;
  bool get isRegister => route == LoginRoute.register;
}
