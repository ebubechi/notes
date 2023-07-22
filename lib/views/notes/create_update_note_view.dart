import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
// import 'package:notes/services/cloud-firestore/cloud_storage_constants.dart';
import 'package:notes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:notes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';
// import '../../services/sql-crud/notes_service.dart';
// import '../../services/navigation/navigator_service.dart';
import '../../services/cloud-firestore/cloud_note.dart';
// import '../../services/cloud-firestore/cloud_storage_exceptions.dart';
import '../../services/cloud-firestore/firebase_cloud_storage.dart';

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({super.key});

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  // late final NavigatorService _navigatorService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _navigatorService = NavigatorService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListner() async {
    final note = _note;
    if (note != null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note!.documentId,
      text: text,
    );
  }

  void _setupTextControllerListner() {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_textControllerListner);
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(
        documentId: note.documentId,
      );
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  Future<CloudNote> _createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      // prepopulating the text field for editing
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(
      ownerUserId: userId,
    );
    _note = newNote;
    return newNote;
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.amberAccent,
          title: const Text('Your notes'),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text); 
                }
              },
              icon: const Icon(
                Icons.share,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: _createOrGetExistingNote(context),
          builder: (
            BuildContext context,
            AsyncSnapshot<CloudNote> snapshot,
          ) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // _note = snapshot.data as DatabaseNote;
                _setupTextControllerListner();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'Start typing your note...'),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:notes/services/auth/auth_service.dart';
// import 'package:notes/utilities/generics/get_arguments.dart';
// import '../../services/sql-crud/notes_service.dart';
// // import '../../services/navigation/navigator_service.dart';

// class CreateOrUpdateNoteView extends StatefulWidget {
//   const CreateOrUpdateNoteView({super.key});

//   @override
//   State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
// }

// class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
//   DatabaseNote? _note;
//   late final NotesService _notesService;
//   // late final NavigatorService _navigatorService;
//   late final TextEditingController _textController;

//   @override
//   void initState() {
//     _notesService = NotesService();
//     // _navigatorService = NavigatorService();
//     _textController = TextEditingController();
//     super.initState();
//   }

//   void _textControllerListner() async {
//     final note = _note;
//     if (note != null) {
//       return;
//     }
//     final text = _textController.text;
//     await _notesService.updateNote(
//       note: note!,
//       text: text,
//     );
//   }

//   void _setupTextControllerListner() {
//     _textController.removeListener(_textControllerListner);
//     _textController.addListener(_textControllerListner);
//   }

//   void _deleteNoteIfTextIsEmpty() async {
//     final note = _note;
//     if (_textController.text.isEmpty && note != null) {
//       await _notesService.deleteNote(id: note.id);
//     }
//   }

//   void _saveNoteIfTextNotEmpty() async {
//     final note = _note;
//     final text = _textController.text;
//     if (note != null && text.isNotEmpty) {
//       await _notesService.updateNote(
//         note: note,
//         text: text,
//       );
//     }
//   }

//   Future<DatabaseNote> _createOrGetExistingNote(BuildContext context) async {
//     final widgetNote = context.getArgument<DatabaseNote>();
//     if (widgetNote != null) {
//       _note = widgetNote;
//       // prepopulating the text field for editing
//       _textController.text = widgetNote.text;
//       return widgetNote;
//     }
//     final existingNote = _note;
//     if (existingNote != null) {
//       return existingNote;
//     }
//     final currentUser = AuthService.firebase().currentUser!;
//     final email = currentUser.email;
//     final owner = await _notesService.getUser(email: email);
//     final newNote = await _notesService.createNote(owner: owner);
//     _note = newNote;
//     return newNote;
//   }

//   @override
//   void dispose() {
//     _deleteNoteIfTextIsEmpty();
//     _saveNoteIfTextNotEmpty();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(150),
//         child: AppBar(
//           automaticallyImplyLeading: true,
//           backgroundColor: Colors.amberAccent,
//           title: const Text('Your notes'),
//         ),
//       ),
//       body: FutureBuilder(
//         future: _createOrGetExistingNote(context),
//         builder: (
//           BuildContext context,
//           AsyncSnapshot<DatabaseNote> snapshot,
//         ) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               // _note = snapshot.data as DatabaseNote;
//               _setupTextControllerListner();
//               return TextField(
//                 controller: _textController,
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//                 decoration: const InputDecoration(
//                     hintText: 'Start typing your note...'),
//               );
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
