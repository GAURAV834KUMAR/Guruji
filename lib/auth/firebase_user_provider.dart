import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class GurujiFirebaseUser {
  GurujiFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

GurujiFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<GurujiFirebaseUser> gurujiFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<GurujiFirebaseUser>(
      (user) {
        currentUser = GurujiFirebaseUser(user);
        return currentUser!;
      },
    );
