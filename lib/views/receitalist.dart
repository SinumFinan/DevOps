import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinum_2/models/despesa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sinum_2/models/receita.dart';
import 'package:sinum_2/views/modal_altera_receita.dart';
import 'package:intl/intl.dart';
import 'package:sinum_2/views/modal_inclui_receita.dart';

class ReceitaList extends StatefulWidget {
  ReceitaList({Key? key}) : super(key: key);

  @override
  State<ReceitaList> createState() => _ReceitaListState();
}

class _ReceitaListState extends State<ReceitaList> {
  final Map<String, Despesa> _minhasReceitas = {};

  String _idUsuario = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference? receitasRef;

  String _getCurrency(double value) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(value);
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuario = usuarioLogado.uid.toString();
      receitasRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_idUsuario)
          .collection('receitas');
      //print(_idUsuario);
    }
    receitasRef;

    super.initState();
  }

  void onDelete(String doc_Id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuario = usuarioLogado.uid.toString();
      FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_idUsuario)
          .collection('receitas')
          .doc(doc_Id)
          .delete();
      //print(_idUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: StreamBuilder(
          stream: receitasRef!.snapshots(),
          builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                var doc_id = document.id;
                var dateTimestamp = document['date'];
                DateTime timestamp1 = DateTime.fromMicrosecondsSinceEpoch(
                    dateTimestamp.microsecondsSinceEpoch);
                //final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1);
                return SingleChildScrollView(
                  child: Center(
                    child: Card(
                      margin: const EdgeInsetsDirectional.only(
                          start: 5, top: 3, end: 5, bottom: 3),
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_getCurrency(document['price'])),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              DateFormat('d MMM y', "pt-BR")
                                  .format(document['date'].toDate()),
                              style: const TextStyle(fontSize: 9),
                            ),
                          ],
                        ), //const Icon(Icons.monetization_on_outlined),
                        title: Text(document['title']),
                        subtitle: Text(document['category']),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Receita receitaAlterar = Receita(
                                    doc_id,
                                    document['title'],
                                    document['category'],
                                    document['price'].toString(),
                                    timestamp1,
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReceitaFormAlterar(
                                                  receita: receitaAlterar)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  onDelete(doc_id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReceitaForm()));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
