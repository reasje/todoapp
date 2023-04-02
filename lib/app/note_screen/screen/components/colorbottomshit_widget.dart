// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todoapp/provider/theme_provider.dart';
// class ColorBottomSheet extends StatefulWidget {
//   ColorBottomSheet({Key? key}) : super(key: key);

//   @override
//   _ColorBottomSheetState createState() => _ColorBottomSheetState();
// }

// class _ColorBottomSheetState extends State<ColorBottomSheet> {

//   @override
//   Widget build(BuildContext context) {
//               final _themeProvider =
//               Provider.of<ThemeProvider>(context, listen: false);
//               List<Color> colors = _themeProvider.getNoteColors();
              
//               return showModalBottomSheet(
//                   context: context,
//                   builder: (context) {
//                     return GridView(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3) , children: ,);
//                   });
//   }
// }