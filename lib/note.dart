import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/boxes.dart';
import 'package:note_app/model/note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class notesView extends StatefulWidget {
  const notesView({super.key});

  @override
  State<notesView> createState() => _notesViewState();
}

class _notesViewState extends State<notesView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  List<Note> noteList = [];

  getNotes() {
    setState(() {
      noteList = notebox.values.toList().cast<Note>();
    });
  }

  void addNote() {
    final String title = titleController.text;
    final String content = contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      final Note newNote = Note(
        title: title,
        content: content,
        createdAt: DateFormat('dd - MMMM - yyyy HH:mm')
            .format(DateTime.now())
            .toString(),
        updatedAt: DateFormat('dd - MMMM - yyyy HH:mm')
            .format(DateTime.now())
            .toString(),
      );
      setState(() {
        notebox.add(newNote);
        noteList.add(newNote);
      });

      print('Note added: $newNote');

      // Clear the text fields
      titleController.clear();
      contentController.clear();
    } else {
      print("nda masuk");
    }

    getNotes();
  }

  void _deleteNoteAt(Note index) async {
    print(noteList);
    setState(() {
      noteList.remove(index);

      print("Note deleted at index $index");
      notebox.delete(index);
      print(noteList);
      print(notebox);
    });
  }

  void showForm(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        showDragHandle: true,
        builder: (_) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Title',
                  ),
                  cursorColor: Color(0xFFF4CE14),
                  autocorrect: false,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Content',
                  ),
                  minLines: 10,
                  maxLines: 10,
                  cursorColor: Color(0xFFF4CE14),
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: addNote,
                    child: Text(
                      'Add Note',
                      style: GoogleFonts.montserrat(
                          color: Color(0xFF379777),
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4CE14))),
              ],
            ),
          ));
        });
  }

  void editForm(BuildContext context, Note? note) async {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);
    final createdAt = note?.createdAt;

    showModalBottomSheet(
        context: context,
        isDismissible: true,
        showDragHandle: true,
        builder: (_) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Title',
                  ),
                  cursorColor: Color(0xFFF4CE14),
                  autocorrect: false,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: 'Content',
                  ),
                  minLines: 10,
                  maxLines: 10,
                  cursorColor: Color(0xFFF4CE14),
                  keyboardType: TextInputType.multiline,
                  autocorrect: false,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () {
                      final String title = titleController.text;
                      final String content = contentController.text;

                      if (title.isNotEmpty && content.isNotEmpty) {
                        note?.title = titleController.text;
                        note?.content = contentController.text;
                        if (note != null) {
                          note?.updatedAt = DateFormat('dd - MMMM - yyyy HH:mm')
                              .format(DateTime.now());
                        }

                        setState(() {
                          notebox.putAt(
                              notebox
                                  .keyAt(notebox.values.toList().indexOf(note)),
                              note);
                          noteList[noteList.indexOf(note!)] = note!;
                        });
                      } else {
                        print("object");
                      }

                      getNotes();
                    },
                    child: Text(
                      'Edit Note',
                      style: GoogleFonts.montserrat(
                          color: Color(0xFF379777),
                          fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4CE14))),
              ],
            ),
          ));
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Notes",
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
              ),
              Column(
                children: noteList.map((e) {
                  return Dismissible(
                    key: Key(e.hashCode.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteNoteAt(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${e.title} deleted')),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  e.title,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(e.content,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                Text("Created: " + e.createdAt,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300)),
                                Text("Edited: " + e.createdAt,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                            SizedBox(width: 105),
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () => editForm(context, e),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF4CE14),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFF4CE14).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showForm(context);
        },
        backgroundColor: Color(0xFFF4CE14),
        child: Icon(Icons.add),
      ),
    );
  }
}
