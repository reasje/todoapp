import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// class ColorSlider extends StatefulWidget {
//   final Color noteColor;
//   ColorSlider({@required this.noteColor});
//   @override
//   _ColorSliderState createState() => _ColorSliderState();
// }

// class _ColorSliderState extends State<ColorSlider> {
//   final colors = [
//     Color(0xffffffff), // classic white
//     Color(0xfff28b81), // light pink
//     Color(0xfff7bd02), // yellow
//     Color(0xfffbf476), // light yellow
//     Color(0xffcdff90), // light green
//     Color(0xffa7feeb), // turquoise
//     Color(0xffcbf0f8), // light cyan
//     Color(0xffafcbfa), // light blue
//     Color(0xffd7aefc), // plum
//     Color(0xfffbcfe9), // misty rose
//     Color(0xffe6c9a9), // light brown
//     Color(0xffe9eaee) // light gray
//   ];

//   final Color borderColor = Color(0xffd3d3d3);
//   final Color foregroundColor = Color(0xff595959);

//   final _check = Icon(Icons.check);

//   Color noteColor;
//   int indexOfCurrentColor;
//   @override
//   void initState() {
//     super.initState();
//     this.noteColor = widget.noteColor;
//     indexOfCurrentColor = colors.indexOf(noteColor);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _myProvider = Provider.of<myProvider>(context);
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: List.generate(colors.length, (index) {
//         return GestureDetector(
//             onTap: () => (indexOfColor) {
//                   setState(() {
//                     noteColor = colors[indexOfColor];
//                     indexOfCurrentColor = indexOfColor;
//                   });
//                   _myProvider.changeNoteColor(colors[indexOfColor]);
//                 },
//             child: Padding(
//                 padding: EdgeInsets.only(left: 6, right: 6),
//                 child: Container(
//                     child: new CircleAvatar(
//                       child: _checkOrNot(index),
//                       foregroundColor: foregroundColor,
//                       backgroundColor: colors[index],
//                     ),
//                     width: 38.0,
//                     height: 38.0,
//                     padding: const EdgeInsets.all(1.0), // border width
//                     decoration: new BoxDecoration(
//                       color: borderColor, // border color
//                       shape: BoxShape.circle,
//                     ))));
//       }),
//     );
//   }

//   Widget _checkOrNot(int index) {
//     if (indexOfCurrentColor == index) {
//       return _check;
//     }
//     return null;
//   }
// }

// Widget ColorSlider(BuildContext context) {
//   final colors = [
//     Color(0xffffffff), // classic white
//     Color(0xfff28b81), // light pink
//     Color(0xfff7bd02), // yellow
//     Color(0xfffbf476), // light yellow
//     Color(0xffcdff90), // light green
//     Color(0xffa7feeb), // turquoise
//     Color(0xffcbf0f8), // light cyan
//     Color(0xffafcbfa), // light blue
//     Color(0xffd7aefc), // plum
//     Color(0xfffbcfe9), // misty rose
//     Color(0xffe6c9a9), // light brown
//     Color(0xffe9eaee) // light gray
//   ];
//   final Color borderColor = Color(0xffd3d3d3);
//   final Color foregroundColor = Color(0xff595959);

//   final _check = Icon(Icons.check);

//   final _myProvider = Provider.of<myProvider>(context);
//   return GridView.count(
//     crossAxisCount: 4,
//       children: List.generate(colors.length, (index) {
//         return GestureDetector(
//             onTap: () => (indexOfColor) {
//                   print('object');
//                   _myProvider.changeNoteColor(colors[indexOfColor], index);
//                 },
//             child: Padding(
//                 padding: EdgeInsets.only(left: 6, right: 6),
//                 child: Container(
//                     child: new CircleAvatar(
//                       child: _myProvider.indexOfSelectedColor == index
//                           ? _check
//                           : null,
//                       foregroundColor: foregroundColor,
//                       backgroundColor: colors[index],
//                     ),
//                     width: 38.0,
//                     height: 38.0,
//                     padding: const EdgeInsets.all(1.0), // border width
//                     decoration: new BoxDecoration(
//                       color: borderColor, // border color
//                       shape: BoxShape.circle,
//                     ))));
//       }),

//   );
// }
