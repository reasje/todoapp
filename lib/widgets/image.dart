import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/note_provider.dart';
import 'package:todoapp/provider/theme_provider.dart';

class PicDetail extends StatelessWidget {
  final index;
  const PicDetail({Key key ,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<NoteProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
          backgroundColor: _themeProvider.mainColor,
          body: InkWell(
            onTap: (){Navigator.pop(context);},
                      child: Center(
              child: Hero(
              tag: 'imageHero',
              transitionOnUserGestures: true,
              
              child: Image.memory(
                
                _myProvider.imageList[index],
              )),
            ),
          ),
    );
  }
}
