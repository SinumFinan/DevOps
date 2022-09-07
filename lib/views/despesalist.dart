import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sinum_2/models/despesa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sinum_2/views/modal_inclui_despesa.dart';
import 'package:intl/intl.dart';
import 'package:sinum_2/views/modal_altera_despesa.dart';

class DespesaList extends StatefulWidget {
  DespesaList({Key? key}) : super(key: key);

  @override
  State<DespesaList> createState() => _DespesaListState();
}

class _DespesaListState extends State<DespesaList> {
  final Map<String, Despesa> _minhasDespesas = {};

  String _idUsuario = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference? despesasRef;

  String _getCurrency(double value) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(value);
  }

  /*Future _recuperarDadosUsuario() async {
    var noteref;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if (usuarioLogado != null) {
      _idUsuario = usuarioLogado.uid.toString();
      noteref = FirebaseFirestore.instance.collection('usuarios').doc(_idUsuario).collection('despesas');
      //print(_idUsuario);
    }
    return noteref.snapshot();
  }


  Future <List> _recuperaDespesas() async {
    List <Despesa> todasDespesas = [];
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? usuarioLogado = await auth.currentUser;

      if (usuarioLogado != null) {
        _idUsuario = usuarioLogado.uid.toString();
        //print(_idUsuario);
      }
      FirebaseFirestore db = FirebaseFirestore.instance;

      QuerySnapshot querySnapshot = await db.collection('usuarios').doc(_idUsuario).collection('despesas').get();
      for (DocumentSnapshot item in querySnapshot.docs) {
        print(item.id);
        String despesaId = item.id;
        var dados = item.data() as Map;
        //print('dados usuários: ' + dados['date'].toDate().toString());
        Despesa despesa = Despesa(despesaId, dados['title'], dados['category'],dados['price'], DateTime.parse(dados['date'].toDate().toString()));
        todasDespesas.add(despesa);
        //todasDespesas.putIfAbsent(despesaId, () => despesa);

      }

    } catch (err) {
      print(err);
    }
    return todasDespesas;

  }*/

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuario = usuarioLogado.uid.toString();
      despesasRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_idUsuario)
          .collection('despesas');
      //print(_idUsuario);
    }
    despesasRef;

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
          .collection('despesas')
          .doc(doc_Id)
          .delete();
      //print(_idUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(2),
        child: StreamBuilder(
          stream: despesasRef!.snapshots(),
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
                      margin: EdgeInsetsDirectional.only(
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
                              style: TextStyle(fontSize: 9),
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
                                  //print(timestamp1);
                                  //var dateAlterado = Timestamp.fromDate(document['date']);
                                  Despesa despesaAlterar = Despesa(
                                    doc_id,
                                    document['title'],
                                    document['category'],
                                    document['price'],
                                    timestamp1,
                                  );
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DespesaFormAlterar(
                                                  despesa: despesaAlterar)));
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
              MaterialPageRoute(builder: (context) => const DespesaForm()));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
