import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
// ignore: depend_on_referenced_packages
import 'package:tuple/tuple.dart';
import 'package:provider/provider.dart';

import 'package:notes/model.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TextEditorModel(),
    child: MaterialApp(
      title: "Notes",
      theme: ThemeData(useMaterial3: true, primaryColor: Colors.amber),
      routes: {"/": (context) => const MainView()},
      initialRoute: "/",
    ),
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
    return CallbackShortcuts(
      bindings: Provider.of<TextEditorModel>(context, listen: false).bindings,
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Provider.of<TextEditorModel>(context).isSideBarExpanded ? SidePanel() : Container(),
            const VerticalDivider(
              thickness: 10,
              width: 10,
            ),
            Expanded(child: TextView()),
          ],
        ),
      ),
    );
  }
}

class TextView extends StatefulWidget {
  TextView({Key? key}) : super(key: key);

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: QuillToolbar.basic(
              controller: Provider.of<TextEditorModel>(context).quillController,
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
              fontFamilyValues: const {"Roboto Mono": "RobotoMono"}),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: QuillEditor(
              controller: Provider.of<TextEditorModel>(context, listen: false)
                  .quillController,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              autoFocus: true,
              readOnly: false,
              placeholder: 'Start Typing...',
              expands: false,
              padding: EdgeInsets.zero,
              customStyles: DefaultStyles(
                placeHolder: DefaultTextBlockStyle(
                    const TextStyle(
                      fontFamily: "RobotoMono",
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    const Tuple2(8, 0),
                    const Tuple2(0, 0),
                    null),
                paragraph: DefaultTextBlockStyle(
                    const TextStyle(
                      fontFamily: "RobotoMono",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    const Tuple2(8, 0),
                    const Tuple2(0, 0),
                    null),
                h1: DefaultTextBlockStyle(
                    const TextStyle(
                      fontFamily: "RobotoMono",
                      fontSize: 48,
                      color: Colors.black,
                    ),
                    const Tuple2(8, 0),
                    const Tuple2(0, 0),
                    null),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SidePanel extends StatefulWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditorModel>(
      builder: ((context, model, child) => SizedBox(
        width: 200,
        child: ListView.builder(
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextButton(
                onPressed: () {
    
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder()),
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]!),
                  textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black, fontFamily: "RobotoMono"))
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text(model.notes[index]),
                ),
              ),
            );
          }),
          itemCount: model.notes.length,
        ),
      )),
    );
  }
}