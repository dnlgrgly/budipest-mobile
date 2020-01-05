import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './ui/screens/home.dart';
import './ui/screens/addToilet.dart';

import './core/viewmodels/ToiletModel.dart';
import './core/common/variables.dart';

import './locator.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    useCountryCode: false,
    fallbackFile: 'en',
    path: 'assets/locales',
    forcedLocale: new Locale('en'),
  );
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await flutterI18nDelegate.load(null);
  runApp(Application(flutterI18nDelegate));
}

class Application extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  final FlutterI18nDelegate flutterI18nDelegate;

  Application(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => locator<ToiletModel>())
      ],
      child: MaterialApp(
        title: "Budipest",
        theme: ThemeData(
          primarySwatch: black,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Muli',
                fontSizeFactor: 1.4,
              ),
        ),
        initialRoute: '/',
        routes: {'/': (context) => Home(), '/add': (context) => AddToilet()},
        // routes: {'/': (context) => AddToilet()},
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          flutterI18nDelegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'), // English
          const Locale('hu'), // Hungarian
        ],
      ),
    );
  }
}
