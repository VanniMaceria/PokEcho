import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokecho/model/bean/Utente.dart';

class UtenteModel {
  UtenteModel();

  //riferimento agli utenti
  final CollectionReference utenti =
      FirebaseFirestore.instance.collection('users');

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

  //Update
  Future<void> updateUser(String docID, Utente utente) {
    return utenti.doc(docID).update({
      'email': utente.email.trim(),
      'password': utente.password.trim(),
      'bestScore': utente.bestScore
    });
  }

  //update del bestScore, da chiamare quando l'utente batte il suo record
  Future<void> updateUserBestScore(String docID, int bestScore) {
    return utenti.doc(docID).update({'bestScore': bestScore});
  }

  //update della mail, da chiamare quando l'utente dalla sua pagina riservata vuole cambiare la mail
  Future<void> updateUserMail(String docID, String mail) {
    return utenti.doc(docID).update({'mail': mail});
  }

  //update della password, da chiamare quando l'utente dalla sua pagina riservata vuole cambiare la password
  Future<void> updateUserPassword(String docID, String password) {
    return utenti.doc(docID).update({'password': password});
  }

  //Delete
  Future<void> deleteUser(String docID) {
    return utenti.doc(docID).delete();
  }
}
