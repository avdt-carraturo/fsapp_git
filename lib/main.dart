import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_links/app_links.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/notifications_page.dart';
import 'widgets/footer_nav.dart';
import 'widgets/scan_result_dialog.dart';
import 'theme/app_theme.dart';
import 'package:fsapp_shared/shared.dart';
import 'services/auth_wrapper.dart';
import 'pages/welcome_page.dart';
import 'providers/theme_provider.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

bool get isMobile {
  return !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
       defaultTargetPlatform == TargetPlatform.iOS);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (isMobile) {
    //await FirebaseMessaging.instance.requestPermission();
  }

 

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TravelWithSecurityApp()
      )
    );
}

class TravelWithSecurityApp extends StatelessWidget {
  const TravelWithSecurityApp({super.key});

  @override
  Widget build(BuildContext context) {
  final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: rootNavigatorKey,
      title: 'Travel with Security',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const WelcomePage(),
    );
  }
}