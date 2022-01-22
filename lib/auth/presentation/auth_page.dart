import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  final Uri authUri;
  final void Function(Uri redirectUri) redirectUriCallback;

  const AuthPage({
    Key? key,
    required this.authUri,
    required this.redirectUriCallback,
  }) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
