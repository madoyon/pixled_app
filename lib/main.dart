import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/page_home.dart';
import 'pages/page_settings.dart';
import 'package:provider/provider.dart';
import 'models/device_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeviceList(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFD7BAFF),
          onPrimary: Color(0xFF3F1B6E),
          primaryContainer: Color(0xFF563586),
          onPrimaryContainer: Color(0xFFEDDCFF),
          secondary: Color(0xFFCEC2DA),
          onSecondary: Color(0xFF352D40),
          secondaryContainer: Color(0xFF4C4357),
          onSecondaryContainer: Color(0xFFEBDDF7),
          tertiary: Color(0xFFF2B7C2),
          onTertiary: Color(0xFF4B252E),
          tertiaryContainer: Color(0xFF653B44),
          onTertiaryContainer: Color(0xFFFFD9DF),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF1D1B1E),
          onBackground: Color(0xFFE7E1E6),
          surface: Color(0xFF1D1B1E),
          onSurface: Color(0xFFE7E1E6),
          surfaceVariant: Color(0xFF4A454E),
          onSurfaceVariant: Color(0xFFCCC4CF),
          outline: Color(0xFF958E99),
          onInverseSurface: Color(0xFF1D1B1E),
          inverseSurface: Color(0xFFE7E1E6),
          inversePrimary: Color(0xFF6F4DA0),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFFD7BAFF),
          outlineVariant: Color(0xFF4A454E),
          scrim: Color(0xFF000000),
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
          ),
          // ···
          titleLarge: GoogleFonts.epilogue(
            fontSize: 30,
          ),
          bodyLarge:
              GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.normal),
          bodyMedium:
              GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
          bodySmall:
              GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (currentPageIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError("No widget implemented yet for this index");
    }

    return Scaffold(
      appBar: null,
      body: page,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(
            () {
              currentPageIndex = index;
            },
          );
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home"),
          NavigationDestination(
              selectedIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: "Settings"),
        ],
      ),
    );
  }
}
