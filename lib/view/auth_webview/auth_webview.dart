import 'package:flutter/material.dart';
import 'package:moviebar/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthWebView extends StatefulWidget {
  final String authUrl;
  final String requestToken;
  final String apiReadToken;

  const AuthWebView({
    super.key,
    required this.authUrl,
    required this.requestToken,
    required this.apiReadToken,
  });

  @override
  State<AuthWebView> createState() => _AuthWebViewState();
}

class _AuthWebViewState extends State<AuthWebView> {
  late final WebViewController _controller;
  late final _authProvider = Provider.of<AuthProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('/approve')) {
              // Onay sayfasına geldiğimizde orijinal request token'ı döndür
              Navigator.of(context).pop(widget.requestToken);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {
            if (url.contains('/approve')) {
              await _authProvider.authenticate(widget.requestToken);

              Navigator.of(context).pop(widget.requestToken);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'TMDB Authorization',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
