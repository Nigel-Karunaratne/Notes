import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: unused_import
import 'dart:convert';
import 'dart:io';

class TextEditorModel extends ChangeNotifier {
  int currentNote = 0;
  final List<String> notes = [];

  bool isSideBarExpanded = true;

  QuillController quillController = QuillController.basic(); //public

  Map<ShortcutActivator, void Function()> bindings = {};

  TextEditorModel() {
    //TODO: Initialize notes[]. Set currentNote to a new entry?
    bindings = {
      //App-Level Things
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
        saveCurrentNote();
      },
      //Formatting Text
      const SingleActivator(LogicalKeyboardKey.keyB, control: true): () {
        // ignore: avoid_print
        print(quillController.document.toDelta().toJson());
      },
      const SingleActivator(LogicalKeyboardKey.keyI, control: true): () {
      },
      const SingleActivator(LogicalKeyboardKey.keyU, control: true): () {}
    };
  }

  void saveCurrentNote() async{
    String json = jsonEncode(quillController.document.toDelta().toJson());
    File newFile = File("${Directory.current.path}\\notes\\${notes[currentNote]}.json");
    print(newFile.absolute);
    newFile.writeAsString(json, mode: FileMode.write);
    notifyListeners();
  }

  void loadNote() async {
    File newFile = File("${Directory.current.path}\\notes\\sdss.json");
    var x = jsonDecode(await newFile.readAsString());
    quillController = QuillController(document: Document.fromJson(x), selection: const TextSelection.collapsed(offset: 0));
    notifyListeners();
  }

  void createNewNote() {
    notes.add("");
    currentNote = notes.length-1;
    notifyListeners();
  }

  void deleteNote(int index) {
    notes.removeAt(index);
    if (currentNote - 1 < 0) {
      //create blank note
    }
    else {
      currentNote--;
    }
  }
}
