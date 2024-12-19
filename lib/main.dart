import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviebar/core/providers/app_provider.dart';
import 'package:moviebar/core/providers/auth_provider.dart';
import 'package:moviebar/view/categories/categories_view_model.dart';
import 'package:moviebar/view/home/home_view_model.dart';
import 'package:moviebar/view/login/login_view.dart';
import 'package:moviebar/view/login/login_view_model.dart';
import 'package:moviebar/view/profile/profile_view_model.dart';
import 'package:moviebar/view/search/search_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()),
        ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ],
      child: const Moviebar(),
    ),
  );
}

class Moviebar extends StatelessWidget {
  const Moviebar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moviebar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
