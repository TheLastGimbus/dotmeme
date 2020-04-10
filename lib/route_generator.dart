import 'package:dotmeme/pages/home_page/home_page.dart';
import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/swiping_page':
        return (args is SwipingPageRouteData)
            ? MaterialPageRoute(
          builder: (_) =>
              SwipingPage(
                imagesList: args.imagesList,
                startIndex: args.startIndex,
              ),
        )
            : _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Whoopsie!')),
        body: Center(child: Text('We got some error here :/')),
      ),
    );
  }
}
