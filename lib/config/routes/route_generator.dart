import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/config/routes/routes.dart';
import 'package:travel_app/presentation/pages/account_details/account_detail.dart';
import 'package:travel_app/presentation/pages/details/detail_page.dart';
import 'package:travel_app/presentation/pages/home/home.dart';
import 'package:travel_app/presentation/pages/login-signup/verify_signup/verify_signup.dart';
import 'package:travel_app/presentation/pages/map/osm_map.dart';
import 'package:travel_app/presentation/pages/splash/splash_page.dart';
import 'package:travel_app/presentation/pages/trips/trips_page.dart';
import 'package:travel_app/presentation/pages/welcome/welcome_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.home:
        return CupertinoPageRoute(builder: (_) => Home());
      case Routes.verifyRegister:
        return CupertinoPageRoute(builder: (_) => VerifyRegisterScreen());

      case Routes.trips:
        return CupertinoPageRoute(builder: (_) => TripsPage());

      // case Routes.favorite:
      //   return CupertinoPageRoute(builder: (_) => FavoritePage());

      case Routes.detail:
        return CupertinoPageRoute(builder: (_) => DetailPage());

      case Routes.welcome:
        return CupertinoPageRoute(builder: (_) => WelcomeScreen());

      case Routes.profile:
        return CupertinoPageRoute(builder: (_) => AccountDetail());

      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => SplashPage());

      case Routes.osmmap:
        return CupertinoPageRoute(builder: (_) => MapSample());

      // return _errorRoute();

      // case Routes.profile:
      //    return CupertinoPageRoute(builder: (_) => List_Libraries());

      //     case Routes.login:
      //    return CupertinoPageRoute(builder: (_) => Login());

      //  case Routes.signUp:
      //    return CupertinoPageRoute(builder: (_) => SignUp());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
