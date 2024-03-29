import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/functions.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:todoapp/model/note_model.dart';
import 'package:todoapp/app/note_screen/logic/note_logic.dart';
import 'package:todoapp/theme/theme_logic.dart';
import 'package:todoapp/locales/locales.dart' as locale;
import 'package:get/get.dart';
import 'package:todoapp/widgets/buttons.dart';

import '../../../../applocalizations.dart';
import '../../../../widgets/snackbar.dart';
import '../../../note_screen/screen/note_screen.dart';

class ReOrderableCardWidget extends StatelessWidget {
  const ReOrderableCardWidget({Key? key, required this.note, this.notes, this.index}) : super(key: key);
  final Note note;
  final notes;
  final index;
  @override
  Widget build(BuildContext context) {
    final _noteLogic = Get.find<NoteLogic>();

    final _themeState = Get.find<ThemeLogic>().state;
    List<int>? keys = notes.keys.cast<int>().toList();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.only(left: w * 0.1, bottom: h * 0.01, right: w * 0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          color: Colors.transparent,
        ),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete_sweep,
          size: h * w * 0.0002,
          color: _themeState.textColor,
        ),
      ),
      onDismissed: (direction) async {
        var bnote = await notes.get(keys![index]);
        Note note = Note(bnote.title, bnote.text, bnote.isChecked, bnote.color, bnote.bnote.imageList, bnote.voiceList, bnote.taskList,
            bnote.resetCheckBoxs, bnote.password);
        notes.delete(keys[index]);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(MySnackBar(
          locale.undoNote.tr,
          'undoNote',
          true,
          context: context,
          index: index,
          noteBox: notes,
          note: note,
          keys: keys,
        ) as SnackBar);
      },
      child: AnimationConfiguration.staggeredList(
        position: index,
        delay: Duration(milliseconds: 100),
        child: SlideAnimation(
          duration: Duration(milliseconds: 2500),
          curve: Curves.fastLinearToSlowEaseIn,
          horizontalOffset: 30,
          verticalOffset: 300.0,
          child: Center(
            child: FlipAnimation(
              duration: Duration(milliseconds: 4000),
              curve: Curves.fastLinearToSlowEaseIn,
              flipAxis: FlipAxis.y,
              child: Container(
                  width: w * 0.9,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.009, vertical: w * 0.04),
                  margin: EdgeInsets.only(bottom: h * 0.01, top: isLandscape ? w * 0.1 : h * 0.002),
                  decoration: BoxDecoration(
                      color: Color(note.color!).withOpacity(0.5),
                      //border: Border.all(width: 1, color:  Colors.whiteSmoke),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  //clipBehavior: Clip.antiAlias,
                  child: Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: _themeState.textColor,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: false,

                                // tried too hard to make the expansion color and
                                // collapsed color personalized but there was  a problem
                                // Every widget when We call the notifier in the provider
                                // as I called one is ExpansionTile the Tile will be
                                // recreated so We have to define this specific listTile
                                // a key that the widget won't be changed !
                                title: InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _noteLogic.updateIsChecked(keys, index);
                                        },
                                        child: Container(
                                            height: h * 0.04,
                                            width: h * 0.04,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: _themeState.textColor!, width: 1.5),
                                                borderRadius: BorderRadius.circular(10),
                                                color: note.isChecked ?? false ? Color(note.color!).withOpacity(0.2) : null),
                                            child: note.isChecked ?? false
                                                ? Icon(
                                                    Icons.check_rounded,
                                                    size: h * 0.03,
                                                    color: Colors.white,
                                                  )
                                                : Container()),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(
                                              note.title!.length >= (w * 0.08).round()
                                                  ? note.title!.substring(0, (w * 0.08).round()) + "..."
                                                  : note.title!,
                                              softWrap: false,
                                              style: TextStyle(
                                                  color: _themeState.noteTitleColor[index],
                                                  fontSize: _themeState.isEn! ? h * w * 0.00011 : h * w * 0.00009,
                                                  fontWeight: _themeState.isEn! ? FontWeight.w100 : FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () async {
                                    if (note.password! == '' || note.password == null) {
                                      // does not have a password
                                      _noteLogic.loadNote(keys, index).then((value) {
                                        Get.to(() => NoteScreen(), transition: Transition.rightToLeft);
                                      });
                                    } else {
                                      print(note.password!);
                                      // have the password and it must be checked
                                      await screenLock<void>(
                                        context: context,
                                        correctString: note.password!,
                                        canCancel: true,
                                        didUnlocked: () {
                                          Get.back();
                                          _noteLogic.loadNote(keys, index).then((value) {
                                            print("Halo");
                                            Get.to(() => NoteScreen(), transition: Transition.rightToLeft);
                                          });
                                        },
                                        digits: note.password!.length,
                                      );
                                    }
                                  },
                                ),
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(w * 0.05),
                                    child: Text(
                                      note.text!.length > 1500 ? note.text!.toString().substring(0, 1500) + "..." : note.text!,
                                      style: TextStyle(
                                        color: _themeState.textColor,
                                        fontSize: h * w * 0.00008,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
          ),
        ),
      ),
    );
  }
}
