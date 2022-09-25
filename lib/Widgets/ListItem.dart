import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/DB/Notes_DB.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    super.key,
    required this.index,
    required this.note,
  });
  final Note note;
  final int index;
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late String title;
  late String description;
  late DateTime? date;

  @override
  Widget build(BuildContext context) {
    title = widget.note.title;
    description = widget.note.description;
    date = widget.note.date;
    final Dateformat = DateFormat.yMMMEd().format(date!);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        child: Material(
          color: Theme.of(context).cardColor,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/description',
                  arguments: [widget.index, widget.note]);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: GoogleFonts.cairo(
                          height: 1.7,
                          color:  Theme.of(context).textTheme.headline1!.color,
                          fontSize: 25,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      description,
                      maxLines: 3,
                      style: GoogleFonts.cairo(
                        height: 1,
                        color:  Theme.of(context).textTheme.headline2!.color,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(width: double.infinity,alignment: Alignment.centerRight,
                      child: Text(
                        Dateformat,
                        style: GoogleFonts.cairo(
                          height: 1,
                          color:  Theme.of(context).textTheme.headline2!.color,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
