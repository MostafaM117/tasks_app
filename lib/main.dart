import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tasks_app/providers/app_provider.dart';
import 'package:tasks_app/home_page.dart';
import 'package:tasks_app/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider()..getisDark(),
      builder: (context, child) {
        return Consumer<AppProvider>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                appBarTheme: AppBarTheme(
                  backgroundColor: value.isDark ? Colors.black : Colors.white,
                  titleTextStyle: TextStyle(
                    color: value.isDark ? Colors.white : Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                scaffoldBackgroundColor: value.isDark
                    ? Colors.black
                    : Colors.white,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                  backgroundColor: value.isDark ? Colors.white : Colors.black,
                  foregroundColor: value.isDark ? Colors.black : Colors.white,
                ),
              ),
              home: const HomePage(),
            );
          },
        );
      },
    );
  }
}
