import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokecho/model/utente_model.dart';

class UsersController {
  final UtenteModel utenteModel = UtenteModel();

  Stream<QuerySnapshot> getAllUsers() {
    return utenteModel.selectAllUsers();
  }

  Stream<QuerySnapshot> getTop151Users() {
    return utenteModel.selectTop151Users();
  }
}
