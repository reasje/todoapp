import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/provider/theme_provider.dart';

class LoadingCardWidget extends StatelessWidget {
  const LoadingCardWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    double SizeX = MediaQuery.of(context).size.height;
    double SizeY = MediaQuery.of(context).size.width;
    double SizeXSizeY = SizeX * SizeY;
        bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: _themeProvider.textColor,
        highlightColor: _themeProvider.mainColor,
        child: Container(
          height: SizeX * 0.15,
          width: SizeY * 0.8,
          padding: EdgeInsets.symmetric(
              horizontal: SizeY * 0.01, vertical: SizeY * 0.04),
          margin: EdgeInsets.only(
              bottom: SizeX * 0.04,
              top: isLandscape ? SizeY * 0.1 : SizeX * 0.01),
          decoration: BoxDecoration(
              color: _themeProvider.textColor.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}