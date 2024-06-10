import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokecho/model/bean/Utente.dart';
import 'package:pokecho/model/utente_model.dart';
import 'package:pokecho/controller/ricerca_controller.dart';
import 'package:pokecho/utils/custom_appbar_back.dart';

class Classifica extends StatefulWidget {
  const Classifica({super.key});

  @override
  State<Classifica> createState() => _ClassificaState();
}

class _ClassificaState extends State<Classifica> {
  final UtenteModel utenteModel = UtenteModel();
  final RicercaController ricercaController = RicercaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarBack(title: "Leaderboard"),
      body: StreamBuilder<QuerySnapshot>(
        stream: utenteModel.selectTop151Users(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occured'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Utente utente = Utente(data['email'], data['password']);
              utente.bestScore = data['bestScore'];

              return FutureBuilder<String>(
                future: ricercaController.fetchPokemonSprite(index + 1),
                builder: (context, pokemonSnapshot) {
                  if (pokemonSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      leading: CircularProgressIndicator(),
                      title: Row(
                        children: [
                          Expanded(child: Text(utente.email.split('@').first)),
                          SizedBox(width: 16),
                          // Distanza fissa tra nome utente e best score
                          Text('Best Score: ${utente.bestScore}'),
                        ],
                      ),
                    );
                  }

                  if (pokemonSnapshot.hasError) {
                    return ListTile(
                      leading: Icon(Icons.error),
                      title: Row(
                        children: [
                          Expanded(child: Text(utente.email.split('@').first)),
                          SizedBox(width: 16),
                          Text('Best Score: ${utente.bestScore}'),
                        ],
                      ),
                    );
                  }

                  return ListTile(
                    leading: SizedBox(
                      width: 50, // Imposta una larghezza fissa per l'immagine
                      child: Image.network(pokemonSnapshot.data ?? ''),
                    ),
                    title: Row(
                      children: [
                        Text('${index + 1}'),
                        Icon(
                          Icons.arrow_right,
                          color: Color(0xFFD02525),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text(utente.email.split('@').first)),
                        SizedBox(width: 16),
                        Text('${utente.bestScore}'),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
