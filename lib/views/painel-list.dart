import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sinum_2/models/chart.dart';
import 'package:sinum_2/models/despesa.dart';

class PainelList extends StatefulWidget {
  const PainelList({Key? key}) : super(key: key);

  @override
  State<PainelList> createState() => _PainelListState();
}

class _PainelListState extends State<PainelList> {
  final List<Despesa> _despesasGrafico = [];

  List<Despesa> get _recentTransactions {
    return _despesasGrafico.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  String _nomeUsuario = '';
  String _idUsuario = '';
  double _totalDespesa45 = 0.0;
  double _totalReceita45 = 0.0;
  double _totalDespesa = 0.0;
  double _totalReceita = 0.0;
  double _saldoGeral = 0.0;
  final Timestamp _umMesEMeio =
      Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 45)));

  String _getCurrency(double value) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatter.format(value);
  }

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db
        .collection('usuarios')
        .doc(auth.currentUser!.uid.toString())
        .get();
    var dados = snapshot.data() as Map;
    //print ('Nome do usuário: ' + dados['nome'].toString());
    //print("dados: " + snapshot.data().toString());
    _nomeUsuario = dados['nome'].toString();
    setState(() {
      _idUsuario = usuarioLogado!.uid.toString();
    });

    await db
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('receitas')
        .snapshots()
        .listen((snapshot) {
      for (DocumentSnapshot item in snapshot.docs) {
        var dados = item.data() as Map;
        var listaReceitas = [];
        listaReceitas.add(dados['price']);
        for (var i = 0; i < listaReceitas.length; i++) {
          setState(() {
            _totalReceita45 += listaReceitas[i];
          });
        }
      }
    });

    await db
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('despesas')
        .snapshots()
        .listen((snapshot) {
      for (DocumentSnapshot item in snapshot.docs) {
        var dados = item.data() as Map;
        var listaDespesas = [];
        listaDespesas.add(dados['price']);
        for (var i = 0; i < listaDespesas.length; i++) {
          setState(() {
            _totalDespesa45 += listaDespesas[i];
          });
        }
      }
    });

    await db
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('receitas')
        .snapshots()
        .listen((snapshot) {
      for (DocumentSnapshot item in snapshot.docs) {
        var dados = item.data() as Map;
        var listaReceitas = [];
        listaReceitas.add(dados['price']);
        for (var i = 0; i < listaReceitas.length; i++) {
          _totalReceita += listaReceitas[i];          
        }
        //print(_totalReceita);
      }
    });

    await db
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('despesas')
        .snapshots()
        .listen((snapshot) {
      for (DocumentSnapshot item in snapshot.docs) {
        var dados = item.data() as Map;
        var listaDespesas = [];
        listaDespesas.add(dados['price']);
        _despesasGrafico.add(
          Despesa(
            item.id,
            dados['title'],
            dados['category'],
            dados['price'],
            DateTime.fromMicrosecondsSinceEpoch(dados['date'].microsecondsSinceEpoch),
          ),
        );
        //print(_despesasGrafico.elementAt(0).date);        
        for (var i = 0; i < listaDespesas.length; i++) {
          _totalDespesa += listaDespesas[i];          
        }
        //print(_totalDespesa);
      }
    });    
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();    
    //_recuperaReceita();
  }

  @override
  Widget build(BuildContext context) {
    _saldoGeral = _totalReceita45 - _totalDespesa45;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text('Bem vindo(a) $_nomeUsuario'),            
            const SizedBox(
              height: 40,
            ),
            const Text('Despesas da Semana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Chart(recentDespesas: _recentTransactions),            
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.amberAccent,
                  elevation: 6,
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Total de Despesas do', textAlign: TextAlign.center,),
                          const Text('seu histórico', textAlign: TextAlign.center,),
                          const SizedBox(height: 15,),
                          Text(_getCurrency(_totalDespesa45), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 6,
                  margin: const EdgeInsets.all(20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Total de Receitas do', textAlign: TextAlign.center,),
                          const Text('seu histórico', textAlign: TextAlign.center,),
                          const SizedBox(height: 15,),
                          Text(_getCurrency(_totalReceita45), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              color: _saldoGeral >= 0 ? Colors.green : Colors.red,
              elevation: 6,
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    //color: Colors.yellow.shade300,
                    child: const Center(
                        child: Text(
                      'Saldo Geral',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    )),
                  ),
                  Container(
                    height: 30,
                    //color: Colors.yellow.shade300,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Center(
                        child: Text(
                      _getCurrency(_saldoGeral),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
