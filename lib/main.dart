import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
// ignore: depend_on_referenced_packages
import 'package:tuple/tuple.dart';

void main() {
  runApp(MaterialApp(
    title: "Notes",
    theme: ThemeData(
      useMaterial3: true,
      primaryColor: Colors.amber
    ),
    routes: {
      "/": (context) => const MainView()
    },
    initialRoute: "/",
  ));
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Center(
      //     child: Text("App Name"),
      //   ),
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox( //TODO: Make this it's own class w/ ability to expand and retract it
            width: 200,
            child: ListView.builder(
              itemBuilder: ((context, index) {
                return Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  margin: const EdgeInsets.symmetric(vertical: 1,),
                  color: Colors.grey[300]!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Text("Card #$index"),
                  ),
                );
              }),
              itemCount: 10,
            ),
          ),


          const VerticalDivider(
            thickness: 10,
            width: 10,
          ),
          Expanded(
            child: TextView()
          ),
        ],
      ),
    );
  }
}

class TextView extends StatefulWidget {
  TextView({Key? key}) : super(key: key);

  @override
  State<TextView> createState() => _TextViewState();

  final QuillController _controller = QuillController.basic();
}

class _TextViewState extends State<TextView> {
  final _focusNode = FocusNode();

  void _b(RawKeyEvent value) {
      if (value is RawKeyDownEvent) {
        if(value.logicalKey == LogicalKeyboardKey.keyB) {
          widget._controller.formatText(widget._controller.selection.end, 0, Attribute.bold);
        }
      if(value.logicalKey == LogicalKeyboardKey.keyU) {
          widget._controller.formatText(widget._controller.selection.end, 0, Attribute.underline);
        }
      if(value.logicalKey == LogicalKeyboardKey.keyI) {
          widget._controller.formatText(widget._controller.selection.end, 0, null);
        }
      }
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_b);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RawKeyboard.instance.addListener(_b);
        
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: QuillToolbar.basic(
            controller: widget._controller,

            showAlignmentButtons: true,
            showDividers: true,

            showBackgroundColorButton: false,
            showLink: false,
            showColorButton: false,
            showCodeBlock: false,
            showInlineCode: false,
            showFontFamily: false,
            showFontSize: false,
            showImageButton: false,
            showVideoButton: false,
            
            fontFamilyValues: const {"Roboto Mono": "RobotoMono"}

          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            // child: QuillEditor.basic(
            //   controller: widget._controller,
            //   readOnly: false,
            // ),
            child: QuillEditor(
              controller: widget._controller,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              autoFocus: false,
              readOnly: false,
              placeholder: 'Start Typing...',
              expands: false,
              padding: EdgeInsets.zero,

              customStyles: DefaultStyles(
                paragraph: DefaultTextBlockStyle(
                  const TextStyle(
                    fontFamily: "RobotoMono",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  const Tuple2(8, 0),
                  const Tuple2(0, 0),
                  null
                ),
                h1: DefaultTextBlockStyle(
                  const TextStyle(
                    fontFamily: "RobotoMono",
                    fontSize: 48,
                    color: Colors.black,
                  ),
                  const Tuple2(8, 0),
                  const Tuple2(0, 0),
                  null
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }
}