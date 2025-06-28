import 'package:flutter/material.dart';
import 'package:frontend/model/note.dart';
import 'package:frontend/screans/note_details.dart';
import 'package:frontend/utils/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  NoteList({super.key});
  final user = FirebaseAuth.instance.currentUser;

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  late List<Note> noteList = [];

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.headlineMedium;

    return ListView.builder(
      itemCount: count + 1,
      itemBuilder: (BuildContext context, int position) {
        if (position == 0) {
          // Big profile card at top
          return Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.email ?? "Unknown User",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Logged in",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final note = noteList[position - 1];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            elevation: 3.0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(note.priority),
                child: getPriorityIcon(note.priority),
              ),
              title: Text(note.title, style: titleStyle),
              subtitle: Text(note.date),
              trailing: GestureDetector(
                child: const Icon(Icons.delete, color: Colors.grey),
                onTap: () => _delete(context, note),
              ),
              onTap: () {
                navigateToDetails(note, 'Edit Note');
              },
            ),
          );
        }
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetails(Note note, String title) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetails(note, title)),
    );

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
