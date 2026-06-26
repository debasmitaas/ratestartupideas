import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/utils/app_theme.dart';
import 'data/repositories/idea_repository_impl.dart';
import 'presentation/providers/idea_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env", mergeWith: {}, isOptional: true);
  final prefs = await SharedPreferences.getInstance();
  final repository = IdeaRepositoryImpl(sharedPreferences: prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => IdeaProvider(repository: repository)),
      ],
      child: const StartupApp(),
    ),
  );
}

class StartupApp extends StatelessWidget {
  const StartupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Startup Idea Evaluator',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const MainScreen(),
        );
      },
    );
  }
}
