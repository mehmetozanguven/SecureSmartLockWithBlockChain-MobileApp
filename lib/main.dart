import 'package:flutter/material.dart';
import 'package:smart_lock/src/localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_lock/src/view/forget_password_without_login.dart';
import 'package:smart_lock/src/view/login_page.dart';
import 'package:smart_lock/src/view/register_view.dart';
import 'package:smart_lock/src/view/user_drawer_menu_view.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          Localization.of(context).getText(text: "title"),
      localizationsDelegates: [
        const LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('tr', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/new_register':(context) => RegisterPage(),
        '/forget_password_without_login' : (context) => ForgetPasswordWithoutLoginPage(),
        '/user_qr_code_page' : (context) => UserDrawerMenuPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

