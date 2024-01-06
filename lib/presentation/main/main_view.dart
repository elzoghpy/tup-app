// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tupapp/presentation/main/pages/home/home_view/home_page.dart';
import 'package:tupapp/presentation/main/pages/notifications/notification_page.dart';
import 'package:tupapp/presentation/main/pages/search/search_page.dart';
import 'package:tupapp/presentation/main/pages/settings/setting_page.dart';
import 'package:tupapp/presentation/resources/color_manager.dart';
import 'package:tupapp/presentation/resources/strings_manger.dart';
import 'package:tupapp/presentation/resources/values_manger.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const NotificationsPage(),
    const SettingsPage()
  ];
  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr(),
  ];

  var _title = AppStrings.home.tr();
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          // Theme.of(context).textTheme.titleSmall
          style: TextStyle(
            color: ColorManager.white,
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
            selectedItemColor: ColorManager.primary,
            unselectedItemColor: ColorManager.grey,
            currentIndex: _currentIndex,
            onTap: onTap,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: AppStrings.home.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: AppStrings.search.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_none_outlined),
                label: AppStrings.notifications.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppStrings.settings.tr(),
              ),
            ]),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
