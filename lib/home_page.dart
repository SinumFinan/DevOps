import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sinum_2/login.dart';
import 'package:sinum_2/views/despesalist.dart';
import 'package:sinum_2/views/painel-list.dart';
import 'package:sinum_2/views/receitalist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  


  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }



  @override
  void initState() {
    
    _tabController = TabController(
      length: 3,
      initialIndex: 1,
      vsync: this,
    );
    super.initState();
    


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinum Financial'),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.yellow,
          tabs: const [
            Tab(
              text: 'Despesas',
            ),
            Tab(
              text: 'Painel',
            ),
            Tab(
              text: 'Receitas',
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _deslogarUsuario();
            },
            icon: const Icon(Icons.exit_to_app_rounded),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DespesaList(),
          const PainelList(),
          ReceitaList(),
        ],
      ),
    );
  }
}
