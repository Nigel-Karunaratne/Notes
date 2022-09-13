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
      //Formatting Text         // print(quillController.document.toDelta().toJson());
      //bold
      const SingleActivator(LogicalKeyboardKey.keyB, control: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("bold")) {
          quillController.formatSelection(Attribute.clone(Attribute.bold, null));
        } else {
          quillController.formatSelection(Attribute.bold);
        }
      },
      //italic
      const SingleActivator(LogicalKeyboardKey.keyI, control: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("italic")) {
          quillController.formatSelection(Attribute.clone(Attribute.italic, null));
        } else {
          quillController.formatSelection(Attribute.italic);
        }
      },
      //underline
      const SingleActivator(LogicalKeyboardKey.keyU, control: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("underline")) {
          quillController.formatSelection(Attribute.clone(Attribute.underline, null));
        } else {
          quillController.formatSelection(Attribute.underline);
        }
      },
      //strikethrough
      const SingleActivator(LogicalKeyboardKey.keyS, control: true, alt: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("strike")) {
          quillController.formatSelection(Attribute.clone(Attribute.strikeThrough, null));
        } else {
          quillController.formatSelection(Attribute.strikeThrough);
        }
      },

      // left align
      const SingleActivator(LogicalKeyboardKey.keyL, control: true, shift: true): () {
          quillController.formatSelection(Attribute.leftAlignment);
      },
      // center align
      const SingleActivator(LogicalKeyboardKey.keyE, control: true, shift: true): () {
          quillController.formatSelection(Attribute.centerAlignment);
      },
      // right align
      const SingleActivator(LogicalKeyboardKey.keyR, control: true, shift: true): () {
          quillController.formatSelection(Attribute.rightAlignment);
      },
      
      //normal weighting
      const SingleActivator(LogicalKeyboardKey.digit4, control: true): () {
          //TODO : FIX THIS => quillController.formatSelection(Attribute.??);
      },
      // h1 weighting
      const SingleActivator(LogicalKeyboardKey.digit1, control: true): () {
          quillController.formatSelection(Attribute.h1);
      },
      // h2 weighting
      const SingleActivator(LogicalKeyboardKey.digit2, control: true): () {
          quillController.formatSelection(Attribute.h2);
      },
      // h3 weighting
      const SingleActivator(LogicalKeyboardKey.digit3, control: true): () {
          quillController.formatSelection(Attribute.h3);
      },
      
      // ordered list
      const SingleActivator(LogicalKeyboardKey.digit7, control: true, shift: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("list")) {
          quillController.formatSelection(Attribute.clone(Attribute.ol, null));
        } else {
          quillController.formatSelection(Attribute.ol);
        }
      },
      // unordered list
      const SingleActivator(LogicalKeyboardKey.digit8, control: true, shift: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("list")) {
          quillController.formatSelection(Attribute.clone(Attribute.ul, null));
        } else {
          quillController.formatSelection(Attribute.ul);
        }
      },
      // checkbox //* Checkboxes may cause crashing??
      const SingleActivator(LogicalKeyboardKey.digit9, control: true, shift: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("list")) {
          quillController.formatSelection(Attribute.clone(Attribute.unchecked, null));
        } else {
          quillController.formatSelection(Attribute.unchecked);
        }
      },
      
      // block quote
      const SingleActivator(LogicalKeyboardKey.digit6, control: true, shift: true): () {
        if(quillController.getSelectionStyle().attributes.keys.contains("blockquote")) {
          quillController.formatSelection(Attribute.clone(Attribute.blockQuote, null));
        } else {
          quillController.formatSelection(Attribute.blockQuote);
        }
      },
      // indent left
      const SingleActivator(LogicalKeyboardKey.bracketLeft, control: true): () {
        quillController.formatSelection(Attribute.indent);
      },
      // indent right //TODO : allow for multiple indents
      const SingleActivator(LogicalKeyboardKey.bracketRight, control: true): () {
        quillController.formatSelection(Attribute.indentL1);
      },
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
