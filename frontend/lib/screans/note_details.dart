import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/note.dart';
import '../utils/database_helper.dart';

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, "/login"); // Adjust route if needed
}

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetails(this.note, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {
    return NoteDetailsState(note, appBarTitle);
  }
}

class NoteDetailsState extends State<NoteDetails> {
  static const _priorities = ['High', 'Low'];
  final DatabaseHelper helper = DatabaseHelper();

  final String appBarTitle;
  final Note note;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  NoteDetailsState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {
            moveToLastScreen();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton<String>(
                items:
                    _priorities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged: (value) {
                  setState(() {
                    updatePriorityAsInt(value!);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (_) => updateTitle(),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (_) => updateDescription(),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColorLight,
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                      child: const Text('Save', textScaleFactor: 1.5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _delete,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColorLight,
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                      child: const Text('Delete', textScaleFactor: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    note.priority = (value == 'High') ? 1 : 2;
  }

  String getPriorityAsString(int value) {
    return value == 1 ? 'High' : 'Low';
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    Navigator.pop(context, true); // ✅ Always return true to trigger refresh
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id!);
    _showAlertDialog(
      'Status',
      result != 0 ? 'Note Deleted Successfully' : 'Error Deleting Note',
    );
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text(title), content: Text(message)),
    );
  }
}
