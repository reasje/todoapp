import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingState {

  PageController pageController = new PageController(initialPage: 0, keepPage: true);

  final _currentPage = 0.obs;
  set currentPage(int value) => _currentPage.value = value;
  int get currentPage => _currentPage.value;

  OnBoardingState();
}
