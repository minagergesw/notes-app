import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'Notes_DB.g.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1)();
  TextColumn get description => text().withLength(min: 1)();
  DateTimeColumn get date => dateTime().nullable()();
}

@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  Future<List<Note>> getAllNotes() async {
    return await select(notes).get();
  }

  Stream<List<Note>> watchAllNotes() {
    return select(notes).watch();
  }

  Stream<Note> getSingleNote(int id) {
    return (select(notes)..where((item) => item.id.equals(id))).watchSingle();
  }

  Future<int> insertNote(NotesCompanion note) async {
    return await into(notes).insert(note);
  }

  Future updateNote(NotesCompanion note) async {
    return await update(notes).replace(note);
  }

  Future deleteNote(int id) async {
    return await (delete(notes)..where((item) => item.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file, logStatements: true);
  });
}
