import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application/data/database.dart';
import 'package:to_do_application/model/add_note_model.dart';
import 'package:to_do_application/utils/app_colors.dart';
import 'package:to_do_application/view/home.dart';

class MyNotesScreen extends StatefulWidget {
  final AddNoteModel? note;
  final Function? updateNoteList;
  final Function? deleteNoteList;

  MyNotesScreen(
      {super.key, this.note, this.updateNoteList, this.deleteNoteList});

  @override
  State<MyNotesScreen> createState() => _MyNotesScreenState();
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String selectedPriority = 'Low';
  String btnText = "Add Note";
  String titleText = "Add Note";

//controllers

  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  //TextEditingController _priorityController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final List<String> _priorties = ["High", "Medium", "Low"];
  DateTime _date = DateTime.now();

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _title = _titleController.text.toString().trim();
      print('$_title, $_date, $selectedPriority');

      AddNoteModel note =
          AddNoteModel(title: _title, date: _date, priority: selectedPriority);

      if (widget.note == null) {
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        note.id = widget.note!.id;
        note.status = widget.note!.status;

        DatabaseHelper.instance.updateNote(note);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }

      if (widget.updateNoteList != null) {
        widget.updateNoteList!();
      }
      Navigator.pop(context);

      
    }
  }

  
  _handleDtePicker() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormat.format(date);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      selectedPriority = widget.note!.priority!;
      setState(() {
        btnText = "update note";
        titleText = "update note";
      });
    } else {
      setState(() {
        btnText = "Add Note";
        titleText = "Add Note";
      });
    }
    _dateController.text = _dateFormat.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlime,
      appBar: AppBar(
        backgroundColor: AppColors.limedark,
        title: Text("Add Note Screen"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Icon(Icons.arrow_back),
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: Text(
                          titleText,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                              hintText: "title of task",
                              labelText: "Task",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          validator: (input) => input!.trim().isEmpty
                              ? "please enter note"
                              : null,
                          onSaved: (input) => _title != input,
                          // initialValue: title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "Date",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.limedark),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onTap: _handleDtePicker,
                          readOnly: true,
                          controller: _dateController,
                          decoration: InputDecoration(
                              hintText: "Date",
                              labelText: "Date",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          "Priority",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.limedark),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: DropdownButtonFormField(
                            items: _priorties.map((String priority) {
                              return DropdownMenuItem(
                                  value: priority,
                                  child: Text(
                                    priority,
                                    style: TextStyle(fontSize: 15),
                                  ));
                            }).toList(),
                            style: TextStyle(
                                fontSize: 10, color: AppColors.limedark),
                            decoration: InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 22,
                                  color: AppColors.limedark,
                                ),
                                labelText: "priority",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            validator: (input) =>
                                _priorties == null ? "please select" : null,
                            onChanged: (String? newvalue) {
                              setState(() {
                                selectedPriority = newvalue!;
                              });
                            },
                            value: selectedPriority,
                          )),
                      Container(
                        height: 60,
                        width: double.infinity,
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: AppColors.limedark),
                        child: MaterialButton(
                            onPressed: _submit,
                            child: Text(
                              btnText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
