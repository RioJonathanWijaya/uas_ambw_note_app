import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/boxes.dart';
import 'package:note_app/note.dart';
import 'package:note_app/model/note.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Hive.deleteBoxFromDisk('notes');

  notebox = await Hive.openBox<Note>('notes');
  pinbox = await Hive.openBox<String>('pin');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: const notesView(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
