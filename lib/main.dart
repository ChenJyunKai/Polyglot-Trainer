import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpg/helper/app_theme.dart';
import 'package:rpg/provider/ability.dart';
import 'package:rpg/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final hasData = prefs.getString('ability') != null;
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    ProviderScope(
      child: MyApp(hasData: hasData),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.hasData});

  final bool hasData;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    if (widget.hasData) {
      Future.delayed(Duration.zero, () => ref.read(abilityProvider.notifier).getAbility());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Training',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primaryContainer: AppTheme.background,
        ),
      ),
      builder: (context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        ),
      ),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: routes[settings.name]!, settings: settings);
      },
      initialRoute: widget.hasData ? homeUrl : welcomeUrl,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
        Locale('en', 'US'),
      ],
    );
  }
}
