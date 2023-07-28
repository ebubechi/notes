// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
// import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/services/auth/firebase_auth_provider.dart';
import 'package:notes/views/auth/register_view.dart';
import 'package:notes/views/auth/forgot_password_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'dart:developer' as devtools show log;

// import 'services/auth/auth_user.dart';
import 'helpers/loading/loading_screen.dart';
import 'views/auth/login_view.dart';
// import 'views/auth/register_view.dart';
import 'views/auth/verify_email_view.dart';
import 'views/notes/create_update_note_view.dart';
import 'views/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      // loginRoutes: (context) => const LoginView(),
      // registerRoutes: (context) => const RegisterView(),
      // notesRoutes: (context) => const NotesView(),
      // verifyEmailRoutes: (context) => const VerifyEmailView(),
      createOrUpdateNotesRoutes: (context) => const CreateOrUpdateNoteView(),
    },
   supportedLocales: AppLocalizations.supportedLocales,
   localizationsDelegates: AppLocalizations.localizationsDelegates,
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}




// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FutureBuilder(
//           future: AuthService.firebase().initialize(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 final AuthUser? user = AuthService.firebase().currentUser;
//                 if (user != null) {
//                   if (user.isEmailVerified) {
//                     devtools.log('Email is verified');
//                     return const NotesView();
//                   } else {
//                     return const VerifyEmailView();
//                   }
//                 } else {
//                   return const LoginView();
//                 }
//               default:
//                 return const Scaffold(
//                     body: Center(child: CircularProgressIndicator()));
//             }
//           }),
//     );
//   }
// }


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context) => CounterBloc(),
//       child: Scaffold(
//           appBar: PreferredSize(
//             preferredSize: const Size.fromHeight(150),
//             child: AppBar(
//               automaticallyImplyLeading: true,
//               backgroundColor: Colors.amberAccent,
//               title: const Text('Testing Bloc'),
//               actions: [
//                 IconButton(
//                   onPressed: () async {},
//                   icon: const Icon(
//                     Icons.share,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /// * [BlocConsumer] is a combination of [BlocListner] and [BlocBuilder]
//           body: BlocConsumer<CounterBloc, CounterState>(
//             builder: (BuildContext context, state) {
//               final invalidValue = (state is CounterStateInvalidNumber)
//                   ? state.invalidValue
//                   : '';
//               return Column(
//                 children: [
//                   Text('Current value =>   ${state.value}'),
//                   Visibility(
//                     visible: state is CounterStateInvalidNumber,
//                     child: Text('Invalid input:  $invalidValue'),
//                   ),
//                   TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter a number here',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   Row(
//                     children: [
//                       TextButton(
//                           onPressed: () {
//                             context.watch()
//                                 .read<CounterBloc>()
//                                 .add(DecrementEvent(_controller.text));
//                           },
//                           child: const Text('-')),
//                       TextButton(
//                           onPressed: () {
//                             context
//                                 .read<CounterBloc>()
//                                 .add(IncrementEvent(_controller.text));
//                           },
//                           child: const Text('+')),
//                     ],
//                   )
//                 ],
//               );
//             },
//             listener: (BuildContext context, state) {
//               _controller.clear();
//             },
//           )),
//     );
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValidNumber extends CounterState {
//   const CounterStateValidNumber(
//     int value,
//   ) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;

//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(super.value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(super.value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValidNumber(0)) {
//     on<IncrementEvent>(((event, emit) {
//       conditionalEvent(event, emit, sign: '+');
//     }));
//     on<DecrementEvent>(((event, emit) {
//       conditionalEvent(event, emit, sign: '-');
//     }));
//   }

//   void conditionalEvent(event, Emitter<CounterState> emit,
//       {required String sign}) {
//     final integer = int.tryParse(event.value);
//     if (integer == null) {
//       emit(CounterStateInvalidNumber(
//         invalidValue: event.value,
//         previousValue: state.value,
//       ));
//     } else {
//       if (sign == '+') {
//         emit(CounterStateValidNumber(state.value + integer));
//       } else {
//         emit(CounterStateValidNumber(state.value - integer));
//       }
//     }
//   }
// }
