import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokecho/model/auth.dart';
import 'package:pokecho/model/utente_model.dart';

class UtenteController {
  final UtenteModel _utenteModel = UtenteModel();

  Future<void> logOut() async {
    await Auth().signOut();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _utenteModel.selectAllUsers();
  }

  Stream<QuerySnapshot> getTop151Users() {
    return _utenteModel.selectTop151Users();
  }

  Future<DocumentSnapshot> getUserDetails(String docID) {
    return _utenteModel.utenti.doc(docID).get();
  }

  Future<DocumentSnapshot?> getUserDetailsByEmail(String email) {
    return _utenteModel.getUserDetailsByEmail(email);
  }

  String? getCurrentUserEmail() {
    return _utenteModel.getCurrentUserEmail();
  }

  Future<void> updateUserEmail(String docID, String email) {
    return _utenteModel.updateUserEmail(docID, email);
  }

  Future<void> updateUserPassword(String docID, String password) {
    return _utenteModel.updateUserPassword(docID, password);
  }

  Future<void> updateUserBestScore(String docID, int bestScore) {
    return _utenteModel.updateUserBestScore(docID, bestScore);
  }

  Future<void> deleteUser(String docID) {
    return _utenteModel.deleteUser(docID);
  }
}
