import 'package:flutter/material.dart';
import 'package:repo_viewer/auth/infra/github_authenticator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPage extends StatefulWidget {
  final Uri authUri;
  final void Function(Uri uri) redirectUriCallback;

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
    return Scaffold(
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.authUri.toString(),
          onWebViewCreated: (controller) {
            controller.clearCache();
            CookieManager().clearCookies();
          },
          navigationDelegate: (navigation) {
            if (navigation.url
                .startsWith(GithubAuthenticator.redirectURL.toString())) {
              widget.redirectUriCallback(Uri.parse(navigation.url));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
