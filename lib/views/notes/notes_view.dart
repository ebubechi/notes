import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/cloud-firestore/firebase_cloud_storage.dart';
// import 'package:notes/services/sql-crud/notes_service.dart';
import 'package:notes/services/navigation/navigator_service.dart';
import 'package:notes/views/notes/notes_listt_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import 'dart:developer' as devtools show log;

import '../../services/cloud-firestore/cloud_note.dart';
import '../../utilities/dialogs/show_logout_dialog.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  late final NavigatorService _navigatorService;

  @override
  void initState() {
    _navigatorService = NavigatorService();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final navigator = Navigator.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.amberAccent,
            title: StreamBuilder<int>(
                stream: _notesService.allNotes(ownerUserId: userId).getLength,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final noteCount = snapshot.data ?? 0;
                    final text = context.loc.notes_title(noteCount);
                  return Text(text);
                  } else {
                    return const Text('');
                  }
                }),
            actions: [
              IconButton(
                  onPressed: () {
                    _navigatorService.navPush(
                        context, createOrUpdateNotesRoutes,
                        note: null);
                    // Navigator.of(context).pushNamed(newNotesRoutes);
                  },
                  icon: const Icon(Icons.add)),
              PopupMenuButton<MenuAction>(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text(context.loc.logout_button),
                    )
                  ];
                },
                onSelected: (value) async {
                  var contextRead = context.read<AuthBloc>();
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      // devtools.log(shouldLogout.toString());
                      if (shouldLogout) {
                        contextRead.add(const AuthEventLogOut());
                        // await AuthService.firebase().logOut();
                        // navigator.pushNamedAndRemoveUntil(
                        //     loginRoutes, (_) => false);
                      }
                  }
                },
              )
            ],
          ),
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (
            BuildContext context,
            AsyncSnapshot<Iterable<CloudNote>> snapshot,
          ) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  // int index = 0;
                  // devtools.log(allNotes.elementAt(index).text.toString());
                  for (var element in allNotes) {
                    devtools.log(element.text);
                  }
                  return NoteListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                        documentId: note.documentId,
                      );
                    },
                    onTap: (CloudNote note) {
                      _navigatorService.navPush(
                          context, createOrUpdateNotesRoutes,
                          note: note);
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
// import 'package:flutter/material.dart';
// import 'package:notes/services/auth/auth_service.dart';
// import 'package:notes/services/sql-crud/notes_service.dart';
// import 'package:notes/services/navigation/navigator_service.dart';
// import 'package:notes/views/notes/notes_listt_view.dart';

// import '../../constants/routes.dart';
// import '../../enums/menu_action.dart';
// import 'dart:developer' as devtools show log;

// import '../../utilities/dialogs/show_logout_dialog.dart';

// class NotesView extends StatefulWidget {
//   const NotesView({super.key});

//   @override
//   State<NotesView> createState() => _NotesViewState();
// }

// class _NotesViewState extends State<NotesView> {
//   late final NotesService _notesService;
//   String get userEmail => AuthService.firebase().currentUser!.email;
//   late final NavigatorService _navigatorService;

//   @override
//   void initState() {
//     _navigatorService = NavigatorService();
//     _notesService = NotesService();
//     _notesService.open();
//     // devtools.log(_notesService.getUser(email: getUserEmail).toString());
//     super.initState();
//   }

//   // @override
//   // void dispose() {
//   //   _notesService.close();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final navigator = Navigator.of(context);
//     return Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(150),
//           child: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.amberAccent,
//             title: const Text('Your notes'),
//             actions: [
//               IconButton(
//                   onPressed: () {
//                     _navigatorService.navPush(
//                         context, createOrUpdateNotesRoutes, note: null);
//                     // Navigator.of(context).pushNamed(newNotesRoutes);
//                   },
//                   icon: const Icon(Icons.add)),
//               PopupMenuButton<MenuAction>(
//                 itemBuilder: (BuildContext context) {
//                   return const [
//                     PopupMenuItem<MenuAction>(
//                       value: MenuAction.logout,
//                       child: Text('Log out'),
//                     )
//                   ];
//                 },
//                 onSelected: (value) async {
//                   switch (value) {
//                     case MenuAction.logout:
//                       final shouldLogout = await showLogOutDialog(context);
//                       // devtools.log(shouldLogout.toString());
//                       if (shouldLogout) {
//                         await AuthService.firebase().logOut();
//                         navigator.pushNamedAndRemoveUntil(
//                             loginRoutes, (_) => false);
//                       }
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//         body: FutureBuilder(
//           future: _notesService.getOrCreateUser(email: userEmail),
//           builder:
//               (BuildContext context, AsyncSnapshot<DatabaseUser> snapshot) {
//             switch (snapshot.connectionState) {
//               case (ConnectionState.none):
//                 return const Text('Nothing Yet...');
//               case (ConnectionState.waiting):
//                 return const CircularProgressIndicator();
//               // case (ConnectionState.active):
//               //   break;
//               case (ConnectionState.done):
//                 return StreamBuilder(
//                   stream: _notesService.allNotes,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<DatabaseNote>> snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.active:
//                         if (snapshot.hasData) {
//                           final allNotes = snapshot.data as List<DatabaseNote>;
//                           devtools.log(allNotes.toString());
//                           return NoteListView(
//                             notes: allNotes,
//                             onDeleteNote: (note) async {
//                               await _notesService.deleteNote(
//                                 id: note.id,
//                               );
//                             },
//                             onTap: (DatabaseNote note) {
//                               _navigatorService.navPush(
//                                   context, createOrUpdateNotesRoutes, note: note);
//                             },
//                           );
//                         } else {
//                           return const CircularProgressIndicator();
//                         }
//                       default:
//                         return const CircularProgressIndicator();
//                     }
//                   },
//                 );
//               default:
//                 return const CircularProgressIndicator();
//             }
//           },
//         ));
//   }
// }
