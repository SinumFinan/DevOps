import 'package:flutter/material.dart';
import 'package:sinum_2/models/chart-bar.dart';
import 'package:sinum_2/models/despesa.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentDespesas}) : super(key: key);

  final List<Despesa> recentDespesas;
  

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for(var i = 0; i < recentDespesas.length; i++){
        bool sameDay = recentDespesas[i].date.day == weekDay.day;
        bool sameMonth = recentDespesas[i].date.month == weekDay.month;
        bool sameYear = recentDespesas[i].date.year == weekDay.year;

        if(sameDay && sameMonth && sameYear){
          totalSum += recentDespesas[i].price;
        }
      }

      return {
        'day': DateFormat('EEE', 'pt_BR').format(weekDay),
        'value': totalSum,
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr){
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: double.parse(tr['value'].toString()),
                percentage: _weekTotalValue == 0.0 ? 0 : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
