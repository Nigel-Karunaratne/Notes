import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

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

  final quill.QuillController _controller = quill.QuillController.basic();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: quill.QuillToolbar.basic(
            controller: widget._controller,
            // showFontFamily: false,
            // showAlignmentButtons: true,

            // showImageButton: false,
            // showVideoButton: false,

            // fontFamilyValues: ,

          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            child: quill.QuillEditor.basic(controller: widget._controller, readOnly: false),
          ),
        ),
      ],
    );
  }
}