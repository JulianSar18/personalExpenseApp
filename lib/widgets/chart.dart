import '../widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);
  List<Map<String, Object>> get grupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].fecha.day == weekDay.day &&
            recentTransactions[i].fecha.month == weekDay.month &&
            recentTransactions[i].fecha.year == weekDay.year) {
          totalSum += recentTransactions[i].monto;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'monto': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return grupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + (item['monto'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(grupedTransactionsValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: grupedTransactionsValues.map((data) {
            return Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: ChartBar(
                  (data['day'] as String),
                  (data['monto'] as double),
                  maxSpending == 0.0
                      ? 0.0
                      : (data['monto'] as double) / maxSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
