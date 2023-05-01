import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../model/note_model.dart';

class NoteState {

  // used to save the keys in provider
  RxList<int> providerKeys = <int>[].obs;

  // the index of the main stack and the floating stack
  // to press the back button twice for getting back to the notes list ! without saving
  Rx<int> _notSaving = 0.obs;
  set notSaving(int value) => _notSaving.value = value;
  int get notSaving => _notSaving.value;

  Rxn<int?> _providerIndex = Rxn<int?>();
  set providerIndex(int? value) => _providerIndex.value = value;
  int? get providerIndex => _providerIndex.value;

  Rx<bool> _newNote = true.obs;
  set newNote(bool value) => _newNote.value = value;
  bool get newNote => _newNote.value;

  Rxn<Note?> _bnote = Rxn<Note?>();
  set bnote(Note? value) => _bnote.value = value;
  Note? get bnote => _bnote.value;

  // It is used to store
  // the theme status as string
  Box<String>? _prefsBox;
  set prefsBox(Box<String>? value) => _prefsBox = value;
  Box<String>? get prefsBox => _prefsBox;

  // Hive box for notes
  LazyBox<Note>? _noteBox;
  set noteBox(LazyBox<Note>? value) => _noteBox = value;
  LazyBox<Note>? get noteBox => _noteBox;

  NoteState();
}
