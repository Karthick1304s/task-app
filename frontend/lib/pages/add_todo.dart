import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 7, 20, 95),
              const Color.fromARGB(255, 10, 20, 77),
              const Color.fromARGB(255, 7, 17, 70),
              const Color.fromARGB(255, 5, 13, 63),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              IconButton(
                icon: Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    Text(
                      "New Note",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 25),
                    label("Task Title"),
                    SizedBox(height: 5),
                    title(context),
                    SizedBox(height: 25),
                    label("Task Type"),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        datatype("Important", Colors.blue),
                        SizedBox(width: 10),
                        datatype("Marked", Colors.red),
                      ],
                    ),
                    SizedBox(height: 25),
                    label("Task Description"),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget title(BuildContext context) {
  return Container(
    height: 60,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 82, 92, 101),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextFormField(
      style: TextStyle(color: Colors.grey, fontSize: 16),
      decoration: InputDecoration(
        hintText: "Task Title",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    ),
  );
}

Widget datatype(String label, Color color) {
  return Chip(
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    labelPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    backgroundColor: color,
  );
}

Widget title(BuildContext context) {
  return Container(
    height: 60,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 82, 92, 101),
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextFormField(
      style: TextStyle(color: Colors.grey, fontSize: 16),
      decoration: InputDecoration(
        hintText: "Task Title",
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    ),
  );
}

Widget label(String label) {
  return Text(
    label,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  );
}
