import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sinum_2/home_page.dart';
import 'package:sinum_2/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cadastro.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = '';

  _validarCampos(){
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains('@')){
      if(senha.isNotEmpty){
        setState(() {
          _mensagemErro = '';
        });
        Usuario usuario = Usuario(null, email, senha);

        _logarUsuario(usuario);

      } else {
        setState(() {
          _mensagemErro = 'Preenhcha a senha';
        });
      }

    } else {
      setState(() {
        _mensagemErro = 'Preencha o e-mail';
      });

    }

  }

  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    ).then((firebaseUser){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }).catchError((error){
      setState(() {
        _mensagemErro = 'Erro ao autenticar usuário, verifique os dados e tente novamente.';
      });
    });
  }

  Future? _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    if(usuarioLogado != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.cyanAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      //borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/logo.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: 'Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {
                    _validarCampos();
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Center(
                  child: GestureDetector(
                    child: const Text('Não tem conta? Cadastre-se!'),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Cadastro()));
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}