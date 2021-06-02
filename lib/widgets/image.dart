import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/notes_provider.dart';

class PicDetail extends StatelessWidget {
  final index;
  const PicDetail({Key key ,this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _myProvider = Provider.of<myProvider>(context);
    return Hero(
        tag: 'imageHero',
        transitionOnUserGestures: true,
        
        child: Image.memory(
          
          _myProvider.imageList[index],
        ));
  }
}
