import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kitakyushu_shukatu/ui/favorite/favorite_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteManager(),
      child: const MyApp(),
    ),
  );
}
