import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DespesaForm extends StatefulWidget {
  const DespesaForm({Key? key}) : super(key: key);

  @override
  State<DespesaForm> createState() => _DespesaFormState();
}

String dataText = 'Data: ';
DateTime _dataValue = DateTime.now();
String _idUsuario = '';

TextEditingController _controllerTitle = TextEditingController();
TextEditingController _controllerCategory = TextEditingController();
TextEditingController _controllerPrice = TextEditingController();

void putDespesa(
    String title, String category, double price, Timestamp date) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? usuarioLogado = await auth.currentUser;
  if (usuarioLogado != null) {
    _idUsuario = usuarioLogado.uid.toString();
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('despesas')
        .add({
      'title': title,
      'category': category,
      'price': price,
      'date': date,
    });
    //print(_idUsuario);
  }
}

void clearFields() {
  _controllerTitle.clear();
  _controllerCategory.clear();
  _controllerPrice.clear();
}

class _DespesaFormState extends State<DespesaForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Despesa'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white24,
        child: Column(
          children: [
            TextField(
              controller: _controllerTitle,
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.black),
                //hintText: 'Nome',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _controllerCategory,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                labelText: 'Categoria',
                labelStyle: TextStyle(color: Colors.black),
                //hintText: 'Categoria',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _controllerPrice,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                labelText: 'Valor',
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Utilizar ponto, ex: R\$ 50.25',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                prefixText: 'R\$ ',
                prefixStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      dataText,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(_dataValue),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2030),
                    ).then((date){
                      setState(() {
                        _dataValue = date!;
                      });
                    });
                  },
                  child: const Text('Escolher Data'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                putDespesa(
                    _controllerTitle.text,
                    _controllerCategory.text,
                    double.parse(_controllerPrice.text),
                    Timestamp.fromDate(_dataValue));
                clearFields();
                _dataValue = DateTime.now();
                Navigator.pop(context);
              },
              child: const Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}
