class Despesa {
  String _id;
  String _title;
  String _category;
  double _price;
  DateTime _date;

  Despesa(
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

  double get price => _price;

  set price(double value) {
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