import 'package:aspireme_flutter/BackEnd/Database/sql_document_funciton.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_folder_function.dart';
import 'package:aspireme_flutter/BackEnd/Database/sql_note_functions.dart';
import 'package:aspireme_flutter/Pages/Globally%20Used/LoadingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class UserProfile extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //TODO: when starting a new app download users data if sync

  final FirebaseFirestore firebaseDatabase = FirebaseFirestore.instance;

  Future<void> signIn() async {
    try {
      await _signInWithGoogle();
    } catch (e) {
      debugPrint("sign in User profile : $e");
    }
  }

  Future<void> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await _auth.signInWithCredential(credential);
  }

  Future<void> syncDatabase(BuildContext context) async {
    showDialog(context: context, builder: (context) => const LoadingWidget());
    if (getUser == null) {
      await signIn();
    }

    try {
      if (_auth.currentUser == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Could Not Sign in")));
        }
        return;
      }

      // } throw Exception("current user null");

      final usersReference = await firebaseDatabase
          .collection("users")
          .doc("${_auth.currentUser?.uid}")
          .get();

      if (usersReference.exists) {
        await updateDatabase();
      } else {
        await createDatabase();
      }
    } catch (e) {
      debugPrint("Firebase syncDatabase : $e");
    } finally {
      if (context.mounted) Navigator.pop(context);
    }
  }

  User? get getUser => _auth.currentUser;

  Future<void> createDatabase() async {
    try {
      final allRawFolders = await Sqlfolderfunction.getAllRawFolders();
      final allRawDocumentModels =
          await Sqldocumentfunciton.getRawDocumentModels();
      final allRawNotes = await Sqlnotefunctions.getAllRawNotes();

      await firebaseDatabase.collection("users").doc("${getUser?.uid}").set({
        "userId": getUser?.uid,
        "folders": allRawFolders,
        "documents": allRawDocumentModels,
        "notes": allRawNotes,
        "timeStamp": DateFormat("dd/nn/yy").format(DateTime.now())
      });
    } catch (e) {
      debugPrint("createDatabase : $e");
    }
  }

  Future<void> updateDatabase() async {
    //TODO: doesnt actually update it drops the document then creates new maybe find a way to update each documents
    try {
      if (getUser?.uid == null) throw Exception("uid is null");
      await firebaseDatabase.collection("users").doc(getUser!.uid).delete();
      await createDatabase();
    } catch (e) {
      debugPrint("updateDatabase : $e");
    }
  }
}
