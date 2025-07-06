import 'package:flutter/material.dart';
import 'package:note_app/views/note_view.dart';

import 'helper/sql_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SqlHelper().getDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteScreen(),
    );
  }
}
