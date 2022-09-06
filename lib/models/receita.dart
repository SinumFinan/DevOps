class Receita {
  String _id;
  String _title;
  String _category;
  String _price;
  DateTime _date;

  Receita(
      this._id,
      this._title,
      this._category,
      this._price,
      this._date,
      );

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}