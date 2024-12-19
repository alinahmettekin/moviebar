import 'package:flutter/material.dart';
import 'package:moviebar/core/providers/auth_provider.dart';
import 'package:moviebar/core/services/tmdb_service.dart';
import 'package:moviebar/view/auth_webview/auth_webview.dart';
import 'package:moviebar/view/navigation/navigation_view.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  late final AuthProvider _authProvider;
  final tmdbService = TMDBService();
  bool isLoading = false;

  Future<void> handleLogin(BuildContext context) async {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    isLoading = true;
    await _authProvider.checkAuthStatus();
    if (_authProvider.isAuthenticated) {
      if (context.mounted) _navigateToHomeView(context);
      return;
    }
    try {
      // Take request token from TMDBy
      final requestToken = await _authProvider.createRequestToken();

      // Open webiview for to user for approve
      final approvedToken = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => AuthWebView(
            authUrl: tmdbService.getAuthUrl(requestToken),
            requestToken: requestToken,
            apiReadToken: tmdbService.apiReadToken,
          ),
        ),
      );

      // İf user approved to token
      if (approvedToken != null) {
        // Complete authentication process with approved token
        await _authProvider.authenticate(approvedToken);
        if (_authProvider.isAuthenticated) {
          if (context.mounted) _navigateToHomeView(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      isLoading = false;
    }
  }

  void checkAuthStatus(BuildContext context) {}
}

_navigateToHomeView(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationView(),
    ),
  );
}
