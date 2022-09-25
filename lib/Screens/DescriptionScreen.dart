import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/DB/Notes_DB.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({super.key});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  late String title;
  late String description;
  late DateTime date;
  late int id;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    final argsList = ModalRoute.of(context)!.settings.arguments as List;
    double index = double.parse(argsList[0].toString());
    Note note = argsList[1];
    title = note.title;
    description = note.description;
    date = note.date!;
    print(date);
    id = note.id;
    final Dateformat = DateFormat.yMMMEd().format(date);

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
          foregroundColor: Theme.of(context).textTheme.headline1!.color,
          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
          actions: [
            IconButton(
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
                                  initialValue: title,
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
                                  initialValue: description,
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

                                      await database.updateNote(NotesCompanion(
                                        id: drift.Value(id),
                                        title: drift.Value(title),
                                        description: drift.Value(description),
                                        date: drift.Value(DateTime.now()),
                                      ));
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Save'))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.edit_rounded)),
            IconButton(
                onPressed: () async {
                  await database.deleteNote(id);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete_rounded))
          ]),
      body: StreamBuilder(
          stream: database.getSingleNote(id),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              title = snapshot.data!.title;
              description = snapshot.data!.description;
              date = snapshot.data!.date!;
            }
            return SafeArea(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Hero(
                      tag: index,
                      child: Material(
                        type: MaterialType.transparency,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    title,
                                    style: GoogleFonts.cairo(
                                        height: 1.7,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .color,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    description,
                                    style: GoogleFonts.cairo(
                                        height: 1,
                                        letterSpacing: 1.2,
                                        wordSpacing: 1.2,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Dateformat,
                                    style: GoogleFonts.cairo(
                                      height: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .color,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ))),
            );
          }),
    );
  }
}
