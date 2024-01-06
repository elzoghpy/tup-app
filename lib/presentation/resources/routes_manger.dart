// ignore_for_file: unreachable_switch_case

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tupapp/app/di.dart';
import 'package:tupapp/presentation/forgot_password/view/forgot_password_view.dart';
import 'package:tupapp/presentation/login/view/login_view.dart';
import 'package:tupapp/presentation/main/main_view.dart';
import 'package:tupapp/presentation/onboarding/view/onboarding_view.dart';
import 'package:tupapp/presentation/register/view/register_view.dart';
import 'package:tupapp/presentation/resources/strings_manger.dart';
import 'package:tupapp/presentation/store_details/store_details_view.dart';

import '../splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const registerView());
      case Routes.forgotPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.storeDetailsRoute:
        initStoreDetailsModule();

        return MaterialPageRoute(builder: (_) => const StoreDetailsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound.tr()),
              ),
              body: Center(child: Text(AppStrings.noRouteFound.tr())),
            ));
  }
}
