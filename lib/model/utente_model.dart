import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokecho/model/bean/Utente.dart';

class UtenteModel {
  UtenteModel();

  //riferimento agli utenti di Firestore
  final CollectionReference utenti =
      FirebaseFirestore.instance.collection('users');
  //riferimento agli utenti di Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //OPERAZIONI CRUD

  //Create
  Future<void> createFireStoreUser({required Utente utente}) {
    return utenti.add({
      'email': utente.email.trim(),
      'password': utente.password.trim(),
      'bestScore': 0
    });
  }

  //Retrieve
  Stream<QuerySnapshot> selectAllUsers() {
    final utentiStream = utenti.snapshots();
    return utentiStream;
  }

  //retrieve sul bestScore, serve per la classifica
  Stream<QuerySnapshot> selectTop151Users() {
    final utentiStream =
        utenti.orderBy('bestScore', descending: true).limit(151).snapshots();

    return utentiStream;
  }

  Future<DocumentSnapshot?> getUserDetailsByEmail(String email) async {
    QuerySnapshot querySnapshot =
        await utenti.where('email', isEqualTo: email).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      return null;
    }
  }

  String? getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  //Update
  Future<void> updateUser(String docID, Utente utente) {
    return utenti.doc(docID).update({
      'email': utente.email.trim(),
      'password': utente.password.trim(),
      'bestScore': utente.bestScore
    });
  }

  Future<void> updateUserEmail(String docID, String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateEmail(email); //aggiorno la mail Authentication
      return utenti
          .doc(docID)
          .update({'mail': email}); //aggiorno la mail Firestore
    }
  }

  Future<void> updateUserPassword(String docID, String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(password);
      return utenti.doc(docID).update({'password': password});
    }
  }

  //update del bestScore, da chiamare quando l'utente batte il suo record
  Future<void> updateUserBestScore(String docID, int bestScore) {
    return utenti.doc(docID).update({'bestScore': bestScore});
  }

  //Delete
  Future<void> deleteUser(String docID) {
    User? user = _auth.currentUser;
    user!.delete(); //elimina l'utente da Authentication
    return utenti.doc(docID).delete(); //elimina l'utente da Firestore
  }
}
