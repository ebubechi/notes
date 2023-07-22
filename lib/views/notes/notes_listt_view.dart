import 'package:flutter/material.dart';
// import 'package:notes/services/sql-crud/notes_service.dart';

import '../../services/cloud-firestore/cloud_note.dart';
import '../../utilities/dialogs/show_delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  // final List<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NoteListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListTile(
              onTap: () => onTap(note),
              title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
              ),
            ),
          );
        });
  }
}
// import 'package:flutter/material.dart';
// import 'package:notes/services/sql-crud/notes_service.dart';

// import '../../utilities/dialogs/show_delete_dialog.dart';

// typedef NoteCallback = void Function(DatabaseNote note);

// class NoteListView extends StatelessWidget {
//   final List<DatabaseNote> notes;
//   final NoteCallback onDeleteNote;
//   final NoteCallback onTap;
//   const NoteListView({
//     super.key,
//     required this.notes,
//     required this.onDeleteNote,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return ListTile(
//             onTap: () => onTap(note),
//             title: Text(
//               note.text,
//               maxLines: 1,
//               softWrap: true,
//               overflow: TextOverflow.ellipsis,
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () async {
//                 final shouldDelete = await showDeleteDialog(context);
//                 if (shouldDelete) {
//                   onDeleteNote(note);
//                 }
//               },
//             ),
//           );
//         });
//   }
// }
