import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/app/logic/theme_provider.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: _themeProvider.textColor,
        highlightColor: _themeProvider.mainColor,
        child: Container(
          height: h * 0.15,
          width: w * 0.8,
          padding: EdgeInsets.symmetric(horizontal: w * 0.01, vertical: w * 0.04),
          margin: EdgeInsets.only(bottom: h * 0.04, top: isLandscape ? w * 0.1 : h * 0.01),
          decoration: BoxDecoration(color: _themeProvider.textColor.withOpacity(0.1), borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
