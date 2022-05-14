import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences _prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      child: MyApp(
        token: _prefs.getBool('login'),
        role: _prefs.getString("role"),
      ),
    ),
  );
}
