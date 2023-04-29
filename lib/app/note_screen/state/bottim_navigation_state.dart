import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/model/bottomnav_tab_model.dart';
import 'package:todoapp/model/navigationitem_model.dart';

class BottomNavState {

  List<Color> tabColors = [Color(0xffaa66cc), Color(0xFFff4444), Color(0xFFffbb33), Color(0xFF33b5e5), Color(0xFF00c851)];

  PageController? pageController;

  ScrollController scrollController = new ScrollController();

  // list of images that will be loaded on user tap
  RxList<BottomNavTab> tabs = [].obs as RxList<BottomNavTab>;

  RxList<NavigationItem> items = [].obs as RxList<NavigationItem>;

  Rx<int> _selectedTab = 0.obs;
  set selectedTab(int value) => _selectedTab.value = value;
  int get selectedTab => _selectedTab.value;
  
  BottomNavState();
}