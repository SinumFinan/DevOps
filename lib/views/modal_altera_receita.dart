import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sinum_2/models/receita.dart';

class ReceitaFormAlterar extends StatefulWidget {
  ReceitaFormAlterar({Key? key, required this.receita}) : super(key: key);
  final Receita receita;

  @override
  State<ReceitaFormAlterar> createState() => _ReceitaFormAlterarState();
}

class _ReceitaFormAlterarState extends State<ReceitaFormAlterar> {
  final Map<String, dynamic> _formData = {};



  String _idUsuario = '';

  void _loadFormData(Receita despesa) {
    _formData['id'] = despesa.id;
    _formData['title'] = despesa.title;
    _formData['category'] = despesa.category;
    _formData['price'] = despesa.price;
    _formData['date'] = despesa.date;
  }


  late TextEditingController _controllerTitle = TextEditingController(text: widget.receita.title);
  late TextEditingController _controllerCategory = TextEditingController(text: widget.receita.category);
  late TextEditingController _controllerPrice = TextEditingController(text: widget.receita.price);

  void clearFields() {
    _controllerTitle.clear();
    _controllerCategory.clear();
    _controllerPrice.clear();
  }


  void putDespesa(
      String title, String category, double price, Timestamp date) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      _idUsuario = usuarioLogado.uid.toString();
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_idUsuario)
          .collection('receitas')
          .doc(widget.receita.id)
          .set({
        'title': title,
        'category': category,
        'price': price,
        'date': date,
      });
      //print(_idUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadFormData(widget.receita);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alterar Receita'),
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
                    const Text(
                      'Data:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(widget.receita.date),
                      //widget.despesa.date.toString(),
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
                    ).then((date) {
                      setState(() {
                        widget.receita.date = date!;
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
                    Timestamp.fromDate(widget.receita.date));
                clearFields();
                Navigator.pop(context);
              },
              child: const Text('ALTERAR'),
            ),
          ],
        ),
      ),
    );
  }
}