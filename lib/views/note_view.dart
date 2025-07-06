import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/note_model.dart';
import '../helper/sql_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              SqlHelper().deleteallnote().whenComplete(() {
                setState(() {});
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        onPressed: () {
          TextEditingController title = TextEditingController();
          TextEditingController content = TextEditingController();
          showCupertinoDialog(
            context: context,
            builder: (_) {
              return CupertinoAlertDialog(
                title: Text("Add Note"),
                content: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      TextFormField(controller: title),
                      TextFormField(controller: content),
                    ],
                  ),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: Text("No",style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text("yes",style: TextStyle(fontWeight: FontWeight.bold),),
                    onPressed: () {
                      SqlHelper()
                          .addNote(
                            Note(title: title.text, content: content.text),
                          )
                          .whenComplete(() {
                            setState(() {});
                          });
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),

    );
  }
}
