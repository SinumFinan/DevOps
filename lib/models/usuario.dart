class Usuario{
  String? _nome;
  String _email;
  String _senha;

  Usuario(this._nome, this._email, this._senha);

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map ={
      'nome': this._nome,
      'email': this._email
    };
    return map;
  }

  String get senha => _senha;
  set senha (String value){
    _senha = value;
  }

  String get email => _email;
  set email (String value){
    _senha = value;
  }

  String get nome => _nome!;
  set nome (String value){
    _senha = value;
  }

}