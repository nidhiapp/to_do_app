import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application/data/database.dart';
import 'package:to_do_application/model/add_note_model.dart';
import 'package:to_do_application/utils/app_colors.dart';
import 'package:to_do_application/view/add_notes_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<AddNoteModel>> _noteList;

  final DateFormat _dateformatter = DateFormat('MMM dd ,yyyy');

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Widget _buildNote(AddNoteModel note) {
    print(note.title);
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.limedark,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
              '${_dateformatter.format(note.date!)} -  ${note.priority}',
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.limedark,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            leading: Icon(Icons.task),
            trailing: Checkbox(
                activeColor: AppColors.limedark,
                value: note.status == 1 ? true : false,
                onChanged: (value) {
                 
                  note.status == value ? 1 : 0;
                  DatabaseHelper.instance.updateNote(note);
                  _updateNoteList();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyNotesScreen(
                            note: note,
                            updateNoteList: _updateNoteList(),
                          )));
            },
          ),
          Divider(
            height: 2,
            thickness: 0.5,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    
    _noteList = DatabaseHelper.instance.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlime,
      appBar: AppBar(
        backgroundColor: AppColors.limedark,
        title: Text("To Do List"),
      ),
      body: FutureBuilder(
          future: _noteList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final int completeNoteCount = snapshot.data!
                .where((AddNoteModel note) => note.status == 1)
                .toList()
                .length;

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Tasks",
                          style: TextStyle(
                              color: AppColors.limedark,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '  $completeNoteCount of ${snapshot.data!.length}',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 115, 119, 84),
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )
                      ],
                    ),
                  );
                }
                return _buildNote(snapshot.data![index - 1]);
                // return Column(
                //   children: [
                //     ListTile(
                //       title: Text("task"),subtitle:Text("coloor"),

                //     ),
                //     Divider(height: 4,thickness: 0.5,)
                //   ],
                // );
              },
              itemCount: int.parse(snapshot.data!.length.toString()) + 1,
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.limedark,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyNotesScreen(
                        updateNoteList: _updateNoteList(),
                      )));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
