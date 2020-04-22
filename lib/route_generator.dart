import 'package:dotmeme/pages/home_page/home_page.dart';
import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:dotmeme/pages/testing_page/testing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) =>
              MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => MemesProvider()),
                  ChangeNotifierProvider(create: (_) => HomePageProvider()),
                ],
                child: HomePage(),
              ),
        );
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
      case '/testing_page':
        return MaterialPageRoute(builder: (_) => TestingPage());

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
