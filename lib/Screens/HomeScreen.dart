import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/DB/Notes_DB.dart';
import 'package:notes_app/Theme/Style.dart';
import 'package:notes_app/Theme/Theme_Provider.dart';
import 'package:notes_app/Widgets/ListItem.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AnimatedTheme(
      // curve: Curves.easeInBack,
      duration: const Duration(milliseconds: 300),
      data: themeProvider.currentTheme == 'light'
          ? Style.lightTheme(context)
          : Style.darkTheme(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Notes',
            style: GoogleFonts.cairo(
                height: 1.7,
                color: Theme.of(context).textTheme.headline1!.color,
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              color: Theme.of(context).textTheme.headline1!.color,
              onPressed: () {
                if (themeProvider.currentTheme == 'light') {
                  setState(() {
                    themeProvider.changeTheme('dark');
                  });
                } else {
                  setState(() {
                    themeProvider.changeTheme('light');
                  });
                }
              },
              icon: Icon(themeProvider.currentTheme == 'light'
                  ? Icons.mode_night_rounded
                  : Icons.wb_sunny_rounded),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            StreamBuilder(
                stream: database.watchAllNotes(),
                builder: (context, snapshot) {
                  List notes = snapshot.data ?? [];
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Note note = notes[index];

                      return Column(
                        children: [
                          Hero(
                              tag: index,
                              child: Material(
                                  type: MaterialType.transparency,
                                  child: ListItem(index: index, note: note))),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: notes.length,
                  );
                })
          ]),
        ),
        floatingActionButton: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColorDark,
            foregroundColor: Colors.white,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Title',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                title = value.toString();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: 6,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                description = value.toString();
                              },
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 50),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  await database.insertNote(NotesCompanion(
                                    title: drift.Value(title),
                                    description: drift.Value(description),
                                    date: drift.Value(DateTime.now()),
                                  ));
                                  Navigator.pop(context);
                                } else {}
                              },
                              child: Text('Save'))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(
              Icons.post_add_rounded,
              size: 36,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
