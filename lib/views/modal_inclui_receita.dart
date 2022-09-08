import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceitaForm extends StatefulWidget {
  const ReceitaForm({Key? key}) : super(key: key);

  @override
  State<ReceitaForm> createState() => _ReceitaFormState();
}

String dataText = 'Data: ';
DateTime _dataValue = DateTime.now();
String _idUsuario = '';

TextEditingController _controllerTitle = TextEditingController();
TextEditingController _controllerCategory = TextEditingController();
TextEditingController _controllerPrice = TextEditingController();

void putReceita(String title, String category, double price, Timestamp date) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? usuarioLogado = await auth.currentUser;
  if (usuarioLogado != null) {
    _idUsuario = usuarioLogado.uid.toString();
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_idUsuario)
        .collection('receitas')
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

class _ReceitaFormState extends State<ReceitaForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Receita'),
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
              keyboardType: TextInputType.number,
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
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(_dataValue),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    showDatePicker(
                      //locale: Locale('fr', 'CA'),                      
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
                  child: Text('Escolher Data'),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                putReceita(
                    _controllerTitle.text,
                    _controllerCategory.text,
                    double.parse(_controllerPrice.text),
                    Timestamp.fromDate(_dataValue));
                clearFields();
                _dataValue = DateTime.now();
                Navigator.pop(context);
              },
              child: Text('SALVAR'),
            ),
          ],
        ),
      ),
    );
  }
}