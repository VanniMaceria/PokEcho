class Utente {
  late String _email;
  late String _password;
  late int _bestScore;

  Utente(String email, String password) {
    this._email = email;
    this._password = password;
    this._bestScore = 0;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  int get bestScore => _bestScore;

  set bestScore(int value) {
    _bestScore = value;
  }

  /*
    // Creazione di un nuovo utente
    Utente utente = Utente('example@example.com', 'password123');

    // Accesso all'email tramite getter
    print('Email: ${utente.email}');

    // Modifica della password tramite setter
    utente.password = 'newpassword123';
  */
}
