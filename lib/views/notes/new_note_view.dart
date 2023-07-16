import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../../services/crud/notes_service.dart';
import '../../services/navigation/navigator_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final NavigatorService _navigatorService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _navigatorService = NavigatorService();
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
      note: note!,
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
      await _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
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
        ),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DatabaseNote> snapshot,
        ) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListner();
              return  TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                 hintText: 'Start typing your note...' 
                ),
                );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
