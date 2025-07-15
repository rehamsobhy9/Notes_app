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
              SqlHelper.deleteallnote().whenComplete(() {
                setState(() {});
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                      SqlHelper
                          .addNote(
                            Note(title: title.text, content: content.text)
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
        }, child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<Map>>(
          future: SqlHelper.loadDate(),
          builder: (context,AsyncSnapshot<List<Map>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction){
                      SqlHelper.deletenote(
                          snapshot.data![index]['id']).whenComplete(
                              (){setState(() {});});
                    },
                    child: Card(
                      color: Colors.white60,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.purple.shade200,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text('${snapshot.data![index]['title']}')),
                                Text('${snapshot.data![index]['content']}'),
                              ],
                            ),
                            IconButton(
                                onPressed: (){
                                  String title = '';
                                  String content = '';
                                  showCupertinoDialog(context: context,
                                      builder: (_){
                                        return CupertinoAlertDialog(
                                          title: Text("Update Note"),
                                          content: Material(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  initialValue: snapshot.data![index]['title'],
                                                  onChanged: (value){
                                                    title = value;
                                                  },),
                                                TextFormField(
                                                  initialValue: snapshot.data![index]['content'],
                                                  onChanged: (value){
                                                    content = value;
                                                  },),
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
                                                SqlHelper.updatenote(
                                                    Note(
                                                      title: title == '' ? snapshot.data![index]['title'] : title,
                                                      content: content == '' ? snapshot.data![index]['content'] : content,
                                                      id: snapshot.data![index]
                                                      ['id'],
                                                    ))
                                                    .whenComplete(() {
                                                  setState(() {});
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.edit)),
                            Text('${index+1}',style: TextStyle(
                                fontSize: 50
                            ),)
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
