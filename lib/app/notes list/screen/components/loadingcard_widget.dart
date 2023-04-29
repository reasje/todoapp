import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/theme/theme_logic.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeState = Get.find<ThemeLogic>().state;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: _themeState.textColor!,
        highlightColor: _themeState.mainColor!,
        child: Container(
          height: h * 0.15,
          width: w * 0.8,
          padding: EdgeInsets.symmetric(horizontal: w * 0.01, vertical: w * 0.04),
          margin: EdgeInsets.only(bottom: h * 0.04, top: isLandscape ? w * 0.1 : h * 0.01),
          decoration: BoxDecoration(color: _themeState.textColor!.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
