import 'package:doko_app/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../views/sign_up_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.token, required this.role}) : super(key: key);
  final bool? token;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_7f513d735daa4f81b1d65353ce27d220",
      builder: (context, navigatorKey) {
        return MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: token == null
                ? const SignupPage()
                : Homepage(
                    role: role!,
                  ));
      },
    );
  }
}
